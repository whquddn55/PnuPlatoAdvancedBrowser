import 'package:flutter/material.dart';

class SettingCheckBox extends StatefulWidget {
  final bool checked;
  final String title;
  const SettingCheckBox({Key? key, required this.title, required this.checked}) : super(key: key);

  @override
  _SettingCheckBoxState createState() => _SettingCheckBoxState();
}

class _SettingCheckBoxState extends State<SettingCheckBox> {
  late bool checked;

  @override
  void initState() {
    super.initState();
    checked = widget.checked;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => setState(() => checked = !checked),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title),
                Checkbox(value: checked, onChanged: (_) {}),
              ],
            ),
          ),
          const Divider(height: 3, thickness: 1),
        ],
      ),
    );
  }
}
