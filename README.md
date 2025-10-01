##Explorador de Salón - Tarea 3
Una aplicación Flutter que permite explorar un salón de clases interactivo con información detallada de cada mueble.

#Características
Interfaz interactiva: Navega por el salón de clases y haz clic en los muebles para ver sus detalles

Animaciones fluidas: Transiciones y efectos visuales atractivos

Arquitectura limpia: Implementación siguiendo los principios de Clean Architecture

Gestión de estado: Uso de BLoC para la gestión del estado de la aplicación

Diseño responsivo: Interfaz adaptada para diferentes tamaños de pantalla

#Estructura del Proyecto
text
tarea3salon/
├── core/
│   └── features/
│       └── classroom/
│           ├── data/
│           │   └── models/
│           │       └── furniture_model.dart
│           ├── domain/
│           │   └── entities/
│           │       └── furniture_entity.dart
│           └── presentation/
│               ├── cubit/
│               │   └── classroom_cubit.dart
│               ├── screens/
│               │   ├── classroom_screen.dart
│               │   └── furniture_detail_screen.dart
│               └── widgets/
│                   └── interactive_classroom_image.dart
├── assets/
│   └── images/
│       ├── classroom.jpg
│       └── furniture/
│           ├── lampara.jpg
│           ├── mesa.jpg
│           ├── pizarron.jpg
│           └── silla.jpg
└── main.dart
Tecnologías Utilizadas
Flutter: Framework principal

Flutter BLoC: Gestión de estado

Equatable: Comparación de objetos

Google Fonts: Tipografías personalizadas

Material Design 3: Sistema de diseño

Instalación
Clona el repositorio o descarga los archivos del proyecto

Asegúrate de tener Flutter instalado en tu sistema

Navega al directorio del proyecto:

bash
cd tarea3salon
Instala las dependencias:

bash
flutter pub get
Ejecuta la aplicación:

bash
flutter run
#Configuración de Assets
La aplicación utiliza las siguientes imágenes que deben estar ubicadas en la carpeta assets/images/:

classroom.jpg - Imagen principal del salón

furniture/mesa.jpg - Imagen de las mesas

furniture/silla.jpg - Imagen de las sillas

furniture/pizarron.jpg - Imagen del pizarrón

furniture/lampara.jpg - Imagen de las lámparas

#Funcionalidades
##Pantalla Principal (ClassroomScreen)
Muestra una vista general del salón de clases

<img width="344" height="716" alt="Captura de pantalla 2025-09-30 a la(s) 6 04 05 p m" src="https://github.com/user-attachments/assets/1e3c4083-9f4e-4887-8133-550a997cf127" />

Puntos interactivos sobre cada mueble

Indicaciones para interactuar con la aplicación

Imagen Interactiva (InteractiveClassroomImage)
Imagen del salón con puntos de interacción

Animaciones de pulsación en los muebles

Navegación a pantallas de detalle

Efectos visuales al hacer hover

##Detalle de Muebles (FurnitureDetailScreen)
<img width="344" height="716" alt="Captura de pantalla 2025-09-30 a la(s) 6 04 21 p m" src="https://github.com/user-attachments/assets/5f15b1ed-f579-4c9e-aa63-fb1bd4e074fd" />
<img width="344" height="716" alt="Captura de pantalla 2025-09-30 a la(s) 6 04 32 p m" src="https://github.com/user-attachments/assets/172abc6f-ac7f-4423-965e-37c96eee9292" />
<img width="344" height="716" alt="Captura de pantalla 2025-09-30 a la(s) 6 04 43 p m" src="https://github.com/user-attachments/assets/bfa0127a-b08e-430d-be57-d8ebfdfe3bda" />
<img width="344" height="716" alt="Captura de pantalla 2025-09-30 a la(s) 6 04 55 p m" src="https://github.com/user-attachments/assets/88cb4fdf-26e4-48ae-ad52-358a3f493294" />



Información detallada de cada mueble

Especificaciones técnicas (material, dimensiones)

Animaciones de entrada y transición

##Diseño de tarjetas informativas

Muebles Incluidos
La aplicación incluye los siguientes muebles:

Mesas: 2 mesas de trabajo con diferentes posiciones

Sillas: 3 sillas escolares ergonómicas

Pizarrón: 1 pizarrón blanco de gran formato

Iluminación: 2 luminarias LED empotradas
