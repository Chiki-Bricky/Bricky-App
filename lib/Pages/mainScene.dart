// // ignore_for_file: file_names

// import 'package:flutter/material.dart';

// class MainScrene extends StatefulWidget {
//   const MainScrene({Key? key}) : super(key: key);

//   @override
//   State<MainScrene> createState() => _MainScreneState();
// }

// class _MainScreneState extends State<MainScrene> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[900],
//       appBar: AppBar(
//         title: Text('Todo List'),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           FloatingActionButton(
//             backgroundColor: Colors.greenAccent,
//             onPressed: () {
//               showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return AlertDialog(
//                       title: Text('Add element'),
//                       content: TextField(
//                         //row instead of TextField for adding another widget
//                         onChanged: (String value) {
//                           _getLego = value;
//                         },
//                       ),
//                       actions: [
//                         ElevatedButton(
//                             onPressed: () {
//                               //  setState(() {
//                               //   todoList.add(_userToDO);
//                               //  });
//                               Navigator.pushReplacementNamed(context, '/todo',
//                                   arguments: _getLego);
//                             },
//                             child: Text('add'))
//                       ],
//                     );
//                   });
//             },
//             child: Icon(
//               Icons.add_box,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
