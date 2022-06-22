import 'package:flutter/material.dart';
import 'package:whereyouat/app/home/account/account_page.dart';
import 'package:whereyouat/app/home/cupertino_home_scaffold.dart';
import 'package:whereyouat/app/home/tab_item.dart';
import 'events/events_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.map;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.myEvents: GlobalKey<NavigatorState>(),
    TabItem.map: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.map: (_) => Container(),
      TabItem.myEvents: (_) => EventsPage(),
      TabItem.account: (_) => const AccountPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
      onWillPop: () async =>
          !await navigatorKeys[_currentTab]!.currentState!.maybePop(),
    );
  }

  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentTab = tabItem;
      });
    }
  }
}
