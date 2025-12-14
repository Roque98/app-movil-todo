# 🔧 Sistema de Gestión de Órdenes de Trabajo (Mantenimiento)

Aplicación móvil desarrollada en Flutter para la gestión integral de órdenes de trabajo de mantenimiento, con autenticación por roles y flujos completos para técnicos, solicitantes y administradores.

## ✨ Características Principales

### 🎯 Gestión de Órdenes de Trabajo
- ✅ Crear, editar y eliminar OTs
- ✅ Asignación de técnicos
- ✅ Seguimiento del estado en tiempo real
- ✅ Historial completo de cambios
- ✅ Carga de archivos adjuntos y fotos de evidencia

### 👥 Sistema de Autenticación por Roles
- **Administrador**: Control total del sistema
- **Supervisor**: Gestión de OTs y asignación de técnicos
- **Técnico**: Ejecución de trabajos y actualización de estado
- **Solicitante**: Creación de OTs y aceptación/rechazo de trabajos

### 🔍 Búsqueda y Filtros Avanzados
- Búsqueda por texto en múltiples campos
- Filtros por estado, tipo de falla, prioridad y técnico
- Ordenamiento configurable (fecha y prioridad)
- Filtros combinables

### 🗺️ Geolocalización y Mapas
- Captura de coordenadas GPS al crear OTs
- Vista previa del mapa con marcador
- Mapa interactivo en detalle de OT
- Integración con Google Maps

### 📄 Exportación y Compartir
- Generación de PDFs profesionales de OTs
- Compartir OT vía apps nativas (WhatsApp, Email, etc.)
- Formato de texto con toda la información relevante
- Links a Google Maps en texto compartido

### 🔔 Sistema de Notificaciones
- Centro de notificaciones integrado
- Alertas de asignación de OTs
- Notificaciones de cambios de estado
- Notificaciones de vencimiento de SLA
- Contador de notificaciones no leídas

### 📊 Dashboard con KPIs
- Contadores en tiempo real por estado
- Visualización tipo cards con gradientes
- Resumen estadístico por rol

### 📱 Flujos de Trabajo Implementados
1. **Flujo del Solicitante**:
   - Crear OT con descripción y archivos adjuntos
   - Seguimiento del estado
   - Aceptar/Rechazar trabajo con comentarios

2. **Flujo del Técnico**:
   - Ver OTs asignadas
   - Iniciar, pausar y reanudar trabajo
   - Cerrar OT con descripción y fotos de evidencia
   - Cálculo automático de tiempos

3. **Flujo del Supervisor/Admin**:
   - Vista completa de todas las OTs
   - Asignación de técnicos
   - Edición de prioridades
   - Gestión de estados

## 🚀 Tecnologías y Arquitectura

- **Framework**: Flutter (Dart)
- **Gestión de Estado**: StatefulWidget
- **UI**: Material Design 3
- **Datos**: Dummy data (listo para integración con backend)

## 📁 Estructura del Proyecto

```
lib/
├── data/
│   ├── dummy_data.dart              # Datos de ejemplo de OTs
│   ├── usuarios_dummy.dart          # Usuarios de prueba
│   └── notificaciones_dummy.dart    # Notificaciones de ejemplo
├── models/
│   ├── orden_trabajo.dart           # Modelo de OT con enums y métodos
│   ├── usuario.dart                 # Modelo de usuario y permisos
│   ├── material.dart                # Modelo de materiales usados
│   └── notificacion.dart            # Modelo de notificaciones
├── screens/
│   ├── login_screen.dart            # Pantalla de autenticación
│   ├── dashboard_screen.dart        # Dashboard principal con filtros
│   ├── nueva_ot_screen.dart         # Formulario de creación con GPS y mapa
│   ├── detalle_ot_screen.dart       # Vista detallada, acciones y mapa
│   ├── editar_ot_screen.dart        # Formulario de edición con tabs
│   └── notificaciones_screen.dart   # Centro de notificaciones
├── services/
│   ├── auth_service.dart            # Servicio de autenticación
│   └── pdf_service.dart             # Servicio de generación de PDFs
└── main.dart                        # Punto de entrada de la aplicación
```

