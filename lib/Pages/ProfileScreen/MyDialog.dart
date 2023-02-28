import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaky_links/Components/constants.dart';
import 'package:get/get.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

class MyDialog extends StatefulWidget {
  MyDialog(
      {Key? key, required this.plan,
      required this.onValueChange,
      required this.initialValue}) : super(key: key);

  final String plan;
  final String initialValue;
  final void Function(String) onValueChange;
  List addPlan = [];
  @override
  State createState() => new MyDialogState();
}

class MyDialogState extends State<MyDialog> {
  var _selectedId;
  late int _sId;
  late ProductDetailsResponse response;
  Map<String, bool> values = {
  };
  final InAppPurchase _iap = InAppPurchase.instance;
  bool available = false;
  late StreamSubscription<List<PurchaseDetails>> subscription;
  List products = [];
  List purchases = [];
  var planNM;

  @override
  void initState() {
    super.initState();
    setState(() {
      planNM=widget.plan.toLowerCase().toString().replaceAll(" plan", "");

      print(planNM+"+++++++");
      setState(() {
        Constant.current_plan=planNM.toString().toUpperCase();
      });
      if(planNM=="platinum"){
        setState(() {
          planNM="premium";
        });
      }

    });
    print(planNM +
        "tmonths" +
        "____" +
        planNM +
        "smonths" +
        "____" +
        planNM +
        "yearly");
    _selectedId = widget.initialValue;
    _sId = 3;
    initialize();
  }

  void initialize() async {
    available = await _iap.isAvailable();

    if (available) {
      await _getProducts();
      // await _getPastPurchases();
      // verifyPurchase();

      subscription = _iap.purchaseStream.listen((data) async {
        setState(() {
          purchases.addAll(data);
        });
        for (PurchaseDetails purchase in purchases) {
          print("All..........:");
          //SOLUTION
          if (Platform.isAndroid) {
            // _iap.consumePurchase(purchase);
            print(purchase.status.toString());
            if(purchase.status.toString()!="PurchaseStatus.error")
              receipt_data(purchase.verificationData.localVerificationData,
                purchase.productID);
          } else if (Platform.isIOS) {
            if (purchase.pendingCompletePurchase) {
              // await _iap.completePurchase(purchase);
              print(purchase.verificationData.localVerificationData.toString());
              // if (!purchase.pendingCompletePurchase)
              verifyreceipt_data(
                  purchase.verificationData.localVerificationData,
                  purchase.productID);
            }
          }
        }
      });
    }
  }

  Future<void> _getProducts() async {
    Set<String> ids;
    if(Platform.isIOS)
      {
        ids = {
          planNM + "Plan",
          planNM + "tmonths",
          planNM + "smonths",
          planNM + "yearly"
        };
      }
    else {
      ids = {
        "sneakylink" + planNM + "plan",
       planNM + "tmonths",
       planNM + "smonths",
       planNM + "yearly"
      };
    }
    response = await _iap.queryProductDetails(ids);

    setState(() {
      products = response.productDetails;
      for (ProductDetails i in products) {
        print("ProductList=>");
        print(i.title.toString());
        print(i.description.toString());
        print(i.id.toString());
        print(i.price.toString());
        print(i.currencyCode.toString());
      }

      for (var element in products) {
        values["${element.title.toString().replaceAll(" (Sneaky Links Meet New Friends)", "")} ${element.price}"] = false;
      }

      print(values.toString());
    });
  }

