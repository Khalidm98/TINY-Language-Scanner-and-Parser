import 'package:flutter/material.dart';
import '../models/compiler.dart';

class Rectangle extends StatelessWidget {
  final String statement;
  final String identifier;

  Rectangle(this.statement, [this.identifier]);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(width: 2),
        color: Colors.white,
      ),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: identifier == null
          ? Text(statement)
          : Column(
              children: [
                Expanded(child: Center(child: Text(statement))),
                Expanded(
                  child: Center(child: FittedBox(child: Text('($identifier)'))),
                ),
              ],
            ),
    );
  }
}

class Circle extends StatelessWidget {
  final String value;

  Circle(this.value);

  @override
  Widget build(BuildContext context) {
    String label;
    if (int.tryParse(value) != null)
      label = 'const';
    else if (Compiler.operators.contains(value))
      label = 'op';
    else
      label = 'id';

    return Padding(
      padding: const EdgeInsets.all(20),
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.black,
        child: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        '($value)',
                        style: const TextStyle(color: Colors.black),
                      ),
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
