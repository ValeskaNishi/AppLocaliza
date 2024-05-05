import 'package:url_launcher/url_launcher.dart';

void _launchMapsUrl(String sourceLatitude, String sourceLongitude, String destination) async {
  String googleUrl = 'https://www.google.com/maps/dir/?api=1&origin=$sourceLatitude,$sourceLongitude&destination=$destination&travelmode=driving';
  if (await canLaunch(googleUrl)) {
    await launch(googleUrl);
  } else {
    throw 'Could not open the map.';
  }
}