## 🎨 Capturas de Pantalla

_(Pendiente agregar screenshots)_

## 🔧 Instalación y Configuración

### Prerrequisitos
- Flutter SDK ^3.10.4
- Dart SDK
- Android Studio / VS Code
- Dispositivo o emulador Android/iOS

### Pasos de Instalación

1. **Clonar el repositorio**
```bash
git clone https://github.com/Roque98/app-movil-todo.git
cd app-movil-todo
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Configurar Google Maps API Key** (Obligatorio para funcionalidad de mapas)

⚠️ **IMPORTANTE**: Para que el mapa funcione correctamente, debes configurar una API Key de Google Maps.

Ver la guía completa: **[docs/CONFIGURACION_GOOGLE_MAPS.md](docs/CONFIGURACION_GOOGLE_MAPS.md)**

Pasos rápidos:
- Obtén una API Key en [Google Cloud Console](https://console.cloud.google.com/)
- Edita `android/app/src/main/AndroidManifest.xml` (línea 43)
- Edita `ios/Runner/AppDelegate.swift` (línea 12)
- Reemplaza `TU_API_KEY_AQUI` con tu API Key

4. **Ejecutar la aplicación**
```bash
flutter run
```

## 👤 Usuarios de Prueba

| Email | Contraseña | Rol | Descripción |
|-------|-----------|-----|-------------|
| admin@empresa.com | admin123 | Administrador | Acceso completo |
| supervisor@empresa.com | super123 | Supervisor | Gestión de OTs |
| tecnico@empresa.com | tecnico123 | Técnico | Ejecución de trabajos |
| solicitante@empresa.com | solicitante123 | Solicitante | Creación de OTs |

## 📋 Estado del Proyecto

**Versión**: 1.0.0 (Sistema funcional con datos dummy)
**Progreso**: 52% (11/20 tareas completadas)

### ✅ Completado
- ✅ Sistema de autenticación por roles
- ✅ CRUD completo de órdenes de trabajo
- ✅ Filtros y búsqueda avanzada
- ✅ Flujos de trabajo completos (iniciar, pausar, reanudar, cerrar)
- ✅ Carga de archivos simulada con validaciones
- ✅ Historial completo de cambios
- ✅ Sistema de notificaciones integrado
- ✅ Reasignación de técnicos con validaciones de flujo
- ✅ **Geolocalización con GPS y Google Maps**
- ✅ **Exportación de OTs a PDF profesional**
- ✅ **Compartir OTs vía apps nativas**

### 🚧 En Progreso / Pendiente
- ⏳ Integración con backend (API REST)
- ⏳ Carga real de archivos (image_picker, file_picker)
- ⏳ Notificaciones push (Firebase Cloud Messaging)
- ⏳ Persistencia local (SQLite/Hive)
- ⏳ Tests automatizados (unit, widget, integration)
- ⏳ Dashboard avanzado con estadísticas y gráficas
- ⏳ Modo offline con sincronización
- ⏳ Historial de pausas detallado
- ⏳ Sistema de materiales mejorado

Ver [TAREAS_PENDIENTES.md](TAREAS_PENDIENTES.md) para detalles completos.

## 🌿 GitFlow

El proyecto sigue las buenas prácticas de GitFlow:

- **main**: Rama de producción estable
- **develop**: Rama de desarrollo activo
- **feature/**: Nuevas características
- **bugfix/**: Corrección de bugs
- **hotfix/**: Parches urgentes

## 🤝 Contribución

1. Fork el proyecto
2. Crear rama de feature (`git checkout -b feature/nueva-caracteristica`)
3. Commit cambios (`git commit -m 'feat: agregar nueva característica'`)
4. Push a la rama (`git push origin feature/nueva-caracteristica`)
5. Abrir Pull Request a `develop`

## 📄 Licencia

Este proyecto es privado y está bajo desarrollo.

## 👨‍💻 Autor

**Angel Roque**
- GitHub: [@Roque98](https://github.com/Roque98)

---

🤖 **Generated with [Claude Code](https://claude.com/claude-code)**

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
