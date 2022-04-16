import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final Function onPressed;
  final Widget? child;
  final String? text;

  const MainButton({Key? key, required this.onPressed, this.child, this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => onPressed(),
        child: Container(
          width: 200,
          height: 40,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: child ??
              Center(
                  child: Text(
                text!,
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
        ));
  }
}
