import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/services/session_manager.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/services/auth_service.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/blocs/login/login_bloc.dart';
import 'features/auth/presentation/blocs/register/register_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/main/main_page.dart';

// ¡NUEVOS IMPORTS!
import 'features/opportunities/data/repositories/opportunity_repository_impl.dart';
import 'features/opportunities/data/services/opportunity_service.dart';
import 'features/opportunities/domain/repositories/opportunity_repository.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // --- Singletons (Servicios y Utilidades) ---
        Provider<http.Client>(
          create: (_) => http.Client(),
          dispose: (_, client) => client.close(), 
        ),
        Provider<SessionManager>(
          create: (_) => SessionManager(prefs),
        ),
        
        // --- Servicios de API (Clases con http) ---
        ProxyProvider<http.Client, AuthService>(
          update: (_, client, __) => AuthService(client),
        ),
        ProxyProvider<http.Client, OpportunityService>( // <-- AÑADIDO
          update: (_, client, __) => OpportunityService(client),
        ),

        // --- Repositorios (Implementaciones) ---
        ProxyProvider2<AuthService, SessionManager, AuthRepository>(
          update: (_, authService, sessionManager, __) =>
              AuthRepositoryImpl(authService, sessionManager),
        ),
        ProxyProvider2<OpportunityService, SessionManager, OpportunityRepository>( // <-- AÑADIDO
          update: (_, oppService, sessionManager, __) =>
              OpportunityRepositoryImpl(oppService, sessionManager),
        ),

        // --- BLoCs (Solo BLoCs de páginas, los de feature se proveen en la ruta) ---
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(context.read<AuthRepository>()),
        ),
        BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(context.read<AuthRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'flutter_InnoSpaces',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        
        // --- Lógica de Rutas (Sin cambios) ---
        initialRoute: '/',
        routes: {
          '/': (context) {
            final sessionManager = context.read<SessionManager>();
            if (sessionManager.isLoggedIn()) {
              return const MainPage();
            }
            return const LoginPage();
          },
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/main': (context) => const MainPage(),
          // NOTA: Las rutas de detalle y crear las manejamos con MaterialPageRoute
          // para poder pasar argumentos (como el ID) fácilmente.
        },
      ),
    );
  }
}