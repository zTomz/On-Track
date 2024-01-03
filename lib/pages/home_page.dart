import 'package:flutter/material.dart';
import 'package:planer/extensions/theme_extension.dart';
import 'package:planer/pages/widgets/nav_bar.dart';
import 'package:planer/provider/goal_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<int> expandedIndexes = [];

  @override
  Widget build(BuildContext context) {
    final goalProvider = context.watch<GoalProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planer'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          tooltip: "Vorheriger Tag",
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            tooltip: "Nächster Tag",
            icon: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ],
      ),
      bottomNavigationBar: const NavBar(currentPage: 1),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 25,
              itemBuilder: (context, index) {
                final isTileExpanded = expandedIndexes.contains(index);

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: index == 0
                          ? const Radius.circular(20)
                          : const Radius.circular(12),
                      bottom: index == 24
                          ? const Radius.circular(20)
                          : const Radius.circular(12),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Item $index",
                                    style: context.textTheme.bodyLarge,
                                  ),
                                  Text(
                                    "Description of the item\nDescription of the item Description of the itemDescription of the item\nDescription of the item\n",
                                    style: context.textTheme.bodySmall,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (isTileExpanded) {
                                    expandedIndexes.remove(index);
                                  } else {
                                    expandedIndexes.add(index);
                                  }
                                });
                              },
                              icon: AnimatedRotation(
                                duration: const Duration(milliseconds: 200),
                                turns: isTileExpanded ? 0.5 : 1,
                                child: const Icon(
                                  Icons.expand_circle_down_rounded,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (isTileExpanded) ...[
                          const SizedBox(height: 15),
                          const TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Wert",
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
