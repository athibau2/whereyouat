import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:open_location_picker/open_location_picker.dart';
import 'package:provider/provider.dart';
import 'package:whereyouat/app/home/google_maps/location_auth.dart';
import 'package:whereyouat/bloc/application_bloc.dart';
import 'package:whereyouat/services/location.dart';

class GoogleMapsPage extends StatefulWidget {
  const GoogleMapsPage({Key? key}) : super(key: key);

  @override
  State<GoogleMapsPage> createState() => _GoogleMapsPageState();
}

class _GoogleMapsPageState extends State<GoogleMapsPage> {
  Completer<GoogleMapController> _controller = Completer();
  late Position position;
  final location = LocationAuth(lat: 0, lng: 0);

  @override
  void initState() {
    ApplicationBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);

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
                    // onMapCreated: (GoogleMapController controller) {
                    //   _controller.complete(controller);
                    // },
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
            child: ListView(
              children: [
                Text("Hello 1"),
                Text("Hello 2"),
                Text("Hello 3"),
                Text("Hello 4"),
                Text("Hello 5"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
