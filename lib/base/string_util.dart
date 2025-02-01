class StringUtil {}

extension StringExtension on int? {
  String convertToReadableText() {
    if (this == null) {
      return "알 수 없음";
    }
    if (this! >= 0) {
      return "지상 $this층";
    } else {
      return "지하 ${-1 * this!}층";
    }
  }
}
