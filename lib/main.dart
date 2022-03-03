import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/screens/main_screen.dart';
import '/services/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  await SQFLiteProvider.init();
  runApp(const ICSApp());
}

class ICSApp extends StatelessWidget {
  const ICSApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}
