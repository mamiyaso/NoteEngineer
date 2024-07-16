import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:note_engineer/note_encryption.dart';
import 'package:note_engineer/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class NoteEditScreen extends StatefulWidget {
  final Function onSave;
  final String? noteId;
  final String? initialTitle;
  final String? initialContent;
  final String? initialUpdatedAt;

  const NoteEditScreen(
      {super.key,
        required this.onSave,
        this.noteId,
        this.initialTitle,
        this.initialContent,
        this.initialUpdatedAt});

  @override
  NoteEditScreenState createState() => NoteEditScreenState();
}

class NoteEditScreenState extends State<NoteEditScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _mathController = TextEditingController();

  final _contentFocusNode = FocusNode();
  final _mathFocusNode = FocusNode();

  final _supabaseClient = Supabase.instance.client;
  DateTime? _selectedDate;
  bool _showMathField = false;
  String? _selectedDirectory;

  @override
  void initState() {
    super.initState();
    _loadSelectedDirectory();

    if (widget.initialTitle != null) {
      _titleController.text = widget.initialTitle!;
    }
    if (widget.initialContent != null) {
      _contentController.text = widget.initialContent!;
    }
    if (widget.initialUpdatedAt != null) {
      _selectedDate = DateTime.parse(widget.initialUpdatedAt!);
    }
  }

  Future<void> _loadSelectedDirectory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedDirectory = prefs.getString('selected_directory');
    });
  }

  Future<void> _saveNote() async {
    final userId = _supabaseClient.auth.currentUser!.id;
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      widget.onSave();
      if (mounted) {
        Navigator.pop(context);
      }
      return;
    }
    final encryptedTitle = title.isNotEmpty
        ? await EncryptionService.encryptData(title)
        : await null;
    final encryptedContent = content.isNotEmpty
        ? await EncryptionService.encryptData(content)
        : await null;

    bool isUpdated = (widget.initialTitle != null &&
        _titleController.text != widget.initialTitle!) ||
        (widget.initialContent != null &&
            _contentController.text != widget.initialContent!);

    if (widget.noteId == null) {
      await _supabaseClient.from('notes').insert({
        'user_id': userId,
        'title': encryptedTitle,
        'content': encryptedContent,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'is_favorite': false,
        'is_trashed': false,
      });
    } else if (isUpdated) {
      await _supabaseClient.from('notes').update({
        'title': encryptedTitle,
        'content': encryptedContent,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', widget.noteId as Object);
    }

    widget.onSave();
    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _deleteNote() async {
    if (widget.noteId != null) {
      await _supabaseClient.from('notes').update({
        'is_trashed': true,
      }).eq('id', widget.noteId as Object);
      widget.onSave();
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  void _toggleMathField() {
    setState(() {
      _showMathField = !_showMathField;
    });
  }

  void _calculateMathExpression() {
    String expression = _mathController.text;
    expression = _convertSymbolsToFunctions(expression);

    final comparisonOperators = ['==', '!=', '<=', '>=', '<', '>'];
    String? comparisonOperator;

    for (var operator in comparisonOperators) {
      if (expression.contains(operator)) {
        comparisonOperator = operator;
        break;
      }
    }

    if (comparisonOperator != null) {
      final parts = expression.split(comparisonOperator);
      if (parts.length == 2) {
        try {
          Parser p = Parser();
          Expression exp1 = p.parse(parts[0]);
          Expression exp2 = p.parse(parts[1]);
          ContextModel cm = ContextModel();

          double result1 = exp1.evaluate(EvaluationType.REAL, cm);
          double result2 = exp2.evaluate(EvaluationType.REAL, cm);

          bool isValid;

          switch (comparisonOperator) {
            case '==':
              isValid = result1 == result2;
              break;
            case '!=':
              isValid = result1 != result2;
              break;
            case '<=':
              isValid = result1 <= result2;
              break;
            case '>=':
              isValid = result1 >= result2;
              break;
            case '<':
              isValid = result1 < result2;
              break;
            case '>':
              isValid = result1 > result2;
              break;
            default:
              isValid = false;
          }

          String message = isValid ? 'True' : 'False';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Expression: $message')),
          );

          setState(() {
            _contentController.text += '\n$expression = $message';
            _mathController.clear();
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                Text('noteEditScreen.invalidMathExpression'.tr())
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
              Text('noteEditScreen.invalidMathExpression'.tr())
          ),
        );
      }
    } else {
      try {
        Parser p = Parser();
        Expression exp = p.parse(expression);
        ContextModel cm = ContextModel();
        double result = exp.evaluate(EvaluationType.REAL, cm);
        String formattedResult = result.toStringAsFixed(3);
        setState(() {
          _contentController.text += '\n$expression = $formattedResult';
          _mathController.clear();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
              Text('noteEditScreen.invalidMathExpression'.tr())
          ),
        );
      }
    }
  }

  String _convertSymbolsToFunctions(String expression) {
    return expression
        .replaceAll('≤', '<=')
        .replaceAll('≥', '>=')
        .replaceAll('√', 'sqrt')
        .replaceAll('π', '3.14159')
        .replaceAll('≈', '==')
        .replaceAll('≠', '!=')
        .replaceAll('±', '+-');
  }

  Future<void> _saveToTextFile() async {
    final String content =
        '${_titleController.text}\n${_contentController.text}';
    final String fileName = _titleController.text
        .replaceAll(RegExp(r'[^\w\s]+'), '')
        .trim();

    String? selectedDirectory;
    final prefs = await SharedPreferences.getInstance();

    try {
      if (_selectedDirectory != null) {
        selectedDirectory = _selectedDirectory!;
      } else {
        selectedDirectory = prefs.getString('selected_directory') ??
            await FilePicker.platform.getDirectoryPath();
      }

      if (selectedDirectory == null) {
        throw Exception('No directory selected');
      }

      final String filePath = '$selectedDirectory/$fileName.txt';
      final File file = File(filePath);
      await file.writeAsString(content);

      _showSnackBar(
          'noteEditScreen.noteSaved'.tr(args: [fileName]));
    } catch (e) {
      _showSnackBar(
          'noteEditScreen.errorSavingFile'.tr(args: [e.toString()]));
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    _selectedDate = DateTime.now();
    String formattedDate = _selectedDate != null
        ? DateFormat('HH:mm dd.MM.yyyy').format(_selectedDate!)
        : 'noteEditScreen.noDate'.tr();
    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(
        backgroundColor: themeProvider.accentColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: themeProvider.textColor),
          onPressed: _saveNote,
        ),
        actions: [
          PopupMenuButton<String>(
            color: themeProvider.backgroundColor,
            onSelected: (value) {
              if (value == 'delete') {
                _deleteNote();
              } else if (value == 'save') {
                _saveNote();
              } else if (value == 'calculate') {
                _toggleMathField();
              } else if (value == 'save-txt') {
                _saveToTextFile();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'delete',
                child: Text('noteEditScreen.delete'.tr(),
                    style: TextStyle(color: themeProvider.textColor)
                ),
              ),
              PopupMenuItem(
                value: 'save',
                child: Text('noteEditScreen.save'.tr(),
                    style: TextStyle(color: themeProvider.textColor)
                ),
              ),
              PopupMenuItem(
                value: 'calculate',
                child: Text('noteEditScreen.calculate'.tr(),
                    style: TextStyle(color: themeProvider.textColor)
                ),
              ),
              PopupMenuItem(
                value: 'save-txt',
                child: Text('noteEditScreen.saveAsTxt'.tr(),
                    style: TextStyle(color: themeProvider.textColor)
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: themeProvider.backgroundColor,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'noteEditScreen.enterTitle'.tr(),
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.textColor,
                    ),
                  ),
                ),
                Text(
                  formattedDate,
                  style: TextStyle(color: themeProvider.textColor),
                ),
              ],
            ),
          ),
          if (_showMathField)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: _mathFocusNode,
                      controller: _mathController,
                      decoration: InputDecoration(
                        hintText:
                        'noteEditScreen.enterMathExpression'.tr(),
                        border: InputBorder.none,
                        isCollapsed: true,
                        contentPadding: const EdgeInsets.all(16.0),
                        hintStyle: TextStyle(color: themeProvider.textColor),
                      ),
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(
                          fontSize: 16.0, color: themeProvider.textColor
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.calculate,
                        color: themeProvider.accentColor
                    )
                    ,
                    onPressed: _calculateMathExpression,
                  ),
                ],
              ),
            ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                _contentFocusNode.requestFocus();
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: themeProvider.textColor),
                  color: themeProvider.backgroundColor,
                ),
                child: TextField(
                  focusNode: _contentFocusNode,
                  controller: _contentController,
                  decoration: InputDecoration(
                    hintText: 'noteEditScreen.enterNotes'.tr(),
                    border: InputBorder.none,
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.all(16.0),
                    hintStyle: TextStyle(color: themeProvider.textColor),
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(
                      fontSize: 16.0, color: themeProvider.textColor
                  ),
                  textAlignVertical: TextAlignVertical.top,
                  expands: true,
                  buildCounter: (context,
                      {required currentLength,
                        required isFocused,
                        maxLength}) =>
                  null,
                ),
              ),
            ),
          ),
          Container(
            color: themeProvider.backgroundColor,
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildMathButton('+', themeProvider),
                _buildMathButton('-', themeProvider),
                _buildMathButton('*', themeProvider),
                _buildMathButton('/', themeProvider),
                _buildMathButton('%', themeProvider),
                _buildMathButton('<', themeProvider),
                _buildMathButton('>', themeProvider),
                _buildMathButton('≈', themeProvider),
                _buildMathButton('≠', themeProvider),
                _buildMathButton('≤', themeProvider),
                _buildMathButton('≥', themeProvider),
                _buildMathButton('±', themeProvider),
                _buildMathButton('(', themeProvider),
                _buildMathButton(')', themeProvider),
                _buildMathButton('^', themeProvider),
                _buildMathButton('√', themeProvider),
                _buildMathButton('π', themeProvider),
                _buildMathButton('abs', themeProvider),
                _buildMathButton('log', themeProvider),
                _buildMathButton('ln', themeProvider),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMathButton(String symbol, ThemeProvider themeProvider) {
    return InkWell(
      onTap: () {
        _insertAtCursor(symbol);
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        width: 48,
        height: 48,
        child: Text(
          symbol,
          style: TextStyle(fontSize: 20, color: themeProvider.textColor),
        ),
      ),
    );
  }

  void _insertAtCursor(String text) {
    final TextEditingController controller = _contentFocusNode.hasFocus
        ? _contentController
        : _mathController;
    final textValue = controller.text;
    final cursorPosition = controller.selection.baseOffset;
    final newText =
    textValue.replaceRange(cursorPosition, cursorPosition, text);
    controller.text = newText;
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: cursorPosition + text.length)
    );
  }
}