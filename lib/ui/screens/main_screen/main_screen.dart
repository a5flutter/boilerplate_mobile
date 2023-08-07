import 'package:blank_project/application.dart';
import 'package:blank_project/bloc/income_messages_bloc/income_messages_bloc.dart';
import 'package:blank_project/ui/common_widgets/custom_scaffold.dart';
import 'package:blank_project/ui/navigation/routes.dart';
import 'package:blank_project/ui/navigation/screens.dart';
import 'package:blank_project/ui/screens/main_screen/widgets/main_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  Widget wrappedRoute() {
    mainScreenKey = GlobalKey<MainScreenState>();
    return MainScreen(key: mainScreenKey);
  }

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool bottomNavVisible = true;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  final List<String> tabsInitialRoutes = [
    Screens.screen1,
    Screens.screen2,
    Screens.screen3,
    Screens.screen4
  ];

  final List<bool> pagesInitialized = [true, false, false, false];

  late List<Object> _tabsInitialArguments;

  @override
  void initState() {
    mainScreenInScope = true;
    super.initState();
    ///Arguments for tabs can be added here
    _tabsInitialArguments = [[], [], [], []];
    ///Connect to external notifications
    //BlocProvider.of<IncomeMessagesBloc>(context).add(MessagesInitialized());
  }

  @override
  void didChangeDependencies() {
    ///Route args catching example
    final args = ModalRoute.of(context)!.settings.arguments as List<Object>?;
    super.didChangeDependencies();
  }


  @override
  void dispose() {
    mainScreenInScope = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          if (_navigatorKeys[_selectedIndex].currentState!.canPop()) {
            _navigatorKeys[_selectedIndex].currentState!.pop(context);
            return Future(() => false);
          }
          return Future(() => true);
        },
        child: CustomScaffold(
              safeAreaBottom: true,
              body: Stack(
                children: [
                  _buildOffstageNavigator(0),
                  _buildOffstageNavigator(1),
                  _buildOffstageNavigator(2),
                  _buildOffstageNavigator(3),
                ],
              ),
              bottomNavigationBar: MainBottomNavigationBar(
                  currentPage: _selectedIndex,
                  onItemTap: changePage,
              ),
            ),
        );
  }

  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          if (routeSettings.name == '/') {
            return MaterialPageRoute(
                builder: (context) =>
                    appRoutes[tabsInitialRoutes[index]]!(context),
                settings: RouteSettings(
                    name: routeSettings.name,
                    arguments: _tabsInitialArguments[index],
                ),
            );
          } else {
            return MaterialPageRoute(
                builder: appRoutes[routeSettings.name]!,
                settings: routeSettings,
            );
          }
        },
      ),
    );
  }

  void changePage(int index) => setState(() => _selectedIndex = index);

  void currentPagePop() => _navigatorKeys[_selectedIndex].currentState!.pop();

  void hideBottomNavigationBar() => setState(() => bottomNavVisible = false);
}
