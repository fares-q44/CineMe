import 'package:cineme/screens/explore_screen.dart';
import 'package:cineme/screens/search_screen.dart';
import 'package:cineme/screens/terms_screen.dart';
import 'package:cineme/screens/watchlist_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> pages = [
    {'page': ExploreScreen(), 'title': 'Explore'},
    {'page': SearchScreen(), 'title': 'Search'},
    {'page': WatchlistScreen(), 'title': 'Watchlist'},
  ];
  int selectedPageIndex = 0;
  void _selectPage(int index) {
    setState(
      () {
        selectedPageIndex = index;
      },
    );
  }

  launchLinkedin() async {
    Uri url = Uri.parse('https://www.linkedin.com/in/fares-alqahtani/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw ('Could not launch');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(selectedPageIndex == 1
                ? "Search "
                : selectedPageIndex == 2
                    ? "Watchlist "
                    : "CineMe "),
            Container(
              height: 25,
              width: 25,
              margin: EdgeInsets.only(bottom: 5),
              child: Image.asset(selectedPageIndex == 1
                  ? "assets/icons/loupe.png"
                  : selectedPageIndex == 2
                      ? "assets/icons/clipboard.png"
                      : "assets/icons/tape.png"),
            )
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 3,
        width: 250,
        child: SafeArea(
          child: Column(
            children: [
              Material(
                elevation: 15,
                child: Image.asset(
                  'assets/images/cineme.jpg',
                  fit: BoxFit.cover,
                  height: 200,
                  width: 250,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ListTile(
                onTap: launchLinkedin,
                style: ListTileStyle.list,
                visualDensity: VisualDensity.comfortable,
                leading: Container(
                  margin: EdgeInsets.only(left: 4),
                  child: Icon(
                    Icons.phone,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                title: Text(
                  'Contact us',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TermsScreen(),
                  ));
                },
                style: ListTileStyle.list,
                visualDensity: VisualDensity.comfortable,
                leading: Image.asset(
                  'assets/icons/terms-and-conditions.png',
                  width: 36,
                  height: 36,
                ),
                title: Text(
                  'Terms And Conditions',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ListTile(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
                style: ListTileStyle.list,
                visualDensity: VisualDensity.comfortable,
                leading: Image.asset(
                  'assets/icons/exit.png',
                  width: 40,
                  height: 40,
                ),
                title: Text(
                  'Signout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: IndexedStack(
        index: selectedPageIndex,
        children: [
          ExploreScreen(),
          SearchScreen(),
          WatchlistScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              margin: EdgeInsets.only(bottom: 4),
              width: 30,
              height: 30,
              child: Image.asset('assets/icons/theatre.png'),
            ),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: EdgeInsets.only(bottom: 4),
              width: 30,
              height: 30,
              child: Image.asset('assets/icons/loupe.png'),
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: EdgeInsets.only(bottom: 4),
              width: 30,
              height: 30,
              child: Image.asset('assets/icons/clipboard.png'),
            ),
            label: 'Watchlist',
          ),
        ],
      ),
    );
  }
}
