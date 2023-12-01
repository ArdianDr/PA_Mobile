import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:travel_app/misc/colors.dart';
import 'package:travel_app/pages/detail_page/cubit/store_page_info_states.dart';

class StorePageInfoCubits extends Cubit<List<StorePageInfoState>> {
  StorePageInfoCubits() : super([]);

  addPageInfo(String? name, int? index, Color? color) {
    emit(
        [StorePageInfoState(name: name, index: index, color: color), ...state]);
  }

  updatePageInfo(String? name, int? index, Color? color) {
    var myList = state;
    for (int i = 0; i < myList.length; i++) {
      if (myList[i].name == name) {
        var rem = state.removeAt(i);
        //if the index is same we are here
      }
    }
    emit([StorePageInfoState(name: name, index: index, color: color), ...state]);
  }

  updatePageWish(String? name, int? index, Color? color) {
    var myList = state;
    for (int i = 0; i < myList.length; i++) {
      if (myList[i].name == name) {
        state.removeAt(i);
        //if the index is same we are here
      }
    }
    //with this we always get the updated color of we change the wish button color
    emit([StorePageInfoState(name: name, index: index, color: color), ...state]);
  }
}
