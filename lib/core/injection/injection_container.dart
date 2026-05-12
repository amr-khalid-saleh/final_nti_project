import 'package:get_it/get_it.dart';
import 'package:musix/core/network/dio_client.dart';
import 'package:musix/core/storage/secure_storage_service.dart';
import 'package:musix/features/auth/cubit/auth_cubit.dart';
import 'package:musix/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:musix/features/auth/data/repositories/auth_repository.dart';
import 'package:musix/features/home/cubit/home_cubit.dart';
import 'package:musix/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:musix/features/home/data/repositories/home_repository.dart';
import 'package:musix/features/search/cubit/search_cubit.dart';
import 'package:musix/features/search/cubit/category_tracks_cubit.dart';
import 'package:musix/features/search/data/data_sources/search_remote_data_source.dart';
import 'package:musix/features/search/data/repositories/search_repository.dart';
import 'package:musix/features/library/cubit/library_cubit.dart';
import 'package:musix/features/library/data/data_sources/library_remote_data_source.dart';
import 'package:musix/features/library/data/repositories/library_repository.dart';
import 'package:musix/features/profile/cubit/profile_cubit.dart';
import 'package:musix/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:musix/features/profile/data/repositories/profile_repository.dart';
import 'package:musix/features/now_playing/controller/now_playing_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  sl.registerLazySingleton<DioClient>(() => DioClient(sl()));

  // Features - Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(dio: sl<DioClient>().dio));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
      remoteDataSource: sl(), secureStorage: sl()));
  sl.registerFactory(() => AuthCubit(repository: sl()));
  
  // Features - Home
  sl.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(dio: sl<DioClient>().dio));
  sl.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(remoteDataSource: sl()));
  sl.registerFactory(() => HomeCubit(repository: sl()));
  
  // Features - Search
  sl.registerLazySingleton<SearchRemoteDataSource>(
      () => SearchRemoteDataSourceImpl(dio: sl<DioClient>().dio));
  sl.registerLazySingleton<SearchRepository>(
      () => SearchRepositoryImpl(remoteDataSource: sl()));
  sl.registerFactory(() => SearchCubit(repository: sl()));
  sl.registerFactory(() => CategoryTracksCubit(repository: sl()));
  
  // Features - Library
  sl.registerLazySingleton<LibraryRemoteDataSource>(
      () => LibraryRemoteDataSourceImpl(dio: sl<DioClient>().dio));
  sl.registerLazySingleton<LibraryRepository>(
      () => LibraryRepositoryImpl(remoteDataSource: sl()));
  sl.registerFactory(() => LibraryCubit(repository: sl()));
  
  // Features - Profile
  sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(dio: sl<DioClient>().dio));
  sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(remoteDataSource: sl()));
  sl.registerFactory(() => ProfileCubit(repository: sl()));

  // Global - Now Playing
  sl.registerLazySingleton<NowPlayingCubit>(() => NowPlayingCubit());
}

