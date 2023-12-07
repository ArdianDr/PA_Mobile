// ignore_for_file: no_leading_underscores_for_local_identifiers, must_be_immutable, library_private_types_in_public_api, use_key_in_widget_constructors, non_constant_identifier_names, avoid_print, use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/firebase/fetchUser.dart';
import 'package:travel_app/pages/detail_page.dart';
import 'package:travel_app/provider/home_page_prod.dart';
import 'package:travel_app/provider/settings_screen.dart';
import 'package:travel_app/widgets/app_large_text.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late HomePageProvider _HomePageProvider;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Mendapatkan instance dari HomePageProvider menggunakan context.read
    _HomePageProvider = context.read<HomePageProvider>();
    // Memanggil fetchTrailData untuk mengambil data
    _HomePageProvider.fetchTrailData();
    _HomePageProvider.fetchInspirationData();
    _startAutoPlay();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _stopAutoPlay();
    _pageController.dispose();
    super.dispose();
  }

  var image = {
    "pic1.jpg": "pic1",
    "pic2.jpg": "pic2",
    "pic3.jpg": "pic3",
    "pic4.jpg": "pic4",
  };
  List<String> imagePaths = [
    'https://firebasestorage.googleapis.com/v0/b/travel-app-a01eb.appspot.com/o/promotions%2Fad1.png?alt=media&token=fe0bcda3-4c34-4cc1-8ae4-cb1c46bb6f08',
    'https://firebasestorage.googleapis.com/v0/b/travel-app-a01eb.appspot.com/o/promotions%2Fad2.png?alt=media&token=fe0bcda3-4c34-4cc1-8ae4-cb1c46bb6f08',
    'https://firebasestorage.googleapis.com/v0/b/travel-app-a01eb.appspot.com/o/promotions%2Fad3.png?alt=media&token=fe0bcda3-4c34-4cc1-8ae4-cb1c46bb6f08',
  ];
  Timer? _timer;

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < imagePaths.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    });
  }

  void _stopAutoPlay() {
    _timer?.cancel();
  }

  Widget _buildPageView() {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: _pageController,
        itemCount: imagePaths.length + 1,
        itemBuilder: (context, index) {
          if (index == imagePaths.length) {
            return Container();
          }

          return Stack(
            children: [
              Positioned(
                top: 40,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      imagePaths[index],
                      width: screenWidth,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 5,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Promotions ${index + 1}',
                    // ignore: prefer_const_constructors
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);

    FirebaseAuth _auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: AppLargeText(text: "Discover"),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Image(
              image: NetworkImage(
                  'https://firebasestorage.googleapis.com/v0/b/travel-app-a01eb.appspot.com/o/logo%2Flogo2.png?alt=media&token=fe0bcda3-4c34-4cc1-8ae4-cb1c46bb6f08'),
              width: 35,
              height: 35,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
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
                    Tab(text: "banners"),
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
                  Consumer<HomePageProvider>(
                    builder: (context, provider, _) {
                      if (provider.trailDataList.isEmpty) {
                        // Tampilkan loading atau pesan jika data belum tersedia
                        print("data kosong");
                        return const Center(
                          child: Text(
                            "Data Masih Loading",
                            style: TextStyle(fontSize: 16),
                          ),
                        );
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
                                margin:
                                    const EdgeInsets.only(right: 15, top: 10),
                                width: 250,
                                height: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      provider.trailDataList[index]
                                          ['downloadURL'],
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
                  // Tampilan pada tab ke-2
                  Consumer<HomePageProvider>(
                    builder: (context, provider, _) {
                      if (provider.inspirationDataList.isEmpty) {
                        print("data inspirasi kosong");
                        return const Center(
                          child: Text(
                            'Inspirations are still empty.',
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      } else {
                        // Tampilkan data dari Firestore pada tab ke-2
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: provider.inspirationDataList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var commentData =
                                      provider.inspirationDataList[index];
                                  var formattedDate = DateFormat.yMMMd()
                                      .add_Hm()
                                      .format(
                                          commentData['createdAt'].toDate());

                                  return Card(
                                    elevation: 3,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 16),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                "https://firebasestorage.googleapis.com/v0/b/travel-app-a01eb.appspot.com/o/profile_images%2F${commentData['profile_img']}.jpg?alt=media&token=3001d812-e439-40e3-9def-f2066271bc19"),
                                            radius: 20,
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  commentData['name'],
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  formattedDate,
                                                  style: const TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(commentData['comments']),
                                              ],
                                            ),
                                          ),
                                          // if (commentData['name'] ==
                                          //     name)
                                          PopupMenuButton<String>(
                                            onSelected: (String result) async {
                                              if (result == 'delete') {
                                                Timestamp createdAt =
                                                    commentData['createdAt'];

                                                bool success = await provider
                                                    .deleteComment(createdAt);

                                                if (success) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Comment deleted successfully',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                      duration:
                                                          Duration(seconds: 2),
                                                      backgroundColor:
                                                          Colors.blueAccent,
                                                    ),
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Failed to delete comment',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                      duration:
                                                          Duration(seconds: 2),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                            itemBuilder:
                                                (BuildContext context) =>
                                                    <PopupMenuEntry<String>>[
                                              const PopupMenuItem<String>(
                                                value: 'delete',
                                                child: ListTile(
                                                  leading: Icon(Icons.delete,
                                                      color: Colors.redAccent),
                                                  title: Text('Delete Comment',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .redAccent)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Form(
                              key: _formKey,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: TextFormField(
                                        controller: commentController,
                                        decoration: const InputDecoration(
                                            hintText: 'Add comment...',
                                            border: OutlineInputBorder(),
                                            prefixIcon: Icon(Icons.chat)),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Comment cannot be empty.';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: FloatingActionButton(
                                      onPressed: () async {
                                        if (_formKey.currentState?.validate() ??
                                            false) {
                                          await _HomePageProvider.addComment(
                                              commentController.text);
                                        }
                                        commentController.text = '';
                                      },
                                      backgroundColor: Colors.blueAccent,
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      }
                    },
                  ),

                  _buildPageView(),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            // Container(
            //   margin: const EdgeInsets.only(left: 20, right: 20),
            //   child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         AppLargeText(
            //           text: "Explore More",
            //           size: 22,
            //         ),
            //         AppText(
            //           text: "See all",
            //         )
            //       ]),
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            // Container(
            //   height: 120,
            //   width: double.maxFinite,
            //   margin: const EdgeInsets.only(left: 20),
            //   child: ListView.builder(
            //       itemCount: 4,
            //       scrollDirection: Axis.horizontal,
            //       itemBuilder: (_, index) {
            //         return Container(
            //           margin: const EdgeInsets.only(right: 30),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             children: [
            //               Container(
            //                 // margin: const EdgeInsets.only(right: 50),
            //                 width: 80,
            //                 height: 80,
            //                 decoration: BoxDecoration(
            //                     borderRadius: BorderRadius.circular(10),
            //                     // color: Colors.white,
            //                     image: const DecorationImage(
            //                         image: AssetImage("img/test.jpg"),
            //                         fit: BoxFit.cover)),
            //               ),
            //               const SizedBox(
            //                 height: 5,
            //               ),
            //               AppText(
            //                 text: "x",
            //               )
            //             ],
            //           ),
            //         );
            //       }),
            // )
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: context.watch<ThemeModeData>().isDarkModeActive
                    ? const Color.fromARGB(255, 28, 27, 31)
                    : Colors.blue,
              ),
              accountName: FutureBuilder<Map<String, dynamic>>(
                future: fetchUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Text(snapshot.data?['name'] ?? 'Customer');
                  } else {
                    return const Text('Loading...');
                  }
                },
              ),
              accountEmail: Text(
                _auth.currentUser?.email ?? "No Email",
              ),
              currentAccountPicture: GestureDetector(
                onTap: () async {
                  Map<String, dynamic> userData =
                      await fetchUserData();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AvatarFullScreen(
                        avatarUrl: userData['img'] ?? '',
                      ),
                    ),
                  );
                },
                child: FutureBuilder<Map<String, dynamic>>(
                  future: fetchUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      String avatarUrl =
                          'https://firebasestorage.googleapis.com/v0/b/travel-app-a01eb.appspot.com/o/profile_images%2F${snapshot.data?['img']}.jpg?alt=media&token=0cdd355f-aa19-4496-8824-a70c09ae4be2';
                      return Hero(
                        tag: 'avatarHero',
                        child: CircleAvatar(
                          backgroundImage: avatarUrl.isNotEmpty
                              ? NetworkImage(avatarUrl)
                              : const NetworkImage(
                                  'https://cdn.discordapp.com/attachments/1100056342317760523/1181590241300189307/zeta.jpg'),
                        ),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
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

class AvatarFullScreen extends StatelessWidget {
  final String avatarUrl;

  const AvatarFullScreen({required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: context.watch<ThemeModeData>().isDarkModeActive
      //               ? const Color.fromARGB(255, 28, 27, 31)
      //               : Colors.white,
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Hero(
            tag: 'avatarHero',
            child: Image.network(
              avatarUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
