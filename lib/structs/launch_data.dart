class LaunchData {
  final int _sessionNumber;
  final int _launchPower;
  final DateTime _launchDate;

  LaunchData(this._sessionNumber, this._launchPower, this._launchDate);

  int get sessionNumber => _sessionNumber;
  int get launchPower => _launchPower;
  DateTime get launchDate => _launchDate;
}
