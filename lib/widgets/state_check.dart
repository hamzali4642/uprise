import 'package:flutter/material.dart';
import '../helpers/data_state.dart';

Widget? stateCheck(DataStates state, List list) {
  if (state == DataStates.waiting) {
    return const Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  } else if (state == DataStates.fail) {
    return const Expanded(
      child: Center(
        child: Text("Something Went Wrong.",style: TextStyle(color: Colors.white)),
      ),
    );
  } else if (state == DataStates.success) {
    if (list.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text("No Data Found.",style: TextStyle(color: Colors.white),),
        ),
      );
    }
  }
  return null;
}
