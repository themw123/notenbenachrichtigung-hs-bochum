// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class Check extends StatefulWidget {
  final VoidCallback onDelete;

  const Check({Key? key, required this.onDelete}) : super(key: key);

  @override
  _CheckState createState() => _CheckState();
}

class _CheckState extends State<Check> {
  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Column(
        children: <Widget>[
          const Text(
            'Note verfügbar',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.green,
            ),
          ),
          const Text(
            "gesehen",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Ink.image(
              image: const AssetImage('assets/check.png'),
              fit: BoxFit.cover,
              width: 40,
              height: 40,
              child: InkWell(
                onTap: () {
                  widget.onDelete();
                },
                borderRadius: BorderRadius.circular(26.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
