import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:internshala_assignment/theme/my_theme.dart';
import 'package:popover/popover.dart';

class PopupBtn extends StatefulWidget {
  const PopupBtn(
      {super.key, required this.onConfirm, required this.selectedItems});
  final Function(List<bool>) onConfirm;
  final List<bool> selectedItems;

  @override
  State<PopupBtn> createState() => _PopupBtnState();
}

class _PopupBtnState extends State<PopupBtn> {
  late List<bool> _tempSelectedItems;

  @override
  void initState() {
    super.initState();
    _tempSelectedItems = List.from(widget.selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        showPopover(
          context: context,
          backgroundColor: primary,
          direction: PopoverDirection.top,
          bodyBuilder: (context) {
            return StatefulBuilder(
              builder: (context, setStatePopover) {
                void toggleSelection(int index) {
                  setStatePopover(() {
                    _tempSelectedItems[index] = !_tempSelectedItems[index];
                  });
                }

                return Column(
                  children: [
                    MenuItem(
                      color: _tempSelectedItems[0]
                          ? Colors.grey.shade400
                          : Colors.grey.shade200,
                      text: "Text",
                      onTap: () {
                        toggleSelection(0);
                      },
                    ),
                    MenuItem(
                      color: _tempSelectedItems[1]
                          ? Colors.grey.shade400
                          : Colors.grey.shade200,
                      text: "Image",
                      onTap: () {
                        toggleSelection(1);
                      },
                    ),
                    MenuItem(
                      color: _tempSelectedItems[2]
                          ? Colors.grey.shade400
                          : Colors.grey.shade200,
                      text: "Button",
                      onTap: () {
                        toggleSelection(2);
                      },
                    ),
                    MenuItem(
                      color: primary,
                      text: "Confirm",
                      onTap: () {
                        widget.onConfirm(_tempSelectedItems);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          },
          height: 200,
          width: 250,
        );
      },
      foregroundColor: Colors.black,
      backgroundColor: primary,
      icon: const Icon(Icons.add),
      label: const Text(
        "Add",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem(
      {super.key,
      required this.color,
      required this.text,
      required this.onTap});
  final Color color;
  final String text;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        color: color,
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
