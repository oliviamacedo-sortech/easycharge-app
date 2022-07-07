import 'package:easycharge/components/drawer.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('Easycharge', textAlign: TextAlign.left),
        ),
      );
  }
}