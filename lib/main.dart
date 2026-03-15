import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movies_app/features/splash/presentation/splash_screen.dart';
import 'package:movies_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:movies_app/features/auth/presentation/login_screen.dart';
import 'package:movies_app/features/auth/presentation/register_screen.dart';
import 'package:movies_app/features/auth/presentation/forget_password_screen.dart';
import 'package:movies_app/features/layout/presentation/screens/main_layout.dart';
import 'package:movies_app/features/profile/presentation/screens/update_profile_screen.dart';
import 'package:movies_app/core/constants/routes.dart';
import 'package:movies_app/core/utils/cache_helper.dart';
import 'package:movies_app/core/network/dio_helper.dart';
import 'package:movies_app/core/models/movie_model.dart';
import 'package:movies_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:movies_app/features/home/presentation/cubit/home_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await CacheHelper.init();
  DioHelper.init();
  await Hive.initFlutter();
  
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(MovieModelAdapter());
  }
  
  await Hive.openBox<MovieModel>('watchlist');
  await Hive.openBox<MovieModel>('history');
  
  runApp(const MoviesApp());
}
//END
class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => HomeCubit()..getMovies()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xff121212),
          primaryColor: const Color(0xFFFFBB00),
        ),
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash: (context) => const SplashScreen(),
          AppRoutes.onboarding: (context) => const OnboardingScreen(),
          AppRoutes.login: (context) => const LoginScreen(),
          AppRoutes.register: (context) => const RegisterScreen(),
          AppRoutes.forgetPassword: (context) => const ForgetPasswordScreen(),
          AppRoutes.mainLayout: (context) => const MainLayout(),
          AppRoutes.updateProfile: (context) => const UpdateProfileScreen(),
        },
      ),
    );
  }
}
