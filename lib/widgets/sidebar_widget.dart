import 'package:flutter/material.dart';
// Import your pages here
import '../pages/login_page.dart';
import '../pages/competitions_page.dart';

class CustomSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF1C1C1C), // Background color of the sidebar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wickedbotz',
                    style: TextStyle(
                      color: Colors.tealAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey.shade800,
                    child: Icon(Icons.person, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Avaliador',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ariel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ariel@gmail.com',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Colors.grey.shade700, thickness: 1),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SidebarItem(
              icon: Icons.bolt,
              label: 'Eventos',
              selected: true,
              onTap: () {
                // Close the drawer
                Navigator.of(context).pop();
                // Navigate to CompetitionsPage
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => CompetitionsPage()),
                );
              },
            ),
            SidebarItem(
              icon: Icons.insert_drive_file,
              label: 'Relatórios',
              onTap: () {
                Navigator.of(context).pop();
                _showComingSoonDialog(context);
              },
            ),
            SidebarItem(
              icon: Icons.calendar_today,
              label: 'Agenda de Eventos',
              onTap: () {
                Navigator.of(context).pop();
                _showComingSoonDialog(context);
              },
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  // Close the drawer
                  Navigator.of(context).pop();
                  // Navigate back to LoginPage
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      'Sair da Conta',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Em breve'),
          content: Text('Esta funcionalidade estará disponível em breve.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const SidebarItem({
    Key? key,
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: selected ? Colors.blue : Colors.transparent,
      child: ListTile(
        leading: Icon(
          icon,
          color: selected ? Colors.white : Colors.grey.shade400,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey.shade400,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap ??
            () {
              // Default action if onTap is not provided
            },
      ),
    );
  }
}
