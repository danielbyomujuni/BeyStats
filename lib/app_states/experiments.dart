import 'package:bey_stats/structs/experiment_metadata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Experiments extends Cubit<Map<String, bool>> {
  Experiments() : super({"collection_system": true});

  void _setExperiment(String key, bool isOn) {
    Map<String, bool> newState = state;
    newState[key] = isOn;
    emit(newState);
  }

  bool _isExperimentOn(String key) {
    Map<String, bool> newState = state;
    return newState[key] ?? false;
  }

  static bool isCollectionExperimentOn(BuildContext context) {
    return context.read<Experiments>()._isExperimentOn("collection_system");
  }

  static void setCollectionExperiment(BuildContext context, bool isOnState) {
    context.read<Experiments>()._setExperiment("collection_system", isOnState);
  }

  static List<ExperimentMetadata> getExperiments() {
    return [
      ExperimentMetadata("collection_system", "Collection System", Experiments.setCollectionExperiment)];
    
  }
}
