import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      if (Platform.isIOS){
        return const Center(child: CupertinoActivityIndicator(radius: 30,));
      } else {
        return const Center(child: CircularProgressIndicator(),);
      }
  }
}
