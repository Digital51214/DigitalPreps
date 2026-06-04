import 'package:flutter/material.dart';

class CircularCheckbox extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const CircularCheckbox({
    super.key,
    this.initialValue = false,
    required this.onChanged,
  });

  @override
  State<CircularCheckbox> createState() => _CircularCheckboxState();
}

class _CircularCheckboxState extends State<CircularCheckbox> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isChecked = !isChecked; // toggle
        });
        widget.onChanged(isChecked);
      },
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          shape: BoxShape.circle,

          // 🔥 background color change on select
          color: isChecked ? Colors.black : Colors.white,

          // 🔥 border
          border: Border.all(color: Colors.black, width: 1),
        ),

        child: isChecked
            ? const Icon(Icons.check, color: Colors.white, size: 14)
            : null,
      ),
    );
  }
}
