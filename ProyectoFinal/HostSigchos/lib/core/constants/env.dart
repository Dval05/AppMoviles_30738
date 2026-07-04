import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'GOOGLE_MAPS_API_KEY')
  static final String googleMapsApiKey = _Env.googleMapsApiKey;

  @EnviedField(varName: 'GOOGLE_WEB_CLIENT_ID')
  static final String googleWebClientId = _Env.googleWebClientId;

  @EnviedField(varName: 'GROQ_API_KEY')
  static final String groqApiKey = _Env.groqApiKey;

  @EnviedField(varName: 'FIREBASE_API_KEY_WEB')
  static final String firebaseApiKeyWeb = _Env.firebaseApiKeyWeb;

  @EnviedField(varName: 'FIREBASE_API_KEY_ANDROID')
  static final String firebaseApiKeyAndroid = _Env.firebaseApiKeyAndroid;

  @EnviedField(varName: 'FIREBASE_API_KEY_IOS')
  static final String firebaseApiKeyIos = _Env.firebaseApiKeyIos;

  @EnviedField(varName: 'STRIPE_PUBLISHABLE_KEY')
  static final String stripePublishableKey = _Env.stripePublishableKey;

  @EnviedField(varName: 'STRIPE_TEST_MODE')
  static final String stripeTestMode = _Env.stripeTestMode;
}
