import 'dart:convert';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaky_links/Models/PartyModel.dart';
import 'package:sneaky_links/Pages/ProfileScreen/subscribe.dart';
import 'package:sneaky_links/Pages/RoomScreen/inside_the_room_without_comment_screen.dart';
import 'package:sneaky_links/Pages/RoomScreen/room_item_widget.dart';
import 'package:sneaky_links/Services/api_repository.dart';
import 'package:sneaky_links/Services/connectionerror.dart';
import 'package:sneaky_links/flutter_flow/flutter_flow_theme.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sneaky_links/flutter_flow/flutter_flow_widgets.dart';
import '../../Components/constants.dart';
import '../../controllers/party_controller.dart';
import 'create_room_popup.dart';

class nearbyRoomsScreen extends StatefulWidget {
  @override
  State<nearbyRoomsScreen> createState() => _nearbyRoomsScreenState();
}

class _nearbyRoomsScreenState extends State<nearbyRoomsScreen> {
  final myController = Get.put(PartyController());

  int payamount = 0;

  Map<String, dynamic>? paymentIntentData;
  final _formkey = GlobalKey<FormState>();
  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  late SharedPreferences pref;
  var free_party_join = 0;

  getData() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      free_party_join = pref.getInt(Constant.user_id + "free_party_join") ?? 0;
    });
    myController.updateData("");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 27,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 26,
                  right: 26,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 1,
                      child: SearchBar(
                        obscureText: false,
                        hintT: 'Search',
                        onChange: (str) {
                          myController.updateData(str);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
              left: 26,
              top: 10,
              right: 26,
            ),

            // decoration: BoxDecoration(
            //   color: ColorConstant.gray50,
            // ),
            child: Obx(
              () => myController.isoffline.value
                  ? Center(child: ConnectionError(
                      onTap: () {
                        // getData();
                        myController.updateData(searchController.text);
                      },
                    ))
                  : myController.isDataProcessing.value
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          // controller: myController.scrollController,
                          itemCount: myController.myList.length,
                          itemBuilder: (context, index) {
                            if (index == myController.myList.length - 1 &&
                                myController.isMoreDataAvailable.value) {
                              return Column(
                                children: [
                                  Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ],
                              );
                            }
                            PartyModel item = myController.myList[index];
                            return InkWell(
                                onTap: () async {
                                  setState(() {
                                    payamount = item.price;
                                  });
                                  if (item.createdBy.toString() ==
                                      Constant.user_id) {
                                    var res = await Get.to(
                                        InsideTheRoomWithoutCommentScreen(item.roomId.toString()));
                                    if (res != null) {
                                      myController
                                          .updateData(searchController.text);
                                    }
                                  }
                                  // else if (item.price > 0) {
                                  // stripePayment(item);
                                  // }
                                  else if (item.isPasscodeRequiredToJoin) {
                                    displayTextInputDialog(context, item);
                                  } else if (item.price > 0) {
                                    myController
                                        .joinParty(item.roomId, txtController.text)
                                        .then((value) async {
                                      if (value != null) {
                                        leave(item.roomId.toString(),item);
                                      }
                                    });
                                    // makePayment(item,"");
                                  } else {
                                    if (Constant.plan_active == 1) {
                                      if (Constant.current_plan == "ELITE" ||
                                          Constant.current_plan == "PREMIUM") {
                                        if (free_party_join < 5) {
                                          myController
                                              .joinParty(item.roomId, "")
                                              .then((value) async {
                                            if (value != null) {
                                              var res = await Get.to(
                                                  InsideTheRoomWithoutCommentScreen(item.roomId.toString()));
                                              if (res != null) {
                                                myController.updateData(
                                                    searchController.text);
                                              }
                                            }
                                          });
                                          setState(() {
                                            free_party_join++;
                                          });
                                          pref.setInt(
                                              Constant.user_id +
                                                  "free_party_join",
                                              free_party_join);
                                        } else {
                                          showLongToast("Expire Plan");
                                        }
                                      } else if (Constant.current_plan ==
                                          "FREE") {
                                        showLongToast(
                                            "You can't join the party without subscription");
                                      } else {
                                        myController
                                            .joinParty(item.roomId, "")
                                            .then((value) async {
                                          if (value != null) {
                                            var res = await Get.to(
                                                InsideTheRoomWithoutCommentScreen(item.roomId.toString()));
                                            if (res != null) {
                                              myController.updateData(
                                                  searchController.text);
                                            }
                                          }
                                        });
                                      }
                                    } else {
                                      // showLongToast("Plan Expire");
                                      Get.defaultDialog(
                                        title: Constant.titleText,
                                        radius: 30,
                                        barrierDismissible: false,
                                        content:Column(
                                          children: [
                                            Column(
                                              children:   [
                                                const CircleAvatar(
                                                    radius: 20,
                                                    backgroundColor: Colors.white,
                                                    backgroundImage:AssetImage("assets/images/logo.png",)
                                                ),
                                                const SizedBox(height: 10,),
                                                Text(Constant.description,textAlign:TextAlign.center,)
                                              ],
                                            ),
                                            const SizedBox(height: 10,),
                                            Row(
                                              mainAxisAlignment:MainAxisAlignment.spaceAround,
                                              children: [
                                                OutlinedButton(
                                                    onPressed:(){
                                                      Get.back();
                                                    },
                                                    child:const Text("Later")
                                                ),
                                                ElevatedButton(
                                                    onPressed:(){
                                                      Get.back();
                                                      Get.to(subscribe());
                                                    },
                                                    child:const Text("Upgrade")
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: RoomsItemWidget(item));
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }

  final txtController = TextEditingController();

  Future displayTextInputDialog(BuildContext context, PartyModel item) async {
    txtController.text = "";
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // title: Text('Passcode'),
            content: Form(
              key: _formkey,
              child: TextFormField(
                controller: txtController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(hintText: "Passcode"),
                validator: (String? text) {
                  if (text!.isEmpty) return "Please Enter Passcode";
                },
              ),
            ),
            actions: <Widget>[
              FlatButton(
                // color: Colors.red,
                // textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Get.back();
                  });
                },
              ),
              FlatButton(
                color: FlutterFlowTheme.primaryColor,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    if (_formkey.currentState!.validate()) {
                      Get.back();

                      if (item.price > 0) {
                        myController
                            .joinParty(item.roomId, txtController.text)
                            .then((value) async {
                          if (value != null) {
                            leave(item.roomId.toString(),item);
                          }
                        });
                        // makePayment(item,"");
                      } else {
                        if (Constant.plan_active == 1) {
                          if (Constant.current_plan == "ELITE" ||
                              Constant.current_plan == "PREMIUM") {
                            if (free_party_join < 5) {
                              myController
                                  .joinParty(item.roomId, "")
                                  .then((value) async {
                                if (value != null) {
                                  var res = await Get.to(
                                      InsideTheRoomWithoutCommentScreen(item.roomId.toString()));
                                  if (res != null) {
                                    myController
                                        .updateData(searchController.text);
                                  }
                                }
                              });
                              setState(() {
                                free_party_join++;
                              });
                              pref.setInt(Constant.user_id + "free_party_join",
                                  free_party_join);
                              receipt_dataSave().then((value) {
                              });
                            } else {
                              showLongToast("Expire Plan");
                            }
                          } else if (Constant.current_plan == "FREE") {
                            showLongToast(
                                "You can't join the party without subscription");
                          } else {
                            myController
                                .joinParty(item.roomId, "")
                                .then((value) async {
                              if (value != null) {
                                var res = await Get.to(InsideTheRoomWithoutCommentScreen(item.roomId.toString()));
                                if (res != null) {
                                  myController
                                      .updateData(searchController.text);
                                }
                              }
                            });
                          }
                        } else {
                          // showLongToast("Plan Expire");
                          Get.defaultDialog(
                            title: Constant.titleText,
                            radius: 30,
                            barrierDismissible: false,
                            content:Column(
                              children: [
                                Column(
                                  children:   [
                                    const CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.white,
                                        backgroundImage:AssetImage("assets/images/logo.png",)
                                    ),
                                    const SizedBox(height: 10,),
                                    Text(Constant.description,textAlign:TextAlign.center,)
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment:MainAxisAlignment.spaceAround,
                                  children: [
                                    OutlinedButton(
                                        onPressed:(){
                                          Get.back();
                                        },
                                        child:const Text("Later")
                                    ),
                                    ElevatedButton(
                                        onPressed:(){
                                          Get.back();
                                          Get.to(subscribe());
                                        },
                                        child:const Text("Upgrade")
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        }
                      }

                    }
                  });
                },
              ),
            ],
          );
        });
  }

  Future _getAccountId(item) async {
    EasyLoading.show(status: "Loading...");

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };

    try {
      var request = http.Request('POST', Uri.parse(Constant.createAccount));
      request.body = json.encode({"userId": item.createdBy});
      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      debugPrint(jsonBody.toString());

      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        debugPrint(jsonBody['data']['stripeAccountId']);
        makePayment(item, jsonBody['data']['stripeAccountId']);
        // stripePayment(item,jsonBody['data']['stripeAccountId']);

      } else {
        EasyLoading.showError(jsonBody['message']);
        debugPrint(jsonBody.toString());
        // EasyLoading.showError("The email you entered doesn't appear to belong to an account. Please check your email and try again.");
      }
    } catch (e) {

      debugPrint(e.toString());
      EasyLoading.showError("Oops!");
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
    }
  }


  Future leave(id,item) async {
    EasyLoading.show(status: "Loading...");

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer '+Constant.access_token
    };

    try {
      var request = http.Request(
          'GET', Uri.parse(Constant.createRoom + "/$id/leave"));

      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      debugPrint("++++++++"+jsonBody.toString());

      if (response.statusCode == 200) {
        // EasyLoading.showSuccess(jsonBody['message']);
        // Get.back(result: "data");
        _getAccountId(item);


      } else {
        EasyLoading.showError(jsonBody['message']);
      }
    } catch (e) {
      EasyLoading.showError("Oops!");
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
    }
  }

  Future<void> makePayment(item, accountId) async {
    try {
      paymentIntentData = await createPaymentIntent('${payamount.toString()}',
          'USD', accountId); //json.decode(response.body);
      debugPrint('Response body==>${paymentIntentData.toString()}');
      // if(paymentIntentData.isNotEmpty) {
        await Stripe.instance
            .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret:
                paymentIntentData!['client_secret'],
                applePay: true,
                googlePay: true,
                testEnv: true,
                style: ThemeMode.light,
                merchantCountryCode: 'US',
                merchantDisplayName: 'ANNIE'))
            .then((value) {});

        ///now finally display payment sheeet
        displayPaymentSheet(item);
      // }
    } catch (e, s) {
      debugPrint('exception:$e$s');
    }
  }

  displayPaymentSheet(item) async {
    try {
      debugPrint("Hello make displayPaymentSheet");

      await Stripe.instance
          .presentPaymentSheet(
              parameters: PresentPaymentSheetParameters(
        clientSecret: paymentIntentData!['client_secret'],
        confirmPayment: true,
      ))
          .then((newValue) {
        debugPrint('payment intent' + paymentIntentData!['id'].toString());
        // debugPrint('payment intent' + paymentIntentData!['client_secret'].toString());
        // debugPrint('payment intent' + paymentIntentData!['amount'].toString());
        // debugPrint('payment intent' + paymentIntentData.toString());
        _SavePayment(item);
      }).onError((error, stackTrace) {
        debugPrint('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });

    } on StripeException catch (e) {
      debugPrint('Exception/DISPLAYPAYMENTSHEET==> $e');

      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Text("Cancelled"),
              ));
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future _SavePayment(item) async {
    EasyLoading.show(status: "Loading...");

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };

    try {
      var request = http.Request('POST', Uri.parse(Constant.savePayment));
      request.body = json.encode(
          {"paymentData": paymentIntentData.toString(), "roomId": item.roomId});
      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      debugPrint(jsonBody.toString());

      if (response.statusCode == 200) {
        EasyLoading.dismiss();

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Paid successfully")));
        if (!item.isPasscodeRequiredToJoin) {
          myController
              .joinParty(item.roomId, txtController.text)
              .then((value) async {
            if (value != null) {
            var res = await Get.to(InsideTheRoomWithoutCommentScreen(item.roomId.toString()));
            if (res != null) {
              myController.updateData(searchController.text);
            }
            }
          });
        }
        else {
          var res = await Get.to(InsideTheRoomWithoutCommentScreen(item.roomId.toString()));
          if (res != null) {
            myController.updateData(searchController.text);
          }
        }

        paymentIntentData = null;
      } else {
        EasyLoading.showError(jsonBody['message']);
        debugPrint(jsonBody.toString());
        // EasyLoading.showError("The email you entered doesn't appear to belong to an account. Please check your email and try again.");
      }
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.showError("Oops!");
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency, String accountId) async {
    try {
      debugPrint("createPaymentIntent");
      Map<String, dynamic> body = {
        'amount': calculateAmount('${payamount.toString()}'),
        'currency': currency,
        'payment_method_types[]': 'card',
        'transfer_data[destination]': accountId,
        // 'transfer_data[destination]': "acct_1LA4JUQPg2fQqcUT",
      };
      debugPrint(body.toString());
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer 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',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      debugPrint('Create Intent reponse ===> ${response.body.toString()}');

      return jsonDecode(response.body);
    } catch (err) {
      debugPrint('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    debugPrint("calculateAmount");
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }

}
