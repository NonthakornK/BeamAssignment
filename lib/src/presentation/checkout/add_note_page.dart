import 'package:flutter/material.dart';

import '../../common/component/custom_button.dart';
import '../../common/component/custom_textformfield.dart';

class AddNotePageArgs {
  final String? note;

  const AddNotePageArgs({this.note});
}

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key, required this.args});
  static const routeName = '/add_note';

  final AddNotePageArgs args;

  @override
  State<StatefulWidget> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  late TextEditingController _noteTextController;

  @override
  void initState() {
    _noteTextController = TextEditingController(text: widget.args.note);
    super.initState();
  }

  @override
  void dispose() {
    _noteTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(
            Icons.close,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 16,
            ),
            child: CustomButton.primary(
              onPressed: () =>
                  Navigator.of(context).pop(_noteTextController.text),
              text: "Save",
            ),
          ),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Add internal note",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              CustomTextFormField(
                controller: _noteTextController,
                title: "note",
                maxLength: 250,
                maxLines: 8,
                helperText: "This note is only visible to you and your team.",
              )
            ],
          ),
        ),
      ),
    );
  }
}
