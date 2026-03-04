double evaluateExpression(String input) {
  input = input.replaceAll(' ', '');
  input = input.replaceAll('-', '+-');

  List<String> parts = input.split('+');

  double total = 0;

  for (var part in parts) {
    if (part.trim().isEmpty) continue;
    total += double.parse(part);
  }

  return total;
}

enum InputMode {
  normal,
  operator,
}
