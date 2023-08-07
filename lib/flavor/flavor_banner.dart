import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:package_info_plus/package_info_plus.dart';

class FlavorBanner extends StatelessWidget {
  const FlavorBanner({required this.child});

  final Widget child;
  static String package = '';

  Future<String> getPackageInfo() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  @override
  Widget build(BuildContext context) {
    if (FlavorConfig.instance.variables['environment'] == 'production') {
      return child;
    }

    return FutureBuilder<String>(
      future: getPackageInfo(),
      builder: (context, snapshot) {
        package = snapshot.data!;
        return Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            child,
            SizedBox(
              width: 50,
              height: 50,
              child: CustomPaint(
                painter: BannerPainter(
                  message: '${FlavorConfig.instance.name!} $package',
                  textDirection: Directionality.of(context),
                  layoutDirection: Directionality.of(context),
                  location: BannerLocation.bottomEnd,
                  color: FlavorConfig.instance.color,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
