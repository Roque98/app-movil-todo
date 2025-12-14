# 🏛️ Arquitectura del Proyecto

Esta página documenta la arquitectura, patrones de diseño y decisiones técnicas del Sistema de Gestión de Órdenes de Trabajo.

## 📋 Tabla de Contenidos

1. [Visión General](#visión-general)
2. [Capas de la Aplicación](#capas-de-la-aplicación)
3. [Modelos de Datos](#modelos-de-datos)
4. [Gestión de Estado](#gestión-de-estado)
5. [Navegación](#navegación)
6. [Servicios](#servicios)
7. [Integración con APIs Externas](#integración-con-apis-externas)
8. [Flujo de Datos](#flujo-de-datos)

---

## 1. Visión General

### Stack Tecnológico

- **Framework**: Flutter 3.10.4+
- **Lenguaje**: Dart 3.0+
- **UI**: Material Design 3
- **Gestión de Estado**: StatefulWidget (futuro: Provider/Riverpod)
- **Persistencia**: Datos dummy en memoria (futuro: SQLite/Hive)
- **Backend**: Sin backend por ahora (futuro: REST API)

### Principios de Diseño

1. **Separation of Concerns**: Modelos, Vistas y Lógica separados
2. **DRY (Don't Repeat Yourself)**: Reutilización de código
3. **KISS (Keep It Simple, Stupid)**: Soluciones simples y mantenibles
4. **Material Design**: Siguiendo guidelines de Google

---

## 2. Capas de la Aplicación

```
┌─────────────────────────────────────┐
│         PRESENTACIÓN (UI)           │
│  screens/, widgets/, components/    │
├─────────────────────────────────────┤
│       LÓGICA DE NEGOCIO             │
│          services/                  │
├─────────────────────────────────────┤
│       MODELOS DE DATOS              │
│           models/                   │
├─────────────────────────────────────┤
│       FUENTE DE DATOS               │
│    data/ (dummy), (futuro: API)    │
└─────────────────────────────────────┘
```

### Capa de Presentación (UI)

**Ubicación**: `lib/screens/`, `lib/widgets/`

**Responsabilidades**:
- Renderizar la interfaz de usuario
- Manejar interacciones del usuario
- Mostrar datos formateados
- Navegación entre pantallas

**Widgets Principales**:

```dart
// screens/
- LoginScreen          // Autenticación
- DashboardScreen      // Lista de OTs con filtros
- NuevaOTScreen        // Formulario de creación
- DetalleOTScreen      // Vista detallada
- EditarOTScreen       // Formulario de edición
- NotificacionesScreen // Centro de notificaciones
```

### Capa de Lógica de Negocio

**Ubicación**: `lib/services/`

**Responsabilidades**:
- Validaciones de negocio
- Transformación de datos
- Lógica de permisos
- Generación de PDFs

**Servicios**:

```dart
// services/
- AuthService    // Autenticación y permisos
- PdfService     // Generación de PDFs
```

### Capa de Modelos

**Ubicación**: `lib/models/`

**Responsabilidades**:
- Definir estructura de datos
- Métodos de serialización (futuro)
- Métodos auxiliares (copyWith, etc.)

**Modelos**:

```dart
// models/
- OrdenTrabajo   // Modelo principal
- Usuario        // Usuarios y roles
- Material       // Materiales usados
- Notificacion   // Notificaciones
```

### Capa de Datos

**Ubicación**: `lib/data/`

**Estado actual**: Datos dummy en memoria
**Futuro**: Integración con API REST y persistencia local

```dart
// data/
- dummy_data.dart             // Lista de OTs de ejemplo
- usuarios_dummy.dart         // Usuarios de prueba
- notificaciones_dummy.dart   // Notificaciones dummy
```

---

## 3. Modelos de Datos

### OrdenTrabajo

El modelo principal de la aplicación.

```dart
class OrdenTrabajo {
  // Identificación
  final String idOT;
  final DateTime fechaSolicitud;

  // Información de creación
  final String solicitanteId;
  final String solicitanteNombre;
  final String ubicacion;
  final double? latitud;
  final double? longitud;
  final TipoFalla tipoFalla;
  final String descripcionProblema;
  final Prioridad prioridadSolicitada;
  final List<String> archivosAdjuntos;

  // Asignación y gestión
  final String? tecnicoAsignadoId;
  final String? tecnicoAsignadoNombre;
  final DateTime? fechaAsignacion;
  final Prioridad? prioridadAsignada;
  final Duration? slaTimeRespuesta;
  final DateTime? fechaCompromiso;
  final String? comentariosGestion;

  // Estado y seguimiento
  final EstadoOT estado;
  final DateTime? fechaHoraInicioReal;
  final DateTime? fechaHoraCierreTecnico;
  final Duration? tiempoTotalTrabajado;
  final String? descripcionTrabajoRealizado;
  final List<Material> materialesUsados;
  final List<String> fotosCierre;

  // Cierre
  final bool? estatusAceptacion;
  final String? comentariosSolicitante;
  final DateTime? fechaCierreTotal;
}
```

**Enums**:

```dart
enum EstadoOT {
  abierta,           // Recién creada, sin asignar
  asignada,          // Asignada a un técnico
  enProgreso,        // Técnico trabajando
  pausada,           // Trabajo pausado temporalmente
  pendienteCierre,   // Técnico finalizó, esperando aprobación
  cerrada,           // Aceptada y cerrada
  rechazada          // Rechazada por el solicitante
}

enum TipoFalla {
  electrica,
  plomeria,
  climatizacion,
  estructural,
  limpieza,
  seguridad,
  tecnologia,
  otro
}

enum Prioridad {
  critica,  // Atención inmediata
  alta,     // Resolver pronto
  media,    // Normal
  baja      // Puede esperar
}
```

### Usuario

```dart
class Usuario {
  final String id;
  final String nombre;
  final String email;
  final String password;    // En producción, nunca almacenar en claro
  final Rol rol;
}

enum Rol {
  administrador,  // Acceso total
  supervisor,     // Gestión de OTs
  tecnico,        // Ejecución de trabajos
  solicitante     // Creación de OTs
}
```

### Material

```dart
class Material {
  final String id;
  final String nombre;
  final int cantidad;
  final double costoUnitario;

  double get costoTotal => cantidad * costoUnitario;
}
```

### Notificacion

```dart
class Notificacion {
  final String id;
  final String titulo;
  final String mensaje;
  final DateTime fecha;
  final TipoNotificacion tipo;
  final String otId;
  final bool leida;
}

enum TipoNotificacion {
  asignacion,       // OT asignada a un técnico
  cambioEstado,     // Estado de OT cambió
  vencimientoSLA,   // OT próxima a vencer SLA
  finalizacion      // Trabajo finalizado
}
```

---

## 4. Gestión de Estado

### Estado Actual: StatefulWidget

**Ventajas**:
- Simple y directo
- No requiere librerías adicionales
- Fácil de entender para principiantes

**Desventajas**:
- Difícil escalar con estado global complejo
- Puede llevar a prop drilling
- Re-renders innecesarios

**Ejemplo**:

```dart
class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<OrdenTrabajo> _ordenes = dummyOrdenes;
  String _searchQuery = '';

  void _filtrarOrdenes(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordenesFiltradas = _ordenes.where((ot) {
      // lógica de filtrado
    }).toList();

    return Scaffold(/* ... */);
  }
}
```

### Futuro: Provider o Riverpod

Para versiones futuras, se recomienda migrar a un sistema de gestión de estado más robusto:

```dart
// Ejemplo con Provider
class OrdenTrabajoProvider extends ChangeNotifier {
  List<OrdenTrabajo> _ordenes = [];

  List<OrdenTrabajo> get ordenes => _ordenes;

  void actualizarOrden(OrdenTrabajo ot) {
    final index = _ordenes.indexWhere((o) => o.idOT == ot.idOT);
    if (index != -1) {
      _ordenes[index] = ot;
      notifyListeners();
    }
  }
}
```

---

## 5. Navegación

### Navigator 1.0

Usamos el Navigator tradicional de Flutter:

```dart
// Push a nueva pantalla
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DetalleOTScreen(ordenTrabajo: ot),
  ),
);

// Pop (volver)
Navigator.pop(context);

// Pop con resultado
Navigator.pop(context, otActualizada);
```

### Pasar Datos entre Pantallas

```dart
// Pantalla origen
final result = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => EditarOTScreen(
      ordenTrabajo: ot,
      onGuardar: (otEditada) {
        // Callback cuando se guarda
      },
    ),
  ),
);

// Pantalla destino
class EditarOTScreen extends StatelessWidget {
  final OrdenTrabajo ordenTrabajo;
  final Function(OrdenTrabajo) onGuardar;

  const EditarOTScreen({
    required this.ordenTrabajo,
    required this.onGuardar,
  });
}
```

---

## 6. Servicios

### AuthService

**Responsabilidad**: Gestionar autenticación y permisos

```dart
class AuthService {
  Usuario? _usuarioActual;

  Usuario? get usuarioActual => _usuarioActual;

  bool login(String email, String password) {
    // Buscar en usuarios dummy
    final usuario = usuariosDummy.firstWhere(
      (u) => u.email == email && u.password == password,
      orElse: () => null,
    );

    if (usuario != null) {
      _usuarioActual = usuario;
      return true;
    }
    return false;
  }

  void logout() {
    _usuarioActual = null;
  }

  bool tienePermiso(Permiso permiso) {
    if (_usuarioActual == null) return false;
    return permiso.roles.contains(_usuarioActual!.rol);
  }
}
```

### PdfService

**Responsabilidad**: Generar PDFs de órdenes de trabajo

```dart
class PdfService {
  static Future<void> generarPDF(OrdenTrabajo ot) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          _buildEncabezado(ot),
          _buildInformacion(ot),
          _buildMateriales(ot),
          // ...
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'OT_${ot.idOT}.pdf',
    );
  }
}
```

---

## 7. Integración con APIs Externas

### Google Maps

**Paquetes**:
- `google_maps_flutter`: Mapa interactivo
- `geolocator`: Captura de GPS

**Configuración**:

Ver [Configuración de Google Maps](Configuracion-Google-Maps)

**Uso**:

```dart
// Capturar ubicación
final position = await Geolocator.getCurrentPosition(
  locationSettings: const LocationSettings(
    accuracy: LocationAccuracy.high,
  ),
);

// Mostrar mapa
GoogleMap(
  initialCameraPosition: CameraPosition(
    target: LatLng(position.latitude, position.longitude),
    zoom: 15,
  ),
  markers: {
    Marker(
      markerId: MarkerId('ubicacion'),
      position: LatLng(position.latitude, position.longitude),
    ),
  },
)
```

### Share Plus

**Paquete**: `share_plus`

**Uso**:

```dart
await Share.share(
  'Contenido a compartir',
  subject: 'Asunto del share',
);
```

### PDF y Printing

**Paquetes**:
- `pdf`: Generación de documentos PDF
- `printing`: Visor nativo de PDFs

```dart
final pdf = pw.Document();
pdf.addPage(/* ... */);

await Printing.layoutPdf(
  onLayout: (format) async => pdf.save(),
);
```

---

## 8. Flujo de Datos

### Ciclo de Vida de una OT

```
┌─────────────────────────────────────────────────────┐
│  1. CREACIÓN (Solicitante)                         │
│     Nueva OT → Estado: ABIERTA                     │
└────────────────┬────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────────────────────┐
│  2. ASIGNACIÓN (Supervisor/Admin)                  │
│     Asignar técnico → Estado: ASIGNADA             │
└────────────────┬────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────────────────────┐
│  3. INICIO (Técnico)                               │
│     Iniciar trabajo → Estado: EN PROGRESO          │
└────────────────┬────────────────────────────────────┘
                 ↓
        ┌────────┴─────────┐
        ↓                  ↓
┌──────────────┐    ┌──────────────┐
│  4a. PAUSA   │    │  4b. CIERRE  │
│  (Técnico)   │    │  (Técnico)   │
│              │    │              │
│  Estado:     │    │  Estado:     │
│  PAUSADA     │    │  PENDIENTE   │
│              │    │  CIERRE      │
└──────────────┘    └──────┬───────┘
        ↓                  ↓
┌──────────────┐    ┌──────────────────────┐
│  REANUDAR    │    │  5. REVISIÓN         │
│  (Técnico)   │    │     (Solicitante)    │
│              │    │                      │
│  Estado:     │    │  Opciones:           │
│  EN PROGRESO │    │  - Aceptar → CERRADA │
└──────┬───────┘    │  - Rechazar → RECHAZADA│
       │            └──────────────────────┘
       └───────→ Volver a paso 4b
```

### Flujo de Actualización de Datos

```
Pantalla (UI)
    │
    │ Usuario realiza acción (ej: Iniciar OT)
    ↓
Handler (_iniciarTrabajo)
    │
    │ Crea nueva instancia con copyWith()
    ↓
OrdenTrabajo otActualizada = ot.copyWith(
    estado: EstadoOT.enProgreso,
    fechaHoraInicioReal: DateTime.now(),
)
    │
    │ Llama al callback
    ↓
onOTActualizada(otActualizada)
    │
    │ Actualiza el estado global
    ↓
setState(() {
    _ordenes[index] = otActualizada;
})
    │
    │ Flutter reconstruye la UI
    ↓
build() se ejecuta con nuevos datos
```

---

## 🔄 Decisiones de Arquitectura

### ¿Por Qué StatefulWidget en Lugar de Provider?

**Decisión**: Usar StatefulWidget para empezar

**Razones**:
1. **Simplicidad**: Más fácil de entender para principiantes
2. **Sin dependencias adicionales**: Menos complejidad
3. **Prototipado rápido**: Implementación más veloz
4. **Migración futura**: Fácil migrar a Provider/Riverpod después

**Cuándo migrar**:
- Cuando el estado global sea muy complejo
- Cuando haya mucho "prop drilling"
- Cuando se integre con backend real

### ¿Por Qué Datos Dummy?

**Decisión**: Usar datos en memoria en lugar de backend real

**Razones**:
1. **Desarrollo independiente**: No depender de backend para empezar
2. **Testing rápido**: Datos consistentes para pruebas
3. **Demo**: Mostrar funcionalidad completa sin servidor

**Migración futura**:
- Crear capa de repositorio
- Implementar API REST client
- Agregar persistencia local (SQLite/Hive)

---

## 📚 Patrones de Diseño Utilizados

### Singleton (AuthService)

```dart
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Estado compartido en toda la app
  Usuario? _usuarioActual;
}
```

### Factory (PdfService métodos estáticos)

```dart
class PdfService {
  static Future<void> generarPDF(OrdenTrabajo ot) async {
    // Método estático para crear PDFs
  }
}
```

### Immutability (Modelos con copyWith)

```dart
class OrdenTrabajo {
  // Todos los campos final
  final String idOT;
  final EstadoOT estado;

  // Crear nueva instancia con cambios
  OrdenTrabajo copyWith({
    EstadoOT? estado,
    // ...
  }) {
    return OrdenTrabajo(
      idOT: idOT,
      estado: estado ?? this.estado,
      // ...
    );
  }
}
```

---

## 🚀 Roadmap de Arquitectura

### Corto Plazo
- [ ] Agregar tests unitarios para modelos
- [ ] Implementar capa de repositorio
- [ ] Separar lógica de UI en controladores

### Mediano Plazo
- [ ] Migrar a Provider/Riverpod
- [ ] Implementar API REST client
- [ ] Agregar persistencia local
- [ ] Implementar caché

### Largo Plazo
- [ ] Offline-first con sincronización
- [ ] GraphQL en lugar de REST
- [ ] Arquitectura limpia completa
- [ ] Microservicios en backend

---

## 📞 Referencias

- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)
- [Very Good Architecture](https://verygood.ventures/blog/very-good-flutter-architecture)
- [Clean Architecture en Flutter](https://resocoder.com/flutter-clean-architecture-tdd/)

---

**Última actualización**: Diciembre 2024
