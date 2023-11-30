import 'package:bloc/bloc.dart';
import 'package:travel_app/pages/detail_page/cubit/store_page_info_states.dart';


class StorePageInfoCubits extends Cubit<List<StorePageInfoState>>{
  StorePageInfoCubits():super([]);

  addPageInfo(String? name, int? index){
    emit([StorePageInfoState(name:name, index: index), ...state]);
  }

  updatePageInfo(String? name, int? index){
    var myList = state;
    for(int i=0; i<myList.length; i++){
      if(myList[i].name==name){
        state.remove(StorePageInfoState(name:myList[i].name, index: myList[i].index));
      }
    }

    emit([StorePageInfoState(name:name, index: index), ...state]);
  }  
}