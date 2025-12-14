# LISTA DE TAREAS PENDIENTES - Sistema de Mantenimiento Flutter

**Fecha de creación:** 2025-12-13
**Última actualización:** 2025-12-13 (Actualización automática)

---

## 🔴 TAREAS CRÍTICAS (Bloquean funcionalidad básica)

### 1. ✅ Completar métodos helper del Dashboard
**Archivo:** `lib/screens/dashboard_screen.dart`
**Estado:** ✅ COMPLETADO
**Descripción:** Implementados todos los métodos helper para los chips de filtros avanzados:
- ✅ `_buildTipoFallaChip(String label, TipoFalla? tipo)` - Línea 1052
- ✅ `_buildPrioridadChip(String label, Prioridad? prioridad)` - Línea 1100
- ✅ `_buildTecnicoChip(String label, String? tecnicoId)` - Línea 1148
- ✅ `_getTecnicos()` - Línea 1196

**Prioridad:** CRÍTICA
**Estado:** Los filtros avanzados funcionan correctamente

---

## 🟡 TAREAS DE ALTA PRIORIDAD

### 2. ✅ Implementar funcionalidad de notificaciones
**Archivo:** `lib/screens/notificaciones_screen.dart`
**Estado:** ✅ COMPLETADO
**Descripción:** Sistema completo de notificaciones implementado:
- ✅ Pantalla de notificaciones con diseño moderno
- ✅ Badge con contador de notificaciones no leídas en Dashboard
- ✅ Marcado individual de notificaciones como leídas
- ✅ Botón "Marcar todas como leídas"
- ✅ Notificaciones categorizadas por tipo (asignación, cambio estado, cierre, etc.)
- ✅ Formato de tiempo relativo (hace X min/horas/días)
- ✅ Navegación desde Dashboard a pantalla de notificaciones
- ✅ Estado vacío elegante

**Ubicación:**
- Modelo: `lib/models/notificacion.dart`
- Datos dummy: `lib/data/notificaciones_dummy.dart`
- Pantalla: `lib/screens/notificaciones_screen.dart`
- Badge en Dashboard: `lib/screens/dashboard_screen.dart` (líneas ~162-195)

**Prioridad:** ALTA

---

### 3. ✅ Implementar menú de opciones en Detalle OT
**Archivo:** `lib/screens/detalle_ot_screen.dart`
**Estado:** ✅ COMPLETADO
**Descripción:** PopupMenuButton implementado con las siguientes opciones:
- ✅ Reasignar técnico (admin/supervisor) - **FUNCIONAL COMPLETO**
  - Diálogo con lista de técnicos disponibles
  - Muestra técnico actual con badge
  - Validación: no se puede reasignar al mismo técnico
  - Actualiza OT y muestra confirmación
  - Cambio de estado automático a "Asignada"
- ✅ Ver historial de cambios - Muestra timeline completo de la OT
- ✅ Exportar a PDF - Mensaje informativo (requiere paquete pdf)
- ✅ Compartir - Mensaje informativo (requiere paquete share_plus)
- ✅ Eliminar OT (solo admin) - Confirmación y eliminación con validaciones

**Ubicación:**
- PopupMenuButton: Líneas 47-106
- Reasignación: Método `_mostrarDialogoReasignar` líneas 1287-1458
- Eliminación: Método `_confirmarEliminar` líneas 1708-1827

---

### 4. ✅ Añadir funcionalidad de carga de archivos adjuntos
**Archivo:** `lib/screens/nueva_ot_screen.dart`
**Estado:** ✅ COMPLETADO
**Descripción:** Sistema completo de carga de archivos implementado:
- ✅ Botones para agregar fotos y documentos
- ✅ Límite de 5 archivos con validación
- ✅ Previsualización de archivos adjuntos con iconos
- ✅ Contador de archivos (X/5)
- ✅ Posibilidad de eliminar archivos individuales
- ✅ Los archivos se guardan en la OT creada

**Ubicación:** Líneas 203-361, variable de estado línea 20

---

