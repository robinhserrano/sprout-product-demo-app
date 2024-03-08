import 'package:flutter/material.dart';
import 'package:sprout_mobile_exam_serrano/2_application/core/routes.dart';
import 'package:sprout_mobile_exam_serrano/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Product List App',
      routerConfig: routes,
    );
  }
}
