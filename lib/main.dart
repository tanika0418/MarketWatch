import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:market_watch/providers/AuthProvider.dart';
import 'package:market_watch/providers/DataProvider.dart';
import 'package:market_watch/providers/ScreenProvider.dart';
import 'package:market_watch/screens/LoginScreen.dart';
import 'package:market_watch/screens/MainScreen.dart';
import 'package:market_watch/utils/Constants.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBI1KWe5nVa23ZU_Cps15jRR_RQ6ym0qzc",
        authDomain: "market-watch-c162a.firebaseapp.com",
        projectId: "market-watch-c162a",
        storageBucket: "market-watch-c162a.appspot.com",
        messagingSenderId: "233579828457",
        appId: "1:233579828457:web:4e93e0fc2c8ab084b74c78",
        databaseURL: "https://market-watch-c162a-default-rtdb.firebaseio.com/"),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => DataProvider()),
        ChangeNotifierProvider(create: (ctx) => ScreenProvider()),
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(FirebaseAuth.instance),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Market Watch",
        theme: ThemeData(),
        initialRoute: "/",
        routes: {
          "/": (contextMain) => AuthWrapper(),
          // "/": (contextMain) => AdminScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    return auth.user != null
        ? MainScreen()
        : FutureBuilder(
            future: auth.tryAutoLogin(),
            builder: (ctx, authResultSnapshot) =>
                authResultSnapshot.connectionState == ConnectionState.waiting
                    ? Scaffold(
                        body: Center(
                          child:
                              CircularProgressIndicator(color: kPrimaryColor),
                        ),
                      )
                    : auth.user != null
                        ? MainScreen()
                        : LoginScreen(),
          );
  }
}
