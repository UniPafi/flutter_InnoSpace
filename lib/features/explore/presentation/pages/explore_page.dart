import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_innospace/features/explore/presentation/blocs/explore_projects/explore_projects_bloc.dart';
import 'package:flutter_innospace/features/explore/presentation/blocs/explore_projects/explore_projects_event.dart';
import 'package:flutter_innospace/features/explore/presentation/widgets/explore_project_list.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<Tab> _tabs = const [
    Tab(text: 'Explorar', icon: Icon(Icons.public)),
    Tab(text: 'Favoritos', icon: Icon(Icons.favorite)),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);

    // 1. Cargar la vista inicial (Explorar, índice 0)
    _tabController.addListener(_handleTabSelection);
    
    // Despachar la carga inicial después de que el widget se haya construido
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Forzar la carga de la primera pestaña
      _fetchDataForCurrentTab(0); 
    });
  }

  void _handleTabSelection() {
    // Solo despachar si la pestaña realmente cambió (y no está en transición)
    if (!_tabController.indexIsChanging) { 
      _fetchDataForCurrentTab(_tabController.index);
    }
  }

  void _fetchDataForCurrentTab(int index) {
    // El BLoC ya está disponible en el árbol gracias a MainPage.dart
    final bloc = context.read<ExploreBloc>();
    
    if (index == 0) {
      // Pestaña "Explorar" (isFavoriteView: false)
      bloc.add(const FetchProjects(isFavoriteView: false));
    } else {
      // Pestaña "Favoritos" (isFavoriteView: true)
      bloc.add(const FetchProjects(isFavoriteView: true));
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Usamos el color primario del tema para el AppBar
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proyectos'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
          // Ajustes de color para la TabBar
          labelColor: Theme.of(context).colorScheme.onPrimary,
          unselectedLabelColor: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.7),
          indicatorColor: Theme.of(context).colorScheme.secondary, // Celeste
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          // Vista 1: Explorar
          ExploreProjectList(isFavoriteView: false),
          
          // Vista 2: Favoritos
          ExploreProjectList(isFavoriteView: true),
        ],
      ),
    );
  }
}