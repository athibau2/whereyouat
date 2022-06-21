import 'dart:ffi';

import 'package:flutter/material.dart';

import '../models/event.dart';

class EventListTile extends StatelessWidget {
  const EventListTile({Key? key, required this.event, this.onTap})
      : super(key: key);

  final Event event;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(event.name),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
