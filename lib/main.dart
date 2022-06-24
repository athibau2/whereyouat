import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:whereyouat/app/landing_page.dart';
import 'package:whereyouat/bloc/application_bloc.dart';
import 'package:whereyouat/services/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ApplicationBloc(),
        child: Provider<AuthBase>(
          create: (context) => Auth(),
          child: MaterialApp(
              title: 'Where You At',
              theme: ThemeData(
                primaryColor: Colors.green[700],
              ),
              home: LandingPage()),
        ));
  }
}
