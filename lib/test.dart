// GridView.builder(
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         mainAxisSpacing: 1.0,
//         crossAxisSpacing: 1.0,
//       ),
//       itemCount: _items.length,
//       itemBuilder: (BuildContext context, int index) {
//         final CheckListCard<T> _item = _items[index];
//         final bool isSelected = _selectedItems.contains(_item);

//         return Stack(
//           children: <Widget>[
//             Positioned.fill(
//               child: (_item.title ?? const SizedBox()),
//             ),
//             Positioned(
//               top: 5,
//               left: 5,
//               child:
//                   Visibility(visible: _item.leadingCheckBox, child: checkbox),
//             ),
//             Positioned(
//               top: 5,
//               left: 5,
//               child: Visibility(
//                 visible: _item.leadingCheckBox,
//                 child: SizedBox(
//                   width: _item.checkBoxGap,
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 5,
//               left: 5,
//               child: Visibility(
//                   visible: !_item.leadingCheckBox, child: checkbox),
//             ),
//             Positioned(
//               top: 5,
//               left: 5,
//               child: Visibility(
//                 visible: !_item.leadingCheckBox,
//                 child: SizedBox(
//                   width: _item.checkBoxGap,
//                 ),
//               ),
//             ),
//             Positioned.fill(
//               child: TextButton(
//                 onPressed: !_item.enabled
//                     ? null
//                     : () {
//                         _onChange(_item);
//                       },
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all<Color>(
//                       Colors.black.withOpacity(0)),
//                 ),
//                 child: Container(),
//               ),
//             ),
//           ],
//         );
//       }
//     );
