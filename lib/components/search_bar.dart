import 'package:flutter/material.dart';
import 'package:flutter_application_learning/globals.dart' as globals;

class SearchBar extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  const SearchBar({Key? key, required this.focusNode, required this.controller}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool searchBarFocused = false;

  @override
  void initState() {
    widget.focusNode.addListener(() {
      setState(() {
        searchBarFocused = widget.focusNode.hasFocus;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        style: const TextStyle(
          color: globals.FocusedForeground
        ),
        decoration: InputDecoration(
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: globals.UnfocusedForeground)
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: globals.FocusedForeground)
          ),
          suffixIcon: Icon(
            Icons.search,
            color: searchBarFocused ?globals.FocusedForeground : globals.UnfocusedForeground
          )
        ),            
      )
    );
  }
}