import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/pages/navpages/bar_item_page.dart';
import 'package:travel_app/pages/home_page.dart';
import 'package:travel_app/pages/navpages/my_page.dart';
import 'package:travel_app/pages/navpages/search_page.dart';
import 'package:travel_app/provider/settings_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List pages = [
    const HomePage(),
    const BarItemPage(),
    const SearchPage(),
    const MyPage()
  ];

  int currentIndex=0;
  void onTap(int index){
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedFontSize: 0,
        selectedFontSize: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: context.watch<ThemeModeData>().isDarkModeActive
                  ? Colors.white
                  : Colors.blueAccent,
        onTap: onTap,
        currentIndex: currentIndex,
        selectedItemColor: context.watch<ThemeModeData>().isDarkModeActive
                  ? Colors.blueAccent
                  : Colors.grey,
        unselectedItemColor: context.watch<ThemeModeData>().isDarkModeActive
                  ? Colors.black
                  : Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(label:("Home"), icon: Icon(Icons.apps)),
          BottomNavigationBarItem(label:("Bar"), icon: Icon(Icons.bar_chart_sharp)),
          BottomNavigationBarItem(label:("Search"), icon: Icon(Icons.search)),
          BottomNavigationBarItem(label:("My"), icon: Icon(Icons.person)),
        ]
        ),
    );
  }
}