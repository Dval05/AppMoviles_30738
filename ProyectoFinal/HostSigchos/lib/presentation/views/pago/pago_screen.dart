import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/services/stripe_test_service.dart';
import '../../../domain/entities/pago.dart';
import '../../../domain/entities/reserva.dart';
import '../../../themes/esquema_color.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/pago_viewmodel.dart';
import '../../viewmodels/reserva_viewmodel.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/loading_overlay.dart';

class PagoScreen extends StatefulWidget {
  const PagoScreen({super.key});

  @override
  State<PagoScreen> createState() => _PagoScreenState();
}

class _PagoScreenState extends State<PagoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tarjetaController = TextEditingController();
  final _fechaController = TextEditingController();
  final _cvvController = TextEditingController();
  final _stripeTestService = StripeTestService();

  String _metodoPago = 'tarjeta';
  List<Reserva>? _reservasAPagar;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_reservasAPagar == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is List<Reserva>) {
        _reservasAPagar = args;
      } else if (args is String) {
        final rVm = context.read<ReservaViewModel>();
        final res = rVm.reservas.cast<Reserva?>().firstWhere(
          (r) => r?.id == args,
          orElse: () => rVm.reservaActual,
        );
        if (res != null) {
          _reservasAPagar = [res];
        }
      }
    }
  }

  @override
  void dispose() {
    _tarjetaController.dispose();
    _fechaController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _procesarPago() async {
    if (_metodoPago == 'tarjeta' && !_formKey.currentState!.validate()) {
      return;
    }
    if (_reservasAPagar == null || _reservasAPagar!.isEmpty) return;

    final usuarioId = context.read<AuthViewModel>().usuarioActual?.id;
    if (usuarioId == null) return;

    String referencia = 'TRX-${DateTime.now().millisecondsSinceEpoch}';

    if (_metodoPago == 'tarjeta') {
      final stripeResult = await _stripeTestService.confirmEducationalPayment(
        amount: _reservasAPagar!.fold<double>(
          0,
          (sum, reserva) => sum + reserva.precioTotal,
        ),
        cardNumber: _tarjetaController.text,
        expiry: _fechaController.text,
        cvc: _cvvController.text,
      );

      if (!stripeResult.isSuccessful) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(stripeResult.message),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      referencia = stripeResult.reference;
    }

    bool allSuccess = true;

    for (final reserva in _reservasAPagar!) {
      final pago = Pago(
        id: '', // Se genera en BD
        reservaId: reserva.id,
        usuarioId: usuarioId,
        monto: reserva.precioTotal,
        metodo: _metodoPago == 'tarjeta' ? 'stripe_test' : _metodoPago,
        referencia: referencia,
        fechaPago: DateTime.now(),
      );

      final exito = await context.read<PagoViewModel>().procesarPago(pago);
      if (!exito) {
        allSuccess = false;
        break; // Detener si hay un fallo
      }
    }

    if (allSuccess && mounted) {
      // Para métodos no-tarjeta, mostrar mensaje de revisión
      if (_metodoPago != 'tarjeta') {
        _mostrarDialogoEnRevision();
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pago procesado exitosamente (pago de prueba)'),
            backgroundColor: Colors.green,
          ),
        );
        if (!mounted) return;
        Navigator.pop(context); // Regresa a la pantalla anterior (historial)
      }
    }
  }

  void _mostrarDialogoEnRevision() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.hourglass_top_rounded,
            color: Colors.orange,
            size: 40,
          ),
        ),
        title: const Text(
          'Pago en Revisión',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Tu pago ha sido registrado y se encuentra en revisión.',
              textAlign: TextAlign.center,
              style: TextStyle(color: ColorSchemeApp.softGray),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Si el pago no se confirma dentro de 48 horas, el estado cambiará a pendiente.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.pop(
                  context,
                ); // Regresa a la pantalla anterior (historial)
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorSchemeApp.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Entendido'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<PagoViewModel>().isLoading;
    final l10n = AppLocalizations.of(context)!;

    // Calcular el monto total
    final montoTotal =
        _reservasAPagar?.fold<double>(0, (sum, r) => sum + r.precioTotal) ?? 0;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.payment)),
      body: LoadingOverlay(
        isLoading: isLoading,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Resumen de pago
                if (_reservasAPagar != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColorSchemeApp.sandBeige.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Monto a pagar (${_reservasAPagar!.length} reserva${_reservasAPagar!.length > 1 ? 's' : ''})',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${montoTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: ColorSchemeApp.darkGreen,
                          ),
                        ),
                      ],
                    ),
                  ),

                Text(
                  l10n.paymentMethod,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  key: ValueKey(_metodoPago),
                  initialValue: _metodoPago,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.payment,
                      color: ColorSchemeApp.primaryGreen,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: ColorSchemeApp.primaryGreen.withValues(
                          alpha: 0.3,
                        ),
                      ),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'tarjeta',
                      child: Text(l10n.creditDebitCard),
                    ),
                    DropdownMenuItem(
                      value: 'transferencia',
                      child: Text(l10n.bankTransfer),
                    ),
                    DropdownMenuItem(value: 'deuna', child: Text(l10n.deuna)),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _metodoPago = val);
                  },
                ),

                // Aviso para métodos no-tarjeta
                if (_metodoPago != 'tarjeta') ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.blue.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Los pagos por ${_metodoPago == 'transferencia' ? 'transferencia' : 'Deuna'} quedan en estado "En Revisión" hasta ser verificados. Si no se confirman en 48h, pasarán a "Pendiente".',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 32),

                if (_metodoPago == 'tarjeta') ...[

                  CustomTextField(
                    label: l10n.cardNumber,
                    prefixIcon: Icons.credit_card,
                    controller: _tarjetaController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final normalized =
                          value?.replaceAll(
                            RegExp(r'\s+'),
                            '',
                          ) ??
                          '';
                      return normalized.length < 16 ? l10n.error : null;
                    },
                    inputFormatters: [
                      CardNumberFormatter(),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: l10n.expiryDate,
                          prefixIcon: Icons.calendar_today,
                          controller: _fechaController,
                          validator: (value) => value == null || value.isEmpty
                              ? l10n.error
                              : null,
                          keyboardType: TextInputType.datetime,
                          inputFormatters: [CardExpiryFormatter()],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomTextField(
                          label: l10n.cvv,
                          prefixIcon: Icons.security,
                          controller: _cvvController,
                          keyboardType: TextInputType.number,
                          isPassword: true,
                          validator: (value) =>
                              value == null || value.length < 3
                              ? l10n.error
                              : null,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                    ],
                  ),
                ] else if (_metodoPago == 'transferencia') ...[
                  Text(
                    l10n.bankDetails,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColorSchemeApp.primaryGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ColorSchemeApp.primaryGreen.withValues(
                          alpha: 0.3,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.transferInstructions,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.bankName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(l10n.accountType),
                        Text(l10n.accountNumber),
                        Text(l10n.ownerName),
                        Text(l10n.idNumber),
                      ],
                    ),
                  ),
                ] else if (_metodoPago == 'deuna') ...[
                  Text(
                    l10n.deuna,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColorSchemeApp.primaryGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ColorSchemeApp.primaryGreen.withValues(
                          alpha: 0.3,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          l10n.deunaInstructions,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        const Icon(
                          Icons.qr_code_2,
                          size: 100,
                          color: ColorSchemeApp.primaryGreen,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.deunaNumber,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 32),
                GradientButton(
                  text: _metodoPago == 'tarjeta'
                      ? l10n.payNow
                      : l10n.confirmPayment,
                  onPressed: _procesarPago,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CardExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.replaceAll('/', '');
    
    // Evitar que ingrese más de 4 dígitos (MMYY)
    if (newText.length > 4) {
      newText = newText.substring(0, 4);
    }
    
    final buffer = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      if (i == 1 && newText.length > 2) {
        buffer.write('/');
      }
    }
    
    final formatted = buffer.toString();
    
    // Si acaba de escribir el segundo dígito y no está borrando, añadir '/'
    if (newText.length == 2 && oldValue.text.replaceAll('/', '').length == 1) {
      return TextEditingValue(
        text: '$formatted/',
        selection: TextSelection.collapsed(offset: formatted.length + 1),
      );
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Solo permitir dígitos
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (newText.length > 16) {
      newText = newText.substring(0, 16);
    }
    
    final buffer = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      if ((i + 1) % 4 == 0 && i + 1 != newText.length) {
        buffer.write(' ');
      }
    }
    
    final formatted = buffer.toString();
    
    // Lógica para mantener el cursor en el lugar correcto
    int selectionIndex = newValue.selection.end;
    
    // Contar cuántos espacios hay antes del cursor en el texto original
    int spacesBeforeCursorOld = 0;
    for (int i = 0; i < oldValue.selection.end && i < oldValue.text.length; i++) {
      if (oldValue.text[i] == ' ') spacesBeforeCursorOld++;
    }
    
    // Contar cuántos espacios hay antes del cursor en el texto nuevo (sin formato)
    int spacesBeforeCursorNew = 0;
    for (int i = 0; i < newValue.selection.end && i < newValue.text.length; i++) {
      if (newValue.text[i] == ' ') spacesBeforeCursorNew++;
    }
    
    // Ajustar el índice base restando los espacios que el usuario escribió o borró
    int baseIndex = newValue.selection.end - spacesBeforeCursorNew;
    
    // Añadir los espacios generados por nuestro formato
    int finalIndex = baseIndex;
    int spacesToAdd = baseIndex ~/ 4;
    if (baseIndex % 4 == 0 && baseIndex > 0 && baseIndex != 16) {
      // Si el cursor está justo después del 4to dígito, también debe saltar el espacio
      // a menos que estemos borrando
      if (oldValue.text.length > newValue.text.length && oldValue.text.endsWith(' ')) {
        // Borrando, no saltamos
        spacesToAdd--;
      }
    }
    
    finalIndex += spacesToAdd;

    if (finalIndex < 0) finalIndex = 0;
    if (finalIndex > formatted.length) finalIndex = formatted.length;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: finalIndex),
    );
  }
}
