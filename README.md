# Proyecto Login (Creador de Formularios)

Aplicación iOS para crear, editar y eliminar formularios personalizados, con persistencia local y funciones avanzadas.

## Características principales
- Crear formularios con título y descripción.
- Añadir preguntas de diferentes tipos (respuesta corta, párrafo, opción múltiple, casillas).
- Editar y eliminar formularios.
- **Marcar formularios como favoritos/prioridad** (estrella y filtrado).
- **Proteger formularios con contraseña** (nadie más puede verlos sin la clave).
- **Colores llamativos y UI moderna** para mejor legibilidad.
- **Animaciones visuales** en la lista y acciones.
- **Soporte para orientación vertical y horizontal** (landscape/portrait).
- Persistencia local: los formularios se guardan en el dispositivo y se mantienen aunque cierres la app.

## Instalación
1. Clona el repositorio:
   ```sh
   git clone https://github.com/victortejeda/proyecto_Login.git
   ```
2. Abre el proyecto en Xcode (`proyecto_Login.xcodeproj`).
3. Asegúrate de tener Xcode 14 o superior.
4. Compila y ejecuta en el simulador o en tu dispositivo.

## Uso
- Al abrir la app, verás la lista de formularios guardados.
- Pulsa el botón `+` para crear un nuevo formulario.
- Puedes editar un formulario tocándolo en la lista.
- Marca como favorito pulsando la estrella.
- Filtra para ver solo favoritos con el switch.
- Protege cualquier formulario con contraseña desde la pantalla de edición.
- Para eliminar un formulario, pulsa el icono de la papelera.
- Todos los cambios se guardan automáticamente en tu dispositivo.

## Estructura del proyecto
- `ViewModel/GoogleFormViewModel.swift`: Lógica principal, favoritos, contraseñas y persistencia local.
- `Models/FormModel.swift`: Modelos de datos de formularios y preguntas.
- `View/`: Vistas SwiftUI para la interfaz de usuario, colores y animaciones.

## Créditos
Desarrollado por Victor Tejeda.

---

### Notas técnicas
- El código está documentado con comentarios para facilitar su mantenimiento.
- Si quieres sincronizar con un backend en el futuro, puedes reactivar la lógica comentada en el ViewModel. 