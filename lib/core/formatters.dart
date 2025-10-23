String formatNumber(num value) {
  final string = value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1);
  final parts = string.split('.');
  final integer = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < integer.length; i++) {
    final digit = integer[integer.length - 1 - i];
    buffer.write(digit);
    if ((i + 1) % 3 == 0 && i + 1 != integer.length) {
      buffer.write(',');
    }
  }
  final formattedInt = buffer.toString().split('').reversed.join();
  if (parts.length == 1 || int.tryParse(parts.last) == 0) {
    return formattedInt;
  }
  return '$formattedInt.${parts.last}';
}
