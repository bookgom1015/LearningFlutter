import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final List<String> dropDownMenuItemList;
  EdgeInsets margin;
  EdgeInsets padding;
  Color dropdownColor;
  Color focusedColor;
  Color unfocusedColor;

  SearchBar({
    Key? key, 
    required this.focusNode,
    required this.controller,
    required this.dropDownMenuItemList,
    required this.dropdownColor,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.focusedColor = Colors.black,
    this.unfocusedColor = Colors.grey}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool searchBarFocused = false;
  late String dropDownValue;

  @override
  void initState() {
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
      margin: widget.margin,
      padding: widget.padding,
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        style: TextStyle(
          color: widget.focusedColor
        ),
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: widget.unfocusedColor)
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: widget.focusedColor)
          ),
          prefixIcon: DropdownButton(
            value: dropDownValue,            
            style: TextStyle(
              color: widget.focusedColor,
            ),
            icon: Icon(
              Icons.arrow_drop_down,
              color: widget.focusedColor,
            ),
            underline: const SizedBox(
              width: 0,
              height: 0
            ),
            dropdownColor: widget.dropdownColor,
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
            color: searchBarFocused ? widget.focusedColor : widget.unfocusedColor
          )
        ),            
      )
    );
  }
}