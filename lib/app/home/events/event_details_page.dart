import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:whereyouat/services/auth.dart';
import 'package:whereyouat/widgets/custom_button.dart';
import 'package:whereyouat/widgets/show_exception_alert_dialog.dart';
import '../../../services/database.dart';
import '../models/event.dart';

class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage(
      {Key? key,
      required this.database,
      required this.event,
      required this.auth})
      : super(key: key);
  final Database database;
  final Event event;
  final AuthBase auth;

  static Future<void> show(BuildContext context, {required Event event}) async {
    final database = Provider.of<Database>(context, listen: false);
    final _auth = Provider.of<AuthBase>(context, listen: false);

    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
          builder: (context) => EventDetailsPage(
                database: database,
                event: event,
                auth: _auth,
              ),
          fullscreenDialog: true),
    );
  }

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  late Event _event;
  bool loading = false;
  late int people;
  late bool isMine = widget.event.owner == widget.auth.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _event = widget.event;
    people = widget.event.attendees.length;
  }

  Future<void> _optInOrOut(BuildContext context, bool isAttending) async {
    setState(() {
      loading = true;
    });
    // OPT IN
    if (!isAttending) {
      setState(() {
        people += 1;
      });
      try {
        final event = Event(
          id: _event.id,
          name: _event.name,
          location: _event.location,
          startTime: _event.startTime,
          endTime: _event.endTime,
          owner: _event.owner,
          attendees: [..._event.attendees, widget.auth.currentUser!.uid],
          description: _event.description,
        );
        await widget.database.setEvent(event);
        setState(() {
          loading = false;
        });
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: 'Operation failed',
          exception: e,
        );
      }
    }
    // OPT OUT
    else if (isAttending) {
      setState(() {
        people -= 1;
      });
      List<dynamic> attendees = _event.attendees;
      for (int i = 0; i < attendees.length; ++i) {
        if (attendees[i] == widget.auth.currentUser!.uid) {
          attendees.removeAt(i);
          break;
        }
      }
      try {
        final event = Event(
          id: _event.id,
          name: _event.name,
          location: _event.location,
          startTime: _event.startTime,
          endTime: _event.endTime,
          owner: _event.owner,
          attendees: [...attendees],
          description: _event.description,
        );
        await widget.database.optOut(event);
        setState(() {
          loading = false;
        });
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: 'Operation failed',
          exception: e,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isAttending;

    return FutureBuilder<bool>(
        future: widget.database
            .isAttending(widget.auth.currentUser!.uid, _event.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            isAttending = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 6,
                title: const Text("Event Details"),
                centerTitle: true,
                actions: [
                  TextButton(
                    child: const Text(
                      'Done',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
              body: _buildContent(context),
              backgroundColor: Colors.grey[200],
              floatingActionButton: !isMine
                  ? CustomButton(
                      child: loading
                          ? const CircularProgressIndicator()
                          : Text(
                              isAttending ? 'Opt Out' : 'Opt In!',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                      onPressed: () => _optInOrOut(context, isAttending),
                      color: isAttending
                          ? Colors.red
                          : Theme.of(context).primaryColor,
                      borderRadius: 30,
                    )
                  : null,
            );
          } else {
            return Center(
              child: Text(
                snapshot.data as String,
                style: const TextStyle(fontSize: 20),
              ),
            );
          }
        });
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildDetails(context),
          ),
        ),
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.event),
            ),
            Expanded(
              flex: 9,
              child: Text(_event.name),
            ),
          ],
        ),
        const Divider(
          thickness: 1.0,
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.text_snippet),
            ),
            Expanded(
              flex: 9,
              child: Text(
                _event.description,
              ),
            ),
          ],
        ),
        const Divider(
          thickness: 1.0,
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.gps_fixed),
            ),
            Expanded(
              flex: 9,
              child: SelectableText(
                _event.location['displayName'].toString(),
              ),
            ),
          ],
        ),
        const Divider(
          thickness: 1.0,
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: FaIcon(FontAwesomeIcons.clock),
            ),
            Expanded(flex: 9, child: _formatDateTime(_event.startTime)),
          ],
        ),
        const Divider(
          thickness: 1.0,
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: FaIcon(FontAwesomeIcons.clock),
            ),
            Expanded(flex: 9, child: _formatDateTime(_event.endTime)),
          ],
        ),
        const Divider(
          thickness: 1.0,
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.people),
            ),
            Expanded(flex: 9, child: Text(people.toString())),
          ],
        ),
        const Divider(
          thickness: 1.0,
        ),
      ],
    );
  }

  Widget _formatDateTime(DateTime date) {
    int hour = date.hour;
    dynamic minute = date.minute;
    String timeOfDay = 'AM';
    if (date.hour > 12) {
      hour = date.hour - 12;
      timeOfDay = 'PM';
    }
    if (minute == 0) minute = '00';
    if (minute < 10) minute = '0' + minute.toString();

    String getWeekday(int weekday) {
      switch (weekday) {
        case 1:
          return 'Monday';
        case 2:
          return 'Tuesday';
        case 3:
          return 'Wednesday';
        case 4:
          return 'Thursday';
        case 5:
          return 'Friday';
        case 6:
          return 'Saturday';
        case 7:
          return 'Sunday';
        default:
          return '';
      }
    }

    return Text(getWeekday(date.weekday) +
        ', ' +
        date.month.toString() +
        '/' +
        date.day.toString() +
        '/' +
        date.year.toString() +
        ', ' +
        hour.toString() +
        ':' +
        minute.toString() +
        ' $timeOfDay');
  }
}
