import 'package:cineme/providers/auth.dart';
import 'package:cineme/providers/movies.dart';
import 'package:cineme/providers/search.dart';
import 'package:cineme/providers/watchlist.dart';
import 'package:cineme/providers/youtube_provider.dart';
import 'package:cineme/screens/auth_screen.dart';
import 'package:cineme/screens/tabs_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (_) => Auth(),
        ),
        ChangeNotifierProvider<Movies>(
          create: (_) => Movies()..fetchMovies(),
        ),
        ChangeNotifierProvider<Watchlist>(
          create: (_) => Watchlist()..fetchAndSetWatchlist(),
        ),
        ChangeNotifierProvider<Search>(
          create: (_) => Search(),
        ),
        ChangeNotifierProvider<YoutubeProvider>(
          create: (_) => YoutubeProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Cineme',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF22264C),
          accentColor: const Color(0xFF663DD7),
        ),
        home: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) =>
              snapshot.connectionState != ConnectionState.done
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : StreamBuilder(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (ctx, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (userSnapshot.hasData) {
                          return TabsScreen();
                        }
                        return AuthScreen();
                      }),
        ),
      ),
    );
  }
}
