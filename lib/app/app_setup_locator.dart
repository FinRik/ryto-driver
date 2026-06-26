import 'package:get_it/get_it.dart';

import '../core/services/api_service.dart';
import '../core/services/arrival_time_service.dart';
import '../core/services/bottom_sheet_service.dart';
import '../core/services/chat_service.dart';
import '../core/services/dio_service.dart';
import '../core/services/g_api_service.dart';
import '../core/services/regional_manager_service.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  sl.registerLazySingleton(() => BottomSheetService());

  sl.registerSingleton<DioService>(DioService());

  sl.registerLazySingleton<ApiService>(
    () => ApiService(sl<DioService>().client),
  );

  sl.registerLazySingleton<GApiService>(
    () => GApiServiceImpl(sl<DioService>().client),
  );

  sl.registerLazySingleton<RegionalManagerService>(
    () => RegionalManagerServiceImpl(sl<DioService>().client),
  );

  sl.registerLazySingleton<ChatService>(
    () => ChatService(sl<DioService>().client),
  );

  sl.registerLazySingleton<ArrivalTimeService>(
        () => ArrivalTimeService(sl<DioService>().client),
  );
}
