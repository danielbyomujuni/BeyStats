class LaunchData {
  final int _id;
  final int _sessionNumber;
  final int _launchPower;
  final DateTime _launchDate;

  LaunchData(
      this._id, this._sessionNumber, this._launchPower, this._launchDate);

  int get id => _id;
  int get sessionNumber => _sessionNumber;
  int get launchPower => _launchPower;
  DateTime get launchDate => _launchDate;
}
