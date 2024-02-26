import 'package:flutter/material.dart';
import '../helpers/data_state.dart';

Widget? stateCheck(DataStates state, List list) {

  print(list.length);
  print(state);
  if (state == DataStates.waiting) {
    return Center(
      child: CircularProgressIndicator(),
    );
  } else if (state == DataStates.fail) {
    return Center(
      child: Text("Something Went Wrong.",style: TextStyle(color: Colors.white)),
    );
  } else if (state == DataStates.success) {
    if (list.isEmpty) {
      return Center(
        child: Text("No Data Found.",style: TextStyle(color: Colors.white),),
      );
    }
  }
  return null;
}
