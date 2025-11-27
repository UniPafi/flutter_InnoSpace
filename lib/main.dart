import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_innospace/core/ui/theme.dart';
import 'package:flutter_innospace/features/auth/domain/usecases/SignInUseCase.dart';
import 'package:flutter_innospace/features/auth/domain/usecases/SignUpUseCase.dart';
import 'package:flutter_innospace/features/explore/data/dao/favorite_dao.dart';
import 'package:flutter_innospace/features/explore/data/repositories/collaboration_repository_impl.dart';
import 'package:flutter_innospace/features/explore/data/repositories/project_repository_impl.dart';
import 'package:flutter_innospace/features/explore/data/repositories/student_profile_repository_impl.dart';
import 'package:flutter_innospace/features/explore/data/services/collaboration_service.dart';
import 'package:flutter_innospace/features/explore/data/services/project_service.dart';
import 'package:flutter_innospace/features/explore/data/services/student_profile_service.dart';
import 'package:flutter_innospace/features/explore/domain/repositories/collaboration_repository.dart';
import 'package:flutter_innospace/features/explore/domain/repositories/project_repository.dart';
import 'package:flutter_innospace/features/explore/domain/repositories/student_profile_repository.dart';
import 'package:flutter_innospace/features/explore/domain/use_cases/get_explore_projects_use_case.dart';
import 'package:flutter_innospace/features/explore/domain/use_cases/get_favorite_projects_use_case.dart';
import 'package:flutter_innospace/features/explore/domain/use_cases/get_project_detail_use_case.dart';
import 'package:flutter_innospace/features/explore/domain/use_cases/get_student_profile_use_case.dart';
import 'package:flutter_innospace/features/explore/domain/use_cases/send_collaboration_request_use_case.dart';
import 'package:flutter_innospace/features/explore/domain/use_cases/toggle_favorite_project_use_case.dart';
import 'package:flutter_innospace/features/explore/presentation/blocs/project_detail/project_detail_bloc.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/close_opportunity_use_case.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/create_opportunity_use_case.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/delete_opportunity_use_case.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/get_opportunity_by_id_use_case.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/publish_opportunity_use_case.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/get_my_opportunities_use_case.dart';
import 'package:flutter_innospace/features/opportunities/presentation/blocs/opportunity_detail/opportunity_detail_bloc.dart';
import 'package:flutter_innospace/features/opportunities/presentation/blocs/opportunity_list/opportunity_list_bloc.dart';
import 'package:flutter_innospace/features/postulations/data/repositories/postulations_repository_impl.dart';
import 'package:flutter_innospace/features/postulations/data/services/postulations_service.dart';
import 'package:flutter_innospace/features/postulations/domain/repositories/postulations_repository.dart';
import 'package:flutter_innospace/features/postulations/domain/uses-cases/get_postulations.dart';
import 'package:flutter_innospace/features/postulations/presentation/blocs/postulations_bloc.dart';
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
import 'features/opportunities/domain/use-cases/get_student_applications_use_case.dart';
import 'features/opportunities/domain/use-cases/accept_student_application_use_case.dart';
import 'features/opportunities/domain/use-cases/reject_student_application_use_case.dart';


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
        Provider<FavoriteDao>(
  create: (_) => FavoriteDao(),
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
          update: (_, oppService, sessionManager, _) =>
              OpportunityRepositoryImpl(oppService, sessionManager),
        ),
        ProxyProvider2<http.Client, SessionManager, ProjectService>(

           update: (_, client, sessionManager, __) => ProjectService(client, sessionManager),
        ),

        ProxyProvider2<ProjectService, FavoriteDao, ProjectRepository>(
          update: (_, service, dao, __) => ProjectRepositoryImpl(service, dao),
        ),
        
        ProxyProvider2<http.Client, SessionManager, StudentProfileService>(
           update: (_, client, sessionManager, __) => StudentProfileService(client, sessionManager),
        ),
        ProxyProvider<StudentProfileService, StudentProfileRepository>(
          update: (_, service, __) => StudentProfileRepositoryImpl(service),
        ),
ProxyProvider2<http.Client, SessionManager, CollaborationService>(
  update: (_, client, sessionManager, __) => CollaborationService(client, sessionManager),
),


ProxyProvider<CollaborationService, CollaborationRepository>(
  update: (_, service, __) => CollaborationRepositoryImpl(service),
),


Provider<SendCollaborationRequestUseCase>(
  create: (context) => SendCollaborationRequestUseCase(context.read<CollaborationRepository>()),
),


//colocar aca los UseCases si es q los usan


//USECASES DE FEATURE AUTH
        Provider<SignInUseCase>(
        create: (context) => SignInUseCase(context.read<AuthRepository>()),
          ),
        Provider<SignUpUseCase>(
          create: (context) => SignUpUseCase(context.read<AuthRepository>()),
          ),
        Provider<SignOutUseCase>(
          create: (context) => SignOutUseCase(context.read<AuthRepository>()),
          ),

//USECASES DE FEATURE MY OPPORTUNITIES
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

//USECASES DE FEATURE EXPLORE
Provider<GetExploreProjectsUseCase>(
  create: (context) => GetExploreProjectsUseCase(context.read<ProjectRepository>()),
),

Provider<GetFavoriteProjectsUseCase>(
  create: (context) => GetFavoriteProjectsUseCase(context.read<ProjectRepository>()),
),

Provider<ToggleFavoriteProjectUseCase>(
  create: (context) => ToggleFavoriteProjectUseCase(context.read<ProjectRepository>()),
),

Provider<GetStudentProfileUseCase>(
  create: (context) => GetStudentProfileUseCase(context.read<StudentProfileRepository>()),
),


Provider<GetProjectDetailUseCase>(
  create: (context) => GetProjectDetailUseCase(context.read<ProjectRepository>()),
),


Provider<GetStudentApplicationsUseCase>(
    create: (context) => GetStudentApplicationsUseCase(context.read<OpportunityRepository>()),
),

Provider<AcceptStudentApplicationUseCase>(
    create: (context) => AcceptStudentApplicationUseCase(context.read<OpportunityRepository>()),
),

Provider<RejectStudentApplicationUseCase>(
    create: (context) => RejectStudentApplicationUseCase(context.read<OpportunityRepository>()),
),

//USECASES DE POSTULATIONS

ProxyProvider<http.Client, PostulationsService>(
  update: (_, client, __) => PostulationsService(client),
),

ProxyProvider<PostulationsService, PostulationsRepository>(
  update: (_, service, __) => PostulationsRepositoryImpl(service),
),

Provider<GetPostulationsUseCase>(
  create: (context) =>
      GetPostulationsUseCase(context.read<PostulationsRepository>()),
),


BlocProvider<PostulationsBloc>(
  create: (context) =>
      PostulationsBloc(context.read<GetPostulationsUseCase>()),
),




BlocProvider<OpportunityListBloc>(
    create: (context) => OpportunityListBloc(
        context.read<GetMyOpportunitiesUseCase>(),
    ),
),

BlocProvider<ProjectDetailBloc>(
  create: (context) => ProjectDetailBloc(
    context.read<GetProjectDetailUseCase>(), 
    context.read<GetStudentProfileUseCase>(), 
    context.read<SendCollaborationRequestUseCase>(),
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
        title: 'flutter_InnoSpace',
      theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        
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