import 'package:bey_stats/services/logger.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'database_core.dart';

class DonationDatabase {

  DatabaseCore? _database;
  DonationDatabase._(this._database);

  static DonationDatabase? _donationInstance;

  @protected
  static List<void Function(double value)> listeners = [];

  static Future<DonationDatabase> getInstance() async {
    _donationInstance ??= DonationDatabase._(await DatabaseCore.getInstance());
    return _donationInstance!;
  }

  Future<void> addDonation(double amount) async {
    //Logger.debug("$amount");
    String query = "INSERT INTO 'donations' (donation_amount) VALUES ('$amount');";
    //Logger.debug(query);
    await (await _database!.connection()).execute(query);
    
    notifyListeners(await getTotalDonatedAmount());
  }

  Future<double> getTotalDonatedAmount() async {
    var result = await (await _database!.connection()).rawQuery("SELECT * FROM 'donations';");
    var totalAmount = 0.0;
    //Logger.debug("$result");
    for (var record in result) {
      //Logger.debug("${record["donation_amount"]}");
      totalAmount += record["donation_amount"] as double;
    }

    //Logger.debug("$totalAmount");

    return totalAmount;
  }

  void addListener(void Function(double value) listener) {
    Logger.debug("Added a Listener");
    listeners.add(listener);
    Logger.debug("Listener Count: ${listeners.length}");
  }

  void notifyListeners(double value) {
    Logger.debug("Notifying Listeners: ${listeners.length}");
    for (var listener in listeners) {
      Logger.debug("Notified a Listener");
      listener(value);
    }
  }
}
