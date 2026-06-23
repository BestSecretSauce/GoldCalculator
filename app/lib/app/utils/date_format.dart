String formatYmd(DateTime dt) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  return '${dt.year}-${twoDigits(dt.month)}-${twoDigits(dt.day)}';
}
