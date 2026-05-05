import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musix/core/injection/injection_container.dart' as di;
import 'package:musix/core/utils/app_routes.dart';
import 'package:musix/core/utils/app_router.dart';
import 'package:musix/features/auth/cubit/auth_cubit.dart';
import 'package:musix/features/profile/cubit/profile_cubit.dart';
import 'package:musix/features/now_playing/controller/now_playing_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MusixApp());
}

class MusixApp extends StatelessWidget {
  const MusixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => di.sl<AuthCubit>()..checkSession()),
            BlocProvider(create: (_) => di.sl<ProfileCubit>()),
            // Global player state — shared across all screens and the MiniPlayer
            BlocProvider(create: (_) => di.sl<NowPlayingCubit>()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.black,
              fontFamily: 'SFProDisplay',
            ),
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: AppRoutes.splash,
          ),
        );
      },
    );
  }
}