import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_innospace/features/auth/domain/usecases/SignInUseCase.dart';
import 'package:flutter_innospace/features/auth/domain/usecases/SignUpUseCase.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/CloseOpportunityUseCase.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/CreateOpportunityUseCase.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/DeleteOpportunityUseCase.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/GetMyOpportunitiesUseCase.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/GetOpportunityByIdUseCase.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/PublishOpportunityUseCase.dart';
import 'package:flutter_innospace/features/opportunities/presentation/blocs/opportunity_detail/opportunity_detail_bloc.dart';
import 'package:flutter_innospace/features/opportunities/presentation/blocs/opportunity_list/opportunity_list_bloc.dart';
import 'core/services/session_manager.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/services/auth_service.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/SignOutUseCase.dart';
import 'features/auth/presentation/blocs/login/login_bloc.dart';
import 'features/auth/presentation/blocs/register/register_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/main/main_page.dart';
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
        Provider<http.Client>(
          create: (_) => http.Client(),
          dispose: (_, client) => client.close(), 
        ),
        Provider<SessionManager>(
          create: (_) => SessionManager(prefs),
        ),
        
        ProxyProvider<http.Client, AuthService>(
          update: (_, client, __) => AuthService(client),
        ),
        ProxyProvider<http.Client, OpportunityService>( 
          update: (_, client, __) => OpportunityService(client),
        ),

        ProxyProvider2<AuthService, SessionManager, AuthRepository>(
          update: (_, authService, sessionManager, __) =>
              AuthRepositoryImpl(authService, sessionManager),
        ),
        ProxyProvider2<OpportunityService, SessionManager, OpportunityRepository>( 
          update: (_, oppService, sessionManager, __) =>
              OpportunityRepositoryImpl(oppService, sessionManager),
        ),
        Provider<SignInUseCase>(
        create: (context) => SignInUseCase(context.read<AuthRepository>()),
          ),
        Provider<SignUpUseCase>(
          create: (context) => SignUpUseCase(context.read<AuthRepository>()),
          ),
        Provider<SignOutUseCase>(
          create: (context) => SignOutUseCase(context.read<AuthRepository>()),
          ),

        Provider<CreateOpportunityUseCase>(
           create: (context) => CreateOpportunityUseCase(
            context.read<OpportunityRepository>(),
            context.read<SessionManager>(), 
  ),
),
Provider<GetMyOpportunitiesUseCase>(
    create: (context) => GetMyOpportunitiesUseCase(context.read<OpportunityRepository>()),
),

Provider<GetOpportunityByIdUseCase>(
    create: (context) => GetOpportunityByIdUseCase(context.read<OpportunityRepository>()),
),

Provider<PublishOpportunityUseCase>(
    create: (context) => PublishOpportunityUseCase(context.read<OpportunityRepository>()),
),

Provider<CloseOpportunityUseCase>(
    create: (context) => CloseOpportunityUseCase(context.read<OpportunityRepository>()),
),

Provider<DeleteOpportunityUseCase>(
    create: (context) => DeleteOpportunityUseCase(context.read<OpportunityRepository>()),
),







BlocProvider<OpportunityListBloc>(
    create: (context) => OpportunityListBloc(
        context.read<GetMyOpportunitiesUseCase>(),
    ),
),

BlocProvider<OpportunityDetailBloc>(
    create: (context) => OpportunityDetailBloc(
        context.read<GetOpportunityByIdUseCase>(), 
        context.read<PublishOpportunityUseCase>(),  
        context.read<CloseOpportunityUseCase>(),  
        context.read<DeleteOpportunityUseCase>(),  
    ),
),
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(context.read<SignInUseCase>()),
        ),
        BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(context.read<SignUpUseCase>()),
        ),
      ],
      child: MaterialApp(
        title: 'flutter_InnoSpaces',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        
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
          
        },
      ),
    );
  }
}