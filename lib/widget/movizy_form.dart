import 'dart:ui';

import 'package:flutter/material.dart';

class MovizyFormWidget extends StatelessWidget {
  final String? title;
  final String? picture;
  final String? description;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedPicture;
  final ValueChanged<String> onChangedDescription;

  const MovizyFormWidget({
    Key? key,
    this.title = '',
    this.picture = '',
    this.description = '',
    required this.onChangedTitle,
    required this.onChangedPicture,
    required this.onChangedDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitle(),
              const SizedBox(height: 4),
              buildPicture(),
              const SizedBox(height: 8),
              buildDescription(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );

  Widget buildTitle() => TextFormField(
        maxLines: 1,
        initialValue: title,
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Title',
          hintStyle: TextStyle(color: Colors.white70),
        ),
        validator: (title) =>
            title != null && title.isEmpty ? 'The title cannot be empty' : null,
        onChanged: onChangedTitle,
      );

  Widget buildPicture() => TextFormField(
        maxLines: 1,
        initialValue: picture,
        style: const TextStyle(color: Colors.white60, fontSize: 18),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Picture',
          hintStyle: TextStyle(color: Colors.white60),
        ),
        validator: (picture) => picture != null && picture.isEmpty
            ? 'The picture cannot be empty'
            : null,
        onChanged: onChangedPicture,
      );

  Widget buildDescription() => TextFormField(
        maxLines: 5,
        initialValue: description,
        style: const TextStyle(color: Colors.white60, fontSize: 18),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Description',
          hintStyle: TextStyle(color: Colors.white60),
        ),
        validator: (description) => description != null && description.isEmpty
            ? 'The description cannot be empty'
            : null,
        onChanged: onChangedDescription,
      );
}
