import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lesson_72_permissions/controllers/travel_controller.dart';
import 'package:lesson_72_permissions/firebase_options.dart';
import 'package:lesson_72_permissions/views/screens/home_screen.dart';
import 'package:lesson_72_permissions/services/location_service.dart';
import 'package:provider/provider.dart';
// import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // PermissionStatus cameraPermission = await Permission.camera.status;
  // PermissionStatus locationPermission = await Permission.location.status;

  // print(cameraPermission);
  // if (cameraPermission != PermissionStatus.granted) {
  //   cameraPermission = await Permission.camera.request();
  //   print(cameraPermission);
  // }

  // print(locationPermission);
  // if (locationPermission != PermissionStatus.granted) {
  //   locationPermission = await Permission.location.request();
  //   print(locationPermission);
  // }

  await LocationService.init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TravelController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.blueAccent),
        home: const HomeScreen(),
      ),
    );
  }
}
