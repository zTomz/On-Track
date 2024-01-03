import 'package:flutter/material.dart';
import 'package:planer/pages/widgets/nav_bar.dart';

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: NavBar(currentPage: 0),
    );
  }
}
