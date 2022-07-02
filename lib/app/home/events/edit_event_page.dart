import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:open_location_picker/open_location_picker.dart';
import 'package:provider/provider.dart';
import 'package:whereyouat/services/auth.dart';
import 'package:whereyouat/widgets/format_date.dart';
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
  final kGoogleApiKey = 'AIzaSyA30BkN_es7g6dXeQ3wZAGv4o8UWJNaXS4';
  final _formkey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  late Map<String, dynamic> _location;
  late DateTime _startTime;
  late DateTime _endTime;
  late dynamic _attendees;

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _name = widget.event!.name;
      _location = widget.event!.location;
      _startTime = widget.event!.startTime;
      _endTime = widget.event!.endTime;
      _description = widget.event!.description;
      _attendees = widget.event!.attendees.length == 1
          ? 'Just me :)'
          : widget.event!.attendees.length;
    } else {
      _name = '';
      _location = {};
      _startTime = DateTime.now();
      _endTime = DateTime.now();
      _description = '';
      _attendees = 'Just me :)';
    }
  }

  bool _validateAndSaveForm() {
    final form = _formkey.currentState;
    if (form!.validate() && _location != {}) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit(BuildContext context) async {
    final _auth = Provider.of<AuthBase>(context, listen: false);
    if (_validateAndSaveForm()) {
      try {
        final id = widget.event?.id ?? await getId();
        final event = Event(
          id: id,
          name: _name,
          location: _location,
          startTime: _startTime,
          endTime: _endTime,
          owner: _auth.currentUser!.uid,
          attendees: [_auth.currentUser!.uid],
          description: _description,
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Something is wrong with your form. Make sure none of the fields are empty.'),
        duration: Duration(seconds: 3),
      ));
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
            onPressed: () => _submit(context),
          )
        ],
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(context),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildFormChildren(context),
      ),
    );
  }

  List<Widget> _buildFormChildren(BuildContext context) {
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
        autocorrect: true,
        maxLines: 2,
        initialValue: _description,
        decoration: const InputDecoration(
          labelText: 'Description',
        ),
        onSaved: (value) => _description = value!,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Description can\'t be empty',
      ),
      const SizedBox(
        height: 10,
      ),
      OpenMapPicker(
        decoration: const InputDecoration(
          hintText: "Location",
        ),
        onChanged: (FormattedLocation? newValue) {
          setState(() {
            if (newValue != null) {
              _location = {
                'lat': newValue.lat,
                'long': newValue.lon,
                'displayName': newValue.displayName,
                'address': newValue.address.toJson(),
                'name': newValue.name,
              };
            } else {
              _location = {};
            }
          });
        },
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
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Attendees:",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 7.0),
            child: Text(_attendees.toString()),
          ),
        ],
      ),
    ];
  }
}
