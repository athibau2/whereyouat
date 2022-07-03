import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:whereyouat/app/home/events/edit_event_page.dart';
import 'package:whereyouat/app/home/events/event_details_page.dart';
import 'package:whereyouat/app/home/events/event_list_tile.dart';
import 'package:whereyouat/app/home/events/list_items_builder.dart';
import 'package:whereyouat/services/auth.dart';
import 'package:whereyouat/widgets/show_exception_alert_dialog.dart';
import '../../../services/database.dart';
import '../models/event.dart';

class EventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 6,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            'images/logo.svg',
          ),
        ),
        title: const Text("My Events"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () => EditEventPage.show(context),
            tooltip: 'Create new event',
          ),
        ],
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final _auth = Provider.of<AuthBase>(context, listen: false);

    return StreamBuilder<List<Event>>(
      stream: database.userEventsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Event>(
          snapshot: snapshot,
          itemBuilder: (context, event) => Dismissible(
            key: Key('event-${event.id}'),
            background: Container(color: Colors.red),
            onDismissed: (direction) => _auth.currentUser!.uid == event.owner['uid']
                ? _delete(context, event)
                : _optOut(context, event),
            child: EventListTile(
              event: event,
              onTap: () => _auth.currentUser!.uid == event.owner['uid']
                  ? EditEventPage.show(context, event: event)
                  : EventDetailsPage.show(context, event: event),
            ),
          ),
        );
      },
    );
  }

  Future<void> _delete(BuildContext context, Event event) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteEvent(event);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  Future<void> _optOut(BuildContext context, Event event) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      // await database.deleteEvent(event);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }
}
