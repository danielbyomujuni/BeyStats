class BattlePassHeader {
  int maxLaunchSpeed;
  int launchCount;
  String pageCount;

  BattlePassHeader(this.maxLaunchSpeed, this.launchCount, this.pageCount);
}

class BattlePassLaunchData {
  BattlePassHeader header;
  List<int> launches;

  BattlePassLaunchData(this.header, this.launches);
}
