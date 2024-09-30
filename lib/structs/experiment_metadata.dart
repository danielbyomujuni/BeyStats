
import 'package:flutter/material.dart';

class ExperimentMetadata {
  late final String _id;
  late final String _name;
   late final Function(BuildContext, bool) _setFunction;

  ExperimentMetadata(String id, String name, Function(BuildContext, bool) setFunction) : _id = id, _name = name, _setFunction = setFunction;

  String getName() {
    return _name;
  }

  String getID() {
    return _id;
  }  

  void setExperimentState(BuildContext context, bool isOnState) {
    _setFunction(context, isOnState);
  }
}
