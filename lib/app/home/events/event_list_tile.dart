import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whereyouat/services/auth.dart';

import '../models/event.dart';

class EventListTile extends StatelessWidget {
  const EventListTile({
    Key? key,
    required this.event,
    this.onTap,
  }) : super(key: key);

  final Event event;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthBase>(context, listen: false);

    return ListTile(
      tileColor: _auth.currentUser!.uid == event.owner
          ? Colors.blueGrey[100]
          : Colors.grey[200],
      title: Text(event.name),
      subtitle: Text(event.startTime.toString()),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
