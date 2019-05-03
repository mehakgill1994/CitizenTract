import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
 @override
 _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 GoogleMapController mapController;
 MapType _currentMapType = MapType.normal;

 final LatLng _center = const LatLng(45.5049095, -73.6149791);

 void _onMapCreated(GoogleMapController controller) {
   mapController = controller;
   readFile();
 }

 void _onMapTypeButtonPressed() {
   if (_currentMapType == MapType.normal) {
     mapController.updateMapOptions(
       GoogleMapOptions(mapType: MapType.satellite),
     );
     _currentMapType = MapType.satellite;
   } else {
     mapController.updateMapOptions(
       GoogleMapOptions(mapType: MapType.normal),
     );
     _currentMapType = MapType.normal;
   }
 }

  String locationName, company, budget, startDate, endDate, lat, lng;
  var locationDesc;

  // Read and parse file for site information
  readFile() async{
    var file = File('data/sites.txt');
    var contents = await file.readAsString();
    var lines = contents.split('\n');

    for(var name in lines){
      var features = name.split(';');
      locationName = features[0];
      company = features[1];
      budget = features[2];
      startDate = features[3];
      endDate = features[4];
      lat = features[5];
      lng = features[6];

      locationDesc = [company, budget, startDate, endDate];

      // output all locations automatically
      mapController.addMarker(
      MarkerOptions(
        position: LatLng(
          double.parse(lat),
          double.parse(lng),
        ),
        infoWindowText: InfoWindowText(locationName, locationDesc.toString().substring(1,locationDesc.toString().length-1)),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    }
    
  }

 void _onAddMarkerButtonPressed() {
   mapController.addMarker(
     MarkerOptions(
       position: LatLng(
         mapController.cameraPosition.target.latitude,
         mapController.cameraPosition.target.longitude,
       ),
       infoWindowText: InfoWindowText(locationName, locationDesc.toString().substring(1,locationDesc.toString().length-1)),
       icon: BitmapDescriptor.defaultMarker,
     ),
   );
 }

 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     home: Scaffold(
       appBar: AppBar(
         title: Text('CitizenTract'),
         backgroundColor: Colors.green[700],
       ),
       body: Stack(
         children: <Widget>[
           GoogleMap(
             onMapCreated: _onMapCreated,
             options: GoogleMapOptions(
               trackCameraPosition: true,
               cameraPosition: CameraPosition(
                 target: _center,
                 zoom: 11.0,
               ),
             ),
           ),
           Padding(
             padding: const EdgeInsets.all(16.0),
             child: Align(
               alignment: Alignment.topRight,
               child: Column(
                 children: <Widget>[
                   FloatingActionButton(
                     onPressed: _onMapTypeButtonPressed,
                     materialTapTargetSize: MaterialTapTargetSize.padded,
                     backgroundColor: Colors.green,
                     child: const Icon(Icons.map, size: 36.0),
                   ),
                   const SizedBox(height: 16.0),
                   FloatingActionButton(
                     onPressed: _onAddMarkerButtonPressed,
                     materialTapTargetSize: MaterialTapTargetSize.padded,
                     backgroundColor: Colors.green,
                     child: const Icon(Icons.add_location, size: 36.0),
                   ),
                 ],
               ),
             ),
           ),
         ],
       ),
     ),
   );
 }
}