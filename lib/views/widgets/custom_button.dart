
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String? btnname;
  final Color? color;
  final TextStyle? textstyle;
  final VoidCallback? callback;

  const RoundedButton(
      {super.key, this.btnname, this.color, this.textstyle, this.callback});
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.05,
      width: width * 0.85,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.black,
      ),
      child: ElevatedButton(
        onPressed: () {
          callback!();
        },
        child: Text(
          btnname!,
          style: TextStyle(
            fontSize: width*0.04,
            fontWeight: FontWeight.bold,
            color: Colors.orange.shade200,
          ),
        ),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
      ),
    );



  }
}

