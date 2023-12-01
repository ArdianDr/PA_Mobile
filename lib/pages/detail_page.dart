import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/cubit/app_cubit_states.dart';
import 'package:travel_app/cubit/app_cubits.dart';
import 'package:travel_app/pages/detail_page/cubit/store_page_info_cubits.dart';
import 'package:travel_app/widgets/app_button.dart';
import 'package:travel_app/widgets/app_large_text.dart';
import 'package:travel_app/widgets/app_text.dart';
import 'package:travel_app/widgets/responsive_button.dart';

import '../misc/colors.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int gottenStars = 4;
  int selectedIndex = -1;
  Color? color = AppColors.mainColor;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubits, CubitStates>(builder: (context, state) {
      DetailState detail = state as DetailState;
      var list = BlocProvider.of<StorePageInfoCubits>(context).state;
      print('my list length is ${list.length}');
      for (int i = 0; i < list.length; i++) {
        if (list[i].name == detail.place.name) {
          selectedIndex = list[i].index!;
          color = list[i].color;
        }
      }

      return Scaffold(
        body: SizedBox(
          width: double.maxFinite,
          height: double.maxFinite,
          child: Stack(
            children: [
              Positioned(
                  left: 0,
                  child: Container(
                    width: 350,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              "http://mark.bslmeiyu.com/uploads/" +
                                  detail.place.img),
                          fit: BoxFit.cover),
                    ),
                  )),
              Positioned(
                left: 20,
                top: 50,
                child: Row(children: [
                  IconButton(
                    onPressed: () {
                      BlocProvider.of<AppCubits>(context).goHome();
                    },
                    icon: const Icon(Icons.menu),
                  ),
                ]),
              ),
              Positioned(
                top: 320,
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 30,
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 500,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AppLargeText(
                              text: detail.place.name,
                              color: Colors.black.withOpacity(0)),
                          AppLargeText(
                              text: "\$" + detail.place.price.toString(),
                              color: AppColors.textColor1)
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: AppColors.mainColor,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          AppText(
                            text: detail.place.location,
                            color: AppColors.textColor1,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Wrap(
                            children: List.generate(5, (index) {
                              return Icon(Icons.star,
                                  color: index < detail.place.stars
                                      ? AppColors.starColor
                                      : AppColors.textColor2);
                            }),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          AppText(text: "(5.0)", color: AppColors.textColor2)
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      AppLargeText(
                          text: "People",
                          color: Colors.black.withOpacity(0.8),
                          size: 20),
                      const SizedBox(
                        height: 5,
                      ),
                      AppText(
                        text: "Number of people in your group",
                        color: AppColors.mainTextColor,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Wrap(
                        children: List.generate(5, (index) {
                          return InkWell(
                            onTap: () {
                              var data = state.place;
                              var list =
                                  BlocProvider.of<StorePageInfoCubits>(context)
                                      .state;
                              for (int i = 0; i < list.length; i++) {
                                if (list[i].name ==
                                    data.name) if (list[i].index == index) {
                                  //if the index is same we are here
                                } else {
                                  print('updating info');
                                  BlocProvider.of<StorePageInfoCubits>(context)
                                      .updatePageInfo(data.name, index, color);
                                  selectedIndex = index;
                                }
                              }
                              //only if a button was never clicked
                              if (selectedIndex == -1) {
                                print('adding page info');
                                BlocProvider.of<StorePageInfoCubits>(context)
                                    .addPageInfo(
                                        detail.place.name, index, color);
                              }
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: AppButtons(
                                size: 50,
                                color: selectedIndex == index
                                    ? Colors.white
                                    : Colors.black,
                                backgroundColor: selectedIndex == index
                                    ? Colors.black
                                    : AppColors.buttonBackground,
                                borderColor: selectedIndex == index
                                    ? Colors.black
                                    : AppColors.buttonBackground,
                                text: (index + 1).toString(),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AppLargeText(
                        text: "Description",
                        color: Colors.black.withOpacity(0.8),
                        size: 20,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppText(
                        text: detail.place.description,
                        color: AppColors.mainTextColor,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        var list =
                            BlocProvider.of<StorePageInfoCubits>(context).state;
                        if (list.isEmpty) {
                          setState(() {
                            color = Colors.red;
                          });
                          BlocProvider.of<StorePageInfoCubits>(context)
                              .updatePageWish(
                                  detail.place.name, selectedIndex, color);
                        } else {
                          //only toggle the color
                          for (int i = 0; i < list.length; i++) {
                            if (list[i].name == detail.place.name) {
                              if (list[i].color == Colors.red) {
                                Future.delayed(Duration.zero, () {
                                  BlocProvider.of<StorePageInfoCubits>(context)
                                      .updatePageWish(detail.place.name,
                                          selectedIndex, color);
                                });
                                setState(() {
                                  color = AppColors.mainColor;
                                });
                                return;
                              } else {
                                setState(() {
                                  color = Colors.red;
                                });
                                BlocProvider.of<StorePageInfoCubits>(context)
                                    .updatePageWish(detail.place.name,
                                        selectedIndex, color);
                                return;
                              }
                            } else {
                              if (color == AppColors.mainColor) {
                                setState(() {
                                  color = Colors.red;
                                });
                                BlocProvider.of<StorePageInfoCubits>(context)
                                    .updatePageWish(detail.place.name,
                                        selectedIndex, color);
                              } else {
                                setState(() {
                                  color = AppColors.mainColor;
                                });
                                BlocProvider.of<StorePageInfoCubits>(context)
                                    .updatePageWish(detail.place.name,
                                        selectedIndex, color);
                              }
                            }
                          }
                        }
                      },
                      child: AppButtons(
                        size: 60,
                        color: color!,
                        backgroundColor: Colors.white,
                        borderColor: color!,
                        isIcon: true,
                        icon: Icons.favorite_border,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