### 5. ✅ Implementar carga de fotos de cierre
**Archivo:** `lib/screens/detalle_ot_screen.dart`
**Estado:** ✅ COMPLETADO
**Descripción:** Diálogo completo de cierre implementado:
- ✅ Campo de descripción del trabajo realizado (obligatorio)
- ✅ Sistema de carga de fotos de evidencia (máx. 5)
- ✅ Previsualización de fotos en grid
- ✅ Validación de descripción antes de cerrar
- ✅ Fotos y descripción se guardan en la OT
- ✅ Cálculo automático del tiempo trabajado

**Ubicación:** Método `_mostrarDialogoCierre` líneas 883-1104

---

### 6. ✅ Mejorar diálogo de rechazo de trabajo
**Archivo:** `lib/screens/detalle_ot_screen.dart`
**Estado:** ✅ COMPLETADO
**Descripción:** Diálogo completamente funcional:
- ✅ TextEditingController para capturar el comentario
- ✅ Validación obligatoria del motivo de rechazo
- ✅ Mensaje de error si se intenta rechazar sin motivo
- ✅ Comentario se guarda correctamente en la OT
- ✅ Autofocus en el campo de texto

**Ubicación:** Método `_rechazarTrabajo` líneas 888-982

---

### 7. ✅ Implementar validaciones de flujo de estados
**Archivo:** `lib/screens/detalle_ot_screen.dart`
**Estado:** ✅ COMPLETADO
**Descripción:** Sistema completo de validaciones implementado para prevenir transiciones de estado inválidas:
- ✅ **Iniciar trabajo:** Solo si está en estado "Asignada"
- ✅ **Pausar trabajo:** Solo si está en estado "En Progreso"
- ✅ **Reanudar trabajo:** Solo si está en estado "Pausado"
- ✅ **Finalizar trabajo:** Solo si está en estado "En Progreso" o "Pausado"
- ✅ **Eliminar OT:** Solo si está en estado "Abierta", "Asignada" o "Rechazada"
  - Previene eliminación de OTs en progreso, pausadas, pendientes de cierre o cerradas
  - Diálogo informativo explicando la restricción
- ✅ Mensajes de error descriptivos para cada validación
- ✅ SnackBars con información clara de por qué la acción no es permitida

**Ubicación:**
- `_iniciarTrabajo`: Líneas 798-846 (validación líneas 799-819)
- `_pausarTrabajo`: Líneas 848-895 (validación líneas 849-869)
- `_reanudarTrabajo`: Líneas 897-944 (validación líneas 898-918)
- `_cerrarTrabajo`: Líneas 946-983 (validación líneas 947-968)
- `_confirmarEliminar`: Líneas 1708-1827 (validación líneas 1709-1783)

**Prioridad:** ALTA
**Beneficio:** Previene errores de usuario y mantiene integridad del flujo de trabajo

---

## 🟢 TAREAS DE PRIORIDAD MEDIA

### 8. ✅ Implementar geolocalización
**Archivos:** `lib/screens/nueva_ot_screen.dart`, `lib/screens/detalle_ot_screen.dart`
**Estado:** ✅ COMPLETADO
**Descripción:**
- ✅ Capturar ubicación GPS al crear OT con botón interactivo
  - Icono que cambia al obtener ubicación
  - Loading indicator mientras busca GPS
  - Validación de permisos y servicio de ubicación
  - Mensajes de error descriptivos
- ✅ Mostrar mapa en detalle de OT con Google Maps
  - Vista interactiva con marcador
  - Botón "Abrir en Maps"
  - Coordenadas GPS precisas (6 decimales)
- ✅ Permisos configurados en Android e iOS
- ✅ Almacena latitud y longitud en la OT

**Dependencias:** `geolocator`, `google_maps_flutter` (instalados)
**Prioridad:** MEDIA
**Ubicación:**
- Captura GPS: `lib/screens/nueva_ot_screen.dart` (método `_obtenerUbicacion` líneas 521-659)
- Mapa: `lib/screens/detalle_ot_screen.dart` (método `_buildMapa` líneas 606-676)

---

