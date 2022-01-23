import 'package:fluttertoast/fluttertoast.dart';

Future<void> showToast(String msg) async =>
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
    );
