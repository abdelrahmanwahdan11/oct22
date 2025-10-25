String formatCurrency(double value, {bool compact = false}) {
  if (compact) {
    return _formatCompact(value);
  }
  return '\$${value.toStringAsFixed(2)}';
}

String formatNumber(double value, {int decimals = 2}) {
  return value.toStringAsFixed(decimals);
}

String formatChangePct(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}

String formatVolume(double value) {
  if (value.abs() >= 1000000000) {
    return '${(value / 1000000000).toStringAsFixed(1)}B';
  }
  if (value.abs() >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(1)}M';
  }
  if (value.abs() >= 1000) {
    return '${(value / 1000).toStringAsFixed(1)}K';
  }
  return value.toStringAsFixed(0);
}

String _formatCompact(double value) {
  if (value.abs() >= 1000000000) {
    return '\${(value / 1000000000).toStringAsFixed(1)}B';
  }
  if (value.abs() >= 1000000) {
    return '\${(value / 1000000).toStringAsFixed(1)}M';
  }
  if (value.abs() >= 1000) {
    return '\${(value / 1000).toStringAsFixed(1)}K';
  }
  return '\${value.toStringAsFixed(2)}';
}