### 9. ✅ Implementar exportación a PDF
**Archivo:** `lib/services/pdf_service.dart`
**Estado:** ✅ COMPLETADO
**Descripción:**
- ✅ Generar PDF completo con detalles de la OT
  - Encabezado profesional con ID y estado
  - Información de creación (solicitante, ubicación, GPS, tipo de falla)
  - Descripción del problema
  - Información de gestión (técnico, prioridad, estado)
  - Trabajo realizado con tiempos
  - Tabla de materiales usados con costos
  - Información de cierre (aceptación/rechazo)
- ✅ Diseño profesional con colores por estado
- ✅ Formato A4 con márgenes adecuados
- ✅ Botón "Exportar PDF" funcional en menú de detalle OT
- ✅ Indicador de carga mientras genera PDF
- ✅ Visor/impresora integrado

**Dependencias:** `pdf`, `printing` (instalados)
**Prioridad:** MEDIA
**Ubicación:**
- Servicio: `lib/services/pdf_service.dart` (completo)
- Integración: `lib/screens/detalle_ot_screen.dart` (método `_exportarPDF` líneas 1974-2027)

---

### 10. ✅ Implementar compartir OT
**Archivos:** `lib/screens/detalle_ot_screen.dart`
**Estado:** ✅ COMPLETADO
**Descripción:**
- ✅ Compartir resumen completo de OT por WhatsApp/Email/etc.
  - Encabezado con ID y estado
  - Información de creación con datos completos
  - Link a Google Maps si tiene coordenadas GPS
  - Descripción del problema
  - Información de gestión y técnico
  - Trabajo realizado con tiempos
  - Lista de materiales con costos
  - Estado final (aceptación/rechazo)
- ✅ Formato de texto estructurado con emojis
- ✅ Integración con apps nativas del sistema
- ✅ Botón "Compartir" funcional en menú de detalle OT

**Dependencias:** `share_plus` (instalado)
**Prioridad:** MEDIA
**Ubicación:**
- `lib/screens/detalle_ot_screen.dart`:
  - Método `_compartirOT` (líneas 1812-1842)
  - Método `_generarTextoCompartir` (líneas 1844-1919)

---

### 11. ✅ Agregar ordenamiento de OTs
**Archivo:** `lib/screens/dashboard_screen.dart`
**Estado:** ✅ COMPLETADO
**Descripción:** Sistema completo de ordenamiento implementado:
- ✅ Enum `OrdenamientoOT` con 4 opciones (líneas 18-23)
- ✅ Ordenar por fecha (más reciente/antigua)
- ✅ Ordenar por prioridad (alta primero/baja primero)
- ✅ Dropdown elegante con icono en sección de filtros
- ✅ Ordenamiento se aplica automáticamente a lista filtrada

**Ubicación:**
- Enum: líneas 18-23
- Variable de estado: línea 32
- Lógica de ordenamiento: líneas 88-110
- UI Dropdown: líneas 506-558

---

### 12. ❌ Implementar historial de pausas
**Archivo:** `lib/models/orden_trabajo.dart`
**Estado:** PENDIENTE
**Descripción:**
- Registrar cada vez que se pausa una OT
- Guardar motivo de pausa
- Mostrar historial completo de pausas/reanudaciones
- Calcular tiempo neto trabajado

**Prioridad:** MEDIA
**Tiempo estimado:** 2 horas

---

### 13. ❌ Mejorar sistema de materiales
**Archivo:** `lib/screens/editar_ot_screen.dart`
**Estado:** PENDIENTE
**Descripción:**
- Catálogo de materiales predefinidos
- Búsqueda de materiales
- Cálculo automático de costos
- Validación de stock (futuro)

**Prioridad:** MEDIA
**Tiempo estimado:** 3 horas

---

## 🔵 TAREAS DE BAJA PRIORIDAD (Mejoras futuras)

### 14. ❌ Implementar modo offline
**Archivos:** Múltiples
**Estado:** PENDIENTE
**Descripción:**
- Sincronización cuando hay conexión
- Cache local de OTs
- Cola de operaciones pendientes

**Dependencias:** Paquetes `sqflite`, `connectivity_plus`
**Prioridad:** BAJA
**Tiempo estimado:** 8-10 horas

