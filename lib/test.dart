//  GridView.builder(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//           mainAxisSpacing: 1.0,
//           crossAxisSpacing: 1.0,
//         ),
//         itemCount: _items.length,
//         itemBuilder: (BuildContext context, int index) {
//           final CheckListCard<T> _item = _items[index];
//           final bool isSelected = _selectedItems.contains(_item);
        
//           var checkbox = Transform.scale(
//             scale: 1 * widget.chechboxScaleFactor,
//             child: SizedBox(
//               height: 20,
//               width: 20,
//               child: Checkbox(
//                 materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                 activeColor: _item.selectedColor,
//                 checkColor: _item.checkColor,
//                 fillColor: !_item.enabled
//                     ? MaterialStateProperty.all(_item.disabledColor)
//                     : MaterialStateProperty.all(_item.enabledColor),
//                 shape: _item.shape,
//                 value: isSelected,
//                 side: _item.checkBoxBorderSide,
//                 onChanged: !_item.enabled ? null : (v) {},
//               ),
//             ),
//           );

//           return Stack(
//             children: <Widget>[
//               Positioned.fill(
//                 child: (_item.title ?? const SizedBox()),
//               ),
//               Positioned(
//                 top: 5,
//                 left: 5,
//                 child:
//                     Visibility(visible: _item.leadingCheckBox, child: checkbox),
//               ),
//               Positioned(
//                 top: 5,
//                 left: 5,
//                 child: Visibility(
//                   visible: _item.leadingCheckBox,
//                   child: SizedBox(
//                     width: _item.checkBoxGap,
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 5,
//                 left: 5,
//                 child: Visibility(
//                     visible: !_item.leadingCheckBox, child: checkbox),
//               ),
//               Positioned(
//                 top: 5,
//                 left: 5,
//                 child: Visibility(
//                   visible: !_item.leadingCheckBox,
//                   child: SizedBox(
//                     width: _item.checkBoxGap,
//                   ),
//                 ),
//               ),
//               Positioned.fill(
//                 child: TextButton(
//                   onPressed: !_item.enabled
//                       ? null
//                       : () {
//                           _onChange(_item);
//                         },
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all<Color>(
//                         Colors.black.withOpacity(0)),
//                   ),
//                   child: Container(),
//                 ),
//               ),
//             ],
//           );
//         }
//       );
