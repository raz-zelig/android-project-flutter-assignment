import 'package:flutter/material.dart';

class MyGrabbing extends StatelessWidget {
  final String _text;

  MyGrabbing(this._text);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _text,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Icon(Icons.keyboard_arrow_up,),
            ),
          ),
        ],
      ),
    );
  }
}
