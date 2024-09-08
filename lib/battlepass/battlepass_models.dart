class BattlePassHeader {
  int maxLaunchSpeed;
  int launchCount;
  String pageCount;
  String raw;

  BattlePassHeader(
      this.maxLaunchSpeed, this.launchCount, this.pageCount, this.raw);

  Map<String, dynamic> toJson() => {
        'maxLaunchSpeed': maxLaunchSpeed,
        'launchCount': launchCount,
        'pageCount': pageCount,
        'raw': raw
      };
}

class BattlePassLaunchData {
  BattlePassHeader header;
  List<int> launches;
  String raw;

  BattlePassLaunchData(this.header, this.launches, this.raw);

  Map<String, dynamic> toJson() =>
      {'header': header.toJson(), 'launches': launches, 'raw': raw};
}
