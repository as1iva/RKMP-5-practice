import 'package:fadeev_practice_5/features/movies/di/service_locator.dart';
import 'package:flutter/material.dart';

import 'package:fadeev_practice_5/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupServiceLocator();

  Services.image.preloadImagePool().catchError((e) {
    print("Предзагрузка изображений не удалась (возможно, нет интернета): $e");
  });

  runApp(const MyApp());
}
