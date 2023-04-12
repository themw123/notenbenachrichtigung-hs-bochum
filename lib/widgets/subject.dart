// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'check.dart';
import 'info.dart';

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
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.columnSubject,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      widget.columnOld == 1
                          ? Row(
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Info(
                                    columnPruefer: widget.columnPruefer,
                                    columnDatum: widget.columnDatum,
                                    columnRaum: widget.columnRaum,
                                    columnUhrzeit: widget.columnUhrzeit,
                                    width: double.infinity,
                                  ),
                                ),
                                const SizedBox(
                                    width:
                                        5), // horizontaler Abstand von 16 Pixeln
                                Expanded(
                                    flex: 4,
                                    child: Check(onDelete: widget.onDelete)),
                              ],
                            )
                          : Info(
                              columnPruefer: widget.columnPruefer,
                              columnDatum: widget.columnDatum,
                              columnRaum: widget.columnRaum,
                              columnUhrzeit: widget.columnUhrzeit,
                              width: double.infinity),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
