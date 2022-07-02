import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whereyouat/services/auth.dart';
import 'package:whereyouat/widgets/format_date.dart';

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
    final bool isMine = _auth.currentUser!.uid == event.owner;

    return ListTile(
      tileColor: isMine ? Colors.blueGrey[100] : Colors.grey[200],
      title: Text(event.name),
      subtitle: formatDateTime(event.startTime),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
