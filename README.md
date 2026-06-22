# ZTech - Sistema de Gestión de Notebooks Reacondicionados

Aplicación móvil desarrollada en Flutter para la gestión de notebooks reacondicionados. El sistema permite registrar equipos, administrar usuarios, controlar estados técnicos, gestionar inventario, registrar ventas y visualizar reportes relacionados al proceso de reacondicionamiento.

---

## 1. Información General

| Ítem                | Detalle                                     |
| ------------------- | ------------------------------------------- |
| Nombre del proyecto | ZTech                                       |
| Nombre técnico      | ztech_flutter__app                          |
| Versión             | 1.0.0+1                                     |
| Framework           | Flutter                                     |
| Lenguaje            | Dart                                        |
| Backend             | Firebase                                    |
| Base de datos       | Cloud Firestore                             |
| Autenticación       | Firebase Authentication                     |
| Repositorio         | https://github.com/DanyaDuran/ztech_proyect |

---

## 2. Descripción del Proyecto

ZTech es una aplicación móvil orientada a empresas que compran, reparan, reacondicionan y revenden notebooks. La aplicación permite controlar el ciclo completo de un equipo, desde su ingreso a bodega hasta su venta final.

El sistema se encuentra dividido en módulos según el rol del usuario:

* **Administrador / Super Administrador:** gestión de usuarios (super-adminstrador)/ dashboard, reportes y eventos del sistema (administrador, que es un supervisor de las áreas de operación)
* **Bodega:** registro y visualización de notebooks.
* **Técnico:** revisión, reparación, cambio de estados e historial técnico.
* **Ventas:** visualización de notebooks disponibles y registro de ventas.
* **Reportes:** generación y exportación de información.

---

## 3. Tecnologías Utilizadas

### Frontend

* Flutter
* Dart

### Backend y Servicios Cloud

* Firebase Authentication
* Cloud Firestore

### Herramientas de Desarrollo

* Visual Studio Code
* Android Studio
* Git
* GitHub
* Firebase Console

---

## 4. Librerías y Dependencias

Las dependencias principales del proyecto se encuentran definidas en el archivo `pubspec.yaml`.

| Librería        | Versión | Uso                                                    |
| --------------- | ------: | ------------------------------------------------------ |
| flutter         |     SDK | Framework principal de desarrollo móvil                |
| firebase_core   |  ^4.9.0 | Inicialización y conexión con Firebase                 |
| firebase_auth   |  ^6.5.1 | Autenticación de usuarios mediante correo y contraseña |
| cloud_firestore |  ^6.4.1 | Conexión y operaciones con Cloud Firestore             |
| cupertino_icons |  ^1.0.8 | Íconos estilo iOS utilizados por Flutter               |
| intl            | ^0.20.2 | Formateo de fechas y valores                           |
| pdf             | ^3.11.1 | Generación de documentos PDF                           |
| printing        | ^5.13.4 | Visualización, impresión o exportación de PDF          |
| csv             |  ^8.0.0 | Manejo y generación de archivos CSV                    |
| path_provider   |  ^2.1.5 | Acceso a rutas locales del dispositivo                 |
| share_plus      | ^13.1.0 | Compartir archivos o información desde la aplicación   |
| file_saver      |  ^0.4.0 | Guardado de archivos generados                         |
| open_filex      |  ^4.7.0 | Apertura de archivos desde el dispositivo              |

### Dependencias de desarrollo

| Librería      | Versión | Uso                                            |
| ------------- | ------: | ---------------------------------------------- |
| flutter_test  |     SDK | Pruebas incluidas con Flutter                  |
| flutter_lints |  ^6.0.0 | Reglas de análisis estático y buenas prácticas |

---

## 5. Arquitectura del Proyecto

El proyecto utiliza una arquitectura modular basada en funcionalidades.

Estructura principal:

