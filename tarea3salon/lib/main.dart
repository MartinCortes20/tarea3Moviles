import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/features/classroom/presentation/cubit/classroom_cubit.dart';
import 'core/features/classroom/presentation/screens/classroom_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClassroomCubit(),
      child: MaterialApp(
        title: 'Explorador de Salón',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF3498DB),
            brightness: Brightness.light,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

/// Pantalla de bienvenida con precarga de assets
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _assetsLoaded = false;
  bool _hasError = false;
  bool _preloadStarted = false; // Para evitar múltiples llamadas

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // MOVER la precarga AQUÍ - el contexto ya está listo
    if (!_preloadStarted) {
      _preloadStarted = true;
      _preloadAssets();
    }
  }

  Future<void> _preloadAssets() async {
    try {
      print('🔄 Iniciando precarga de assets...');
      
      // Precargar la imagen del salón - AHORA SÍ funciona
      await precacheImage(
        const AssetImage('assets/images/classroom.jpg'),
        context,
      );
      
      print('✅ Imagen del salón precargada exitosamente');

      if (mounted) {
        setState(() {
          _assetsLoaded = true;
          _hasError = false;
        });
        
        // Navegar después de que los assets estén cargados
        _navigateToClassroom();
      }
    } catch (e) {
      print('❌ Error precargando assets: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _assetsLoaded = true;
        });
        
        // Navegar incluso con error, pero mostrar placeholder
        _navigateToClassroom();
      }
    }
  }

  void _navigateToClassroom() {
    // Pequeña pausa para mostrar la animación completa
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        print('🚀 Navegando a ClassroomScreen...');
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const ClassroomScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF3498DB),
              Color(0xFF2C3E50),
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ícono principal
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _hasError ? Icons.error_outline : Icons.school,
                      size: 100,
                      color: _hasError ? Colors.amber : Colors.white,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Título
                  Text(
                    'Explorador de Salón',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Subtítulo o mensaje de estado
                  Text(
                    _hasError 
                      ? 'Error cargando recursos'
                      : _assetsLoaded 
                          ? 'Listo para explorar'
                          : 'Cargando recursos...',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Indicador de carga o ícono de estado
                  if (!_assetsLoaded)
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  else if (_hasError)
                    const Icon(
                      Icons.warning_amber,
                      color: Colors.amber,
                      size: 40,
                    )
                  else
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 40,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}