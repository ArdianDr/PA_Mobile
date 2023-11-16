import 'package:flutter/material.dart';
import 'package:travel_app/widgets/app_large_text.dart';
import 'package:travel_app/widgets/app_text.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int gottenStars=4;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                        image: AssetImage("img/pic1.jpeg"), 
                        fit: BoxFit.cover),
                  ),
                )),
            Positioned(
              left: 20,
              top: 50,
              child: Row(
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.menu),

                  ),
                ]
              ),
            ),
            Positioned(
              top: 320,
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 30,),
                width: MediaQuery.of(context).size.width,
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.white ,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)
                  )
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AppLargeText(text: "Yosemite", color: Colors.black.withOpacity(0)),
                        AppLargeText(text: "\$ 250", color:AppColors.textColor1.mainColor)
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: AppColors.mainColor,),
                        SizedBox(width: 5,),
                        AppText(text: "USA, California", color: AppColors.textColor1,)
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Wrap(
                      children: List.generate(5, (index){
                        return Icon(Icons.star, color:index<gottenStars?AppColors.starColor:AppColors.textColor2);
                      }),
                    ),
                      SizedBox(width: 10,),
                      AppText(text: "(4.0)", color: AppColors.textColor2)
                      ],
                    ),
                      SizedBox(height: 25,),
                      AppLargeText(text: "People",color:Colors.black.withOpacity(0.8),size:20),
                      SizedBox(height: 5,),
                      AppText(text: "Number of people in your group",color: AppColors.mainTextColor, ),
                      Wrap(
                        children: List.generate(5, index){
                          return Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: AppColors.buttonBackground
                            ),
                          );
                        }
                      )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
