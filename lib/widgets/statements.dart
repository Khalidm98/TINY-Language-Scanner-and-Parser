import 'package:flutter/material.dart';
import '../models/painters.dart';
import './blocks.dart';

class Operator extends StatelessWidget {
  final String op;
  final String left;
  final String right;

  Operator(this.op, this.left, this.right);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: CustomPaint(
        painter: OpLines(),
        child: Column(
          children: [
            Circle(op),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Circle(left), Circle(right)],
            ),
          ],
        ),
      ),
    );
  }
}

class AssignConst extends StatelessWidget {
  final String identifier;
  final String value;
  final int offset;

  AssignConst(this.identifier, this.value, this.offset);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WritePainter(offset),
      child: Column(
        children: [Rectangle('assign', identifier), Circle(value)],
      ),
    );
  }
}

class AssignOp extends StatelessWidget {
  final String identifier;
  final Operator value;
  final int offset;

  AssignOp(this.identifier, this.value, this.offset);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: AssignPainter(offset),
      child: Column(
        children: [Rectangle('assign', identifier), value],
      ),
    );
  }
}

class Read extends StatelessWidget {
  final String identifier;
  final int offset;

  Read(this.identifier, this.offset);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ReadPainter(offset),
      child: Rectangle('read', identifier),
    );
  }
}

class Write extends StatelessWidget {
  final String identifier;
  final int offset;

  Write(this.identifier, this.offset);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WritePainter(offset),
      child: Column(
        children: [Rectangle('write'), Circle(identifier)],
      ),
    );
  }
}

class MultiChildren extends StatelessWidget {
  final String type;
  final Operator condition;
  final List<Widget> body;
  final int offset;

  MultiChildren(this.type, this.condition, this.body, this.offset);

  @override
  Widget build(BuildContext context) {
    bool isNarrow;
    if (body[0] is MultiChildren || body[0] is AssignOp)
      isNarrow = false;
    else
      isNarrow = true;
    return CustomPaint(
      painter: MultiPainter(offset, isNarrow),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: isNarrow ? 200 : 300),
            child: Rectangle(type),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              condition,
              SizedBox(width: isNarrow ? 0 : 100),
              ...body,
            ],
          )
        ],
      ),
    );
  }
}
