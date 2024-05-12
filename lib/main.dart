import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmaloc/screens/splash_screen.dart';
import 'package:pharmaloc/services/authGoogle.dart';
import 'package:pharmaloc/services/authentification.dart';
import 'package:pharmaloc/services/firebase_options.dart';
import 'package:pharmaloc/theme/theme.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';

void main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      MultiProvider(providers: [
        StreamProvider.value(initialData: null,
          value: authGoogle().user,
        )
      ],
        child: const MyApp(),
      )
      );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterNativeSplash.remove();
  }
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser?>.value(
      value: AuthenticationService().user,
      // Donnée initiale facultative
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PHARMALOC',
        theme: ThemeData(
          //primarySwatch: Colors.green,
          textTheme: GoogleFonts.poppinsTextTheme(),
          //hintColor: const Color(0xff367f2b),
        ),
        home: const SplashScreenWrapper(),
      ),
    );
  }
}
