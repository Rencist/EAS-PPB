import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../db/movizy_database.dart';
import '../model/movizy.dart';
import '../page/edit_movizy.dart';
import '../page/movizy_detail.dart';
import '../widget/movizy_card.dart';

class MoviziesPage extends StatefulWidget {
  const MoviziesPage({super.key});

  @override
  State<MoviziesPage> createState() => _MoviziesPageState();
}

class _MoviziesPageState extends State<MoviziesPage> {
  late List<Movizy> movizies;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshMovizies();
  }

  @override
  void dispose() {
    MoviziesDatabase.instance.close();

    super.dispose();
  }

  Future refreshMovizies() async {
    setState(() => isLoading = true);

    movizies = await MoviziesDatabase.instance.readAllMovizies();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Movizies',
            style: TextStyle(fontSize: 24),
          ),
          actions: const [Icon(Icons.search), SizedBox(width: 12)],
        ),
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : movizies.isEmpty
                  ? const Text(
                      'No Movizies',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    )
                  : buildMovizies(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => const AddEditMovizyPage()),
            );

            refreshMovizies();
          },
        ),
      );
  Widget buildMovizies() => StaggeredGrid.count(
      // itemCount: movizies.length,
      // staggeredTileBuilder: (index) => StaggeredTile.fit(2),
      crossAxisCount: 2,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      children: List.generate(
        movizies.length,
        (index) {
          final movizy = movizies[index];

          return StaggeredGridTile.fit(
            crossAxisCellCount: 1,
            child: GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MovizyDetailPage(movizyId: movizy.id!),
                ));

                refreshMovizies();
              },
              child: MovizyCardWidget(movizy: movizy, index: index),
            ),
          );
        },
      ));

// Widget buildMovizies() => StaggeredGridView.countBuilder(
//       padding: const EdgeInsets.all(8),
//       itemCount: movizies.length,
//       staggeredTileBuilder: (index) => StaggeredTile.fit(2),
//       crossAxisCount: 4,
//       mainAxisSpacing: 4,
//       crossAxisSpacing: 4,
//       itemBuilder: (context, index) {
//         final movizy = movizies[index];

//         return GestureDetector(
//           onTap: () async {
//             await Navigator.of(context).push(MaterialPageRoute(
//               builder: (context) => MovizyDetailPage(movizyId: movizy.id!),
//             ));

//             refreshMovizies();
//           },
//           child: MovizyCardWidget(movizy: movizy, index: index),
//         );
//       },
//     );
}
