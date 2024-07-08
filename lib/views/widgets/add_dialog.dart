import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesson_72_permissions/controllers/travel_controller.dart';
import 'package:provider/provider.dart';

class AddDialog extends StatefulWidget {
  bool isAddDialog;
  AddDialog({super.key, this.isAddDialog = true});

  @override
  State<AddDialog> createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  final ImagePicker _imagePicker = ImagePicker();
  File? image;

  final titleTextController = TextEditingController();
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(widget.isAddDialog ? "Add Travel" : "Edit Travel"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleTextController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: "Title",
              errorText: errorText,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(
            color: Colors.grey,
            height: 40,
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(
                fixedSize: const Size(350, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).colorScheme.primary),
            onPressed: () async {
              XFile? imageXFile =
                  await _imagePicker.pickImage(source: ImageSource.camera);
              if (imageXFile != null) {
                setState(() {
                  image = File(imageXFile.path);
                });
              }
            },
            label: const Text("Camera"),
            icon: const Icon(Icons.camera),
            iconAlignment: IconAlignment.start,
          ),
          const SizedBox(height: 30),
          image != null
              ? Container(
                  width: 300,
                  height: 200,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.file(
                    image!,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: const Icon(
                    Icons.image,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (widget.isAddDialog) {
              if (titleTextController.text.trim().isNotEmpty) {
                if (image != null) {
                  Provider.of<TravelController>(context, listen: false)
                      .addTravel(
                    titleTextController.text,
                    image!,
                  );
                }
                errorText = null;
                setState(() {});
              } else {
                errorText = "Please, enter title";
                setState(() {});
              }
            } else {
              // if (titleTextController.text.trim().isNotEmpty) {
              //   if (image != null) {
              //     Provider.of<TravelController>(context, listen: false)
              //         .editTravel(
              //       // id kerak
              //       titleTextController.text,
              //       image!, // vaqtinchalik id yo'qligi uchun xatolik berayapti
              //     );
              //   }
              //   errorText = null;
              //   setState(() {});
              // } else {
              //   errorText = "Please, enter title";
              //   setState(() {});
              // }
            }
            Navigator.pop(context);
          },
          child: const Text("Add"),
        )
      ],
    );
  }
}
