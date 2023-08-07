import 'package:blank_project/bloc/initial_bloc/initial_bloc.dart';
import 'package:blank_project/ui/common_widgets/custom_progress_indicator.dart';
import 'package:blank_project/utils/screen_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InitialScreen extends StatefulWidget {
  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    BlocProvider.of<InitialBloc>(context).add(CheckCredentials());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    ScreenDimensions.calculateMultipliers(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
            body: Container(color: Colors.white,
                child: CustomProgressIndicator())
        ));
  }
}
