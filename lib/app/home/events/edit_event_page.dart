import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:whereyouat/widgets/show_exception_alert_dialog.dart';

import '../../../services/database.dart';
import '../models/event.dart';

class EditEventPage extends StatefulWidget {
  const EditEventPage({Key? key, required this.database, this.event})
      : super(key: key);
  final Database database;
  final Event? event;

  static Future<void> show(BuildContext context, {Event? event}) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
          builder: (context) => EditEventPage(
                database: database,
                event: event,
              ),
          fullscreenDialog: true),
    );
  }

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final _formkey = GlobalKey<FormState>();
  late String _name;
  late String _location;
  late DateTime _startTime;
  late DateTime _endTime;

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _name = widget.event!.name;
      _location = widget.event!.location;
      _startTime = widget.event!.startTime;
      _endTime = widget.event!.endTime;
    } else {
      _name = '';
      _location = '';
      _startTime = DateTime.now();
      _endTime = DateTime.now();
    }
  }

  bool _validateAndSaveForm() {
    final form = _formkey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final id = widget.event?.id ?? await getId();
        final event = Event(
          id: id,
          name: _name,
          location: _location,
          startTime: _startTime,
          endTime: _endTime,
        );
        await widget.database.setEvent(event);
        Navigator.of(context).pop();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 6,
        title: Text(widget.event == null ? "New Event" : 'Edit Event'),
        centerTitle: true,
        actions: [
          TextButton(
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            onPressed: _submit,
          )
        ],
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        initialValue: _name,
        decoration: const InputDecoration(
          labelText: 'Event name',
        ),
        onSaved: (value) => _name = value!,
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
      ),
      const SizedBox(
        height: 10,
      ),
      TextFormField(
        initialValue: _location,
        decoration: const InputDecoration(
          labelText: 'Location',
        ),
        keyboardType: TextInputType.streetAddress,
        onSaved: (value) => _location = value!,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Location can\'t be empty',
      ),
      const SizedBox(
        height: 15,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Start Time:",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          TextButton(
              child: formatDateTime(_startTime),
              onPressed: () {
                DatePicker.showDateTimePicker(context,
                    showTitleActions: false,
                    minTime: DateTime.now(), onChanged: (date) {
                  setState(() {
                    _startTime = date;
                  });
                });
              }),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "End Time:",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          TextButton(
              child: formatDateTime(_endTime),
              onPressed: () {
                DatePicker.showDateTimePicker(context,
                    showTitleActions: true,
                    minTime: _startTime, onChanged: (time) {
                  setState(() {
                    _endTime = time;
                  });
                });
              }),
        ],
      ),
    ];
  }

  Widget formatDateTime(DateTime date) {
    int hour = date.hour;
    dynamic minute = date.minute;
    String timeOfDay = 'AM';
    if (date.hour > 12) {
      hour = date.hour - 12;
      timeOfDay = 'PM';
    }
    if (minute == 0) minute = '00';
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