```text
lib/
│
├── app/
│   └── router/
│
├── core/
│   ├── helpers/
│   ├── session/
│   ├── theme/
│   └── utils/
│
├── shared/
│   ├── cards/
│   ├── components/
│   └── widgets/
│
└── features/
    ├── auth/
    ├── admin/
    ├── dashboard/
    ├── bodega/
    ├── tecnico/
    ├── ventas/
    └── reportes/
```

### Descripción de carpetas

| Carpeta            | Descripción                                  |
| ------------------ | -------------------------------------------- |
| app                | Configuración general de rutas y aplicación  |
| core               | Utilidades globales, sesión, temas y helpers |
| shared             | Componentes reutilizables de interfaz        |
| features/auth      | Login y autenticación                        |
| features/admin     | Gestión de usuarios y eventos del sistema    |
| features/dashboard | Resumen general y métricas                   |
| features/bodega    | Registro y administración de notebooks       |
| features/tecnico   | Diagnóstico, reparación e historial técnico  |
| features/ventas    | Registro de ventas                           |
| features/reportes  | Generación de reportes                       |

---

## 6. Backend

El backend utilizado en este proyecto corresponde a **Firebase**, plataforma cloud de Google.

La aplicación no posee un backend propio desarrollado en Node.js, Laravel u otro framework. En su lugar, utiliza servicios administrados de Firebase:

* **Firebase Authentication:** gestión de usuarios e inicio de sesión.
* **Cloud Firestore:** almacenamiento de datos del sistema.

---

## 7. Configuración de Firebase

Para que la aplicación funcione correctamente, el proyecto debe estar conectado a Firebase.

### Servicios Firebase requeridos

En Firebase Console deben estar habilitados:

1. **Authentication**
2. **Cloud Firestore**

---

### 7.1 Firebase Authentication

El sistema utiliza autenticación mediante correo y contraseña.

En Firebase Console:

1. Ir a **Authentication**.
2. Entrar a **Sign-in method**.
3. Habilitar **Email/Password**.
4. Guardar los cambios.

---

### 7.2 Cloud Firestore

La aplicación utiliza Firestore como base de datos NoSQL.

Colecciones utilizadas:

| Colección      | Descripción                         |
| -------------- | ----------------------------------- |
| users          | Usuarios del sistema y sus roles    |
| notebooks      | Notebooks registrados               |
| status_history | Historial de cambios de estado      |
| ventas         | Registro de ventas                  |
| system_events  | Eventos administrativos del sistema |

Firestore puede crear colecciones automáticamente cuando la aplicación registre información nueva.

---

### 7.3 Archivos de conexión Firebase

Para conectar Flutter con Firebase deben existir los siguientes archivos:

```text
android/app/google-services.json
lib/firebase_options.dart
```

El archivo `google-services.json` se obtiene desde Firebase Console al registrar una aplicación Android.

El archivo `firebase_options.dart` se genera mediante FlutterFire CLI y viene incluido en codigo fuente,

---

### 7.4 Inicialización de Firebase

La aplicación debe inicializar Firebase en `main.dart`, usando:

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

---

## 8. Modelo de Datos Principal

### 8.1 Colección `users`

Campos principales:

| Campo  | Tipo    | Descripción                         |
| ------ | ------- | ----------------------------------- |
| id     | String  | Identificador del usuario           |
| nombre | String  | Nombre del usuario                  |
| correo | String  | Correo utilizado para login         |
| rol    | String  | Rol asignado                        |
| activo | Boolean | Indica si el usuario puede ingresar |

Roles permitidos:

```text

admin
bodega
tecnico
ventas
```

---

### 8.2 Colección `notebooks`

Campos principales:

