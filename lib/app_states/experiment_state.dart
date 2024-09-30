// ignore_for_file: constant_identifier_names

import 'package:bey_stats/services/logger.dart';
import 'package:bey_stats/structs/experiment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExperimentState extends Cubit<Map<String, bool>> {

  static const String COLLECTION_ID = "collection_system";

  ExperimentState() : super({COLLECTION_ID: true});

  void _setExperiment(String key, bool isOn) {
    final updatedState = Map<String, bool>.from(state);
    updatedState[key] = isOn;
    emit(updatedState);
  }

  bool _isExperimentOn(String key) {
    Map<String, bool> newState = state;
    return newState[key] ?? false;
  }

  static bool isCollectionExperimentOn(BuildContext context) {
    Logger.debug("Retreved Collection Experiment State");
    return BlocProvider.of<ExperimentState>(context)._isExperimentOn(COLLECTION_ID);
  }

  static void setCollectionExperiment(BuildContext context, bool isOnState) {
    BlocProvider.of<ExperimentState>(context)._setExperiment(COLLECTION_ID, isOnState);
  }

  static String getCollectionID() {
    return COLLECTION_ID;
  }

  static List<Experiment> getExperiments() {
    return [
      Experiment(COLLECTION_ID, "Collection System", ExperimentState.setCollectionExperiment, ExperimentState.isCollectionExperimentOn)];
    
  }

}
