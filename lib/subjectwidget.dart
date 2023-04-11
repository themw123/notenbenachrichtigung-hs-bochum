import 'package:flutter/material.dart';

class SubjectWidget extends StatefulWidget {
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

  const SubjectWidget(
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
  _SubjectWidgetState createState() => _SubjectWidgetState();
}

class _SubjectWidgetState extends State<SubjectWidget> {
  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      key: ValueKey(widget.columnId),
      position: Tween<Offset>(
        begin: const Offset(-10, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: widget.animation, curve: Curves.ease)),
      child: GestureDetector(
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
                      ],
                    ),
                  ),
                ),
                if (widget.columnOld == 1)
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Column(
                        children: <Widget>[
                          const Text(
                            'Note verfügbar',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const Text("gesehen"),
                          const SizedBox(height: 8),
                          Center(
                            child: Ink.image(
                              image: AssetImage('assets/check.png'),
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
  }
}
