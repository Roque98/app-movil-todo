# 📱 Manual de Usuario - Sistema de Gestión de OTs

Esta guía te ayudará a usar el Sistema de Gestión de Órdenes de Trabajo de manera efectiva.

## 📋 Tabla de Contenidos

1. [Inicio de Sesión](#inicio-de-sesión)
2. [Dashboard Principal](#dashboard-principal)
3. [Crear una Orden de Trabajo](#crear-una-orden-de-trabajo)
4. [Ver Detalles de una OT](#ver-detalles-de-una-ot)
5. [Trabajar con una OT (Técnicos)](#trabajar-con-una-ot-técnicos)
6. [Gestionar OTs (Supervisores/Admins)](#gestionar-ots-supervisoresadmins)
7. [Notificaciones](#notificaciones)
8. [Exportar y Compartir](#exportar-y-compartir)

---

## 1. Inicio de Sesión

### Acceder a la Aplicación

1. Abre la aplicación en tu dispositivo móvil
2. Ingresa tu **email** corporativo
3. Ingresa tu **contraseña**
4. Presiona **"Iniciar Sesión"**

### Usuarios de Prueba

| Email | Contraseña | Rol |
|-------|-----------|-----|
| admin@empresa.com | admin123 | Administrador |
| supervisor@empresa.com | super123 | Supervisor |
| tecnico@empresa.com | tecnico123 | Técnico |
| solicitante@empresa.com | solicitante123 | Solicitante |

> **Nota**: En producción, usa tus credenciales reales proporcionadas por tu organización.

---

## 2. Dashboard Principal

El dashboard es la pantalla principal después de iniciar sesión.

### 🎯 KPIs (Indicadores)

En la parte superior verás tarjetas con contadores:

- **📋 Abiertas**: OTs sin asignar
- **📋 Asignadas**: OTs asignadas pero no iniciadas
- **🔄 En Progreso**: OTs siendo trabajadas
- **⏸️ Pausadas**: OTs en pausa
- **⏳ Pendiente Cierre**: OTs esperando aprobación
- **✅ Cerradas**: OTs completadas
- **❌ Rechazadas**: OTs rechazadas por el solicitante

### 🔍 Búsqueda y Filtros

#### Barra de Búsqueda

Escribe para buscar en:
- ID de la OT
- Descripción del problema
- Ubicación
- Nombre del solicitante
- Nombre del técnico

#### Botón de Filtros

Presiona el ícono de filtro (⚙️) para acceder a filtros avanzados:

1. **Estado**: Filtra por estado de la OT
2. **Tipo de Falla**: Eléctrica, Plomería, Climatización, etc.
3. **Prioridad**: Crítica, Alta, Media, Baja
4. **Técnico**: Filtra por técnico asignado

#### Ordenamiento

Presiona el botón de ordenar (↕️) para ordenar por:
- **Fecha**: Más recientes primero o viceversa
- **Prioridad**: Mayor a menor prioridad

### Lista de OTs

Cada tarjeta muestra:
- **Estado**: Badge de color en la esquina
- **Prioridad**: Ícono y color
- **Tipo de Falla**: Descripción breve
- **Ubicación**: Dónde se encuentra el problema
- **Solicitante**: Quién creó la OT
- **Técnico**: Quién la está trabajando (si está asignada)
- **Fecha**: Cuándo se creó

---

## 3. Crear una Orden de Trabajo

### Quién Puede Crear OTs

Todos los usuarios pueden crear órdenes de trabajo.

### Pasos para Crear una OT

1. **Presiona el botón "+"** en la parte inferior derecha del dashboard

2. **Completa el formulario**:

   **a. Tipo de Falla** *(Requerido)*
   - Selecciona de la lista: Eléctrica, Plomería, Climatización, etc.

   **b. Descripción del Problema** *(Requerido)*
   - Describe detalladamente el problema
   - Mínimo 10 caracteres
   - Sé específico y claro

   **c. Ubicación** *(Requerido)*
   - Escribe manualmente la ubicación, o
   - Presiona el botón de GPS 📍 para capturar tu ubicación actual
   - Si usas GPS, se mostrará un mapa con tu ubicación

   **d. Prioridad Solicitada** *(Requerido)*
   - **Crítica** 🔴: Problema urgente que requiere atención inmediata
   - **Alta** 🟠: Problema importante que debe resolverse pronto
   - **Media** 🔵: Problema normal
   - **Baja** 🟢: Puede esperar

   **e. Archivos Adjuntos** *(Opcional)*
   - Presiona "Agregar Foto" para agregar hasta 5 fotos
   - Presiona "Agregar Video" para agregar hasta 2 videos
   - Los archivos ayudan al técnico a entender el problema

3. **Revisa la información**

4. **Presiona "Crear Orden de Trabajo"**

### Usar GPS

1. Presiona el botón de GPS 📍
2. Acepta los permisos de ubicación si es la primera vez
3. Espera a que se obtenga tu ubicación (verás un indicador de carga)
4. La ubicación se llenará automáticamente
5. Se mostrará un mapa preview con tu ubicación exacta

> **Tip**: Usa el GPS cuando estés físicamente en el lugar del problema para mayor precisión.

---

## 4. Ver Detalles de una OT

### Acceder a los Detalles

1. En el dashboard, presiona cualquier tarjeta de OT
2. Se abrirá la pantalla de detalles completa

### Información Mostrada

#### Encabezado
- **Estado actual** con badge de color
- **Prioridad** con ícono
- **Tipo de falla** y descripción del problema

#### Información de Creación
- Fecha de solicitud
- Solicitante (nombre y ID)
- Ubicación
- Coordenadas GPS (si se capturaron)
- **Mapa interactivo** mostrando la ubicación exacta
- Archivos adjuntos (fotos y videos)

#### Información de Gestión *(Si está asignada)*
- Técnico asignado
- Fecha de asignación
- SLA (tiempo de respuesta comprometido)
- Fecha compromiso
- Comentarios de gestión

#### Información de Seguimiento *(Si se inició el trabajo)*
- Fecha de inicio real
- Fecha de cierre técnico
- Tiempo total trabajado
- Descripción del trabajo realizado
- Materiales utilizados con costos
- Fotos de evidencia del cierre

#### Información de Cierre *(Si está cerrada)*
- Estado final (ACEPTADO o RECHAZADO)
- Comentarios del solicitante
- Fecha de cierre total

### Acciones Disponibles

En la parte superior derecha hay un menú (⋮) con opciones:

- **✏️ Editar**: Modificar la OT (solo si tienes permisos)
- **👤 Reasignar Técnico**: Cambiar el técnico asignado (Supervisores/Admins)
- **📜 Ver Historial**: Ver todos los cambios de la OT
- **📤 Compartir**: Compartir la OT vía WhatsApp, Email, etc.
- **📄 Exportar PDF**: Generar un PDF profesional de la OT
- **🗑️ Eliminar**: Eliminar la OT (solo Admins y en estados permitidos)

---

## 5. Trabajar con una OT (Técnicos)

### 5.1 Recibir una OT Asignada

Cuando se te asigna una OT:
1. Recibirás una **notificación** (🔔)
2. La OT aparecerá en tu dashboard en estado **"Asignada"**
3. Ábrela para ver los detalles

### 5.2 Iniciar el Trabajo

1. Abre la OT asignada
2. Presiona el botón **"Iniciar Trabajo"** en la parte inferior
3. La OT cambiará a estado **"En Progreso"**
4. Se registrará la hora de inicio

> **Importante**: Solo puedes iniciar OTs que estén en estado "Asignada"

### 5.3 Pausar el Trabajo

Si necesitas interrumpir el trabajo:

1. Presiona el botón **"Pausar"**
2. La OT cambiará a estado **"Pausada"**
3. El tiempo de pausa se registra

### 5.4 Reanudar el Trabajo

Para continuar después de una pausa:

1. Presiona el botón **"Reanudar"**
2. La OT vuelve a estado **"En Progreso"**
3. Continúa trabajando

### 5.5 Finalizar el Trabajo

Cuando termines:

1. Presiona el botón **"Finalizar"**

2. Se abrirá un diálogo para registrar:

   **a. Descripción del Trabajo Realizado** *(Requerido)*
   - Describe qué hiciste para resolver el problema
   - Sé detallado y claro

   **b. Fotos de Evidencia** *(Opcional pero recomendado)*
   - Presiona "Agregar foto" para tomar fotos del trabajo terminado
   - Máximo 5 fotos
   - Las fotos son evidencia del trabajo realizado

3. Presiona **"Finalizar"**

4. La OT cambiará a estado **"Pendiente de Cierre"**

5. El solicitante recibirá una notificación para revisar el trabajo

> **Tip**: Siempre agrega fotos del trabajo terminado. Esto evita malentendidos y demuestra que el trabajo se hizo correctamente.

---

## 6. Gestionar OTs (Supervisores/Admins)

### 6.1 Asignar/Reasignar Técnicos

1. Abre una OT
2. Presiona el menú (⋮) → **"Reasignar técnico"**
3. Selecciona el técnico de la lista
4. Confirma la asignación
5. La OT cambiará a estado **"Asignada"**
6. El técnico recibirá una notificación

> **Nota**: Puedes reasignar una OT en cualquier momento, incluso si ya está en progreso.

### 6.2 Editar una OT

1. Abre la OT
2. Presiona el ícono de editar (✏️)
3. La pantalla de edición tiene 3 tabs:

   **Tab 1: Información Básica**
   - Tipo de falla
   - Descripción
   - Ubicación
   - Prioridad solicitada

   **Tab 2: Asignación y Gestión**
   - Técnico asignado
   - Prioridad asignada (puede ser diferente a la solicitada)
   - SLA (tiempo de respuesta)
   - Fecha compromiso
   - Comentarios de gestión

   **Tab 3: Trabajo y Materiales**
   - Descripción del trabajo realizado
   - Materiales usados (agregar, editar, eliminar)
   - Costo total calculado automáticamente

4. Presiona **"Guardar Cambios"**

### 6.3 Ver Historial de Cambios

1. Abre una OT
2. Presiona el menú (⋮) → **"Ver historial"**
3. Verás una línea de tiempo con:
   - OT Creada
   - OT Asignada
   - Trabajo Iniciado
   - Trabajo Finalizado
   - OT Aceptada/Rechazada

### 6.4 Eliminar una OT

**⚠️ Solo administradores pueden eliminar OTs**

Restricciones:
- Solo se pueden eliminar OTs en estado: Abierta, Asignada o Rechazada
- No se pueden eliminar OTs en progreso, pausadas, pendientes de cierre o cerradas

Para eliminar:
1. Abre la OT
2. Presiona el menú (⋮) → **"Eliminar OT"**
3. Confirma la eliminación

> **Advertencia**: Esta acción no se puede deshacer.

---

## 7. Notificaciones

### Acceder a Notificaciones

Presiona el ícono de campana (🔔) en la esquina superior derecha del dashboard.

### Tipos de Notificaciones

1. **Asignación de OT** 👤
   - Cuando se te asigna una nueva OT
   - Prioridad según urgencia de la OT

2. **Cambio de Estado** 🔄
   - Cuando el estado de una OT cambia
   - Ejemplo: De "En Progreso" a "Pendiente Cierre"

3. **Vencimiento de SLA** ⏰
   - Cuando una OT está próxima a vencer su SLA
   - Te alerta para priorizar el trabajo

4. **Finalización de Trabajo** ✅
   - Cuando un técnico finaliza el trabajo en tu OT
   - Solo para solicitantes

### Marcar como Leída

Las notificaciones no leídas tienen un punto azul.

1. Presiona la notificación para abrirla
2. Se abrirá automáticamente la OT relacionada
3. La notificación se marca como leída

### Contador de No Leídas

El número en rojo sobre el ícono 🔔 indica cuántas notificaciones no leídas tienes.

---

## 8. Exportar y Compartir

### 8.1 Exportar a PDF

1. Abre una OT
2. Presiona el menú (⋮) → **"Exportar PDF"** o usa el botón inferior **"Exportar PDF"**
3. Se generará un PDF profesional con:
   - Encabezado con ID y estado
   - Toda la información de la OT
   - Tabla de materiales con costos
   - Colores según el estado
4. Se abrirá automáticamente el visor de PDF nativo
5. Desde ahí puedes:
   - Imprimir
   - Guardar
   - Compartir

### 8.2 Compartir OT

1. Abre una OT
2. Presiona el menú (⋮) → **"Compartir"** o usa el botón inferior **"Compartir"**
3. Se generará un texto formateado con:
   - Información completa de la OT
   - Emojis para mejor lectura
   - Link a Google Maps con la ubicación (si tiene GPS)
4. Selecciona la app para compartir:
   - WhatsApp
   - Email
   - Telegram
   - Copiar al portapapeles
   - Etc.

> **Tip**: Compartir vía WhatsApp es útil para notificar rápidamente a compañeros o supervisores.

---

## 🎯 Consejos y Mejores Prácticas

### Para Solicitantes

✅ **DO:**
- Describe el problema con el mayor detalle posible
- Agrega fotos si puedes
- Usa el GPS cuando estés en el lugar del problema
- Asigna la prioridad real (no todo es crítico)
- Revisa el trabajo cuando el técnico finalice

❌ **DON'T:**
- No uses descripciones genéricas como "No funciona"
- No marques todo como prioridad crítica
- No rechaces trabajos sin dar un motivo claro

### Para Técnicos

✅ **DO:**
- Inicia el trabajo cuando realmente comiences
- Pausa si te interrumpen o necesitas materiales
- Describe detalladamente el trabajo realizado
- Agrega fotos del trabajo terminado
- Registra todos los materiales usados

❌ **DON'T:**
- No dejes OTs en progreso indefinidamente
- No finalices sin agregar descripción del trabajo
- No olvides registrar materiales importantes

### Para Supervisores/Admins

✅ **DO:**
- Asigna técnicos según especialización y disponibilidad
- Ajusta la prioridad según criterio técnico
- Define SLAs realistas
- Monitorea OTs cercanas a vencer el SLA
- Usa comentarios de gestión para comunicar información importante

❌ **DON'T:**
- No reasignes sin motivo durante trabajos en progreso
- No cambies información crítica sin notificar

---

## ❓ Preguntas Frecuentes

### ¿Puedo editar una OT después de crearla?

Depende de tu rol:
- **Solicitantes**: Solo pueden editar si la OT está en estado "Abierta"
- **Supervisores/Admins**: Pueden editar en cualquier momento

### ¿Qué pasa si rechazo el trabajo de un técnico?

1. La OT cambiará a estado "Rechazada"
2. El técnico recibirá una notificación
3. Puedes reasignar a otro técnico o cerrar la OT
4. Es importante que des una explicación clara del rechazo

### ¿Cómo funciona el GPS?

El GPS captura tu ubicación exacta usando el sensor de tu dispositivo. Requiere:
- Permiso de ubicación (se solicita la primera vez)
- GPS activado en tu dispositivo
- Estar en el lugar del problema para precisión

### ¿Los archivos adjuntos se suben a algún servidor?

En la versión actual (1.0.0) con datos dummy, los archivos son simulados. En producción, se integraría con un backend real.

### ¿Puedo usar la app sin conexión?

Actualmente no hay modo offline. Una conexión a internet es necesaria. Esta funcionalidad está en el roadmap futuro.

---

## 📞 Soporte

Si tienes problemas:

1. Consulta la sección [Solución de Problemas](Solucion-de-Problemas-Usuarios)
2. Consulta las [FAQ](FAQ-Usuarios)
3. Contacta a tu administrador del sistema
4. Reporta bugs en [GitHub Issues](https://github.com/Roque98/app-movil-todo/issues)

---

**¿Encontraste útil esta guía?** ⭐

**Última actualización**: Diciembre 2024 | **Versión**: 1.0.0
