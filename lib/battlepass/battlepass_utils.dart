import 'dart:async';

String convertIntListToHexString(List<int> intList) {
  return intList
      .map((int value) => value.toRadixString(16).padLeft(2, '0'))
      .join();
}

Future<void> waitWhile(bool Function() test,
    [Duration pollInterval = Duration.zero]) {
  var completer = Completer<void>();
  void check() {
    if (!test()) {
      completer.complete();
    } else {
      Timer(pollInterval, check);
    }
  }

  check();
  return completer.future;
}

String getBytes(String hexString, int pos, int words) {
  var byteSegment = hexString.substring(pos, pos + (words * 2));
  int n = byteSegment.length;
  List<String> flipped = List<String>.filled(n, '');

  for (int i = 0; i < n; i += 2) {
    flipped[i] = byteSegment[n - i - 2];
    flipped[i + 1] = byteSegment[n - i - 1];
  }

  return flipped.join();
}

List<String> splitIntoChunksUntilZeros(String input) {
  List<String> chunks = [];
  int length = input.length;

  for (int i = 0; i < length; i += 4) {
    String chunk = input.substring(i, i + 4);
    if (chunk == "0000") {
      break;
    }
    chunks.add(chunk);
  }

  return chunks;
}
