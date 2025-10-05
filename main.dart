import 'package:flutter/material.dart';

// -----------------------------------------------------------------------------
// 1. CORE CONVERSION LOGIC (The Model / conversion_service.dart)
// -----------------------------------------------------------------------------

// Defines a class to hold the base conversion logic, supporting bases 2-16.
class ConversionService {
  // Helper to map an integer value (0-15) to its character ('0'-'9', 'A'-'F').
  String _valToChar(int v) {
    if (v < 10) return String.fromCharCode(48 + v); // '0'..'9'
    return String.fromCharCode(55 + v); // 10 -> 'A'
  }

  // Helper to map a character ('0'-'F', case-insensitive) to its integer value (0-15).
  int _charToVal(String c) {
    final uc = c.toUpperCase().codeUnitAt(0);
    if (uc >= 48 && uc <= 57) return uc - 48; // '0'..'9'
    if (uc >= 65 && uc <= 70) return uc - 55; // 'A'..'F' (only valid for base <= 16)
    throw FormatException('Invalid character: $c');
  }

  // Converts a number string from a given base (2-16) to a BigInt (decimal).
  BigInt _fromBaseToBigInt(String s, int base) {
    if (base < 2 || base > 16) throw ArgumentError('Base must be 2..16');

    var str = s.trim();
    var negative = false;

    if (str.startsWith('-')) {
      negative = true;
      str = str.substring(1);
    }
    if (str.isEmpty) throw const FormatException('Empty input');

    BigInt acc = BigInt.zero;
    for (var ch in str.split('')) {
      final val = _charToVal(ch);
      if (val >= base) throw FormatException('Digit "$ch" not valid for base $base');
      acc = acc * BigInt.from(base) + BigInt.from(val);
    }
    return negative ? -acc : acc;
  }

  // Converts a BigInt (decimal) to a number string in the target base (2-16).
  String _bigIntToBase(BigInt value, int base) {
    if (base < 2 || base > 16) throw ArgumentError('Base must be 2..16');
    if (value == BigInt.zero) return '0';

    var negative = value < BigInt.zero;
    var v = negative ? -value : value;

    final digits = <String>[];
    while (v > BigInt.zero) {
      final rem = (v % BigInt.from(base)).toInt();
      digits.add(_valToChar(rem));
      v = v ~/ BigInt.from(base);
    }

    final res = digits.reversed.join();
    return negative ? '-$res' : res;
  }

  // Public method for base conversion.
  String convertBase(String input, int fromBase, int toBase) {
    final decimal = _fromBaseToBigInt(input, fromBase);
    return _bigIntToBase(decimal, toBase);
  }
}

// -----------------------------------------------------------------------------
// 2. MAIN APPLICATION AND UI (The View)
// -----------------------------------------------------------------------------

void main() {
  runApp(const NumberConverterApp());
}

class NumberConverterApp extends StatelessWidget {
  const NumberConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Base Converter',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F8FF),
      ),
      home: const NumberConverterScreen(),
    );
  }
}

// Data structure to map base names to their radix value.
class BaseOption {
  final String name;
  final int radix;
  const BaseOption(this.name, this.radix);
}

// List of available base options for the dropdowns.
const List<BaseOption> availableBases = [
  BaseOption('Binary (Base 2)', 2),
  BaseOption('Octal (Base 8)', 8),
  BaseOption('Decimal (Base 10)', 10),
  BaseOption('Hexadecimal (Base 16)', 16),
];

// -----------------------------------------------------------------------------
// 3. WIDGET AND CONTROLLER LOGIC (The Controller)
// -----------------------------------------------------------------------------

class NumberConverterScreen extends StatefulWidget {
  const NumberConverterScreen({super.key});

  @override
  State<NumberConverterScreen> createState() => _NumberConverterScreenState();
}

class _NumberConverterScreenState extends State<NumberConverterScreen> {
  final ConversionService _service = ConversionService();
  final TextEditingController _inputController = TextEditingController();

  String _result = '';
  BaseOption _fromBase = availableBases[3]; // Default: Hexadecimal
  BaseOption _toBase = availableBases[0]; // Default: Binary

  void _performConversion() {
    final input = _inputController.text.trim();
    final fromBase = _fromBase.radix;
    final toBase = _toBase.radix;

    if (input.isEmpty) {
      setState(() {
        _result = 'Result: Invalid input (Empty)';
      });
      return;
    }

    setState(() {
      try {
        final converted = _service.convertBase(input, fromBase, toBase);
        _result = 'Result: $converted';
      } on ArgumentError catch (e) {
        _result = 'Error: ${e.message}';
      } on FormatException {
        _result = 'Result: Invalid input';
      } catch (_) {
        _result = 'An unexpected error occurred.';
      }
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Base Converter'),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _inputController,
              decoration: const InputDecoration(
                labelText: 'Enter number',
                hintText: 'e.g., FF or 1010',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.text,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            Row(
              children: <Widget>[
                Expanded(child: _buildDropdown('From Base', _fromBase, (newValue) {
                  setState(() => _fromBase = newValue!);
                })),
                const SizedBox(width: 16),
                Expanded(child: _buildDropdown('To Base', _toBase, (newValue) {
                  setState(() => _toBase = newValue!);
                })),
              ],
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _performConversion,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo.shade200,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                elevation: 4,
              ),
              child: const Text(
                'Convert',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 40),

            Center(
              child: Text(
                _result.isNotEmpty ? _result : 'Result: ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _result.startsWith('Error') || _result.contains('Invalid input')
                      ? Colors.red.shade700
                      : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, BaseOption currentValue, ValueChanged<BaseOption?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black54),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<BaseOption>(
              value: currentValue,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.indigo),
              isExpanded: true,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              onChanged: onChanged,
              items: availableBases.map((BaseOption option) {
                return DropdownMenuItem<BaseOption>(
                  value: option,
                  child: Text(option.name),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
