import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:internshala_assignment/pages/choose_widgets_page.dart';
import 'package:internshala_assignment/services/firestore.dart';
import 'package:internshala_assignment/theme/my_theme.dart';
import 'package:internshala_assignment/utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<bool> _selectedItems = [false, false, false];
  List<Widget> _widgets = [];
  final TextEditingController _controller = TextEditingController();
  String? _savedText;
  String? savedImgUrl;
  Uint8List? pickedImageBytes;
  bool showEmptySaveMessage = false; // Flag for showing the message

  FirestoreService _firestoreService = FirestoreService();

  Future<void> _pickImage() async {
    Uint8List? pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        savedImgUrl = null;
        pickedImageBytes = pickedImage;
        _savedText = _controller.text;
      });
    }
  }

  Future<void> _saveData(BuildContext context) async {
    _savedText = _controller.text;

    if (_controller.text == '' && savedImgUrl == null) {
      // Show the message if only the Save button is present
      if (_widgets.length == 1 && _selectedItems[2]) {
        setState(() {
          showEmptySaveMessage = true;
        });
      } else {
        showSnackbar(context, "Cannot save empty data");
      }
      return;
    }

    await _firestoreService.saveData(
      text: _savedText,
      imgUrl: savedImgUrl,
      context: context,
    );

    setState(() {
      _controller.clear();
      savedImgUrl = null;
      pickedImageBytes = null;
      showEmptySaveMessage = false;
    });
  }

  void updateWidgetList(List<bool> selectedItems) {
    setState(() {
      _selectedItems.setAll(0, selectedItems);
      _widgets.clear();

      if (_selectedItems[0]) {
        _widgets.add(
          Column(
            children: [
              const SizedBox(height: 20),
              Container(
                color: Colors.grey.shade100,
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: textPrimary),
                  decoration: InputDecoration(
                    labelText: "Enter Text",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      }

      if (_selectedItems[1]) {
        _widgets.add(
          Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 300,
                  width: double.infinity,
                  color: Colors.grey.shade100,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: pickedImageBytes != null
                      ? Image.memory(
                          pickedImageBytes!,
                          fit: BoxFit.cover,
                        )
                      : const Center(child: Text("Upload Image")),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      }

      if (_selectedItems[2]) {
        _widgets.add(Column(
          children: [
            !(_selectedItems[0] || _selectedItems[1])
                ? SizedBox(
                    height: double.infinity,
                  )
                : SizedBox(),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ElevatedButton(
                onPressed: () => _saveData(context),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black)),
                  backgroundColor: primary,
                  foregroundColor: Colors.black,
                ),
                child: const Text("Save"),
              ),
            ),
          ],
        ));
      }

      // Reset the flag if widgets are updated
      showEmptySaveMessage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Assignment",
          style: TextStyle(
            color: textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: backgroundColor,
          width: double.infinity,
          height: double.infinity,
          child: showEmptySaveMessage
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // Spacer(),

                    Text(
                      "At least a Widget to Save !",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Column(
                      children: _widgets,
                    )
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.max,
                  children: _widgets,
                ),
        ),
      ),
      bottomSheet: Container(
        width: double.infinity,
        color: Colors.white,
        padding:
            const EdgeInsets.only(bottom: 50, top: 20, left: 100, right: 100),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: ElevatedButton(
            onPressed: () async {
              final List<bool>? selectedItems = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ChooseWidgetsPage(selectedItems: _selectedItems),
                ),
              );

              if (selectedItems != null) {
                updateWidgetList(selectedItems);
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: const BorderSide(color: Colors.black),
              ),
            ),
            child: const Text("Add Widgets"),
          ),
        ),
      ),
    );
  }
}
