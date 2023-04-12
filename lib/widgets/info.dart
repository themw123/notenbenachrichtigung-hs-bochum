// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class Info extends StatefulWidget {
  final String columnPruefer;
  final String columnDatum;
  final String columnRaum;
  final String columnUhrzeit;
  final double? width;
  const Info({
    Key? key,
    required this.columnPruefer,
    required this.columnDatum,
    required this.columnRaum,
    required this.columnUhrzeit,
    required this.width,
  }) : super(key: key);

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[200]?.withOpacity(0.6),
      ),
      padding: const EdgeInsets.all(5.0),
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 2),
          Text(
            'Prüfer: ${widget.columnPruefer}',
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Datum: ${widget.columnDatum}',
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Raum: ${widget.columnRaum}',
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Uhrzeit: ${widget.columnUhrzeit}',
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
