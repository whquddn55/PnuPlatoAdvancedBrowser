import 'package:flutter/material.dart';

class SettingDropdown extends StatefulWidget {
  final String title;
  final List<String> itemList;
  final Function onChanged;
  final int initialIndex;
  const SettingDropdown({Key? key, required this.title, required this.itemList, required this.onChanged, this.initialIndex = 0}) : super(key: key);

  @override
  _SettingDropdownState createState() => _SettingDropdownState();
}

class _SettingDropdownState extends State<SettingDropdown> {
  late final List<String> itemList;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    itemList = widget.itemList;
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title),
              DropdownButton(
                value: selectedIndex,
                items: itemList.map((item) => DropdownMenuItem(child: Text(item), value: itemList.indexOf(item))).toList(),
                onChanged: (index) async {
                  bool res = await widget.onChanged(index);
                  if (res == true) {
                    setState(() => selectedIndex = index as int);
                  }
                },
              ),
            ],
          ),
          const Divider(height: 3, thickness: 1),
        ],
      ),
    );
  }
}
