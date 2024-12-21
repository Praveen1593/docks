import 'package:flutter/material.dart';



class DockFinal extends StatefulWidget {
  @override
  _DockFinalState createState() => _DockFinalState();
}

class _DockFinalState extends State<DockFinal> {
  double iconSize = 50;
  int hoveredIndex = -1;

  // List of items in the dock with unique colors
  List<Map<String, dynamic>> dockItems = [
    {'icon': Icons.home, 'label': 'Home', 'color': Colors.blue},
    {'icon': Icons.person, 'label': 'Person', 'color': Colors.green},
    {'icon': Icons.settings, 'label': 'Settings', 'color': Colors.orange},
    {'icon': Icons.message, 'label': 'Messages', 'color': Colors.purple},
    {'icon': Icons.music_note, 'label': 'Music', 'color': Colors.red},
    {'icon': Icons.photo, 'label': 'Photo', 'color': Colors.teal},
    {'icon': Icons.phone, 'label': 'Phone', 'color': Colors.yellow},
    {'icon': Icons.camera, 'label': 'Camera', 'color': Colors.deepPurple},
  ];

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(dockItems.length, (index) {
            return DragTarget<Map<String, dynamic>>(
              onAccept: (draggedItem) {
                setState(() {
                  // Reorder items
                  int draggedIndex =
                  dockItems.indexWhere((item) => item == draggedItem);
                  var removedItem = dockItems.removeAt(draggedIndex);
                  dockItems.insert(index, removedItem);
                });
              },
              builder: (context, candidateData, rejectedData) {
                return LongPressDraggable<Map<String, dynamic>>(
                  data: dockItems[index],
                  feedback: Material(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildDockIcon(index, isDragging: true),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            dockItems[index]['label'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0.5,
                    child: _buildDockItem(index),
                  ),
                  child: _buildDockItem(index),
                );
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _buildDockItem(int index) {
    return GestureDetector(
      onTap: () {
        print("App opened: ${dockItems[index]['label']}");
      },
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            hoveredIndex = index;
          });
        },
        onExit: (_) {
          setState(() {
            hoveredIndex = -1;
          });
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            // Label and Arrow
            if (hoveredIndex == index)
              Positioned(
                bottom: 90,
                child: Column(
                  children: [
                    // Arrow pointing down

                    // Label
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        dockItems[index]['label'],
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    CustomPaint(
                      size: Size(20, 10),
                      painter: TrianglePainter(),
                    ),
                  ],
                ),
              ),
            // Icon with background
            _buildDockIcon(index),
          ],
        ),
      ),
    );
  }

  Widget _buildDockIcon(int index, {bool isDragging = false}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: hoveredIndex == index ? iconSize + 16 : iconSize,
      height: hoveredIndex == index ? iconSize + 16 : iconSize,
      decoration: BoxDecoration(
        color: dockItems[index]['color'],
        borderRadius: BorderRadius.circular(10), // Rounded rectangle
      ),
      child: Icon(
        dockItems[index]['icon'],
        size: hoveredIndex == index ? iconSize + 10 : iconSize,
        color: Colors.white,
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.grey.shade300;
    final path = Path()
      ..moveTo(size.width / 2, size.height) // Start at the bottom center
      ..lineTo(0, 0) // Left corner
      ..lineTo(size.width, 0) // Right corner
      ..close(); // Close the path
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
