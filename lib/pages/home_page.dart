// ignore_for_file: no_leading_underscores_for_local_identifiers, must_be_immutable, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/firebase/fetchUser.dart';
// import 'package:travel_app/firebase/trail.dart';
import 'package:travel_app/pages/detail_page.dart';
import 'package:travel_app/provider/detail_page_prod.dart';
import 'package:travel_app/provider/settings_screen.dart';
import 'package:travel_app/widgets/app_large_text.dart';
import 'package:travel_app/widgets/app_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {

late DetailPageProvider _detailPageProvider;

  @override
  void initState() {
    super.initState();
    // Mendapatkan instance dari DetailPageProvider menggunakan context.read
    _detailPageProvider = context.read<DetailPageProvider>();

    // Memanggil fetchTrailData untuk mengambil data
    _detailPageProvider.fetchTrailData();
  }

  var image = {
    "pic1.jpg": "pic1",
    "pic2.jpg": "pic2",
    "pic3.jpg": "pic3",
    "pic4.jpg": "pic4",
  };
  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    FirebaseAuth _auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: AppLargeText(text: "Discover"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
                labelPadding: const EdgeInsets.only(left: 20, right: 20),
                controller: _tabController,
                labelColor: Colors.blue,
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: CircleTabIndicator(color: Colors.blue, radius: 4),
                tabs: const [
                  Tab(text: "places"),
                  Tab(text: "inspiration"),
                  Tab(text: "emotions"),
                ]),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            height: 400,
            width: double.maxFinite,
            child: TabBarView(
              controller: _tabController,
              children: [
                // Menggunakan Consumer untuk mendapatkan data dari provider
                Consumer<DetailPageProvider>(
                  builder: (context, provider, _) {
                    if (provider.trailDataList.isEmpty) {
                      // Tampilkan loading atau pesan jika data belum tersedia
                      print("data kosong");
                      return const CircularProgressIndicator();
                    } else {
                      // Tampilkan gambar sesuai dengan data yang ada di provider
                      return ListView.builder(
                        itemCount: provider.trailDataList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              // Navigate to the DetailPage and pass the data
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                    // Pass relevant data to DetailPage
                                    data: provider.trailDataList[index],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 15, top: 10),
                              width: 250,
                              height: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    provider.trailDataList[index]['downloadURL'],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
                const Text("there"),
                const Text("bye"),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppLargeText(
                    text: "Explore More",
                    size: 22,
                  ),
                  AppText(
                    text: "See all",
                  )
                ]),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 120,
            width: double.maxFinite,
            margin: const EdgeInsets.only(left: 20),
            child: ListView.builder(
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // margin: const EdgeInsets.only(right: 50),
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // color: Colors.white,
                              image: const DecorationImage(
                                  image: AssetImage("img/test.jpg"),
                                  fit: BoxFit.cover)),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        AppText(
                          text: "x",
                        )
                      ],
                    ),
                  );
                }),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                // color:
                color: context.watch<ThemeModeData>().isDarkModeActive
                    ? const Color.fromARGB(255, 28, 27, 31)
                    : Colors.blue,
              ),
              accountName: FutureBuilder<String?>(
                future: fetchUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Text(snapshot.data ?? 'Customer');
                  } else {
                    return const Text('Loading...');
                  }
                },
              ),
              accountEmail: Text(
                _auth.currentUser?.email ?? "No Email",
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://cdn.discordapp.com/attachments/1100056342317760523/1181590241300189307/zeta.jpg"),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.settings,
              ),
              title: const Text("Setting"),
              onTap: () {
                Navigator.pushNamed(context, '/setting');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, '/introduction');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CircleTabIndicator extends Decoration {
  final Color color;
  double radius;
  CircleTabIndicator({required this.color, required this.radius});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    // TODO: implement createBoxPainter
    return _CirclePainter(color: color, radius: radius);
  }
}

class _CirclePainter extends BoxPainter {
  final Color color;
  double radius;
  _CirclePainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    Paint _paint = Paint();
    _paint.color = color;
    _paint.isAntiAlias = true;
    final Offset circleOffset = Offset(
        configuration.size!.width / 2 - radius / 2, configuration.size!.height);
    canvas.drawCircle(offset + circleOffset, radius, _paint);
  }
}
