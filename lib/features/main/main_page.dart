import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_innospace/features/explore/domain/use_cases/get_explore_projects_use_case.dart';
import 'package:flutter_innospace/features/explore/domain/use_cases/get_favorite_projects_use_case.dart';
import 'package:flutter_innospace/features/explore/domain/use_cases/toggle_favorite_project_use_case.dart';
import 'package:flutter_innospace/features/explore/presentation/blocs/explore_projects/explore_projects_bloc.dart';
import 'package:flutter_innospace/features/explore/presentation/blocs/explore_projects/explore_projects_event.dart';
import 'package:flutter_innospace/features/explore/presentation/pages/explore_page.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/get_my_opportunities_use_case.dart';
import 'package:flutter_innospace/features/opportunities/presentation/blocs/opportunity_list/opportunity_list_bloc.dart';
import 'package:flutter_innospace/features/opportunities/presentation/pages/opportunities_page.dart';
import 'package:flutter_innospace/features/profile/presentation/pages/profile_page.dart';



class RequestsPage extends StatelessWidget { 
  const RequestsPage({super.key}); 
  @override 
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Solicitudes')),
        body: const Center(child: Text('Solicitudes (Próximamente)')),
      ); 
}


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
        context.read<GetFavoriteProjectsUseCase>(), // Nuevo
        context.read<ToggleFavoriteProjectUseCase>(),
    )..add(const FetchProjects(isFavoriteView: false)), 
    child: const ExplorePage(), 
  ),

    BlocProvider<OpportunityListBloc>(
      create: (context) => OpportunityListBloc(context.read<GetMyOpportunitiesUseCase>()),
      child: const OpportunitiesPage(),
    ),
    const RequestsPage(),
    const ProfilePage(),
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
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}