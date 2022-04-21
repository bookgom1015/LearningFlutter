import 'package:flutter/material.dart';
import 'package:flutter_application_learning/globals.dart' as globals;

class SearchBar extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final List<String> dropDownMenuItemList;
  const SearchBar({
    Key? key, 
    required this.focusNode,
    required this.controller,
    required this.dropDownMenuItemList}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late FocusNode dropDownFocusNode;

  bool searchBarFocused = false;
  bool dropDownFocused = false;
  late String dropDownValue;

  @override
  void initState() {
    dropDownFocusNode = FocusNode();
    dropDownFocusNode.addListener(() {
      setState(() {
        dropDownFocused = dropDownFocusNode.hasFocus;
      });
    });

    widget.focusNode.addListener(() {
      setState(() {
        searchBarFocused = widget.focusNode.hasFocus;
      });
    });    

    dropDownValue = widget.dropDownMenuItemList[0];
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
          prefixIcon: DropdownButton(
            focusNode: dropDownFocusNode,
            value: dropDownValue,            
            style: TextStyle(
              color: (dropDownFocused || searchBarFocused) ? globals.FocusedForeground : globals.UnfocusedForeground,
            ),
            icon: Icon(
              Icons.arrow_drop_down,
              color: (dropDownFocused || searchBarFocused) ? globals.FocusedForeground : globals.UnfocusedForeground,
            ),
            underline: const SizedBox(
              width: 0,
              height: 0
            ),
            dropdownColor: globals.IdentityColor,
            onChanged: (String? newValue) {
              setState(() {
                dropDownValue = newValue!;
              });
            },
            items: widget.dropDownMenuItemList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(                
                value: value,
                child: Text(value)
              );
              }
            ).toList(),
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