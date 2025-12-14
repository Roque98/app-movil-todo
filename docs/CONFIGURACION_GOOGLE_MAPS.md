# Configuración de Google Maps

Este documento describe cómo obtener y configurar una API Key de Google Maps para que la funcionalidad de mapas y geolocalización funcione correctamente en la aplicación.

## 📋 Requisitos Previos

- Cuenta de Google
- Acceso a Google Cloud Console
- Proyecto Flutter configurado

## 🔑 Paso 1: Obtener API Key de Google Cloud Console

### 1.1 Crear o Seleccionar un Proyecto

1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Si no tienes un proyecto, haz clic en **"Crear proyecto"**
3. Ingresa un nombre para tu proyecto (ejemplo: "App Mantenimiento")
4. Haz clic en **"Crear"**

### 1.2 Habilitar las APIs Necesarias

1. En el menú lateral, ve a **"APIs y servicios" → "Biblioteca"**
2. Busca y habilita las siguientes APIs:
   - ✅ **Maps SDK for Android** (obligatorio para Android)
   - ✅ **Maps SDK for iOS** (obligatorio para iOS)

Para habilitar cada API:
- Haz clic en el nombre de la API
- Haz clic en el botón **"Habilitar"**
- Espera a que se complete la activación

### 1.3 Crear Credenciales (API Key)

1. Ve a **"APIs y servicios" → "Credenciales"**
2. Haz clic en **"+ Crear credenciales"** en la parte superior
3. Selecciona **"Clave de API"**
4. Se generará automáticamente una API Key
5. **¡IMPORTANTE!** Copia esta clave y guárdala en un lugar seguro

**Ejemplo de API Key:**
```
AIzaSyA1B2C3D4E5F6G7H8I9J0K1L2M3N4O5P6Q
```

## 🔒 Paso 2: Restringir la API Key (MUY IMPORTANTE)

Por seguridad, **NUNCA** dejes la API Key sin restricciones en producción.

### 2.1 Restricciones de Aplicación

1. En la página de Credenciales, haz clic en el nombre de tu API Key
2. En **"Restricciones de aplicación"**:

**Para Android:**
- Selecciona **"Aplicaciones de Android"**
- Haz clic en **"+ Agregar un nombre de paquete y huella digital"**
- Nombre del paquete: `com.example.flutter_application_1` (verifica en `android/app/build.gradle`)
- Huella SHA-1: Obtén con el comando:
  ```bash
  keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
  ```

**Para iOS:**
- Selecciona **"Aplicaciones de iOS"**
- Haz clic en **"+ Agregar un identificador"**
- Bundle ID: Verifica en `ios/Runner.xcodeproj/project.pbxproj` (ejemplo: `com.example.flutterApplication1`)

### 2.2 Restricciones de API

En **"Restricciones de API"**:
1. Selecciona **"Restringir clave"**
2. Marca solo las APIs que vas a usar:
   - ✅ Maps SDK for Android
   - ✅ Maps SDK for iOS

3. Haz clic en **"Guardar"**

## ⚙️ Paso 3: Configurar la API Key en el Proyecto

### 3.1 Configuración para Android

Abre el archivo `android/app/src/main/AndroidManifest.xml`:

**Línea 43** - Reemplaza `TU_API_KEY_AQUI` con tu API Key real:

```xml
<!-- Google Maps API Key -->
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="AIzaSyA1B2C3D4E5F6G7H8I9J0K1L2M3N4O5P6Q" />
```

### 3.2 Configuración para iOS

Abre el archivo `ios/Runner/AppDelegate.swift`:

**Línea 12** - Reemplaza `TU_API_KEY_AQUI` con tu API Key real:

