import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_innospace/core/services/session_manager.dart';
import 'package:flutter_innospace/features/explore/domain/use_cases/get_explore_projects_use_case.dart';
import 'package:flutter_innospace/features/explore/domain/use_cases/get_favorite_projects_use_case.dart';
import 'package:flutter_innospace/features/explore/domain/use_cases/toggle_favorite_project_use_case.dart';
import 'package:flutter_innospace/features/explore/presentation/blocs/explore_projects/explore_projects_bloc.dart';
import 'package:flutter_innospace/features/explore/presentation/blocs/explore_projects/explore_projects_event.dart';
import 'package:flutter_innospace/features/explore/presentation/pages/explore_page.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/get_my_opportunities_use_case.dart';
import 'package:flutter_innospace/features/opportunities/presentation/blocs/opportunity_list/opportunity_list_bloc.dart';
import 'package:flutter_innospace/features/opportunities/presentation/pages/opportunities_page.dart';
import 'package:flutter_innospace/features/postulations/domain/uses-cases/get_postulations.dart';
import 'package:flutter_innospace/features/postulations/presentation/blocs/postulations_bloc.dart';
import 'package:flutter_innospace/features/postulations/presentation/blocs/postulations_event.dart';
import 'package:flutter_innospace/features/postulations/presentation/blocs/postulations_state.dart';
import 'package:flutter_innospace/features/postulations/presentation/widgets/postulation_card_widget.dart'; 
import 'package:flutter_innospace/features/profile/domain/use_cases/get_manager_profile_use_case.dart';
import 'package:flutter_innospace/features/profile/domain/use_cases/update_manager_profile_use_case.dart';
import 'package:flutter_innospace/features/profile/presentation/blocs/profile/profile_bloc.dart';
import 'package:flutter_innospace/features/profile/presentation/pages/profile_page.dart';
import '../auth/domain/repositories/auth_repository.dart';
import 'package:flutter_innospace/features/auth/presentation/blocs/login/login_bloc.dart';


class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF673AB7);
    const Color lightGrayBg = Color(0xFFF5F5F5);

    final sessionManager = context.read<SessionManager>();
    final managerId = sessionManager.getManagerId();

    if (!sessionManager.isLoggedIn() || managerId == null) {
      return Scaffold(
        backgroundColor: lightGrayBg,
        appBar: AppBar(
          title: const Text('Solicitudes'),
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.orange),
              const SizedBox(height: 16),
              const Text(
                'Sesión no válida o ID no encontrado.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPurple,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Volver a Iniciar Sesión'),
              ),
            ],
          ),
        ),
      );
    }

    return BlocProvider(
      create: (context) => PostulationsBloc(
        context.read<GetPostulationsUseCase>(),
      )..add(LoadPostulationsEvent(managerId)),
      child: Scaffold(
        backgroundColor: lightGrayBg, // Fondo gris claro
        appBar: AppBar(
          title: const Text(
            'Solicitudes',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 4,
          // Encabezado Morado con bordes redondeados
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        body: BlocBuilder<PostulationsBloc, PostulationsState>(
          builder: (context, state) {
            // Estado de Carga
            if (state is PostulationsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Estado de Error
            if (state is PostulationsError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.redAccent, size: 60),
                      const SizedBox(height: 16),
                      Text(
                        'Ocurrió un error al cargar las solicitudes.',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Estado Exitoso
            if (state is PostulationsLoaded) {
              if (state.postulations.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        'No tienes solicitudes activas.',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              // Lista de Solicitudes
              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: state.postulations.length,
                itemBuilder: (context, index) {
                  final postulation = state.postulations[index];
                  // Usamos el widget estilizado
                  return PostulationCardWidget(postulation: postulation);
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. CLASE MAIN PAGE (Navegación + Diseño Barra Inferior Blanca)
// ---------------------------------------------------------------------------
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    BlocProvider<ExploreBloc>(
      create: (context) => ExploreBloc(
        context.read<GetExploreProjectsUseCase>(),
        context.read<GetFavoriteProjectsUseCase>(),
        context.read<ToggleFavoriteProjectUseCase>(),
      )..add(const FetchProjects(isFavoriteView: false)),
      child: const ExplorePage(),
    ),
    BlocProvider<OpportunityListBloc>(
      create: (context) =>
          OpportunityListBloc(context.read<GetMyOpportunitiesUseCase>()),
      child: const OpportunitiesPage(),
    ),
    // Aquí usamos la clase RequestsPage completa definida arriba
    const RequestsPage(),
    BlocProvider<ProfileBloc>(
      create: (context) => ProfileBloc(
        context.read<GetManagerProfileUseCase>(),
        context.read<UpdateManagerProfileUseCase>(),
      ),
      child: const ProfilePage(),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // El color de fondo vendrá del Theme (Gris claro) o del Scaffold hijo
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      
      // Contenedor para la barra de navegación (Blanco total + Sombra)
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Fondo blanco explícito
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Sombra suave superior
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Explorar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business_center),
              label: 'Mis Convocatorias',
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
          selectedItemColor: Theme.of(context).primaryColor, // Morado
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white, // Asegura que el widget sea blanco
          elevation: 0, // Quitamos elevación interna
        ),
      ),
    );
  }
}