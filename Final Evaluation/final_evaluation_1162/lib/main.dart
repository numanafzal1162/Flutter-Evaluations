import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:geolocator/geolocator.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      home: Scaffold(body: WeatherAppHomePage()),
    ),
  );
}

class WeatherAppHomePage extends StatefulWidget {
  const WeatherAppHomePage({Key? key}) : super(key: key);

  @override
  State<WeatherAppHomePage> createState() => _WeatherAppHomePageState();
}

class _WeatherAppHomePageState extends State<WeatherAppHomePage> {
  double longitude = 0.0;
  double latitude = 0.0;

  double showlat = 0.0;
  double showlong = 0.0;

  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    fetchLocation();
    read();
    super.initState();
  }

  void fetchLocation() async {
    bool permission = false;

    LocationPermission checkPermission = await Geolocator.checkPermission();

    if (checkPermission == LocationPermission.denied ||
        checkPermission == LocationPermission.deniedForever) {
      LocationPermission reqPermission = await Geolocator.requestPermission();
      if (reqPermission == LocationPermission.whileInUse ||
          reqPermission == LocationPermission.always) {
        permission = true;
      }
    } else {
      permission = true;
    }
    if (permission) {
      Position currentLoc = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude = currentLoc.latitude;
      longitude = currentLoc.longitude;
    } else {
      print("Location Permission Denied");
    }
    add();
  }

  void add() {
    final ToSave = <String, dynamic>{
      'latitude': latitude,
      'logititude': longitude,
    };
    db
        .collection("final")
        .doc("GetData")
        .set(ToSave, SetOptions(merge: true))
        .onError((e, _) => print(e));
  }

  void read() {
    // double lon = 0.0;
    // double lat = 0.0;
    db.collection("final").snapshots().listen(
      (event) {
        for (var doc in event.docs) {
          showlong = doc.data()["logititude"];
          showlat = doc.data()["latitude"];
        }
        // setState(() {
        //   showlat = lat;
        //   showlong = lon;
        // });
      },
      onError: (error) => print("Listen failed: $error"),
    );
  }

  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        Text("Final Evaluiation"),
        SizedBox(height: 40),
        TextButton(
          onPressed: () {
            Flushbar(
              backgroundColor: Colors.green,
              titleText: const Text('Data Added:'),
              messageText: Text('$showlat - $showlong'),
              duration: const Duration(seconds: 3),
            ).show(context);
          },
          child: Text(
            "Press to Get Longitude or Lattitude",
          ),
        ),
      ]),
    );
  }
}