  Future receipt_data(receipt, productID) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print("+++");
    print("recepitData=>" + Constant.current_plan);
    print("recepitData=>" + Constant.currentM.toString());
    print("recepitData=>" + productID);
    EasyLoading.show(status: "Loading...");
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + Constant.access_token
      };
      var request =
      http.Request('POST', Uri.parse(Constant.subscription + "/save"));
      request.body = json.encode({
        "receipt": {
          "receipt": receipt,
          "expiredate": DateTime(
            DateTime.now().year,
            DateTime.now().month + Constant.currentM,
            DateTime.now().day,
            DateTime.now().hour,
            DateTime.now().minute,
            DateTime.now().second,
            DateTime.now().millisecond,
          ).millisecondsSinceEpoch,
          "month": Constant.currentM
        },
        "planName": Constant.current_plan.toLowerCase()=="platinum"?"PREMIUM":Constant.current_plan.toUpperCase(),
        "productId": "$productID",
        "platform": Constant.device_type
      });
      print(request.bodyFields.toString());
      print(
          'Paln=>${productID.toString().replaceAll("sneakylink", "").replaceAll("plan", "").toUpperCase()}');
      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      print("StatusCode");
      print(response.statusCode);
      print(jsonBody.toString());
      if (response.statusCode == 200) {
        EasyLoading.showSuccess(jsonBody['message']);
        pref.setString("currentPlan",
            productID.toString().replaceAll("plan", "").toUpperCase());
        pref.setInt("plan_active", 1);
        setState(() {
          Constant.current_plan =
              productID.toString().replaceAll("plan", "").toUpperCase();
          Constant.plan_active = 1;
        });


      } else {
        EasyLoading.showError(Constant.current_plan + jsonBody['message']);
      }
    } catch (e) {
      EasyLoading.showError("Oops!");
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
    }
  }

  Future verifyreceipt_data(receipt, productID) async {
    print("+++");
    print("recepitData=>" + receipt);
    print(productID);
    EasyLoading.show(status: "Loading...");
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + Constant.access_token
      };
      var request = http.Request(
          'POST', Uri.parse("https://sandbox.itunes.apple.com/verifyReceipt"));
      request.body = json.encode({"receipt-data": receipt});
      //print(request.bodyFields.toString());
      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      print(jsonBody.toString());
      if (response.statusCode == 200) {
        receipt_data(receipt, productID);
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

  Widget build(BuildContext context) {
    return SimpleDialog(
      title: new Text(widget.plan),
      children: <Widget>[
        Container(
          // margin: EdgeInsets.only(top: 150, bottom: 100),
          // decoration: BoxDecoration(
          //   color: Colors.white,
          //   border: Border.all(
          //     width: 2,
          //   ),
          //   borderRadius: BorderRadius.circular(12.0),
          // ),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: values.keys
                    .map((x) => RadioListTile(
                          value: x, //set this to parent object of the
                          //group which determines the selected option.
                          groupValue: _selectedId,
                          onChanged: (value1) {
                            setState(() {
                              _selectedId = value1;
                              if (_selectedId.toString().contains("30%")) {
                                _sId = 0;
                              } else if (_selectedId
                                  .toString()
                                  .contains("20%")) {
                                _sId = 1;
                              } else if (_selectedId
                                  .toString()
                                  .contains("40%")) {
                                _sId = 2;
                              }
                              else{
                                _sId=3;
                              }
                            });
                          },
                          title: Text(
                            x,
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
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
                    child: const Text('OK'),
                    onPressed: () {
                      print(Constant.current_plan);
                      products = response.productDetails;
                     setState(() {
                       if(Platform.isAndroid){
                          if (_sId == 0)
                            Constant.currentM = 6;
                          else if (_sId == 1)
                            Constant.currentM = 3;
                          else if (_sId == 2)
                            Constant.currentM = 12;
                          else
                            Constant.currentM = 1;
                        }
                       else{
                         if (_sId == 0)
                           Constant.currentM = 1;
                         else if (_sId == 1)
                           Constant.currentM = 6;
                         else if (_sId == 2)
                           Constant.currentM = 3;
                         else
                           Constant.currentM = 12;
                       }
                      });

                      final PurchaseParam purchaseParam =
                          PurchaseParam(productDetails: products[_sId]);
                      _iap.buyConsumable(purchaseParam: purchaseParam);
                      Get.back();

                    },
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

}
