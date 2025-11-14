import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/domain/repositories/auth_repository.dart'; 

// ---
// Placeholders de las páginas (Explore, Opportunities, Requests)
// ---
class ExplorePage extends StatelessWidget { 
  const ExplorePage({super.key}); 
  @override 
  Widget build(BuildContext context) => Scaffold( // <-- CORRECCIÓN: 'const' eliminado
        appBar: AppBar(title: const Text('Explorar Proyectos')),
        body: const Center(child: Text('Explorar Proyectos')),
      ); 
}

class OpportunitiesPage extends StatelessWidget { 
  const OpportunitiesPage({super.key}); 
  @override 
  Widget build(BuildContext context) => Scaffold( // <-- CORRECCIÓN: 'const' eliminado
        appBar: AppBar(title: const Text('Mis Convocatorias')),
        body: const Center(child: Text('Mis Convocatorias')),
      ); 
}

class RequestsPage extends StatelessWidget { 
  const RequestsPage({super.key}); 
  @override 
  Widget build(BuildContext context) => Scaffold( // <-- CORRECCIÓN: 'const' eliminado
        appBar: AppBar(title: const Text('Solicitudes')),
        body: const Center(child: Text('Solicitudes (Próximamente)')),
      ); 
}
// ---
// FIN DE PLACEHOLDERS
// ---


// ---
// Página de Perfil (con la corrección de 'mounted')
// ---
class ProfilePage extends StatelessWidget { 
  const ProfilePage({super.key}); 
  
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        automaticallyImplyLeading: false, 
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
          ),
          child: const Text('Cerrar Sesión'),
          onPressed: () async {
            final authRepo = context.read<AuthRepository>();
            await authRepo.signOut();

            // ---
            // ¡CORRECCIÓN! Chequeamos si el widget sigue "montado"
            // ---
            if (context.mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            }
          },
        ),
      ),
    );
  }
}
// ---
// Fin de la página de perfil
// ---


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // Las 4 pantallas
  static const List<Widget> _widgetOptions = <Widget>[
    ExplorePage(),
    OpportunitiesPage(),
    RequestsPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explorar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_center),
            label: 'Convocatorias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            label: 'Solicitudes',
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mi Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}