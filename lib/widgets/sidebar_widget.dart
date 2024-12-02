import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Add this import
import '../data/provider/user_provider.dart'; // Import UserProvider
import '../pages/login_page.dart';
import '../pages/competitions_page.dart';

class CustomSidebar extends StatelessWidget {
  const CustomSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
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
                  const Text(
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
                    child: const Icon(Icons.person, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Avaliador',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.name ?? 'Usuário',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? 'teste@teste.com',
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
                  MaterialPageRoute(builder: (context) => const CompetitionsPage()),
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
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  // Close the drawer
                  Navigator.of(context).pop();
                  // Navigate back to LoginPage
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
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
          title: const Text('Em breve'),
          content: const Text('Esta funcionalidade estará disponível em breve.'),
          actions: [
            TextButton(
              child: const Text('OK'),
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
    super.key,
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });

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
          style: Theme.of(context).textTheme.titleSmall,
        ),
        onTap: onTap ??
            () {
              // Default action if onTap is not provided
            },
      ),
    );
  }
}

