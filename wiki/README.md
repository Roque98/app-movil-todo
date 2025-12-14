# 📖 Instrucciones para Publicar la Wiki en GitHub

Este directorio contiene archivos markdown que se deben copiar a la Wiki de GitHub.

## 🚀 Cómo Publicar en GitHub Wiki

### Opción 1: Interfaz Web de GitHub (Recomendado)

1. **Habilitar la Wiki**:
   - Ve a tu repositorio en GitHub: https://github.com/Roque98/app-movil-todo
   - Haz clic en "Settings" (Configuración)
   - Scroll hasta "Features"
   - Marca la casilla "Wikis"

2. **Acceder a la Wiki**:
   - En la página principal del repositorio, haz clic en la pestaña "Wiki"
   - Haz clic en "Create the first page"

3. **Crear Páginas**:

   Para cada archivo `.md` en este directorio (`wiki/`):

   **a. Home.md** (Página principal)
   - Título: `Home`
   - Copiar contenido de `wiki/Home.md`
   - Clic en "Save Page"

   **b. Manual-de-Usuario.md**
   - Clic en "New Page"
   - Título: `Manual de Usuario` (sin guiones, GitHub los agrega automáticamente)
   - Copiar contenido de `wiki/Manual-de-Usuario.md`
   - Clic en "Save Page"

   **c. Guia-de-Inicio-Rapido.md**
   - Clic en "New Page"
   - Título: `Guia de Inicio Rapido`
   - Copiar contenido de `wiki/Guia-de-Inicio-Rapido.md`
   - Clic en "Save Page"

   **d. Arquitectura.md**
   - Clic en "New Page"
   - Título: `Arquitectura`
   - Copiar contenido de `wiki/Arquitectura.md`
   - Clic en "Save Page"

### Opción 2: Clonar el Repositorio de la Wiki (Avanzado)

La Wiki de GitHub es en realidad un repositorio Git separado.

```bash
# Clonar la wiki
git clone https://github.com/Roque98/app-movil-todo.wiki.git

# Entrar al directorio
cd app-movil-todo.wiki

# Copiar todos los archivos de wiki/
cp ../app-movil-todo/wiki/*.md .

# Agregar, commit y push
git add .
git commit -m "docs: agregar documentación completa de la wiki"
git push origin master
```

## 📁 Archivos Incluidos

| Archivo | Título de la Página | Descripción |
|---------|-------------------|-------------|
| `Home.md` | Home | Página principal de la wiki |
| `Manual-de-Usuario.md` | Manual de Usuario | Guía completa para usuarios finales |
| `Guia-de-Inicio-Rapido.md` | Guia de Inicio Rapido | Setup para desarrolladores |
| `Arquitectura.md` | Arquitectura | Documentación técnica de arquitectura |
| `README.md` | - | Este archivo (no subir a la wiki) |

## 📝 Páginas Adicionales Recomendadas

Estas páginas están referenciadas en la wiki pero aún no están creadas. Puedes crearlas más tarde:

### Para Usuarios:
- **Roles y Permisos**: Qué puede hacer cada rol
- **Flujo de Trabajo**: Diagrama y explicación detallada
- **FAQ Usuarios**: Preguntas frecuentes
- **Solución de Problemas**: Troubleshooting común

### Para Desarrolladores:
- **Configuracion Google Maps**: Ya existe en `docs/CONFIGURACION_GOOGLE_MAPS.md`, puedes copiarla
- **API Reference**: Documentación de clases y métodos
- **Testing**: Guía de testing
- **Deployment**: Cómo compilar y publicar
- **FAQ Desarrolladores**: Preguntas técnicas

### Generales:
- **Changelog**: Historial de versiones
- **Roadmap**: Futuras características
- **Glosario**: Términos y abreviaciones

## 🔗 Enlaces de la Wiki

Una vez publicada, tu wiki estará disponible en:
- **URL**: https://github.com/Roque98/app-movil-todo/wiki
- **Editar**: https://github.com/Roque98/app-movil-todo/wiki/_edit

## ✅ Checklist de Publicación

- [ ] Habilitar Wiki en Settings del repositorio
- [ ] Crear página Home
- [ ] Crear página Manual de Usuario
- [ ] Crear página Guia de Inicio Rapido
- [ ] Crear página Arquitectura
- [ ] (Opcional) Crear página Configuracion Google Maps
- [ ] Verificar que todos los links internos funcionen
- [ ] Agregar link a la Wiki en el README.md principal

## 🎨 Personalización

Si quieres personalizar las páginas:

1. Edita los archivos `.md` en este directorio
2. Vuelve a copiar el contenido a GitHub Wiki
3. También puedes editar directamente en la interfaz web de GitHub

## 📚 Recursos

- [GitHub Wiki Documentation](https://docs.github.com/en/communities/documenting-your-project-with-wikis)
- [Markdown Guide](https://www.markdownguide.org/)
- [GitHub Flavored Markdown](https://github.github.com/gfm/)

---

**Nota**: Estos archivos markdown están en el repositorio para control de versiones, pero la Wiki de GitHub es un repositorio separado.
