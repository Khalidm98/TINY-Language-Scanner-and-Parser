import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './syntax_tree.dart';
import '../models/compiler.dart';

class ScanTokens extends StatefulWidget {
  ScanTokens({Key key}) : super(key: key);

  @override
  _ScanTokensState createState() => _ScanTokensState();
}

class _ScanTokensState extends State<ScanTokens> {
  TextEditingController _controller = TextEditingController();
  Compiler _compiler = Compiler();
  double _height;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_height == null) {
      _height = MediaQuery.of(context).size.height;
    }
  }

  Widget _buildTitledColumn(String label, Widget child) {
    return Container(
      height: _height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 3, color: Colors.indigo),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.indigo,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              label,
              textScaleFactor: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildTokensTable(List<List<Token>> tokens) {
    if (tokens.isEmpty)
      return SizedBox();
    else
      return SizedBox(
        width: double.infinity,
        child: ListView.builder(
          itemCount: tokens.length,
          itemBuilder: (_, index) {
            return Container(
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(color: Colors.indigo, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    alignment: Alignment.center,
                    child: Text('${index + 1}', textScaleFactor: 1.5),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.symmetric(
                          vertical: BorderSide(color: Colors.indigo, width: 2),
                        ),
                      ),
                      child: Column(
                        children: tokens[index].map((token) {
                          return Container(
                            height: 40,
                            alignment: Alignment.center,
                            child: Text(token.value, textScaleFactor: 1.5),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: tokens[index].map((token) {
                        return Container(
                          height: 40,
                          alignment: Alignment.center,
                          child: Text(token.type, textScaleFactor: 1.5),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
  }

  Widget _buildButton({IconData icon, String label, Function onPressed}) {
    return SizedBox(
      width: 200,
      child: RaisedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            label,
            textScaleFactor: 1.75,
            style: TextStyle(color: Colors.white),
          ),
        ),
        color: Colors.indigo,
        padding: EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible =
        MediaQuery.of(context).viewInsets.bottom == 0 ? false : true;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTitledColumn(
                          'TINY Code',
                          TextField(
                            decoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.all(10),
                            ),
                            controller: _controller,
                            keyboardType: TextInputType.multiline,
                            maxLines: isKeyboardVisible ? 15 : 27,
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'Consolas',
                            ),
                            // onChanged: (str) => _controller.text = str,
                          ),
                        ),
                      ),
                      SizedBox(width: 40),
                      Expanded(
                        child: _buildTitledColumn(
                          'Scanned Tokens',
                          _buildTokensTable(_compiler.lines),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildButton(
                      icon: Icons.folder_open,
                      label: 'Open File',
                      onPressed: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        File file = File('./tiny.txt');
                        if (file.existsSync()) {
                          _controller.text = file.readAsStringSync();
                          setState(() {});
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: Text('Error Opening File'),
                                content: Text(
                                  'Cannot find \"tiny.txt\" in path',
                                ),
                                actions: [
                                  FlatButton(
                                    child: Text('Ok'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                    _buildButton(
                      icon: Icons.account_tree,
                      label: 'Parse',
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (_controller.text != null &&
                            _controller.text.isNotEmpty) {
                          _compiler.code = _controller.text;
                          if (_compiler.parse()) {
                            setState(() {});
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) {
                                return SyntaxTree(_compiler.tokens);
                              }),
                            );
                          }
                          else {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Text('Parser Error'),
                                  content: Text('Code syntax is incorrect'),
                                  actions: [
                                    FlatButton(
                                      child: Text('Ok'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              },
                            );
                          }
                        }
                        else {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: Text('Error Parsing'),
                                content: Text('No code to parse'),
                                actions: [
                                  FlatButton(
                                    child: Text('Ok'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                    _buildButton(
                      icon: Icons.search,
                      label: 'Scan',
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (_controller.text != null &&
                            _controller.text.isNotEmpty) {
                          _compiler.code = _controller.text;
                          setState(() => _compiler.scan());
                        }
                        else {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: Text('Error Scanning'),
                                content: Text('No code to scan'),
                                actions: [
                                  FlatButton(
                                    child: Text('Ok'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
