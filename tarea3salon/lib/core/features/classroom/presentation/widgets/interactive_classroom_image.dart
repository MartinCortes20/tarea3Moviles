import 'package:flutter/material.dart';
import '../../domain/entities/furniture_entity.dart';
import '../screens/furniture_detail_screen.dart';

class InteractiveClassroomImage extends StatefulWidget {
  final List<FurnitureEntity> furniture;

  const InteractiveClassroomImage({
    super.key,
    required this.furniture,
  });

  @override
  State<InteractiveClassroomImage> createState() =>
      _InteractiveClassroomImageState();
}

class _InteractiveClassroomImageState extends State<InteractiveClassroomImage>
    with SingleTickerProviderStateMixin {
  String? hoveredId;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // IMAGEN SIMPLIFICADA - sin sistemas de carga duplicados
                _buildClassroomImage(),

                // Overlay oscuro sutil
                Container(
                  color: Colors.black.withOpacity(0.1),
                ),

                // Puntos interactivos
                ...widget.furniture.map((item) => _buildInteractivePoint(item, constraints)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildClassroomImage() {
    return Hero(
      tag: 'classroom_image',
      child: Image.asset(
        'assets/images/classroom.jpg',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          // Muestra un loading mientras carga
          if (frame == null) {
            return Container(
              color: Colors.grey[200],
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
                ),
              ),
            );
          }
          return child;
        },
        errorBuilder: (context, error, stackTrace) {
          print('🚨 Error cargando classroom.jpg: $error');
          return _buildErrorPlaceholder();
        },
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[300]!,
            Colors.grey[400]!,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            size: 80,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            'No se pudo cargar la imagen',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractivePoint(FurnitureEntity item, BoxConstraints constraints) {
    final isHovered = hoveredId == item.id;

    return Positioned(
      left: constraints.maxWidth * item.positionX - 25,
      top: constraints.maxHeight * item.positionY - 25,
      child: GestureDetector(
        onTap: () => _navigateToDetail(context, item),
        onTapDown: (_) => setState(() => hoveredId = item.id),
        onTapUp: (_) => setState(() => hoveredId = null),
        onTapCancel: () => setState(() => hoveredId = null),
        child: MouseRegion(
          onEnter: (_) => setState(() => hoveredId = item.id),
          onExit: (_) => setState(() => hoveredId = null),
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: isHovered
                    ? 1.3
                    : 1.0 + (_pulseController.value * 0.1),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getColorForCategory(item.category).withOpacity(0.9),
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _getColorForCategory(item.category).withOpacity(0.5),
                        blurRadius: isHovered ? 20 : 10,
                        spreadRadius: isHovered ? 2 : 0,
                      ),
                    ],
                  ),
                  child: Icon(
                    _getIconForCategory(item.category),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, FurnitureEntity furniture) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            FurnitureDetailScreen(furniture: furniture),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Mesa':
        return const Color(0xFF3498DB);
      case 'Silla':
        return const Color(0xFFE74C3C);
      case 'Pizarrón':
        return const Color(0xFF2ECC71);
      case 'Iluminación':
        return const Color(0xFFF39C12);
      default:
        return const Color(0xFF95A5A6);
    }
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Mesa':
        return Icons.table_restaurant;
      case 'Silla':
        return Icons.chair;
      case 'Pizarrón':
        return Icons.dashboard;
      case 'Iluminación':
        return Icons.lightbulb;
      default:
        return Icons.help_outline;
    }
  }
}