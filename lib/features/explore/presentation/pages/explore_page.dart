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

class _ExplorePageState extends State<ExplorePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = ['Convocatorias', 'Favoritos'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);

    _tabController.addListener(_handleTabSelection);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDataForCurrentTab(0);
    });
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) {
      _fetchDataForCurrentTab(_tabController.index);
    }
    // Para redibujar el selector de tabs cuando cambia
    setState(() {});
  }

  void _fetchDataForCurrentTab(int index) {
    final bloc = context.read<ExploreBloc>();
    if (index == 0) {
      bloc.add(const FetchProjects(isFavoriteView: false));
    } else {
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
    // Definición de colores del diseño (Basado en las imágenes)
    const Color primaryPurple = Color(0xFF8E6CEF); // Tono morado claro de la imagen
    const Color darkPurple = Color(0xFF673AB7);
    const Color lightGrayBg = Color(0xFFF0F0F5);

    return Scaffold(
      backgroundColor: primaryPurple, // Fondo superior morado
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // --- Encabezado Personalizado ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Explorar',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Barra de Búsqueda
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      prefixIcon: Icon(Icons.search, color: darkPurple),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Selector de Tabs estilo "Cápsula"
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      labelColor: darkPurple,
                      unselectedLabelColor: Colors.white,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent, // Quitar línea divisoria
                      tabs: _tabs.map((tabName) => Tab(text: tabName)).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // --- Cuerpo con esquinas redondeadas superiores ---
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: lightGrayBg,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      ExploreProjectList(isFavoriteView: false),
                      ExploreProjectList(isFavoriteView: true),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}