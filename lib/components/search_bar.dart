import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  //static const Map<String, String> DropDownMenuItems = {
  //  "제목": "title", "태그": "tag", "내용": "description"
  //};

  final FocusNode focusNode;
  final TextEditingController controller;
  Map<String, String> dropDownMenuItems;
  EdgeInsets margin;
  EdgeInsets padding;
  Color dropdownColor;
  Color focusedColor;
  Color unfocusedColor;
  void Function()? onTap;
  void Function(String value)? onChanged;
  void Function(String value)? onDropdownChanged;

  SearchBar({
    Key? key, 
    required this.focusNode,
    required this.controller,
    required this.dropDownMenuItems,
    required this.dropdownColor,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.focusedColor = Colors.black,
    this.unfocusedColor = Colors.grey,
    this.onTap,
    this.onChanged,
    this.onDropdownChanged}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool _searchBarFocused = false;
  late String _currKey;

  @override
  void initState() {
    widget.focusNode.addListener(() {
      setState(() {
        _searchBarFocused = widget.focusNode.hasFocus;
      });
    });    

    _currKey = widget.dropDownMenuItems.keys.first;
    if (widget.onDropdownChanged != null) {
      widget.onDropdownChanged!(widget.dropDownMenuItems.values.first);
    }
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
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: widget.unfocusedColor)
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: widget.focusedColor)
          ),
          prefixIcon: DropdownButton(
            value: _currKey,            
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
                _currKey = newValue!;
              });
              if (widget.onDropdownChanged != null) {
                String vvv = widget.dropDownMenuItems[_currKey]!;
                widget.onDropdownChanged!(widget.dropDownMenuItems[_currKey]!);
              }
            },
            items: widget.dropDownMenuItems.keys.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(                
                value: value,
                child: Text(value)
              );
              }
            ).toList(),
          ),
          suffixIcon: GestureDetector(
            onTap: widget.onTap,
            child: Icon(
              Icons.search,
              color: _searchBarFocused ? widget.focusedColor : widget.unfocusedColor
            )
          )
        ),            
      )
    );
  }
}