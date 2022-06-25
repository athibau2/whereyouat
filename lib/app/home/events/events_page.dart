import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:whereyouat/app/home/events/edit_event_page.dart';
import 'package:whereyouat/app/home/events/event_list_tile.dart';
import 'package:whereyouat/app/home/events/list_items_builder.dart';
import 'package:whereyouat/widgets/show_exception_alert_dialog.dart';
import '../../../services/database.dart';
import '../models/event.dart';
import 'package:latlng/latlng.dart';

class EventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 6,
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
    return StreamBuilder<List<Event>>(
      stream: database.userEventsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Event>(
          snapshot: snapshot,
          itemBuilder: (context, event) => Dismissible(
            key: Key('event-${event.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, event),
            child: EventListTile(
              event: event,
              onTap: () => EditEventPage.show(context, event: event),
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
}
