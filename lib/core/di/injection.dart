import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../../data/datasources/ble_datasource.dart';
import '../../data/repositories/ble_repository_impl.dart';
import '../../domain/repositories/ble_repository.dart';
import '../../domain/usecases/connect_device.dart';
import '../../domain/usecases/scan_devices.dart';
import '../../presentation/bloc/ble_bloc.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // Data Sources
  getIt.registerLazySingleton<BleDataSource>(() => BleDataSourceImpl());
  
  // Repositories
  getIt.registerLazySingleton<BleRepository>(
    () => BleRepositoryImpl(getIt<BleDataSource>()),
  );
  
  // Use Cases
  getIt.registerLazySingleton(() => ScanDevicesUseCase(getIt<BleRepository>()));
  
  // BLoC
  getIt.registerFactory(() => BleBloc(
    scanDevicesUseCase: getIt<ScanDevicesUseCase>(),
    connectDeviceUseCase: getIt<ConnectDeviceUseCase>(),
  ));
}