import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'enter_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'philosophical_page.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform
   );


  runApp( const MyApp());
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '1',
      routes: {
        '1': (context) => const EnterPage(),

        '2': (context) => const PhilosophyScreen(),
      },
    );
  }
}
