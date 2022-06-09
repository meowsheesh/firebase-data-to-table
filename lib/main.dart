import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:manag/table_one.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ManagAPP());
}

class ManagAPP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        platform: TargetPlatform.iOS,
        // primaryColor: Color(0xFF0A0E21),
        colorScheme: ColorScheme.light().copyWith(primary: Color(0xFF32B67A)),
        scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      initialRoute: TableOne.id,
      routes: {
        TableOne.id: (context) => TableOne(),
      },
    );
  }
}
