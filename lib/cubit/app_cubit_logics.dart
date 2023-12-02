import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/cubit/app_cubit_states.dart';
import 'package:travel_app/cubit/app_cubits.dart';
import 'package:travel_app/pages/auth/login.dart';
import 'package:travel_app/pages/detail_page.dart';
import 'package:travel_app/pages/navpages/main_page.dart';
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
          if(state is DetailState){
            return const DetailPage();
          }
          if(state is LoadingState){
            return const Center(child: CircularProgressIndicator(),);
          }
          if(state is LoadedState){
            return const MainPage();
          }
          if(state is LogOut){
            return const Login();
          }
          if(state is LoggedIn){
            return const WelcomePage();
          }
          else{
            return Container();
          }
        }
      ),
    );
  }
}