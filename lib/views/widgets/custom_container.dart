// i want a custom widget of container having text in it
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget{
  final String? text;
  final VoidCallback? callback;
  final Color? color;
  final Border? border;
  const CustomContainer(
  {
    super.key,
    required this.text,
    this.callback,
    this.color,
    this.border,
});
  @override
  Widget build(BuildContext context) {
    var height= MediaQuery.of(context).size.height;
    var width= MediaQuery.of(context).size.width;
    return InkWell(
      onTap: callback,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
          height: height*0.25,
          width: width*0.4,
          decoration: const BoxDecoration(


            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Colors.black,

          ),
          child: Center(
            child: Text(text!, style: TextStyle(
              fontSize: width*0.04,
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade200,
            ),),
          )
          ,
        ),
      ),
    );
  }

}