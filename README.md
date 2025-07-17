# Proyecto Login (Creador de Formularios)

Aplicación iOS para crear, editar y eliminar formularios personalizados, con persistencia local.

## Características principales
- Crear formularios con título y descripción.
- Añadir preguntas de diferentes tipos (respuesta corta, párrafo, opción múltiple, casillas).
- Editar y eliminar formularios.
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
- Para eliminar un formulario, pulsa el icono de la papelera.
- Todos los cambios se guardan automáticamente en tu dispositivo.

## Estructura del proyecto
- `ViewModel/GoogleFormViewModel.swift`: Lógica principal y persistencia local.
- `Models/FormModel.swift`: Modelos de datos de formularios y preguntas.
- `View/`: Vistas SwiftUI para la interfaz de usuario.

## Persistencia local
La app utiliza `UserDefaults` para guardar y cargar los formularios. No depende de internet ni de servidores externos.

## Créditos
Desarrollado por Victor Tejeda.

---

### Notas técnicas
- El código está documentado con comentarios para facilitar su mantenimiento.
- Si quieres sincronizar con un backend en el futuro, puedes reactivar la lógica comentada en el ViewModel. 