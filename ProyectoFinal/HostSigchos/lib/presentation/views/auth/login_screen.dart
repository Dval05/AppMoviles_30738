import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../themes/esquema_color.dart';
import '../../routes/app_routes.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/language_selector.dart';
import '../../widgets/loading_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      var input = _emailController.text.trim();
      var originalInput = input;
      
      // Si ingresan el nombre de la hostería, lo convertimos a formato de correo electrónico
      if (!input.contains('@')) {
        input = input.toLowerCase().replaceAll(' ', '_');
        input = '$input@hostsigchos.com';
      }

      String password = kIsWeb ? originalInput : _passwordController.text;

      final success = await context.read<AuthViewModel>().login(
        input,
        password,
      );

      if (success && mounted) {
        final usuario = context.read<AuthViewModel>().usuarioActual;
        if (usuario != null) {
          _navegarPostLogin();
        }
      }
    }
  }

  void _navegarPostLogin() {
    // Cierra la sesión de autofill de Android antes de navegar; si el sistema
    // sigue mostrando el aviso de "guardar contraseña" cuando el árbol de
    // widgets del login se destruye, Flutter lanza
    // "_dependents.isEmpty is not true" al desmontar los campos.
    TextInput.finishAutofillContext();
    if (kIsWeb) {
      Navigator.pushReplacementNamed(context, AppRoutes.propietarioDashboard);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  Future<void> _loginGoogle() async {
    final success = await context.read<AuthViewModel>().loginConGoogle();
    if (success && mounted) {
      final usuario = context.read<AuthViewModel>().usuarioActual;
      if (usuario != null) {
        _navegarPostLogin();
      }
    }
  }

  Future<void> _loginBiometric() async {
    final success = await context.read<AuthViewModel>().loginConBiometria();
    if (success && mounted) {
      final usuario = context.read<AuthViewModel>().usuarioActual;
      if (usuario != null) {
        _navegarPostLogin();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.landing);
          },
        ),
        actions: const [
          LanguageSelector(iconColor: Colors.white),
          SizedBox(width: 8),
        ],
      ),
      body: LoadingOverlay(
        isLoading: authViewModel.isLoading,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF308658), // Verde claro/brillante
                Color(0xFF1B5133), // Verde medio
                Color(0xFF0D2B1A), // Muy oscuro
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          height: 35,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.welcomeTo,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: ColorSchemeApp.darkGreen,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.signInToContinue,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: ColorSchemeApp.softGray,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        if (authViewModel.errorMessage != null) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: ColorSchemeApp.error.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: ColorSchemeApp.error),
                            ),
                            child: Text(
                              authViewModel.errorMessage!,
                              style: const TextStyle(
                                color: ColorSchemeApp.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],

                        CustomTextField(
                          label: kIsWeb ? 'Nombre de la Hostería' : l10n.emailOrPlaceName,
                          prefixIcon: kIsWeb ? Icons.business : Icons.email_outlined,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return l10n.error;
                            }
                            return null;
                          },
                        ),

                        if (!kIsWeb) ...[
                          CustomTextField(
                            label: l10n.password,
                            prefixIcon: Icons.lock_outline,
                            controller: _passwordController,
                            isPassword: true,
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return l10n.error;
                              }
                              return null;
                            },
                          ),

                          Row(
                            children: [
                              Checkbox(
                                value: authViewModel.keepSession,
                                onChanged: (val) {
                                  if (val != null) {
                                    authViewModel.setKeepSession(value: val);
                                  }
                                },
                                activeColor: ColorSchemeApp.primaryGreen,
                                visualDensity: VisualDensity.compact,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => authViewModel.setKeepSession(value: !authViewModel.keepSession),
                                  child: Text(
                                    l10n.keepSession,
                                    style: const TextStyle(color: ColorSchemeApp.darkText, fontSize: 13),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, AppRoutes.forgotPassword);
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: ColorSchemeApp.primaryGreen,
                                  padding: EdgeInsets.zero,
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                child: Text(l10n.forgotPassword),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],

                        GradientButton(
                          text: kIsWeb ? 'Ingresar' : l10n.login,
                          onPressed: _login,
                        ),


                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                l10n.orContinueWith,
                                style: const TextStyle(color: ColorSchemeApp.softGray),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _loginGoogle,
                                icon: const Icon(
                                  Icons.g_mobiledata,
                                  size: 30,
                                  color: ColorSchemeApp.primaryGreen,
                                ),
                                label: const Text(
                                  'Google',
                                  style: TextStyle(
                                    color: ColorSchemeApp.darkText,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(
                                    color: ColorSchemeApp.divider,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ),
                            if (authViewModel.isBiometricAvailable) ...[
                              const SizedBox(width: 16),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    if (authViewModel.hasSavedCredentials) {
                                      _loginBiometric();
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            l10n.biometricSetupMessage,
                                          ),
                                          backgroundColor: Colors.orange,
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.fingerprint,
                                    size: 30,
                                    color: ColorSchemeApp.primaryGreen,
                                  ),
                                  label: Text(
                                    l10n.biometricLogin,
                                    style: const TextStyle(
                                      color: ColorSchemeApp.darkText,
                                      fontSize: 13,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: const BorderSide(
                                      color: ColorSchemeApp.divider,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(l10n.noAccount, style: const TextStyle(fontSize: 13)),
                            TextButton(
                              onPressed: () {
                                context.read<AuthViewModel>().clearError();
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.register,
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: ColorSchemeApp.primaryGreen,
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              child: Text(l10n.registerHere),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
