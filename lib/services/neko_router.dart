import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NekoRouter {

  static void push<T extends Cubit>(BuildContext context, Widget child) {
      Navigator.push(
     context,
     MaterialPageRoute(builder: (contextLoginScreen) {
        return BlocProvider.value(
            value: BlocProvider.of<T>(context, listen: true),
            child: child);
     }),
   );
  }
}