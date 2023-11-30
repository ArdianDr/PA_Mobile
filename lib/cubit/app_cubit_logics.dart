import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/cubit/app_cubit_states.dart';
import 'package:travel_app/cubit/app_cubits.dart';
import 'package:travel_app/pages/home_page.dart';
import 'package:travel_app/pages/welcome_pages.dart';

class AppCubitLogics extends StatefulWidget{
  const AppCubitLogics({Key? key}) : super(key: key);

  @override
  _AppCubitLogicState createState() => _AppCubitLogicState();
}

class _AppCubitLogicState extends State<AppCubitLogics>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: BlocBuilder<AppCubits, CubitStates>(
        builder: (context, state){
          if(state is WelcomeState){
            return WelcomePage();
          }if(state is LoadingState){
            return Center(child: CircularProgressIndicator(),);
          }if(state is LoadedState){
            return HomePage();
          }else{
            return Container();
          }
        }
      ),
    );
  }
}