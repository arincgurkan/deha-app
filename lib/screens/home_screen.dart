import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './feed_screen.dart';
import './relatives_screen.dart';
import './earthquake_screen.dart';
import './profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController = PageController(
    initialPage: 0,
  );
  int pageIndex = 0;

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(
        milliseconds: 300,
      ),
      curve: Curves.easeInOut,
    );
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          FeedScreen(),
          RelativesScreen(),
          EarthquakeScreen(),
          ProfileScreen(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: SizedBox(
          height: 100,
          child: CupertinoTabBar(
            currentIndex: pageIndex,
            onTap: onTap,
            activeColor: Color.fromRGBO(254, 71, 56, 1),
            backgroundColor: Color.fromRGBO(15, 31, 40, 1),
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.people,
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
              ),
            ],
          )),
    );
  }
}
