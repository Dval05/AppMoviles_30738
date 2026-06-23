import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/pago.dart';
import '../../../domain/entities/reserva.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/reserva_viewmodel.dart';
import '../../viewmodels/pago_viewmodel.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/loading_overlay.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../themes/esquema_color.dart';


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
  
  String _metodoPago = 'tarjeta';
  String? _reservaId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reservaId ??= ModalRoute.of(context)?.settings.arguments as String?;
  }

  @override
  void dispose() {
    _tarjetaController.dispose();
    _fechaController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _procesarPago() async {
    if (_metodoPago == 'tarjeta' && !_formKey.currentState!.validate()) {
      return;
    }
    if (_reservaId == null) return;

      final usuarioId = context.read<AuthViewModel>().usuarioActual?.id;
      if (usuarioId == null) return;

      // Obtener el monto (simulado, buscar de la reserva)
      final reservas = context.read<ReservaViewModel>().reservas;
      final reserva = reservas.cast<Reserva>().firstWhere(
        (r) => r.id == _reservaId,
        orElse: () => context.read<ReservaViewModel>().reservaActual!,
      );

      final pago = Pago(
        id: '', // Se genera en BD
        reservaId: _reservaId!,
        usuarioId: usuarioId,
        monto: reserva.precioTotal,
        metodo: _metodoPago,
        referencia: 'TRX-${DateTime.now().millisecondsSinceEpoch}',
        fechaPago: DateTime.now(),
      );

      final exito = await context.read<PagoViewModel>().procesarPago(pago);

      if (exito && mounted) {
        // El estado de la reserva se actualiza en el caso de uso ProcesarPagoUseCase
        
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pago procesado con éxito'), backgroundColor: Colors.green),
        );
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
      }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<PagoViewModel>().isLoading;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.payment)),
      body: LoadingOverlay(
        isLoading: isLoading,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.paymentMethod,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  key: ValueKey(_metodoPago),
                  initialValue: _metodoPago,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.payment, color: ColorSchemeApp.primaryGreen),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: ColorSchemeApp.primaryGreen.withValues(alpha: 0.3)),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(value: 'tarjeta', child: Text(l10n.creditDebitCard)),
                    DropdownMenuItem(value: 'transferencia', child: Text(l10n.bankTransfer)),
                    DropdownMenuItem(value: 'deuna', child: Text(l10n.deuna)),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _metodoPago = val);
                  },
                ),
                const SizedBox(height: 32),

                if (_metodoPago == 'tarjeta') ...[
                  Text(
                    l10n.cardDetails,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: l10n.cardNumber,
                    prefixIcon: Icons.credit_card,
                    controller: _tarjetaController,
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.length < 16 ? l10n.error : null,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: l10n.expiryDate,
                          prefixIcon: Icons.calendar_today,
                          controller: _fechaController,
                          validator: (value) => value == null || value.isEmpty ? l10n.error : null,
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
                          validator: (value) => value == null || value.length < 3 ? l10n.error : null,
                        ),
                      ),
                    ],
                  ),
                ] else if (_metodoPago == 'transferencia') ...[
                  Text(
                    l10n.bankDetails,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColorSchemeApp.primaryGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ColorSchemeApp.primaryGreen.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.transferInstructions, style: const TextStyle(fontSize: 14)),
                        const SizedBox(height: 16),
                        Text(l10n.bankName, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColorSchemeApp.primaryGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ColorSchemeApp.primaryGreen.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(l10n.deunaInstructions, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
                        const SizedBox(height: 16),
                        const Icon(Icons.qr_code_2, size: 100, color: ColorSchemeApp.primaryGreen),
                        const SizedBox(height: 16),
                        Text(l10n.deunaNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 32),
                GradientButton(
                  text: _metodoPago == 'tarjeta' ? l10n.payNow : l10n.confirmPayment,
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
