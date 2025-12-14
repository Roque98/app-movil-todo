# 🚀 Guía de Inicio Rápido para Desarrolladores

Esta guía te ayudará a configurar tu entorno de desarrollo y comenzar a contribuir al proyecto.

## 📋 Requisitos Previos

### Software Necesario

- **Flutter SDK**: ^3.10.4 o superior
  - [Instalación de Flutter](https://docs.flutter.dev/get-started/install)
- **Dart SDK**: Se instala automáticamente con Flutter
- **Git**: Para control de versiones
- **IDE**: Uno de los siguientes:
  - Android Studio 2022.3+ con plugins de Flutter/Dart
  - VS Code con extensiones de Flutter/Dart
- **Dispositivo de Prueba**:
  - Dispositivo Android real (recomendado), o
  - Emulador Android, o
  - Simulador iOS (solo en macOS)

### Verificar Instalaciones

```bash
# Verificar Flutter
flutter doctor

# Debe mostrar:
# ✓ Flutter (Channel stable, 3.10.4, ...)
# ✓ Dart (3.x.x)
# ✓ Android toolchain
# ✓ Connected device

# Verificar Git
git --version
```

---

## ⚙️ Configuración Inicial

### 1. Fork y Clonar el Repositorio

```bash
# Fork en GitHub
# Ve a https://github.com/Roque98/app-movil-todo y haz clic en "Fork"

# Clonar tu fork
git clone https://github.com/TU_USUARIO/app-movil-todo.git
cd app-movil-todo

# Agregar el upstream
git remote add upstream https://github.com/Roque98/app-movil-todo.git

# Verificar remotes
git remote -v
```

### 2. Cambiar a la Rama develop

```bash
# El desarrollo siempre se hace en develop
git checkout develop
```

### 3. Instalar Dependencias

```bash
# Obtener todos los paquetes de pub.dev
flutter pub get

# Debería completarse sin errores
```

### 4. Configurar Google Maps API Key

⚠️ **IMPORTANTE**: Sin esto, los mapas no funcionarán.

Consulta la guía completa: [Configuración de Google Maps](Configuracion-Google-Maps)

**Resumen rápido:**

1. Obtén una API Key en [Google Cloud Console](https://console.cloud.google.com/)
2. Habilita "Maps SDK for Android" y "Maps SDK for iOS"
3. Edita los archivos:

**Android**: `android/app/src/main/AndroidManifest.xml`
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="TU_API_KEY_AQUI" />
```

**iOS**: `ios/Runner/AppDelegate.swift`
```swift
GMSServices.provideAPIKey("TU_API_KEY_AQUI")
```

### 5. Verificar que Todo Funcione

```bash
# Analizar el código (no debe haber errores)
flutter analyze

# Ejecutar en modo debug
flutter run

# Si todo está bien, la app se abrirá en tu dispositivo/emulador
```

---

## 🏗️ Estructura del Proyecto

```
app-movil-todo/
├── lib/
│   ├── data/                    # Datos dummy
│   │   ├── dummy_data.dart
│   │   ├── usuarios_dummy.dart
│   │   └── notificaciones_dummy.dart
│   ├── models/                  # Modelos de datos
│   │   ├── orden_trabajo.dart
│   │   ├── usuario.dart
│   │   ├── material.dart
│   │   └── notificacion.dart
│   ├── screens/                 # Pantallas de la UI
│   │   ├── login_screen.dart
│   │   ├── dashboard_screen.dart
│   │   ├── nueva_ot_screen.dart
│   │   ├── detalle_ot_screen.dart
│   │   ├── editar_ot_screen.dart
│   │   └── notificaciones_screen.dart
│   ├── services/                # Lógica de negocio
│   │   ├── auth_service.dart
│   │   └── pdf_service.dart
│   └── main.dart                # Punto de entrada
├── android/                     # Configuración Android
├── ios/                         # Configuración iOS
├── docs/                        # Documentación adicional
│   └── CONFIGURACION_GOOGLE_MAPS.md
├── wiki/                        # Archivos para GitHub Wiki
├── .github/                     # Templates de GitHub
│   ├── ISSUE_TEMPLATE/
│   └── pull_request_template.md
├── pubspec.yaml                 # Dependencias
├── README.md                    # Documentación principal
├── CONTRIBUTING.md              # Guía de contribución
└── TAREAS_PENDIENTES.md         # Roadmap del proyecto
```

---

## 🔧 Configuración del IDE

### VS Code

#### Extensiones Recomendadas

```json
{
  "recommendations": [
    "Dart-Code.dart-code",
    "Dart-Code.flutter",
    "alexisvt.flutter-snippets",
    "Nash.awesome-flutter-snippets",
    "usernamehw.errorlens",
    "eamodio.gitlens",
    "aaron-bond.better-comments"
  ]
}
```

#### Settings.json

```json
{
  "[dart]": {
    "editor.formatOnSave": true,
    "editor.formatOnType": true,
    "editor.rulers": [80],
    "editor.selectionHighlight": false,
    "editor.suggest.snippetsPreventQuickSuggestions": false,
    "editor.suggestSelection": "first",
    "editor.tabCompletion": "onlySnippets",
    "editor.wordBasedSuggestions": false
  },
  "dart.lineLength": 120
}
```

### Android Studio

#### Plugins Necesarios

1. File → Settings → Plugins
2. Buscar e instalar:
   - Flutter
   - Dart
   - GitToolBox (opcional)

#### Configurar Flutter SDK

1. File → Settings → Languages & Frameworks → Flutter
2. Flutter SDK path: `/ruta/a/flutter/sdk`

---

## 🌿 Workflow de Desarrollo

### Crear una Nueva Feature

```bash
# 1. Asegurarte de estar en develop y actualizado
git checkout develop
git pull upstream develop

# 2. Crear rama de feature
git checkout -b feature/nombre-de-tu-feature

# 3. Hacer cambios en el código
# ... editar archivos ...

# 4. Verificar cambios
flutter analyze
flutter format .

# 5. Commit
git add .
git commit -m "feat(scope): descripción del cambio"

# 6. Push a tu fork
git push origin feature/nombre-de-tu-feature

# 7. Crear Pull Request en GitHub
# Base branch: develop (NO main)
```

### Convenciones de Commits

Usamos [Conventional Commits](https://www.conventionalcommits.org/):

```bash
<type>(<scope>): <description>

# Ejemplos:
feat(maps): agregar integración con Google Maps
fix(login): corregir validación de email vació
docs(readme): actualizar instrucciones de instalación
refactor(models): simplificar OrdenTrabajo model
test(auth): agregar tests para AuthService
chore(deps): actualizar dependencias
```

**Tipos válidos:**
- `feat`: Nueva característica
- `fix`: Corrección de bug
- `docs`: Solo documentación
- `style`: Formato (sin cambios de código)
- `refactor`: Refactorización
- `perf`: Mejora de rendimiento
- `test`: Tests
- `chore`: Mantenimiento

---

## 🧪 Testing

### Ejecutar Tests

```bash
# Todos los tests
flutter test

# Un archivo específico
flutter test test/models/orden_trabajo_test.dart

# Con coverage
flutter test --coverage
```

### Escribir Tests

```dart
// test/models/orden_trabajo_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:tu_app/models/orden_trabajo.dart';

void main() {
  group('OrdenTrabajo', () {
    test('debe crear una instancia válida', () {
      final ot = OrdenTrabajo(
        idOT: 'OT-001',
        // ... otros campos
      );

      expect(ot.idOT, 'OT-001');
      expect(ot.estado, EstadoOT.abierta);
    });

    test('copyWith debe actualizar estado', () {
      final ot = OrdenTrabajo(/* ... */);
      final otActualizada = ot.copyWith(estado: EstadoOT.asignada);

      expect(otActualizada.estado, EstadoOT.asignada);
      expect(ot.estado, EstadoOT.abierta); // original no cambia
    });
  });
}
```

---

## 📦 Dependencias Principales

### Geolocalización y Mapas

```yaml
geolocator: ^13.0.2           # Captura de GPS
google_maps_flutter: ^2.10.0  # Mapas interactivos
```

### PDF y Compartir

```yaml
pdf: ^3.11.1                  # Generación de PDFs
printing: ^5.13.4             # Visor de PDFs
share_plus: ^10.1.2           # Compartir nativo
```

### UI

```yaml
flutter:
  sdk: flutter
```

---

## 🐛 Debugging

### Logs

```dart
import 'dart:developer' as developer;

// En lugar de print(), usa log():
developer.log('Mensaje de debug', name: 'MiWidget');
```

### Ver Logs

```bash
# En tiempo real
flutter logs

# Filtrar por tag
flutter logs | grep "MiWidget"
```

### DevTools

```bash
# Abrir Flutter DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

---

## 🔨 Build para Producción

### Android APK

```bash
# Debug APK (más rápido para testing)
flutter build apk --debug

# Release APK (optimizado)
flutter build apk --release

# El APK estará en: build/app/outputs/flutter-apk/
```

### Android App Bundle (AAB)

```bash
# Para publicar en Google Play Store
flutter build appbundle --release
```

### iOS

```bash
# Requiere macOS y Xcode
flutter build ios --release
```

---

## 📚 Recursos de Aprendizaje

### Flutter

- [Documentación Oficial de Flutter](https://docs.flutter.dev/)
- [Flutter Widget of the Week](https://www.youtube.com/playlist?list=PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)

### Este Proyecto

- [Arquitectura](Arquitectura) - Cómo está estructurado el código
- [API Reference](API-Reference) - Documentación de clases
- [Testing](Testing) - Guía de testing
- [CONTRIBUTING.md](https://github.com/Roque98/app-movil-todo/blob/develop/CONTRIBUTING.md)

---

## ❓ FAQ Rápido

**P: ¿En qué rama debo trabajar?**
R: Siempre en `develop` o en una rama de feature creada desde `develop`.

**P: ¿Puedo hacer commits directos a develop o main?**
R: No. Siempre usa Pull Requests.

**P: ¿Cómo actualizo mi fork con los últimos cambios?**
```bash
git fetch upstream
git checkout develop
git merge upstream/develop
git push origin develop
```

**P: ¿Qué hago si `flutter pub get` falla?**
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

**P: Los mapas no se ven, solo fondo amarillo**
R: Necesitas configurar la API Key de Google Maps. Ver [Configuración de Google Maps](Configuracion-Google-Maps).

---

## 🚦 Próximos Pasos

1. ✅ Configuraste tu entorno de desarrollo
2. ⏭️ Lee la [Arquitectura del Proyecto](Arquitectura)
3. ⏭️ Revisa [CONTRIBUTING.md](https://github.com/Roque98/app-movil-todo/blob/develop/CONTRIBUTING.md)
4. ⏭️ Busca un issue etiquetado como `good first issue`
5. ⏭️ Crea tu primera Pull Request

---

## 📞 Soporte

¿Tienes problemas con el setup?

1. Revisa [FAQ Desarrolladores](FAQ-Desarrolladores)
2. Ejecuta `flutter doctor -v` y comparte el output
3. Abre un issue en [GitHub](https://github.com/Roque98/app-movil-todo/issues)

---

**¡Bienvenido al equipo de desarrollo!** 🎉

**Última actualización**: Diciembre 2024
