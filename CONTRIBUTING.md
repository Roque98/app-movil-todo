# Guía de Contribución

¡Gracias por tu interés en contribuir al Sistema de Gestión de Órdenes de Trabajo! Esta guía te ayudará a empezar.

## 📋 Tabla de Contenidos

- [Código de Conducta](#código-de-conducta)
- [Cómo Contribuir](#cómo-contribuir)
- [GitFlow y Ramas](#gitflow-y-ramas)
- [Estándares de Código](#estándares-de-código)
- [Commits](#commits)
- [Pull Requests](#pull-requests)
- [Reportar Bugs](#reportar-bugs)
- [Sugerir Mejoras](#sugerir-mejoras)

## 📜 Código de Conducta

Este proyecto y todos los participantes están gobernados por un código de conducta. Al participar, se espera que mantengas este código. Por favor, reporta comportamientos inaceptables.

## 🤝 Cómo Contribuir

### 1. Fork el Proyecto

Haz un fork del repositorio en GitHub y clónalo localmente:

```bash
git clone https://github.com/TU_USUARIO/app-movil-todo.git
cd app-movil-todo
```

### 2. Configura los Remotes

```bash
# Agrega el repositorio original como upstream
git remote add upstream https://github.com/Roque98/app-movil-todo.git

# Verifica los remotes
git remote -v
```

### 3. Mantén tu Fork Sincronizado

```bash
# Obtén los últimos cambios del upstream
git fetch upstream

# Cambia a tu rama develop
git checkout develop

# Fusiona los cambios de upstream/develop
git merge upstream/develop
```

## 🌿 GitFlow y Ramas

Este proyecto sigue el modelo de GitFlow. Aquí están las ramas principales:

### Ramas Principales

- **`main`**: Código en producción. Solo merge desde `develop` o `hotfix/*`
- **`develop`**: Rama de desarrollo principal. Base para nuevas features

### Ramas de Trabajo

- **`feature/*`**: Nuevas características
  ```bash
  git checkout -b feature/nombre-caracteristica develop
  ```

- **`bugfix/*`**: Corrección de bugs en develop
  ```bash
  git checkout -b bugfix/descripcion-bug develop
  ```

- **`hotfix/*`**: Correcciones urgentes en producción
  ```bash
  git checkout -b hotfix/descripcion-urgente main
  ```

- **`release/*`**: Preparación de una nueva versión
  ```bash
  git checkout -b release/v1.1.0 develop
  ```

### Ejemplos de Nombres de Ramas

✅ **Buenos nombres:**
- `feature/google-maps-integration`
- `feature/pdf-export`
- `bugfix/login-validation`
- `hotfix/critical-crash-on-save`

❌ **Malos nombres:**
- `my-changes`
- `test`
- `fix`
- `feature`

## 💻 Estándares de Código

### Dart/Flutter

1. **Sigue las convenciones de Dart:**
   - Usa `lowerCamelCase` para variables y funciones
   - Usa `UpperCamelCase` para clases
   - Usa `snake_case` para nombres de archivos

2. **Formatea el código:**
   ```bash
   flutter format .
   ```

3. **Analiza el código:**
   ```bash
   flutter analyze
   ```

4. **Sin warnings ni errores:**
   - Todo el código debe pasar `flutter analyze` sin errores
   - Los warnings deben ser corregidos o justificados

### Estructura de Archivos

```dart
// 1. Imports de Dart/Flutter
import 'dart:async';
import 'package:flutter/material.dart';

// 2. Imports de paquetes externos
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';

// 3. Imports relativos del proyecto
import '../models/orden_trabajo.dart';
import '../services/auth_service.dart';

// 4. Código de la clase
class MiWidget extends StatelessWidget {
  // ...
}
```

### Comentarios

```dart
/// Documentación de clase con triple slash
/// Describe qué hace la clase
class OrdenTrabajo {

  /// Documentación de métodos públicos
  ///
  /// Parámetros:
  /// - [id]: Identificador único de la OT
  ///
  /// Returns: OrdenTrabajo actualizada
  OrdenTrabajo actualizarEstado(String id, EstadoOT nuevoEstado) {
    // Comentarios inline solo cuando sea necesario aclarar lógica compleja
    final otActualizada = copyWith(estado: nuevoEstado);
    return otActualizada;
  }
}
```

## 📝 Commits

### Formato de Commits (Conventional Commits)

```
<tipo>(<scope>): <descripción corta>

<descripción larga opcional>

<footer opcional>
```

### Tipos de Commit

- **`feat`**: Nueva característica
- **`fix`**: Corrección de bug
- **`docs`**: Cambios en documentación
- **`style`**: Cambios de formato (no afectan el código)
- **`refactor`**: Refactorización de código
- **`test`**: Agregar o modificar tests
- **`chore`**: Mantenimiento (dependencias, configuración)
- **`perf`**: Mejoras de rendimiento

### Ejemplos de Commits

✅ **Buenos commits:**
```bash
feat(maps): agregar integración con Google Maps
fix(login): corregir validación de email
docs(readme): actualizar instrucciones de instalación
refactor(models): simplificar modelo de OrdenTrabajo
test(auth): agregar tests para AuthService
```

❌ **Malos commits:**
```bash
update
fix bug
changes
WIP
asdfasdf
```

### Reglas de Commits

1. **Primera línea máximo 72 caracteres**
2. **Usa imperativo**: "agregar" no "agregado" ni "agrega"
3. **No termines con punto**
4. **Sé específico**: describe QUÉ cambió y POR QUÉ

## 🔄 Pull Requests

### Antes de Crear un PR

1. ✅ Asegúrate de que tu código pasa `flutter analyze`
2. ✅ Formatea tu código con `flutter format .`
3. ✅ Prueba tu código en un dispositivo/emulador
4. ✅ Actualiza la documentación si es necesario
5. ✅ Actualiza los tests si es necesario

### Crear un Pull Request

1. **Push a tu fork:**
   ```bash
   git push origin feature/mi-caracteristica
   ```

2. **Ve a GitHub y crea el PR:**
   - Base branch: `develop` (no `main`)
   - Título descriptivo siguiendo conventional commits
   - Descripción detallada usando la plantilla

### Plantilla de Pull Request

```markdown
## 📋 Descripción

Describe los cambios realizados y el contexto.

## 🎯 Tipo de Cambio

- [ ] Bug fix (cambio que corrige un problema)
- [ ] Nueva característica (cambio que agrega funcionalidad)
- [ ] Breaking change (cambio que rompe compatibilidad)
- [ ] Documentación

## 🧪 Cómo se ha Probado

Describe las pruebas que realizaste.

- [ ] Probado en Android
- [ ] Probado en iOS
- [ ] Tests automatizados agregados/actualizados

## ✅ Checklist

- [ ] Mi código sigue los estándares del proyecto
- [ ] He realizado una auto-revisión de mi código
- [ ] He comentado áreas complejas del código
- [ ] He actualizado la documentación correspondiente
- [ ] Mis cambios no generan nuevos warnings
- [ ] He agregado tests que prueban mi fix/feature
- [ ] Los tests nuevos y existentes pasan localmente

## 📸 Screenshots (si aplica)

Agrega screenshots si hay cambios visuales.
```

### Revisión de Code

- Todos los PRs requieren al menos una aprobación
- Responde a los comentarios de revisión constructivamente
- Haz los cambios solicitados en la misma rama
- Una vez aprobado, el PR será merged por los mantenedores

## 🐛 Reportar Bugs

### Antes de Reportar

1. **Busca si ya existe el issue**
2. **Verifica que sea reproducible**
3. **Asegúrate de tener la última versión**

### Información a Incluir

```markdown
**Descripción del Bug**
Descripción clara y concisa del problema.

**Pasos para Reproducir**
1. Ir a '...'
2. Hacer clic en '....'
3. Scroll hasta '....'
4. Ver error

**Comportamiento Esperado**
Qué esperabas que sucediera.

**Screenshots**
Si aplica, agrega screenshots.

**Entorno:**
 - Dispositivo: [ej. Pixel 4]
 - OS: [ej. Android 11]
 - Versión de la App: [ej. 1.0.0]
 - Flutter version: [ej. 3.10.4]

**Información Adicional**
Cualquier otro contexto sobre el problema.
```

## 💡 Sugerir Mejoras

Las sugerencias de mejoras son bienvenidas. Por favor:

1. **Usa la plantilla de Feature Request**
2. **Explica el caso de uso**
3. **Describe la solución propuesta**
4. **Describe alternativas consideradas**

## 🏗️ Configuración de Desarrollo

### Requisitos

- Flutter SDK ^3.10.4
- Dart SDK
- Android Studio o VS Code
- Git

### Setup Inicial

```bash
# Clonar el repositorio
git clone https://github.com/TU_USUARIO/app-movil-todo.git
cd app-movil-todo

# Crear rama develop local
git checkout develop

# Instalar dependencias
flutter pub get

# Configurar Google Maps (ver docs/CONFIGURACION_GOOGLE_MAPS.md)

# Ejecutar
flutter run
```

### Herramientas Recomendadas

- **VS Code Extensions:**
  - Dart
  - Flutter
  - GitLens
  - Better Comments

- **Android Studio Plugins:**
  - Flutter
  - Dart

## 📚 Recursos

- [Documentación de Flutter](https://flutter.dev/docs)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [GitFlow Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)

## ❓ Preguntas

Si tienes preguntas, puedes:

1. Abrir un issue con la etiqueta `question`
2. Revisar issues cerrados
3. Contactar a los mantenedores

---

¡Gracias por contribuir! 🎉

**Mantenido con ❤️ por Angel Roque**
