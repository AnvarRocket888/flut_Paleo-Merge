import 'package:flutter/cupertino.dart';
import 'services/game_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GameService.instance.initialize();
  runApp(const PaleoMergeApp());
}
