import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:whereyouat/bloc/application_bloc.dart';
import 'package:whereyouat/services/location.dart';

class GoogleMapsPage extends StatefulWidget {
  const GoogleMapsPage({Key? key}) : super(key: key);

  @override
  State<GoogleMapsPage> createState() => _GoogleMapsPageState();
}

class _GoogleMapsPageState extends State<GoogleMapsPage> {
  Completer<GoogleMapController> _controller = Completer();
  final location = Location();
  late Position position;

  void _getPosition() async {
    position = await location.determinePosition();
  }

  @override
  void initState() {
    ApplicationBloc();
    super.initState();
    _getPosition();
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return Scaffold(
      appBar: AppBar(
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
            child: GoogleMap(
              compassEnabled: true,
              mapToolbarEnabled: true,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: const CameraPosition(
                target: LatLng(40.2338, -111.6585),
                zoom: 10,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
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