| Campo               | Tipo   | Descripción                      |
| ------------------- | ------ | -------------------------------- |
| codigo              | String | Código interno del notebook      |
| marca               | String | Marca del equipo                 |
| modelo              | String | Modelo del equipo                |
| procesador          | String | Procesador                       |
| ram                 | String | Memoria RAM                      |
| almacenamiento      | String | Tipo/capacidad de almacenamiento |
| tarjetaGrafica      | String | Tarjeta gráfica                  |
| estado              | String | Estado actual del notebook       |
| descripcionProblema | String | Problema reportado               |
| observacionesBodega | String | Observaciones iniciales          |

---

### 8.3 Colección `status_history`

Registra el historial técnico de cada notebook.

Campos principales:

| Campo              | Tipo      | Descripción                   |
| ------------------ | --------- | ----------------------------- |
| codigoNotebook     | String    | Código del notebook           |
| estadoAnterior     | String    | Estado previo                 |
| estadoNuevo        | String    | Estado actualizado            |
| usuarioResponsable | String    | Usuario que realizó el cambio |
| fecha              | Timestamp | Fecha del cambio              |
| diagnostico        | String    | Diagnóstico técnico           |
| accionesRealizadas | String    | Acciones realizadas           |
| observacion        | String    | Observación adicional         |

---

### 8.4 Colección `ventas`

Registra información de los notebooks vendidos.

---

### 8.5 Colección `system_events`

Registra eventos relevantes del sistema, como creación de usuarios, edición de usuarios o cambios importantes realizados desde módulos administrativos.

---

## 9. Flujo de Estados del Notebook

El sistema utiliza el siguiente flujo de estados:

```text
Pendiente de revisión
        ↓
En reparación
      ↙     ↘
Disponible   Merma
       ↓
En reparación
```

Descripción:

| Estado                | Descripción                                |
| --------------------- | ------------------------------------------ |
| Pendiente de revisión | Equipo recién ingresado desde bodega       |
| En reparación         | Equipo en diagnóstico o reparación técnica |
| Disponible            | Equipo listo para venta                    |
| Merma                 | Equipo dado de baja por no ser reparable   |

---

## 10. Requisitos para Ejecutar el Proyecto

### Software requerido

* Flutter SDK
* Dart SDK
* Android Studio
* Visual Studio Code
* Git
* Emulador Android
* Dispositivo físico android
* Acceso al proyecto Firebase


### Requisitos recomendados del equipo

| Recurso              | Recomendado                            |
| -------------------- | -------------------------------------- |
| Sistema operativo    | Windows 10/11, macOS o Linux           |
| RAM                  | 8 GB o superior                        |
| Almacenamiento libre | 10 GB o superior                       |
| Internet             | Requerido para Firebase y dependencias |

---

## 11. Instalación y Ejecución

### 11.1 Clonar el repositorio

```bash
git clone https://github.com/DanyaDuran/ztech_proyect.git
```

Ingresar a la carpeta del proyecto:

```bash
cd ztech_proyect
```

---

### 11.2 Instalar dependencias

Ejecutar:

```bash
flutter pub get
```

---

### 11.3 Verificar entorno Flutter

Ejecutar:

```bash
flutter doctor
```

Si aparecen errores relacionados a Android, ejecutar:

```bash
flutter doctor --android-licenses
```

Aceptar las licencias presionando `y`.

---

### 11.4 Ejecutar emulador Android

Desde Android Studio:

1. Abrir Android Studio.
2. Ir a **Tools > Device Manager**.
3. Crear o iniciar un emulador Android.
4. Verificar que el emulador esté encendido.

También se puede revisar desde terminal:

```bash
flutter devices
```

---

### 11.5 Ejecutar aplicación

Con el emulador abierto:

```bash
flutter run
```

También se puede ejecutar desde Visual Studio Code:

1. Abrir la carpeta del proyecto.
2. Abrir `lib/main.dart`.
3. Seleccionar el emulador Android.
4. Presionar `F5` o **Run > Start Debugging**.

O en un dispositivo físico

---

## 12. Usuarios de Prueba

Para ingresar a la aplicación se requiere que el usuario exista en:

