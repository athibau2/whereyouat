import 'package:flutter/material.dart';

enum TabItem { map, myEvents, account }

class TabItemData {
  const TabItemData({required this.title, required this.icon});
  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.map: TabItemData(title: 'Map', icon: Icons.map),
    TabItem.myEvents: TabItemData(title: 'My Events', icon: Icons.event),
    TabItem.account: TabItemData(title: 'Account', icon: Icons.person),
  };
}
