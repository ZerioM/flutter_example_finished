import 'dart:io';

import 'package:example_finished/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable

class UpdateNamePopupWidget extends StatefulWidget {
  const UpdateNamePopupWidget(
      {Key? key,
      required this.index,
      required this.itemTitle,
      required this.closeUpdateScreen,
      this.item})
      : super(key: key);

  final Function closeUpdateScreen;
  final int index;
  final String itemTitle;
  final dynamic item;

  @override
  UpdateNamePopup createState() => UpdateNamePopup();
}

class UpdateNamePopup extends State<UpdateNamePopupWidget> {
  final ImagePicker _imagePicker = ImagePicker();
  dynamic icon = "";
  String titleOfPopup = Constants.updateNameOf;
  int index = -1;
  final textController = TextEditingController();
  // constructor

  checkTitle() {
    if (widget.index == -2) {
      titleOfPopup = Constants.createNewEntry;
    } else {
      titleOfPopup = Constants.updateNameOf + widget.itemTitle;
    }

    return titleOfPopup;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titleOfPopup, style: const TextStyle(color: Colors.black)),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(hintText: checkTitle()),
              onSubmitted: (String value) => closeUpdateAndSave(value, context),
            ),
            ElevatedButton(
                child: const Text("Add image"),
                onPressed: () async {
                  final image =
                      await _imagePicker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    icon = image;
                  });
                }),
            icon != ""
                ? Image.file(File(icon!.path),
                    scale: 0.5, fit: BoxFit.contain, height: 200)
                : const Text("No image!")
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
    if (icon != "" && widget.item != null) {
      widget.closeUpdateScreen(widget.index, newTitle, icon, widget.item.id);
    } else if(widget.item != null){
      widget.closeUpdateScreen(widget.index, newTitle, null, widget.item!.id);
    }else if(icon != ""){
      widget.closeUpdateScreen(widget.index, newTitle, icon, null);
    }else{
      widget.closeUpdateScreen(widget.index, newTitle, null, null);
    }
    Navigator.of(context).pop();
  }
}
