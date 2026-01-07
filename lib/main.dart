import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:foody/constatnt/app_theme.dart';
import 'package:foody/core/observers/auth_provider.dart';
import 'package:foody/core/routing/go_router.dart';
import 'package:foody/features/home/bloc/restaurant_cubit.dart';
import 'package:foody/features/menus/bloc/menu_cubit.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        BlocProvider(create: (_) => RestaurantCubit()..fetchRestaurants()),
        BlocProvider(create: (_) => MenuCubit()),
      ],
      builder: (context, child) {
        final auth = context.watch<AuthProvider>();
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Foody',
          routerConfig: AppRouter.create(auth),
          theme: AppTheme.lightTheme,
          // darkTheme: AppTheme.darkTheme,
        );
      },
    );
  }
}