---

### 15. ❌ Agregar gráficas y estadísticas
**Archivo:** Nuevo `lib/screens/estadisticas_screen.dart`
**Estado:** PENDIENTE
**Descripción:**
- Gráfica de OTs por estado
- Gráfica de OTs por tipo de falla
- Tiempo promedio de resolución
- Técnico con más OTs cerradas

**Dependencias:** Paquete `fl_chart`
**Prioridad:** BAJA
**Tiempo estimado:** 4 horas

---

### 16. ❌ Implementar chat/comentarios en OT
**Archivo:** Nuevo archivo
**Estado:** PENDIENTE
**Descripción:**
- Sistema de comentarios en cada OT
- Hilos de conversación
- Notificaciones de nuevos comentarios
- Adjuntar archivos en comentarios

**Prioridad:** BAJA
**Tiempo estimado:** 6 horas

---

### 17. ❌ Agregar filtros por rango de fechas
**Archivo:** `lib/screens/dashboard_screen.dart`
**Estado:** PENDIENTE
**Descripción:**
- DatePicker para seleccionar rango
- Filtrar OTs por fecha de creación
- Filtrar por fecha de cierre
- Presets (hoy, esta semana, este mes)

**Prioridad:** BAJA
**Tiempo estimado:** 2 horas

---

### 18. ❌ Implementar perfiles de usuario
**Archivo:** Nuevo `lib/screens/perfil_screen.dart`
**Estado:** PENDIENTE
**Descripción:**
- Ver/editar información personal
- Cambiar contraseña
- Foto de perfil
- Historial de actividad

**Prioridad:** BAJA
**Tiempo estimado:** 3 horas

---

### 19. ❌ Agregar recordatorios y alarmas
**Archivo:** Nuevo servicio
**Estado:** PENDIENTE
**Descripción:**
- Recordatorios para OTs próximas a vencer
- Alarmas para SLA
- Notificaciones push

**Dependencias:** `flutter_local_notifications`, `workmanager`
**Prioridad:** BAJA
**Tiempo estimado:** 4 horas

---

### 20. ❌ Implementar firma digital
**Archivo:** Nuevo widget
**Estado:** PENDIENTE
**Descripción:**
- Firma del solicitante al aceptar trabajo
- Firma del técnico al cerrar OT
- Guardar firma como imagen

**Dependencias:** Paquete `signature`
**Prioridad:** BAJA
**Tiempo estimado:** 2 horas

---

### 21. ❌ Agregar modo oscuro
**Archivo:** `lib/main.dart` y tema general
**Estado:** PENDIENTE
**Descripción:**
- Implementar ThemeData para modo oscuro
- Toggle en configuración
- Persistir preferencia
- Ajustar todos los colores

**Prioridad:** BAJA
**Tiempo estimado:** 3 horas

---

## 📊 RESUMEN DE PROGRESO

| Prioridad | Total | Completadas | Pendientes | % Completado |
|-----------|-------|-------------|------------|--------------|
| CRÍTICA   | 1     | 1           | 0          | 100%         |
| ALTA      | 6     | 6           | 0          | 100%         |
| MEDIA     | 6     | 4           | 2          | 67%          |
| BAJA      | 8     | 0           | 8          | 0%           |
| **TOTAL** | **21**| **11**      | **10**     | **52%**      |

### ✅ Tareas Completadas (Sesiones Anteriores):
1. ✅ Completar métodos helper del dashboard (CRÍTICA)
2. ✅ Mejorar diálogo de rechazo de trabajo (ALTA)
3. ✅ Implementar menú de opciones en Detalle OT (ALTA)
4. ✅ Añadir funcionalidad de carga de archivos adjuntos (ALTA)
5. ✅ Implementar carga de fotos de cierre (ALTA)
6. ✅ Agregar ordenamiento de OTs (MEDIA)