1. Firebase Authentication.
2. Colección `users` de Firestore.

Ejemplo de usuarios de prueba para evaluación:

| Rol     | Correo                                     | Contraseña |
| ------- | -----------------------------------------  | ---------- |
| Admin   | [admin@ztech.cl](mailto:admin@ztech.cl)    | pass123    |
| Bodega  | [bodega@ztech.cl](mailto:bodega@ztech.cl)  | pass123    |
| Técnico | [tecnico@ztech.cl](mailto:tecnico@ztech.cl)| pass123    |
| Ventas  | [ventas@ztech.cl](mailto:ventas@ztech.cl)  | pass123    |

Antes de aplicar cualquiera de estos, se recomienda usar el siguiente correo:
[superadmin@ztech.cl - contraseña: Admin1234] Para poder crear usuarios desde la app con credenciales y roles, y después verificar en Firebase. 

Importante: estos usuarios ya estan creados previamente en Firebase Authentication y en la colección `users`.

La contraseña debe tener al menos 6 caracteres.

---

## 13. Compilación

### APK

Para generar APK:

```bash
flutter build apk
```

Ruta del archivo generado:

```text
build/app/outputs/flutter-apk/app-release.apk
```

---

### App Bundle

Para generar App Bundle:

```bash
flutter build appbundle
```

Ruta del archivo generado:

```text
build/app/outputs/bundle/release/app-release.aab
```

---

## 14. Solución de Problemas

### Error al instalar dependencias

Ejecutar:

```bash
flutter clean
flutter pub get

```



---

### No aparece el emulador

Verificar dispositivos:

```bash
flutter devices
```

Si no aparece, iniciar el emulador desde Android Studio.

---

### Error de conexión con Firebase

Verificar:

* Que exista `android/app/google-services.json`.
* Que exista `lib/firebase_options.dart`.
* Que Firebase Authentication esté habilitado.
* Que Cloud Firestore esté creado.
* Que exista conexión a Internet.

---

### Error al iniciar sesión

Posibles causas:

* El usuario no existe en Firebase Authentication.
* El usuario no existe en Firestore.
* El campo `activo` está en `false`.
* El rol del usuario es inválido.
* La contraseña es incorrecta.

---

### Error de contraseña débil

Firebase requiere contraseñas de al menos 6 caracteres.

Usar una contraseña de prueba como:

```text
123456
```

---

## 15. Manuales del Proyecto

El proyecto  incluye documentación complementaria en archivo zip.

Estructura:

docs/
├── Manual_Despliegue
└── Manual_tecnico_Backend
└── Manual_Usuario
└── Manual_tecnico

### Manual de Despliegue

Documento que explica paso a paso cómo instalar herramientas, configurar Firebase, ejecutar el emulador y levantar la aplicación.

### Manual Técnico Backend

Documento que describe la configuración de Firebase, Authentication, Firestore, colecciones, flujo de datos, reglas generales y mantenimiento del backend.

### Manual técnico de la app
Documento que explica detalladamente la arquitectura, funcionamiento interno, estructura de desarrollo, tecnologías utilizadas y procedimientos de mantenimiento del sistema ZTech.

### Manual de Usuario
Documento que describe la interacción completa con la app para cualquier usuario.
---

## 16. Consideraciones de Seguridad

* No utilizar contraseñas personales como usuarios de prueba.
* No publicar credenciales privadas.
* Los usuarios de prueba deben ser creados solo para evaluación académica.
* El archivo `google-services.json` permite conectar la app con Firebase, pero la seguridad real debe controlarse mediante reglas de Firestore y Authentication.

---


---

## 17. Autores

Proyecto desarrollado para la asignatura de Desarrollo Móvil.

**Universidad Autónoma de Chile**

Integrantes:

* Danya Andrea Durán Fabres
* Giuliana Zúñiga
* Aarón Orellana
* Antony Marivil
* David Castro






























This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
