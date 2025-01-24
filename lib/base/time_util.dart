class TimeUtil {
  static String getTimeDifference(
      DateTime currentDateTime, DateTime targetDateTime) {
    final difference = currentDateTime.difference(targetDateTime);

    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);
    final seconds = difference.inSeconds.remainder(60);

    final timeDifferenceParts = <String>[];
    if (hours != 0) timeDifferenceParts.add('$hours시간');
    if (minutes != 0) timeDifferenceParts.add('$minutes분');
    timeDifferenceParts.add('$seconds초');

    // 모든 값이 0일 경우 기본 메시지 리턴
    if (timeDifferenceParts.isEmpty) return '0초';

    return timeDifferenceParts.join(' '); // 공백으로 연결된 문자열 리턴
  }
}
