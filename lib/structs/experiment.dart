
import 'package:flutter/material.dart';

class Experiment {
  late final String _id;
  late final String _name;
  late final Function(BuildContext, bool) _setFunction;
  late final bool Function(BuildContext) _getFunction;

  Experiment(String id, String name, Function(BuildContext, bool) setFunction, bool Function(BuildContext) getFunction) : _id = id, _name = name, _setFunction = setFunction, _getFunction = getFunction;

  String getName() {
    return _name;
  }

  String getID() {
    return _id;
  }  

  void setExperimentState(BuildContext context, bool isOnState) {
    _setFunction(context, isOnState);
  }

  bool getExperimentState(BuildContext context) {
    return _getFunction(context);
  }

  Key toKey() {
    return Key(_id);
  }
}
