import 'package:fadeev_practice_5/features/service/image_service.dart';
import 'package:flutter/material.dart';

import 'package:fadeev_practice_5/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final imageService = ImageService();
  await imageService.initialize();

  imageService.preloadImagePool().catchError((e) {
    print("Предзагрузка изображений не удалась (возможно, нет интернета): $e");
  });

  runApp(const MyApp());
}
