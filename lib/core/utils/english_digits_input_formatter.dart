import 'package:flutter/services.dart';

/// Keeps only English digits (0-9) in a field.
///
/// Arabic-Indic (٠-٩) and Persian (۰-۹) digits are converted to their English
/// equivalents, so a user on an Arabic keyboard still gets a valid number,
/// and anything else (letters, spaces, symbols) is dropped.
class EnglishDigitsInputFormatter extends TextInputFormatter {
  const EnglishDigitsInputFormatter();

  static String normalize(String input) {
    final buffer = StringBuffer();
    for (final rune in input.runes) {
      if (rune >= 0x30 && rune <= 0x39) {
        buffer.writeCharCode(rune);
      } else if (rune >= 0x0660 && rune <= 0x0669) {
        buffer.writeCharCode(0x30 + rune - 0x0660);
      } else if (rune >= 0x06F0 && rune <= 0x06F9) {
        buffer.writeCharCode(0x30 + rune - 0x06F0);
      }
    }
    return buffer.toString();
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = normalize(newValue.text);
    if (text == newValue.text) return newValue;

    // Keep the cursor after the same digit it was after before filtering.
    final selectionEnd = newValue.selection.end;
    final cursor = selectionEnd < 0
        ? text.length
        : normalize(
            newValue.text.substring(
              0,
              selectionEnd.clamp(0, newValue.text.length),
            ),
          ).length;

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: cursor),
    );
  }
}
