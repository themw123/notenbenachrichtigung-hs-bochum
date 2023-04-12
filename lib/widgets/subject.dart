// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class Subject extends StatefulWidget {
  final Map<String, dynamic> item;
  final Animation<double> animation;
  final int columnId;
  final String columnSubject;
  final String columnPruefer;
  final String columnDatum;
  final String columnRaum;
  final String columnUhrzeit;
  final int columnOld;
  final VoidCallback onDelete;

  const Subject(
      {Key? key,
      required this.item,
      required this.animation,
      required this.columnId,
      required this.columnSubject,
      required this.columnPruefer,
      required this.columnDatum,
      required this.columnRaum,
      required this.columnUhrzeit,
      required this.columnOld,
      required this.onDelete})
      : super(key: key);

  @override
  _SubjectState createState() => _SubjectState();
}

class _SubjectState extends State<Subject> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-2, 0),
            end: Offset.zero,
          ).animate(
              CurvedAnimation(parent: widget.animation, curve: Curves.ease)),
          child: SizeTransition(
            sizeFactor: widget.animation,
            child: GestureDetector(
              child: Card(
                elevation: 2,
                margin: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.grey[200],
                              ),
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  Text(
                                    'Prüfer: ${widget.columnPruefer}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Datum: ${widget.columnDatum}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Raum: ${widget.columnRaum}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Uhrzeit: ${widget.columnUhrzeit}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (widget.columnOld == 1)
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15),
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
                              const Text("gesehen"),
                              const SizedBox(height: 4),
                              Center(
                                child: Ink.image(
                                  image: const AssetImage('assets/check.png'),
                                  fit: BoxFit.cover,
                                  width: 45,
                                  height: 45,
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
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
