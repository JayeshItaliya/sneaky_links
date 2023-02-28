// import 'package:geocoder/geocoder.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import '../Components/constants.dart';
//
// class LocationProvider extends GetxController {
//   late double latitude;
//   late double longitude;
//   late bool permisionallowed = true;
//   var selectedAddress1;
//   var selectedAddress2;
//   var address;
//   bool loading = false;
//
//
//   @override
//   void onInit() {
//     // TODO: implement onInit
//     super.onInit();
//     getCurrentPosition();
//   }
//
//
//   Future<Position> getCurrentPosition() async {
//     Position position = await Geolocator.getCurrentPosition();
//     if (position != null) {
//       this.latitude = position.latitude;
//       this.longitude = position.longitude;
//       final coordinates = Coordinates(latitude, longitude);
//       final addresses =
//           await Geocoder.local.findAddressesFromCoordinates(coordinates);
//       this.selectedAddress1 = addresses.first.addressLine;
//       this.selectedAddress2 = addresses.first.featureName;
//       this.address = addresses.first;
//       this.permisionallowed = true;
//     } else {
//       showLongToast('Permission not allowed');
//       this.permisionallowed = false;
//
//     }
//     return position;
//   }
// }
