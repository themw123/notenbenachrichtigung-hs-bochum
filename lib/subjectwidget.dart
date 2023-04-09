import 'package:flutter/material.dart';

class SubjectWidget extends StatefulWidget {
  final String columnSubject;
  final String columnPruefer;
  final String columnDatum;
  final String columnRaum;
  final String columnUhrzeit;
  final bool columnOld;

  const SubjectWidget({
    Key? key,
    required this.columnSubject,
    required this.columnPruefer,
    required this.columnDatum,
    required this.columnRaum,
    required this.columnUhrzeit,
    required this.columnOld,
  }) : super(key: key);

  @override
  _SubjectWidgetState createState() => _SubjectWidgetState();
}

class _SubjectWidgetState extends State<SubjectWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        widget.columnSubject,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Prüfer: ${widget.columnPruefer}',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Datum: ${widget.columnDatum}',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Raum: ${widget.columnRaum}',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Uhrzeit: ${widget.columnUhrzeit}',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'old: ${widget.columnOld}',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  height: 55,
                  child: Center(
                    child: Ink.image(
                      image: AssetImage('assets/remove.png'),
                      fit: BoxFit.cover,
                      width: 55,
                      height: 55,
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(26.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}