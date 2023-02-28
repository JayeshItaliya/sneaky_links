import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:get/get.dart';
import 'package:sneaky_links/Components/constants.dart';

class NetworkController extends GetxController {
  StreamSubscription? subscription;
  var offline = false.obs;
  late IO.Socket socket;

  @override
  void onInit() {
    // TODO: implement onInit
    initConnectivity();
    initSocket();
    super.onInit();
  }

  initConnectivity() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        offline.value = true;
      } else if (result == ConnectivityResult.mobile) {
        offline.value = false;
      } else if (result == ConnectivityResult.wifi) {
        offline.value = false;
      } else {
        Get.snackbar("Network Error", "Failed to get network connection");
      }
    });
  }

  Future<void> initSocket() async {
    // print('Connecting to chat service'+Constant.access_token);
    print('Connecting to chat service');
    // String registrationToken = await getFCMToken();
    socket = IO.io(Constant.SERVER_URL, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'query': {
        'token': Constant.access_token,
        'senderId': Constant.user_id,
      }
    });
    socket.connect();
    socket.onConnect((data) {
      print('connected to websocket');
    });
    socket.onError((data) {
      showLongToast("Connection Lost");
      print('onError ' + data.toString());
    });
    socket.onConnectError((data) {
      showLongToast("We are temporarily offline. We will be back soon.");
      print('onConnectError ' + data.toString());
    });
  }

  @override
  void onClose() {
    // socket.disconnect();

    // TODO: implement onClose
    super.onClose();
  }
}
