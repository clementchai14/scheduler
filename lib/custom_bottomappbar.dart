import 'package:flutter/material.dart';

class CustomBottomAppBarItem{
  IconData icon;
  bool hasNotification;

  CustomBottomAppBarItem({this.icon, this.hasNotification});
}

class CustomBottomAppBar extends StatefulWidget{

  final ValueChanged<int> onTabSelected;
  final List<CustomBottomAppBarItem> items;

  CustomBottomAppBar({this.onTabSelected, this.items});

  @override
  State<StatefulWidget> createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar>{

  int _selectedIndex = 0;

  void _onTabIndexChanged(int index){
    widget.onTabSelected(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, (int index){
      return _buildTabItems(
        index: index,
        item: widget.items[index],
        onPressed: _onTabIndexChanged
      );
    });

    return BottomAppBar(
      color: Colors.white,
      child: Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: items,
        ),
      ),
        shape: CircularNotchedRectangle(),
    );
  }

  Widget _buildTabItems({int index, CustomBottomAppBarItem item, ValueChanged<int> onPressed}){
    return Expanded(
      child: SizedBox(
        height: 60.0,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () =>  onPressed(index),
            child: item.hasNotification
                ? Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Icon(
                  item.icon,
                  color: _selectedIndex == index ? Theme.of(context).primaryColor : Colors.grey,
                  size: 24.0,
                ),
                Positioned(
                  top: 10.0,
                  right: 77.0,
                  child: Icon(
                    Icons.brightness_1,
                    color: Colors.red,
                    size: 10.0,
                  ),
                )
              ],
            )
                : Icon(
              item.icon,
              color: _selectedIndex == index ? Theme.of(context).primaryColor : Colors.grey,
              size: 24.0
            ),
          ),
        )
      )
    );
  }
}
