import 'package:flutter/material.dart';

class SubjectWidget extends StatelessWidget {
  final int columnNr;
  final String columnSubject;
  final String columnPruefer;
  final String columnDatum;
  final String columnRaum;
  final String columnUhrzeit;

  const SubjectWidget({
    Key? key,
    required this.columnNr,
    required this.columnSubject,
    required this.columnPruefer,
    required this.columnDatum,
    required this.columnRaum,
    required this.columnUhrzeit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nr. $columnNr',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              columnSubject,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Prüfer: $columnPruefer',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Datum: $columnDatum',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Raum: $columnRaum',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Uhrzeit: $columnUhrzeit',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}