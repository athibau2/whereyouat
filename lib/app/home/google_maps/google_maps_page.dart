import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:whereyouat/app/home/events/event_details_page.dart';
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
  late final Completer<GoogleMapController> _controller = Completer();
  final location = LocationAuth();
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  void _createMarkers(BuildContext context, List<Event> events) {
    for (Event event in events) {
      Marker marker = Marker(
          markerId: MarkerId(event.id),
          infoWindow: InfoWindow(
            title: event.name,
            snippet: event.description,
            onTap: () => EventDetailsPage.show(context, event: event),
          ),
          position: LatLng(event.location['lat'], event.location['long']),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueMagenta));
      markers.add(marker);
    }
  }

  void _showInfoWindow(GoogleMapController controller, Event event) {
    controller.showMarkerInfoWindow(MarkerId(event.id));
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(event.location['lat'], event.location['long']),
      zoom: 15,
    )));
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    late GoogleMapController mapController;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            'images/logo.svg',
          ),
        ),
        title: const Text('Event Map'),
        centerTitle: true,
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
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                    },
                    markers: Set<Marker>.of(markers),
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
                  database.eventsStream().listen((events) {
                    if (snapshot.hasData) {
                      _createMarkers(context, events);
                    }
                  });
                  return ListItemsBuilder<Event>(
                      source: 'map',
                      snapshot: snapshot,
                      itemBuilder: (context, event) {
                        return EventListTile(
                          event: event,
                          onTap: () => _showInfoWindow(mapController, event),
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }
}
