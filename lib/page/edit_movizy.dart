import 'package:flutter/material.dart';
import '../db/movizy_database.dart';
import '../model/movizy.dart';
import '../widget/movizy_form.dart';

class AddEditMovizyPage extends StatefulWidget {
  final Movizy? movizy;

  const AddEditMovizyPage({
    Key? key,
    this.movizy,
  }) : super(key: key);

  @override
  State<AddEditMovizyPage> createState() => _AddEditMovizyPageState();
}

class _AddEditMovizyPageState extends State<AddEditMovizyPage> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String picture;
  late String description;

  @override
  void initState() {
    super.initState();

    title = widget.movizy?.title ?? '';
    picture = widget.movizy?.picture ?? '';
    description = widget.movizy?.description ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [buildButton()],
        ),
        body: Form(
          key: _formKey,
          child: MovizyFormWidget(
            title: title,
            picture: picture,
            description: description,
            onChangedTitle: (title) => setState(() => this.title = title),
            onChangedPicture: (picture) =>
                setState(() => this.picture = picture),
            onChangedDescription: (description) =>
                setState(() => this.description = description),
          ),
        ),
      );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateMovizy,
        child: const Text('Save'),
      ),
    );
  }

  void addOrUpdateMovizy() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.movizy != null;

      if (isUpdating) {
        await updateMovizy();
      } else {
        await addMovizy();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateMovizy() async {
    final movizy = widget.movizy!.copy(
      title: title,
      picture: picture,
      description: description,
    );

    await MoviziesDatabase.instance.update(movizy);
  }

  Future addMovizy() async {
    final movizy = Movizy(
      title: title,
      picture: picture,
      description: description,
      createdTime: DateTime.now(),
    );

    await MoviziesDatabase.instance.create(movizy);
  }
}
