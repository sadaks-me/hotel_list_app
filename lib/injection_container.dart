import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';

import 'core/api/venue_api_service.dart';
import 'core/api/venue_endpoints.dart';
import 'features/venues/data/datasources/local/venue_local_data_source.dart';
import 'features/venues/data/datasources/remote/venue_remote_data_source.dart';
import 'features/venues/data/repositories/venue_repository_impl.dart';
import 'features/venues/domain/repositories/venue_repository.dart';
import 'features/venues/domain/usecases/get_venues_and_filters.dart';
import 'features/venues/presentation/bloc/venue_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Cache directory setup
  final Directory cacheDir = await getTemporaryDirectory();
  final dioCacheDir = Directory('${cacheDir.path}/dio_cache');

  // Create cache directory if it doesn't exist
  if (!await dioCacheDir.exists()) {
    await dioCacheDir.create(recursive: true);
  }

  // Bloc
  sl.registerFactory<VenueBloc>(() => VenueBloc(sl()));

  // Use cases
  sl.registerLazySingleton<GetVenuesAndFilters>(
    () => GetVenuesAndFilters(sl()),
  );

  // Repository
  sl.registerLazySingleton<VenueRepository>(() => VenueRepositoryImpl(sl()));

  // Data sources
  sl.registerLazySingleton<VenueLocalDataSourceImpl>(
    () => VenueLocalDataSourceImpl(),
  );

  // API service with proper cache handling
  sl.registerLazySingleton<VenueApiService>(() => VenueApiService(
        baseUrl: VenueEndpoints.baseUrl,
        cacheDir: dioCacheDir,
      ));

  // Remote data source with fallback to local
  sl.registerLazySingleton<VenueDataSource>(
    () => VenueRemoteDataSourceImpl(
      apiService: sl<VenueApiService>(),
      localDataSource: sl<VenueLocalDataSourceImpl>(),
    ),
  );
}
