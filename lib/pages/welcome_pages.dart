// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:travel_app/widgets/app_large_text.dart';
import 'package:travel_app/widgets/app_text.dart';
import 'package:travel_app/widgets/responsive_button.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();

}

class _WelcomePageState extends State<WelcomePage> {
    List images = [
     "pic1.jpg",
     "pic2.jpg",
     "pic3.jpg",
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: images.length,
        itemBuilder: (_, index){
          return Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "img/"+images[index]
                ),
                fit: BoxFit.cover
                ),
            ),
            child: Container(
              margin: const EdgeInsets.only(top:150, left: 20, right: 20 ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppLargeText(text: "Trips"),
                      AppText(text: "Mountain", size : 30,),
                      SizedBox(
                        width: 250,
                        child: AppText(
                          text: "DESKRIPSI",
                          // color: AppColors.textColor2,
                          size: 14,
                          ),
                      ),
                      const SizedBox(height: 40,),
                      ResponsiveButtton(width: 120,)
                    ],
                  ),
                  Column(
                    children: List.generate(3, (indexDots){
                      return Container(
                        margin: const EdgeInsets.only(bottom: 2),
                        width: 8,
                        height: index==indexDots?25:8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: index==indexDots?Colors.white: Colors.white.withOpacity(0.3)
                        ),
                      );
                    }
                    ),
                  )
                ],
              ),
            ),
          );
        })
    );
  }
}