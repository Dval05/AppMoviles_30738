import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';


// Import L10n
import 'core/l10n/app_localizations.dart';
// Import Services
import 'core/services/notification_service.dart';
import 'firebase_options.dart';
// Import DI container
import 'injection_container.dart';
// Import Routes & Theme
import 'presentation/routes/app_routes.dart';
// Import ViewModels
import 'presentation/viewmodels/auth_viewmodel.dart';
import 'presentation/viewmodels/carrito_reserva_viewmodel.dart';
import 'presentation/viewmodels/chatbot_viewmodel.dart';
import 'presentation/viewmodels/geocoding_viewmodel.dart';
import 'presentation/viewmodels/habitacion_viewmodel.dart';
import 'presentation/viewmodels/hosteria_viewmodel.dart';
import 'presentation/viewmodels/locale_viewmodel.dart';
import 'presentation/viewmodels/notificacion_viewmodel.dart';

import 'presentation/viewmodels/resena_viewmodel.dart';
import 'presentation/viewmodels/reserva_viewmodel.dart';
import 'presentation/viewmodels/weather_viewmodel.dart';
import 'themes/tema_general.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialización de Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).timeout(const Duration(seconds: 8));
  } catch (e) {
    debugPrint('Error inicializando Firebase: $e');
  }

  // Inyección de Dependencias (DI)
  setupLocator();

  // Re-inyectar usuario tester (ejecución temporal)
  _crearTesterDeGoogle();


  // Inicializar servicio de notificaciones usando GetIt
  try {
    await getIt<NotificationService>().inicializar().timeout(
      const Duration(seconds: 3),
    );
  } catch (e) {
    debugPrint('Error inicializando notificaciones: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<LocaleViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<WeatherViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<AuthViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<HosteriaViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<HabitacionViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<ReservaViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<CarritoReservaViewModel>()),

        ChangeNotifierProvider(create: (_) => getIt<GeocodingViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<ChatbotViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<NotificacionViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<ResenaViewModel>()),
      ],
      child: const HostSigchosApp(),
    ),
  );
}

class HostSigchosApp extends StatelessWidget {
  const HostSigchosApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeVm = context.watch<LocaleViewModel>();

    return MaterialApp(
      title: 'HostSigchos',
      debugShowCheckedModeBanner: false,
      theme: GeneralThemeApp.theme,
      navigatorKey: AppRoutes.navigatorKey,
      locale: localeVm.locale,
      supportedLocales: const [
        Locale('es'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}

// FUNCION TEMPORAL
Future<void> _crearTesterDeGoogle() async {
  try {
    const email = 'google.tester@hostsigchos.com';
    const password = 'Tester12345!';
    
    // Crear el usuario en Authentication
    final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    final newUid = userCredential.user!.uid;
    
    await FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: 'hostsigchos')
        .collection('usuarios').doc(newUid).set({
      'nombre': 'Google Tester',
      'email': email,
      'cedula': '1700000000',
      'telefono': '+593999999999',
      'fechaNacimiento': Timestamp.fromDate(DateTime(1990, 1, 1)),
      'fechaRegistro': FieldValue.serverTimestamp(),
      'fotoUrl': null,
      'ubicacion': 'Google Play',
      'idioma': 'es',
    });
    
    debugPrint('=== USUARIO TESTER RE-CREADO EXITOSAMENTE ===');
    debugPrint('Email: $email');
    debugPrint('Password: $password');
    debugPrint('UID: $newUid');
  } on FirebaseAuthException catch (e) {
    debugPrint('=== ERROR CREANDO TESTER: ${e.code} - ${e.message} ===');
  } catch (e) {
    debugPrint('=== ERROR DESCONOCIDO CREANDO TESTER: $e ===');
  }
}
