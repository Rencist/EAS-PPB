import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/movizy_database.dart';
import '../model/movizy.dart';
import 'edit_movizy.dart';

class MovizyDetailPage extends StatefulWidget {
  final int movizyId;

  const MovizyDetailPage({
    Key? key,
    required this.movizyId,
  }) : super(key: key);

  @override
  State<MovizyDetailPage> createState() => _MovizyDetailPageState();
}

class _MovizyDetailPageState extends State<MovizyDetailPage> {
  late Movizy movizy;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshMovizy();
  }

  Future refreshMovizy() async {
    setState(() => isLoading = true);
    movizy = await MoviziesDatabase.instance.readMovizy(widget.movizyId);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [editButton(), deleteButton()],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(12),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Image.network(movizy.picture),
                    const SizedBox(height: 8),
                    Text(
                      movizy.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat.yMMMd().format(movizy.createdTime),
                      style: const TextStyle(color: Colors.white38),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movizy.description,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 18),
                    )
                  ],
                ),
              ),
      );

  Widget editButton() => IconButton(
      icon: const Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditMovizyPage(movizy: movizy),
        ));
        refreshMovizy();
      });

  Widget deleteButton() => IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          await MoviziesDatabase.instance.delete(widget.movizyId);
          Navigator.of(context).pop();
        },
      );
}
