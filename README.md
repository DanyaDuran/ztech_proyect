# ztech_flutter__app

Aplicación móvil desarrollada en Flutter para la gestión de inventario de notebooks de ZTech.

## Getting Started

1. Clonar el repositorio:

```bash
git clone https://github.com/DanyaDuran/ztech_proyect.git
cd ztech_proyect
```

2. Instalar dependencias:
```bash
flutter pub get
```

3. Cambiarse a la rama del sprint:
```bash
git checkout sprint-0
git pull origin sprint-0
```

4. (Flujo de trabajo con GitHub: trabajaremos usando ramas y Pull Requests (PR))

feature/sprint-0-nombre → sprint-0 → develop → main

5. Reglas principales

main:
- Rama principal del proyecto.
- No trabajaremos directamente sobre esta rama.

develop:
- Rama de desarrollo general.
- Recibe los cambios aprobados desde las ramas de sprint (las de abajo).

sprint-0:
- Rama de integración del Sprint 0.
- Aquí se integran los avances mediante Pull Request.

feature/sprint-0-tunombre:
- Es la rama personal de cada uno, funciona como una pizarra o borrador donde haremos nuestra parte de código
de la tarea y después la llevaremos a la rama de cada sprint (en este caso, el que se menciona arriba sprint 0).

- Cada integrante trabaja en su propia rama.

6. Crear una rama personal

Cada uno debe crear su rama desde sprint-0 usando estos comandos:
```bash
git checkout sprint-0
git pull origin sprint-0
git checkout -b feature/sprint-0-tuNombre
```
Ejemplo:

```bash
git checkout -b feature/sprint-0-danya
```


7. Para guardar cambios

Usaremos commits claros con los comandos:
```bash
git add .
git commit -m "feat: descripción del cambio"
```
Tipos de commit a usar para ayudar a clasificar.
feat: nueva funcionalidad
chore: configuración, estructura o tareas internas
fix: corrección de errores
docs: documentación


8. Subir cambios

Esto es en la terminal de VS code, obviamente dentro de nuestro proyecto usar: 

```bash
git push -u origin feature/sprint-0-tuNombre
```

9. Crear Pull Request (la opcion esta al lado de Issues)

Cada integrante debe crear un Pull Request en GitHub:

base: sprint-0
compare: feature/sprint-0-tuNombre

El Pull Request debe incluir una descripción breve de lo realizaron.

REGLAS A SEGUIUR: 

- No trabajar directamente en main.
- No trabajar directamente en develop.
- No hacer push directo a sprint-0.
- Cada integrante debe trabajar en su propia rama.
- Todo cambio debe integrarse mediante Pull Request.
- Antes de comenzar, siempre hacer git pull origin sprint-0.

Estructura Temporal del proyecto basada en documento (sujeta  a cambios,  ya  que debemos esperar a que nos
entreguen una mayor profundidad y contexto del proyecto y en requerimientos)

```txt

lib/
├── main.dart
├── app/
│   └── app.dart
├── core/
│   ├── constants/
│   ├── theme/
│   └── widgets/
└── features/
    ├── auth/
    ├── dashboard/
    ├── inventory/
    └── location/
```
Cada feature contiene como solicita el documento:

data/
domain/
presentation/

































This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
