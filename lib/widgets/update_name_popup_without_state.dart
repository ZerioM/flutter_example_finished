import 'package:example_finished/config/constants.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UpdateNamePopupWithoutState extends StatelessWidget {

  String itemTitle = "";
  int index = -1;
  String titleOfPopup = Constants.updateNameOf;
  final Function closeUpdateScreen;
  final textController = TextEditingController();

  // constructor
  UpdateNamePopupWithoutState({Key? key, required this.index, required this.itemTitle, required this.closeUpdateScreen}) : super(key: key) {
    if(index == -2) {
      titleOfPopup = Constants.createNewEntry;
    } else {
      titleOfPopup = Constants.updateNameOf + itemTitle;
    }
  } 

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
    title: Text(titleOfPopup, style: const TextStyle(color: Colors.black)),
    content: Container(
          child:
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: textController,
                  decoration: InputDecoration(hintText: itemTitle),
                  onSubmitted: (String value) => closeUpdateAndSave(value, context),
                ),
              ],
            ),
        ),
    actions: <Widget>[
      TextButton(
        onPressed: () => closeUpdateAndSave(textController.text, context),
        child: const Text('Save', style: TextStyle(color: Colors.black)),
      ),
    ],
  );
  }

  closeUpdateAndSave(newTitle, context) {
    closeUpdateScreen(index, newTitle);
    Navigator.of(context).pop();
  }
  
}