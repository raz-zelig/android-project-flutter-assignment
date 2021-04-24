import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'authNotifier.dart';
import 'savedNotifier.dart';
import 'randomWords.dart';
import 'login.dart';
import 'saved.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
              body:
                  Center(child: Text(snapshot.error.toString(), textDirection: TextDirection.ltr)));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthNotifier.instance(),
        ),
        ChangeNotifierProxyProvider<AuthNotifier, SavedNotifier>(
          create: (_) => SavedNotifier(),
          update: (_, auth, saved) => saved!..update(auth),
        ),
      ],
      child: MaterialApp(
        title: 'Startup Name Generator',
        theme: ThemeData(
          primaryColor: Colors.red,
        ),
        home: RandomWords(),
        routes: {
          '/login': (BuildContext context) => Login(),
          '/saved': (BuildContext context) => Saved(),
        },
      ),
    );
  }
}



