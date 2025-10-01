import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/classroom_cubit.dart';
import '../widgets/interactive_classroom_image.dart';

/// Pantalla principal del salón de clases
class ClassroomScreen extends StatelessWidget {
  const ClassroomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('🏫 ClassroomScreen construido');
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Explorador de Salón',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2C3E50),
      ),
      body: BlocBuilder<ClassroomCubit, ClassroomState>(
        builder: (context, state) {
          print('🔄 BlocBuilder estado: ${state.runtimeType}');
          
          if (state is ClassroomInitial) {
            print('📥 Estado inicial - cargando muebles...');
            // Cargar datos al iniciar
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<ClassroomCubit>().loadFurniture();
            });
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando muebles del salón...'),
                ],
              ),
            );
          }

          if (state is ClassroomLoaded) {
            print('✅ Estado cargado - ${state.furniture.length} muebles');
            return Column(
              children: [
                // Banner informativo
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.touch_app,
                        color: Color(0xFF3498DB),
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Toca cualquier mueble para ver sus detalles',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Imagen interactiva del salón
                Expanded(
                  child: InteractiveClassroomImage(
                    furniture: state.furniture,
                  ),
                ),
              ],
            );
          }

          if (state is ClassroomError) {
            print('❌ Estado error: ${state.message}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}