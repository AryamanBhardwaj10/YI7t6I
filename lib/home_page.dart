// import 'dart:typed_data';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:internshala_assignment/components/popup_btn.dart';
// import 'package:internshala_assignment/services/firestore.dart';
// import 'package:internshala_assignment/theme/my_theme.dart';
// import 'package:internshala_assignment/utils/utils.dart';
// import 'package:popover/popover.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final List<bool> _selectedItems = [false, false, false];
//   List<Widget> _widgets = [];

//   final TextEditingController _controller = TextEditingController();
//   //for saving
//   String? _savedText;
//   String? savedImgUrl;
//   Uint8List? pickedImageBytes;

//   FirestoreService _firestoreService = FirestoreService();
//   Future<void> _pickImage() async {
//     Uint8List? pickedImage = await pickImage();
//     if (pickedImage != null) {
//       setState(() {
//         savedImgUrl = null;
//         pickedImageBytes = pickedImage;
//         _savedText = _controller.text;
//       });
//       String uid = DateTime.now().millisecondsSinceEpoch.toString();
//       // savedImgUrl = await _firestoreService.uploadImageToStore(
//       //     'images', pickedImage, uid);
//     }
//   }

//   Future<void> _saveData(BuildContext context) async {
//     if (_savedText == null && savedImgUrl == null) {
//       showSnackbar(context, "Cannot save empty data");
//       return;
//     }

//     await _firestoreService.saveData(
//       text: _savedText,
//       imgUrl: savedImgUrl,
//       context: context,
//     );

//     setState(() {
//       _controller.clear();
//       savedImgUrl = null;
//       pickedImageBytes = null;
//     });
//   }

//   void updateWidgetList(List<bool> selectedItems) {
//     setState(() {
//       _selectedItems.setAll(0, selectedItems);

//       _widgets.clear();
//       if (_selectedItems[0]) {
//         _widgets.add(
//           Column(
//             children: [
//               Container(
//                 child: TextField(
//                   controller: _controller,
//                   style: TextStyle(color: textPrimary),
//                   decoration: InputDecoration(
//                     labelText: "Enter Text",
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 30),
//             ],
//           ),
//         );
//       }
//       if (_selectedItems[1]) {
//         _widgets.add(
//           Column(
//             children: [
//               GestureDetector(
//                 onTap: _pickImage,
//                 child: Container(
//                   height: 200,
//                   width: double.infinity,
//                   color: Colors.grey,
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   child: pickedImageBytes != null
//                       ? Image.memory(
//                           pickedImageBytes!,
//                           fit: BoxFit
//                               .cover, // Adjust the image to fit the container
//                         )
//                       : const Center(child: Text("Image Placeholder")),
//                 ),
//               ),
//               const SizedBox(height: 30),
//             ],
//           ),
//         );
//       }
//       if (_selectedItems[2]) {
//         _widgets.add(Container(
//           margin: const EdgeInsets.symmetric(vertical: 8),
//           child: ElevatedButton(
//             onPressed: () {
//               _saveData(context);
//             },
//             child: const Text("Save"),
//           ),
//         ));
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         title: const Text(
//           "Assignment",
//           style: TextStyle(
//             color: textPrimary,
//             fontSize: 22,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       body: Container(
//         padding: EdgeInsets.symmetric(horizontal: 20),
//         width: double.infinity,
//         height: double.infinity,
//         child: Column(
//           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           mainAxisSize: MainAxisSize.max,
//           children: _widgets,
//         ),
//       ),
//       floatingActionButton: PopupBtn(
//         onConfirm: updateWidgetList,
//         selectedItems: _selectedItems,
//       ),
//     );
//   }
// }
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:internshala_assignment/components/popup_btn.dart';
import 'package:internshala_assignment/services/firestore.dart';
import 'package:internshala_assignment/theme/my_theme.dart';
import 'package:internshala_assignment/utils/utils.dart';
import 'package:popover/popover.dart';

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

  FirestoreService _firestoreService = FirestoreService();

  Future<void> _pickImage() async {
    Uint8List? pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        savedImgUrl = null;
        pickedImageBytes = pickedImage;
        _savedText = _controller.text;
      });

      updateWidgetList(_selectedItems);
      String uid = DateTime.now().millisecondsSinceEpoch.toString();
      savedImgUrl = await _firestoreService.uploadImageToStore(
          'images', pickedImage, uid);
    }
  }

  Future<void> _saveData(BuildContext context) async {
    _savedText = _controller.text;

    if (_controller.text == '' && savedImgUrl == null) {
      showSnackbar(context, "Cannot save empty data");
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
    });
    updateWidgetList(_selectedItems);
  }

  void updateWidgetList(List<bool> selectedItems) {
    setState(() {
      _selectedItems.setAll(0, selectedItems);

      _widgets.clear();

      if (_selectedItems[0]) {
        _widgets.add(
          Column(
            children: [
              Container(
                child: TextField(
                  controller: _controller,
                  style: TextStyle(color: textPrimary),
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
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: pickedImageBytes != null
                      ? Image.memory(
                          pickedImageBytes!,
                          fit: BoxFit.cover,
                        )
                      : const Center(child: Text("Image Placeholder")),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      }

      if (_selectedItems[2]) {
        _widgets.add(Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ElevatedButton(
            onPressed: () {
              _saveData(context);
            },
            child: const Text("Save"),
          ),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text(
          "Assignment",
          style: TextStyle(
            color: textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: _widgets,
        ),
      ),
      floatingActionButton: PopupBtn(
        onConfirm: updateWidgetList,
        selectedItems: _selectedItems,
      ),
    );
  }
}
