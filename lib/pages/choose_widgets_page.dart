// import 'package:flutter/material.dart';
// import 'package:internshala_assignment/theme/my_theme.dart';

// class ChooseWidgetsPage extends StatefulWidget {
//   const ChooseWidgetsPage({super.key, required this.selectedItems});
//   final List<bool> selectedItems;

//   @override
//   State<ChooseWidgetsPage> createState() => _ChooseWidgetsPageState();
// }

// class _ChooseWidgetsPageState extends State<ChooseWidgetsPage> {
//   late List<bool> _selectedOptions;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _selectedOptions = List<bool>.from(widget.selectedItems);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         child: Column(
//           children: [
//             const SizedBox(height: 200),
//             Container(
//               color: Colors.grey.shade400,
//               child: ListTile(
//                 contentPadding: EdgeInsets.zero,
//                 minVerticalPadding: 0,
//                 leading: Container(
//                   color: Colors.white,
//                   height: 70,
//                   width: 50,
//                   padding: EdgeInsets.all(6),
//                   child: Icon(
//                     Icons.circle,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 title: Text(
//                   "Text Widget",
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:internshala_assignment/theme/my_theme.dart';

class ChooseWidgetsPage extends StatefulWidget {
  const ChooseWidgetsPage({super.key, required this.selectedItems});
  final List<bool> selectedItems;

  @override
  State<ChooseWidgetsPage> createState() => _ChooseWidgetsPageState();
}

class _ChooseWidgetsPageState extends State<ChooseWidgetsPage> {
  late List<bool> _selectedOptions;

  @override
  void initState() {
    super.initState();
    _selectedOptions = List<bool>.from(widget.selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 200),
            _buildOptionTile(
              title: "Text Widget",
              index: 0,
            ),
            const SizedBox(height: 20),
            _buildOptionTile(
              title: "Image Widget",
              index: 1,
            ),
            const SizedBox(height: 20),
            _buildOptionTile(
              title: "Save Button",
              index: 2,
            ),
            const Spacer(),
            Column(
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, _selectedOptions);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: Colors.black),
                      ),
                    ),
                    child: const Text("Import Widgets"),
                  ),
                ),
                const SizedBox(height: 150),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({required String title, required int index}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOptions[index] = !_selectedOptions[index];
        });
      },
      child: Container(
        color: Colors.grey.shade400,
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          minVerticalPadding: 0,
          leading: Container(
            color: Colors.white,
            height: 70,
            width: 50,
            padding: const EdgeInsets.all(6),
            child: Icon(
              Icons.circle,
              color: _selectedOptions[index] ? Colors.green : Colors.grey,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
