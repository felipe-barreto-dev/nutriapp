// import 'package:flutter/material.dart';

// class Rotulo extends StatelessWidget {
//   String value;

//   const Rotulo(this.texto, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return DropdownMenu<String>(
//       initialSelection: value,
//       onSelected: (String? newValue) {
//         setState(() {
//           value = newValue!; 
//         });
//       },
//       dropdownMenuEntries: tipos.map<DropdownMenuEntry<String>>((String value) {
//         return DropdownMenuEntry<String>(value: value, label: value);
//       }).toList(),
//     );
//   }
// }
