# 🧪 Estrategia de Pruebas Móviles (Flutter)

Este documento detalla las mejores herramientas **gratuitas** y estrategias para realizar pruebas exhaustivas en la aplicación móvil **HostSigchos**, enfocándose especialmente en la simulación de condiciones de red, *rate limiting* y pruebas de extremo a extremo (E2E).

---

## 1. Pruebas de Red y Rate Limiting (Simulación de estrés)

Cuando las aplicaciones móviles se conectan a Firebase o a APIs de terceros, es crucial probar cómo reaccionan ante conexiones lentas, cortes de red, o cuando alcanzan límites de peticiones (Rate Limit). 

### 🏆 Mejor Herramienta Gratuita: **Android Emulator Extended Controls / Proxy Tools**

#### Opción A: Aceleración de red del Emulador (Nativa y Gratuita)
El emulador de Android Studio tiene herramientas nativas para simular latencia y cortes sin instalar nada extra.
* **Cómo usarlo:**
  1. Abre el emulador de Android.
  2. Haz clic en los tres puntos **(...)** en la barra de herramientas del emulador para abrir los *Extended Controls*.
  3. Ve a la pestaña **Cellular**.
  4. En **Network type**, cámbialo de *Full* a *GPRS* o *EDGE* (para simular red muy lenta).
  5. En **Signal strength**, ponlo en *Poor*.
  6. Para probar **Rate Limiting** o *Timeouts*, establece el estado de la red en *Denied* o *Unregistered* justo antes de enviar una reserva para verificar si tu capa de `Repository` captura la excepción de timeout (10 segundos) correctamente.

#### Opción B: Proxyman (Versión gratuita) / Charles Proxy
Si necesitas interceptar el tráfico, manipular las respuestas de las APIs (por ejemplo, devolver un Error HTTP 429 Too Many Requests manualmente) para probar el Rate Limit del Chatbot IA:
* **Proxyman** tiene una versión gratuita excelente para macOS/Windows.
* Permite interceptar las llamadas HTTP del emulador y establecer un **Map Local** (devolver un JSON de error de límite excedido en lugar de ir al servidor).

---

## 2. Pruebas de Integración y E2E (End-to-End)

Para automatizar flujos completos como: *Abrir la app -> Hacer Login -> Buscar Hostería -> Reservar -> Confirmar*.

### 🏆 Mejor Herramienta Gratuita para Flutter: **Patrol**

[Patrol](https://patrol.leancode.co/) es un framework open-source construido específicamente para Flutter. Supera al `integration_test` nativo de Flutter porque permite interactuar con elementos nativos del sistema operativo.
* **¿Por qué es el mejor?**
  * Puede tocar botones de permisos nativos (como el permiso de notificaciones o de GPS).
  * Puede interactuar con WebViews o dialogs de autenticación nativa (Google Sign-In).
  * Es 100% gratuito.
* **Instalación:**
  ```bash
  dart pub global activate patrol_cli
  flutter pub add patrol --dev
  ```

### 🥈 Alternativa No-Code: **Maestro**
[Maestro](https://maestro.mobile.dev/) es otra herramienta open-source increíble. Escribes los tests en archivos YAML súper simples (ejemplo: `tapOn: "Iniciar Sesión"`). Es agnóstico a Flutter, prueba la app compilada tal como lo haría un humano.

---

## 3. Pruebas de Backend sin consumir cuota (Firebase)

Para probar flujos de creación de cientos de reservas sin agotar tu cuota gratuita de lectura/escritura de Firestore (lo que generaría un Rate Limit real).

### 🏆 Mejor Herramienta Gratuita: **Firebase Local Emulator Suite**

Es una herramienta oficial de Google que corre un servidor local de Firebase en tu máquina.
* **Cómo usarlo:**
  1. Instala Firebase CLI: `npm install -g firebase-tools`
  2. Inicializa: `firebase init emulators`
  3. Ejecuta: `firebase emulators:start`
  4. En tu `main.dart`, configura la conexión para que apunte al localhost:
     ```dart
     if (kDebugMode) {
       FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
       FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
     }
     ```
* **Ventajas:** Puedes borrar y crear miles de documentos de reservas en milisegundos sin preocuparte por costos ni límites de velocidad de la nube.

---

## 4. Pruebas Unitarias y de Widgets (Nativas)

Para probar funciones aisladas (ej. validación del carrito, cálculo de totales) y componentes visuales (`HosteriaCard`).

### 🏆 Mejor Herramienta Gratuita: **flutter_test (Incluida)**

* **Unit Tests:** Úsalo para probar la lógica de tus *UseCases* y *ViewModels* (mockeando el Repository con la librería `mockito`).
* **Widget Tests:** Permite renderizar un widget en memoria sin necesidad de un emulador y verificar si los textos o colores cambian al hacer tap.
* **Comando:** `flutter test`

## Resumen de tu Stack de Pruebas Recomendado

1. **Unit/Widget:** `flutter test` + `mockito` (Para la capa Domain/Presentation).
2. **E2E / UI Automatizada:** `Patrol` (Para probar flujos completos de reserva).
3. **Estrés / Rate Limiting:** Controles del Emulador de Android + `Proxyman` (Para simular redes lentas y errores 429).
4. **Backend Local:** `Firebase Emulator Suite` (Para no agotar cuotas reales).
