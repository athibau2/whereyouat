import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:whereyouat/widgets/show_alert_dialog.dart';
import 'package:whereyouat/widgets/show_exception_alert_dialog.dart';
import '../../services/auth.dart';
import '../../services/database.dart';
import 'models/event.dart';
import 'package:latlng/latlng.dart';

class EventsPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(context,
        title: 'Logout',
        content: 'Are you sure you want to logout?',
        cancelActionText: 'Cancel',
        defaultActionText: 'Logout');

    if (didRequestSignOut == true) _signOut(context);
  }

  Future<void> _createEvent(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.createEvent(Event(
        name: 'Ultimate',
        startTime: DateTime.now(),
        location: 'Timpview High School',
        // latLng: LatLng(0, 0),
      ));
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Events"),
        centerTitle: true,
        actions: [
          FlatButton(
            child: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _createEvent(context),
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Event>>(
      stream: database.eventsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final events = snapshot.data;
          final children = events!.map((event) => Text(event.name)).toList();
          return ListView(
            children: children,
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Some error occured'),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
