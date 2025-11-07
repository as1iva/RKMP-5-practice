import 'package:fadeev_practice_5/features/service/image_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {

  getIt.registerSingleton<ImageService>(ImageService());

  await getIt<ImageService>().initialize();
}

class Services {
  static ImageService get image => getIt<ImageService>();
}