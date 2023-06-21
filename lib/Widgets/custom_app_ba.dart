import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget {
  final String titre;
  const CustomAppBar({
    Key? key,
    required this.titre,
  }) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // color: Colors.orange,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 12,
      child: Center(
        child: Text(
          widget.titre,
          style: TextStyle(fontSize: 30, color: Colors.blue[800]),
        ),
      ),
    );
  }
}
