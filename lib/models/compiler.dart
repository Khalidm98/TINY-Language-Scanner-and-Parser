class Token {
  final String value;
  final String type;

  Token(this.value, this.type);

  @override
  String toString() => '$value , $type';
}

class Compiler {
  static const Set<String> statements = {
    'if',
    'then',
    'end',
    'repeat',
    'until',
    'read',
    'write',
    'else'
  };
  static const Set<String> operators = {
    ':=',
    '+',
    '-',
    '*',
    '/',
    '%',
    '!=',
    '=',
    '<',
    '>',
    '(',
    ')',
    ';'
  };

  List<List<Token>> lines = List();
  List<String> tokens = List();
  String code = '';

  String _getOperatorType(String op) {
    switch (op) {
      case ':=':
        return 'ASSIGN';
      case '+':
        return 'PLUS';
      case '-':
        return 'MINUS';
      case '*':
        return 'MULT';
      case '/':
        return 'DIV';
      case '%':
        return 'MOD';
      case '!=':
        return 'NOTEQUAL';
      case '=':
        return 'EQUAL';
      case '<':
        return 'LESSTHAN';
      case '>':
        return 'GREATERTHAN';
      case '(':
        return 'OPENBRACKET';
      case ')':
        return 'CLOSEDBRACKET';
      case ';':
        return 'SEMICOLON';
      default:
        return 'NOT_DEFINED';
    }
  }

  void _reformatCode() {
    String edited = code;

    // remove all comments
    while (edited.contains('{')) {
      edited = edited.replaceRange(
        edited.indexOf('{'),
        edited.indexOf('}') + 1,
        ' ',
      );
    }

    // remove replace all new lines, carriage returns and tabs with whitespaces
    edited = edited.replaceAll('\n', ' ');
    edited = edited.replaceAll('\r', ' ');
    edited = edited.replaceAll('\t', ' ');

    // surround all operators with whitespaces on both sides
    operators.forEach((op) => edited = edited.replaceAll(op, ' $op '));
    edited = edited.replaceAll(': ', ':').replaceAll('! ', '!');
    tokens = edited.split(' ')..removeWhere((str) => str.isEmpty);
  }

  void scan() {
    int line = 0;
    String type;

    _reformatCode();
    lines.clear();

    tokens.forEach((value) {
      if (value == 'end' || value == 'until') {
        line++;
      }

      if (statements.contains(value)) {
        type = value.toUpperCase();
      } else if (operators.contains(value)) {
        type = _getOperatorType(value);
      } else if (int.tryParse(value[0]) != null) {
        type = 'NUMBER';
      } else {
        type = 'IDENTIFIER';
      }

      if (line == lines.length)
        lines.add([Token(value, type)]);
      else
        lines[line].add(Token(value, type));

      if (value == ';' || value == 'then' || value == 'repeat') {
        line++;
      }
    });
  }

  bool parse() {
    scan();
    // reformat to match parse constraints
    tokens.add(';');
    for (int i = 0; i < tokens.length; i++) {
      if (tokens[i] == 'end' || tokens[i] == 'until') {
        if (tokens[i - 1] == ';') return false;
        tokens.insert(i, ';');
        i++;
      }
    }
    for (int i = 0; i < tokens.length; i++) {
      if (tokens[i] == 'end' && tokens[i + 1] == ';') {
        tokens.removeAt(i + 1);
      }
    }
    return true;
  }
}