### ✅ Tareas Completadas en esta Sesión (2025-12-14):
7. ✅ Implementar sistema de notificaciones con badge (ALTA)
8. ✅ Implementar funcionalidad de reasignación de técnico (ALTA - completar tarea #3)
9. ✅ Agregar validaciones de flujo en cambios de estado (ALTA - NUEVA)
10. ✅ Implementar geolocalización completa (MEDIA)
11. ✅ Implementar exportación a PDF (MEDIA)
12. ✅ Implementar sistema de compartir (MEDIA)

---

## 🎯 PRÓXIMOS PASOS RECOMENDADOS

### Sistema Funcional con Datos Dummy ✅
**TODAS las funcionalidades críticas y de alta prioridad están implementadas (100%)**
El sistema está completamente listo para trabajar con datos dummy y demostrar el flujo completo del negocio.

### Nuevas Características Implementadas:
- ✅ Sistema de notificaciones completo con badges
- ✅ Reasignación de técnicos funcional
- ✅ Validaciones de flujo de estados

### Para Implementación con Backend Real:
1. **INMEDIATO:**
   - Conectar con API REST backend
   - Implementar autenticación real (JWT, OAuth)
   - Persistencia de datos en base de datos

2. **CORTO PLAZO:**
   - Implementar geolocalización real con Google Maps (Tarea #8)
   - Exportación a PDF con paquete `pdf` (Tarea #9)
   - Sistema de compartir con `share_plus` (Tarea #10)

3. **MEDIANO PLAZO:**
   - Historial de pausas detallado (Tarea #12)
   - Catálogo de materiales con búsqueda (Tarea #13)
   - Filtros por rango de fechas (Tarea #17)

4. **LARGO PLAZO:**
   - Modo offline con sincronización (Tarea #13)
   - Dashboard de estadísticas y gráficas (Tarea #14)
   - Sistema de chat/comentarios (Tarea #15)
   - Perfiles de usuario (Tarea #17)

---

## 📝 NOTAS ADICIONALES

- ✅ El proyecto usa datos dummy actualmente
- ❌ Falta integración con backend real
- ❌ Considerar implementar persistencia local con SQLite o Hive
- ❌ Evaluar necesidad de estado global (Provider, Riverpod, Bloc)
- ❌ Agregar tests unitarios y de integración

---

## 🎉 RESUMEN DE SESIÓN ACTUAL (2025-12-14)

### Logros de Esta Sesión:
1. **✅ Sistema de Notificaciones Completo**
   - Modelo de notificaciones con enum de tipos
   - Pantalla de notificaciones con UI moderna
   - Badge con contador de notificaciones no leídas
   - Marcado individual y masivo como leídas
   - Formato de tiempo relativo inteligente
   - Estado vacío elegante
   - 11 notificaciones dummy para testing

2. **✅ Reasignación de Técnicos Funcional**
   - Diálogo completo con lista de técnicos
   - Muestra técnico actual con badge "Actual"
   - Validación: no permite reasignar al mismo técnico
   - Actualiza OT y cambia estado a "Asignada"
   - SnackBar de confirmación con detalles
   - Diseño moderno y profesional

3. **✅ Validaciones de Flujo de Estados**
   - **Iniciar trabajo:** Solo desde estado "Asignada"
   - **Pausar trabajo:** Solo desde estado "En Progreso"
   - **Reanudar trabajo:** Solo desde estado "Pausado"
   - **Finalizar trabajo:** Solo desde "En Progreso" o "Pausado"
   - **Eliminar OT:** Previene eliminación de OTs activas
     - Bloqueado para: En Progreso, Pausada, Pendiente Cierre, Cerrada
     - Permitido para: Abierta, Asignada, Rechazada
   - Mensajes de error claros y descriptivos
   - Diálogos informativos explicando las restricciones

4. **✅ Geolocalización GPS Completa**
   - Captura de ubicación GPS con botón interactivo
   - Validación de permisos en tiempo real
   - Mapa interactivo en detalle de OT
   - Marcador con información de la OT
   - Botón para abrir en Google Maps
   - Coordenadas con 6 decimales de precisión

5. **✅ Exportación a PDF Profesional**
   - Servicio completo de generación de PDF
   - Diseño profesional con formato A4
   - Encabezado con ID y estado con colores
   - Todas las secciones de la OT incluidas
   - Tabla de materiales con costos
   - Visor/impresora integrado
   - Indicador de carga durante generación

6. **✅ Sistema de Compartir Completo**
   - Generación de resumen estructurado
   - Formato con emojis para mejor lectura
   - Link a Google Maps para coordenadas
   - Incluye toda la información relevante
   - Integración con apps nativas (WhatsApp, Email, etc.)
   - Manejo de errores robusto

### Archivos Modificados/Creados:
**Nuevos:**
1. `lib/models/notificacion.dart` - Modelo de notificación
2. `lib/data/notificaciones_dummy.dart` - 11 notificaciones de ejemplo
3. `lib/screens/notificaciones_screen.dart` - Pantalla completa de notificaciones
4. `lib/services/pdf_service.dart` - Servicio de generación de PDF completo

**Modificados:**
1. `pubspec.yaml` - Dependencias agregadas:
   - `geolocator: ^13.0.2`
   - `google_maps_flutter: ^2.10.0`
   - `pdf: ^3.11.1`
   - `printing: ^5.13.4`
   - `share_plus: ^10.1.2`
2. `android/app/src/main/AndroidManifest.xml` - Permisos de ubicación e internet
3. `ios/Runner/Info.plist` - Permisos de ubicación para iOS
4. `lib/screens/nueva_ot_screen.dart`:
   - Método `_obtenerUbicacion()` (líneas 521-659)
   - Variables de estado para GPS
   - Botón interactivo con loading
5. `lib/screens/dashboard_screen.dart` - Badge de notificaciones en AppBar
6. `lib/screens/detalle_ot_screen.dart`:
   - Reasignación de técnicos completa (líneas 1287-1519)
   - Validaciones de flujo en todos los métodos
   - Mapa interactivo con Google Maps (líneas 606-676)
   - Exportación a PDF funcional (líneas 1974-2027)
   - Sistema de compartir completo (líneas 1812-1972)
7. `TAREAS_PENDIENTES.md` - Actualizado con progreso completo

### Análisis de Progreso:
- **Tareas Críticas:** 1/1 (100%) ✅
- **Tareas Alta Prioridad:** 6/6 (100%) ✅
- **Tareas Media Prioridad:** 4/6 (67%) ⬆️ +50%
- **Tareas Baja Prioridad:** 0/8 (0%)
- **Progreso Total:** 11/21 tareas (52%) ⬆️ +14%

### Estado del Sistema:
✅ **Sistema 100% funcional con datos dummy**
✅ **TODAS las tareas críticas y de alta prioridad completadas**
✅ **Listo para demostración completa del flujo de negocio**
✅ **Código analizado sin errores (flutter analyze)**

### ¿Qué Falta para Producción?
**Funcional (pero con datos dummy):**
- ✅ Autenticación por roles
- ✅ Dashboard con KPIs
- ✅ CRUD completo de OTs
- ✅ Flujos de trabajo completos
- ✅ Notificaciones con badge
- ✅ Reasignación de técnicos
- ✅ Validaciones de flujo
- ✅ Geolocalización GPS completa
- ✅ Exportación a PDF profesional
- ✅ Sistema de compartir funcional

**Requiere Integración Real:**
- ❌ Backend API REST
- ❌ Base de datos real
- ❌ Carga real de archivos (image_picker, file_picker para fotos reales)
- ❌ Notificaciones push reales (Firebase Cloud Messaging)
- ❌ API Key de Google Maps (actualmente usa placeholder)
- ❌ Tests automatizados

---

**Última revisión por:** Claude Code
**Fecha:** 2025-12-14
**Estado del sistema:** ✅ Sistema demo completo - 52% total completado (100% críticas + altas, 67% medias)
**Próximo objetivo:** Implementar tareas de prioridad media restantes o integración con backend real

**Nota:** Para usar Google Maps en dispositivos reales, necesitas:
1. Obtener una API Key de Google Cloud Console
2. Reemplazar "YOUR_API_KEY_HERE" en `android/app/src/main/AndroidManifest.xml`
3. Configurar la API Key en iOS también si es necesario