```swift
import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Configura tu API Key aquí
    GMSServices.provideAPIKey("AIzaSyA1B2C3D4E5F6G7H8I9J0K1L2M3N4O5P6Q")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

## 🧹 Paso 4: Limpiar y Reconstruir el Proyecto

Después de configurar la API Key, ejecuta:

```bash
flutter clean
flutter pub get
flutter run
```

**En caso de que el mapa siga mostrando un fondo amarillo:**
1. Desinstala completamente la app del dispositivo/emulador
2. Ejecuta `flutter clean`
3. Vuelve a instalar: `flutter run`

## 🧪 Paso 5: Verificar que Funciona

### Prueba la funcionalidad de GPS:

1. Abre la aplicación
2. Navega a **"Nueva OT"**
3. Haz clic en el botón de GPS 📍
4. Deberías ver:
   - Las coordenadas GPS en el campo de ubicación
   - Un mapa interactivo mostrando tu ubicación con un marcador

### Prueba el mapa en Detalle de OT:

1. Abre cualquier orden de trabajo que tenga coordenadas GPS
2. Desplázate hasta la sección de **"Información de Creación"**
3. Deberías ver un mapa interactivo con el marcador en la ubicación

## 💰 Costos y Límites

### Plan Gratuito

Google Maps ofrece **$200 USD/mes en créditos gratuitos**, que incluyen:

- **Maps SDK for Android/iOS**:
  - 28,000 cargas de mapas dinámicos (Mobile Native Dynamic Maps) gratis al mes
  - Después: $7.00 USD por cada 1,000 cargas adicionales

### Recomendaciones:

- ✅ Para desarrollo y testing: el plan gratuito es más que suficiente
- ✅ Para apps pequeñas (<1000 usuarios activos): probablemente no excedas el límite gratuito
- ⚠️ Para apps en producción con muchos usuarios: monitorea el uso en Google Cloud Console
- ⚠️ Configura alertas de facturación para evitar sorpresas

### Monitoreo de Uso:

1. Ve a Google Cloud Console
2. Menú → **"Facturación"** → **"Presupuestos y alertas"**
3. Crea una alerta cuando llegues al 50%, 75% y 90% de tu presupuesto

## 🔐 Mejores Prácticas de Seguridad

### ❌ NO HAGAS ESTO:

```dart
// MAL: API Key hardcodeada en el código Dart
const String apiKey = "AIzaSyA1B2C3D4E5F6G7H8I9J0K1L2M3N4O5P6Q";
```

### ✅ HAZ ESTO:

1. **Usa variables de entorno** para desarrollo (archivo `.env`)
2. **Configura restricciones** en Google Cloud Console
3. **NO subas la API Key a GitHub** si tu repositorio es público
4. **Usa diferentes API Keys** para desarrollo y producción

### Uso de Variables de Entorno (Opcional pero Recomendado):

1. Instala el paquete `flutter_dotenv`:
   ```bash
   flutter pub add flutter_dotenv
   ```

2. Crea un archivo `.env` en la raíz del proyecto:
   ```
   GOOGLE_MAPS_API_KEY=AIzaSyA1B2C3D4E5F6G7H8I9J0K1L2M3N4O5P6Q
   ```

3. Agrega `.env` a tu `.gitignore`:
   ```
   .env
   ```

4. Crea un script para inyectar la API Key durante el build

## 🐛 Solución de Problemas

### Problema: Mapa muestra fondo amarillo o gris

**Causas posibles:**
- API Key no configurada o incorrecta
- APIs no habilitadas en Google Cloud Console
- Restricciones de API Key demasiado estrictas
- App no reconstruida después de cambios

**Solución:**
1. Verifica que la API Key esté correctamente copiada (sin espacios ni comillas extra)
2. Confirma que Maps SDK for Android/iOS estén habilitadas
3. Revisa las restricciones en Google Cloud Console
4. Ejecuta `flutter clean && flutter pub get`
5. Desinstala y reinstala la app completamente

### Problema: Error "SERVICE_DISABLED"

**Causa:** Maps SDK no habilitado en Google Cloud Console

**Solución:**
1. Ve a Google Cloud Console → APIs y servicios → Biblioteca
2. Busca "Maps SDK for Android" o "Maps SDK for iOS"
3. Haz clic en "Habilitar"

### Problema: Error "API_KEY_INVALID"

**Causa:** API Key incorrecta o mal formateada

**Solución:**
1. Verifica que copiaste la API Key completa
2. No debe tener espacios, comillas ni caracteres extra
3. Debe verse como: `AIzaSyA...` (39 caracteres típicamente)

### Problema: Mapa funciona en debug pero no en release

**Causa:** Falta configurar SHA-1 de release keystore

**Solución:**
1. Genera la huella SHA-1 de tu release keystore:
   ```bash
   keytool -list -v -keystore /ruta/a/tu/release.keystore -alias tu_alias
   ```
2. Agrega esta huella en Google Cloud Console → Credenciales → Tu API Key → Restricciones de aplicación

## 📚 Recursos Adicionales

- [Documentación oficial de Google Maps Platform](https://developers.google.com/maps/documentation)
- [Google Maps Flutter Plugin](https://pub.dev/packages/google_maps_flutter)
- [Pricing de Google Maps](https://mapsplatform.google.com/pricing/)
- [Mejores prácticas de seguridad](https://developers.google.com/maps/api-security-best-practices)

## 📞 Soporte

Si encuentras problemas no cubiertos en esta documentación:

1. Revisa la consola de errores de Flutter: `flutter logs`
2. Verifica el panel de Google Cloud Console para errores de API
3. Consulta la documentación oficial del plugin
4. Abre un issue en el repositorio del proyecto
