import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:whereyouat/app/home/events/event_list_tile.dart';
import 'package:whereyouat/app/home/events/list_items_builder.dart';
import 'package:whereyouat/app/home/google_maps/location_auth.dart';
import 'package:whereyouat/app/home/models/event.dart';
import 'package:whereyouat/services/database.dart';

class GoogleMapsPage extends StatefulWidget {
  const GoogleMapsPage({Key? key}) : super(key: key);

  @override
  State<GoogleMapsPage> createState() => _GoogleMapsPageState();
}

class _GoogleMapsPageState extends State<GoogleMapsPage> {
  // Completer<GoogleMapController> _controller = Completer();
  final location = LocationAuth();

  @override
  void initState() {
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {}

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            'images/logo.svg',
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: FutureBuilder<Map<String, double>?>(
              future: location.determinePosition(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return GoogleMap(
                    compassEnabled: true,
                    mapToolbarEnabled: true,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(snapshot.data!.values.first,
                          snapshot.data!.values.last),
                      zoom: 14,
                    ),
                    onMapCreated: _onMapCreated,
                  );
                } else {
                  return Center(
                    child: Text(
                      snapshot.data as String,
                      style: const TextStyle(fontSize: 20),
                    ),
                  );
                }
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Event>>(
                stream: database.eventsStream(),
                builder: (context, snapshot) {
                  return ListItemsBuilder<Event>(
                    source: 'map',
                    snapshot: snapshot,
                    itemBuilder: (context, event) => EventListTile(
                      event: event,
                      onTap: () {
                        print('REROUTE TO EVENT INFO PAGE');
                      },
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
