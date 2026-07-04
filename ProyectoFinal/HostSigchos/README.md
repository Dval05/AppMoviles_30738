# 🌲 HostSigchos

HostSigchos es el Sistema de Reservas de Hosterías para la región de Sigchos. Esta aplicación móvil permite a los usuarios descubrir hosterías, verificar disponibilidad de habitaciones, reservar y procesar pagos.

## 📋 Documentación de Proyecto

Para mantener el código profesional, limpio y escalable, la documentación se ha dividido en los siguientes módulos:

- 🛡️ **[Seguridad y Ofuscamiento](SECURITY.md)**: Explicación de cómo las API Keys están aseguradas (Envied), la configuración de red y la ofuscación ProGuard/R8 para prevenir ingeniería inversa.
- 🏗️ **[Arquitectura y Clean Code](ARCHITECTURE.md)**: Explicación sobre la Inyección de Dependencias (DI) con `get_it`, el patrón Singleton y la separación de responsabilidades usando principios SOLID.

## 🚀 Despliegue y Compilación Segura

Debido a los mecanismos de seguridad implementados, si deseas compilar la aplicación para Producción (Release) con todo ofuscado, usa el siguiente comando:

```bash
# Compilar un AppBundle para la Play Store con ofuscamiento completo
flutter build appbundle --release --obfuscate --split-debug-info=./debug-info

# O para un APK instalable directamente:
flutter build apk --release --obfuscate --split-debug-info=./debug-info
```

> **Nota:** El flag `--obfuscate` asegura que el código Dart sea convertido a binario ilegible, mientras que R8/ProGuard se encarga del código nativo de Android.

## 🛠️ Tecnologías Principales

- **Flutter / Dart**
- **Firebase** (Auth, Firestore, Storage)
- **Stripe** (Pagos)
- **Provider** (Manejo de Estado)
- **GetIt** (Inyección de Dependencias)
- **Envied** (Ofuscación de Keys)
