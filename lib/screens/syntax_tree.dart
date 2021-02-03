import 'package:flutter/material.dart';
import '../widgets/statements.dart';

class SyntaxTree extends StatelessWidget {
  final List<String> tokens;

  SyntaxTree(this.tokens);

  int _horizontalOffset(List<String> next) {
    if (next.isEmpty) return -1;
    if (next[0] == 'read' || next[0] == 'write') {
      return 0;
    } else if (next.length > 1 && next[1] == ':=') {
      if (next[3] == ';') {
        return 1;
      } else {
        return 2;
      }
    } else if (next[0] == 'if') {
      if (next[5] == 'read' ||
          next[5] == 'write' ||
          (next[6] == ':=' && next[8] == ';')) {
        return 2;
      } else {
        return 3;
      }
    } else if (next[0] == 'repeat') {
      if (next[1] == 'read' ||
          next[1] == 'write' ||
          (next[2] == ':=' && next[4] == ';')) {
        return 2;
      } else {
        return 3;
      }
    }
    return -1;
  }

  int _innerOffset(String statement, List<String> children) {
    int index = 0;
    int offset = 0;
    String base = statement == 'if' ? 'end' : 'until';
    while (children[index] != base) {
      if (children[index] == 'read' || children[index] == 'write') {
        offset += 1;
        index += 3;
      } else if (children[index + 1] == ':=') {
        if (children[index + 3] == ';') {
          offset += 1;
          index += 4;
        } else {
          offset += 3;
          index += 6;
        }
      } else if (children[index] == 'if') {
        final endIndex = trimIf(children.sublist(index + 5));
        offset += _horizontalOffset(children.sublist(index)) + 1;
        offset += _innerOffset(
          'if',
          children.sublist(index + 5, endIndex + index + 6),
        );
        index += endIndex + 6;
      }
      else if (children[index] == 'repeat') {
        final endIndex = trimRepeat(children.sublist(index + 1));
        offset += _horizontalOffset(children.sublist(index)) + 1;
        offset += _innerOffset(
          'repeat',
          children.sublist(index + 1, index + endIndex + 2),
        );
        index += endIndex + 6;
      }
    }
    return offset;
  }

  int trimIf(List<String> children) {
    int count = 0;
    for (int i = 0; i < children.length; i++) {
      if (children[i] == 'if') {
        count++;
      } else if (children[i] == 'end' && count == 0) {
        return i;
      } else if (children[i] == 'end') {
        count--;
      }
    }
    // the func wil never reach this statement
    return 0;
  }

  int trimRepeat(List<String> children) {
    int count = 0;
    for (int i = 0; i < children.length; i++) {
      if (children[i] == 'repeat') {
        count++;
      } else if (children[i] == 'until' && count == 0) {
        return i;
      } else if (children[i] == 'until') {
        count--;
      }
    }
    // the func wil never reach this statement
    return 0;
  }

  List<Widget> _buildTree(List<String> children) {
    List<Widget> tree = List();
    int index = 0;
    int offset;
    while (index < children.length) {
      if (children[index] == 'read') {
        offset = _horizontalOffset(children.sublist(index + 3));
        tree.add(Read(children[index + 1], offset));
        index += 3;
      } else if (children[index] == 'write') {
        offset = _horizontalOffset(children.sublist(index + 3));
        tree.add(Write(children[index + 1], offset));
        index += 3;
      } else if (children[index] == ':=') {
        if (children[index + 2] == ';') {
          offset = _horizontalOffset(children.sublist(index + 3));
          tree.add(AssignConst(
            children[index - 1],
            children[index + 1],
            offset,
          ));
          index += 3;
        } else {
          offset = _horizontalOffset(children.sublist(index + 5));
          tree.add(AssignOp(
            children[index - 1],
            Operator(
              children[index + 2],
              children[index + 1],
              children[index + 3],
            ),
            offset,
          ));
          index += 5;
        }
      } else if (children[index] == 'if') {
        final endIndex = trimIf(children.sublist(index + 5));
        if ((index + endIndex + 6) == children.length) {
          offset = -1;
        }
        else {
          offset = _horizontalOffset(children.sublist(index + endIndex + 6));
          offset += _innerOffset(
            'if',
            children.sublist(index + 5, endIndex + index + 6),
          );
        }
        tree.add(MultiChildren(
          'if',
          Operator(
            children[index + 2],
            children[index + 1],
            children[index + 3],
          ),
          _buildTree(children.sublist(index + 5, endIndex + index + 5)),
          offset,
        ));
        index += endIndex + 5;
      } else if (children[index] == 'repeat') {
        final endIndex = trimRepeat(children.sublist(index + 1));
        if ((index + endIndex + 6) == children.length) {
          offset = -1;
        }
        else {
          offset = _horizontalOffset(children.sublist(index + endIndex + 6));
          offset += _innerOffset(
            'repeat',
            children.sublist(index + 1, index + endIndex + 2),
          );
        }
        tree.add(MultiChildren(
          'repeat',
          Operator(
            children[index + endIndex + 3],
            children[index + endIndex + 2],
            children[index + endIndex + 4],
          ),
          _buildTree(children.sublist(index + 1, index + endIndex + 1)),
          offset,
        ));
        index += endIndex + 6;
      } else {
        index++;
      }
    }
    return tree;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Syntax Tree')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildTree(tokens),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
