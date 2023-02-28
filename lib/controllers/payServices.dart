import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaky_links/Components/constants.dart';

class ProviderModel with ChangeNotifier {
  final InAppPurchase _iap = InAppPurchase.instance;
  bool available = false;
  late StreamSubscription<List<PurchaseDetails>> subscription;
  List products = [];
  List purchases = [];

// here to add more Products in this case we have 2 Product IDs
  final String mySecondProductID = 'sneakylinkdiamondplan';
  final String mythirdProductID = 'sneakylinkpremiumplan';
  final String myfourProductID = 'sneakylinkeliteplan';

// here to add more Products in this case we have 2 Product IDs
  final String IOSmySecondProductID = 'diamondPlan';
  final String IOSmythirdProductID = 'premiumPlan';
  final String IOSmyfourProductID = 'elitePlan';

// here to Create boolean for our Second Product to check if its Purchased our not.
  bool _isSecondItemPurchased = false;

  bool get isSecondItemPurchased => _isSecondItemPurchased;

  set isSecondItemPurchased(bool value) {
    _isSecondItemPurchased = value;
    notifyListeners();
  }

  bool _isThirdItemPurchased = false;

  bool get isthirdItemPurchased => _isThirdItemPurchased;

  set isthirdItemPurchased(bool value) {
    _isThirdItemPurchased = value;
    notifyListeners();
  }

  void initialize() async {
    available = await _iap.isAvailable();
    if (available) {
      await _getProducts();

      subscription = _iap.purchaseStream.listen((data) async {
        purchases.addAll(data);
        notifyListeners();
        for (PurchaseDetails purchase in purchases) {
          debugPrint("All Data");
          //SOLUTION
          if (Platform.isAndroid) {
            await _iap.completePurchase(purchase);

            if (purchase.status.toString() != "PurchaseStatus.error") {
              receipt_data(purchase);
            }
          } else if (Platform.isIOS) {
            await _iap.completePurchase(purchase);
            if (purchase.pendingCompletePurchase) {
              verifyreceipt_data(purchase);
            }
          }
        }
      });
    }
  }

  void verifyPurchase() {
//   here verify and complete our second Product Purchase
    PurchaseDetails secondPurchase = hasPurchased(mySecondProductID);
    if (secondPurchase != null &&
        secondPurchase.status == PurchaseStatus.purchased) {
      if (secondPurchase.pendingCompletePurchase) {
        _iap.completePurchase(secondPurchase);
        if (secondPurchase != null &&
            secondPurchase.status == PurchaseStatus.purchased) {
          // showLongToast(purchase.toString());
          // debugPrint(secondPurchase.billingClientPurchase);
          // receipt_data(secondPurchase.billingClientPurchase);
          isSecondItemPurchased = true;
          showLongToast(secondPurchase.toString());

          // receipt_data(secondPurchase.verificationData.localVerificationData,secondPurchase.productID);
          notifyListeners();
        }
      }
    }
//   here verify and complete our second Product Purchase
    PurchaseDetails thirdPurchase = hasPurchased(mythirdProductID);
    if (thirdPurchase != null &&
        thirdPurchase.status == PurchaseStatus.purchased) {
      if (thirdPurchase.pendingCompletePurchase) {
        _iap.completePurchase(thirdPurchase);

        if (thirdPurchase != null &&
            thirdPurchase.status == PurchaseStatus.purchased) {
          showLongToast(thirdPurchase.toString());
          // debugPrint(secondPurchase.billingClientPurchase);
          // receipt_data(secondPurchase.billingClientPurchase);
          isthirdItemPurchased = true;
          notifyListeners();
        }
      }
    }
//   here verify and complete our second Product Purchase
    PurchaseDetails fourPurchase = hasPurchased(myfourProductID);
    if (fourPurchase != null &&
        fourPurchase.status == PurchaseStatus.purchased) {
      if (fourPurchase.pendingCompletePurchase) {
        _iap.completePurchase(fourPurchase);
        if (fourPurchase != null &&
            fourPurchase.status == PurchaseStatus.purchased) {
          showLongToast(fourPurchase.toString());
          isthirdItemPurchased = true;
          notifyListeners();
        }
      }
    }
  }

  PurchaseDetails hasPurchased(String productID) {
    return purchases
        .firstWhereOrNull((purchase) => purchase.productID == productID);
  }

  Future<void> _getProducts() async {
    Set<String> ids;
    if (Platform.isIOS)
      ids = {IOSmyfourProductID, IOSmythirdProductID, IOSmySecondProductID};
    else
      ids = {myfourProductID, mythirdProductID, mySecondProductID};
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    debugPrint(response.productDetails.toString());
    // products = response.productDetails;
    products =
        response.productDetails.sorted((a, b) => b.price.compareTo(a.price));
    products.swap(1, 2);
    notifyListeners();
  }

  Future<bool> verifyPurchased(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  Future receipt_data(purchase) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    debugPrint("+++");
    debugPrint("recepitData=>" + Constant.current_plan);
    debugPrint(
        "recepitData=>" + purchase.verificationData.localVerificationData);
    debugPrint(purchase.productID);
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
          "receipt": purchase.verificationData.localVerificationData,
          "expiredate": DateTime(
            DateTime.now().year,
            DateTime.now().month + Constant.currentM,
            DateTime.now().day,
            DateTime.now().hour,
            DateTime.now().minute,
            DateTime.now().second,
            DateTime.now().millisecond,
          ).millisecondsSinceEpoch,
          "month": Constant.currentM,
          "likerejectcount": 0,
          "partycount": 0,
          "messagecount": 0,
        },
        "planName": Constant.current_plan.toLowerCase() == "free"
            ? "VOYEUR"
            : Constant.current_plan.toLowerCase() == "platinum"
                ? "PREMIUM"
                : Constant.current_plan.toUpperCase(),
        "productId": "${purchase.productID}",
        "platform": Constant.device_type
      });
      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      if (response.statusCode == 200) {
        EasyLoading.showSuccess(jsonBody['message']);
        pref.setString("currentPlan",
            purchase.productID.toString().replaceAll("plan", "").toUpperCase());
        pref.setInt("plan_active", 1);
        Constant.current_plan =
            purchase.productID.toString().replaceAll("plan", "").toUpperCase();
        Constant.plan_active = 1;

        notifyListeners();
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

  Future verifyreceipt_data(purchase) async {
    debugPrint("+++");
    debugPrint(
        "recepitData=>" + purchase.verificationData.localVerificationData);
    debugPrint(purchase.productID);
    EasyLoading.show(status: "Loading...");
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + Constant.access_token
      };
      var request = http.Request(
          'POST', Uri.parse("https://sandbox.itunes.apple.com/verifyReceipt"));
      request.body = json.encode(
          {"receipt-data": purchase.verificationData.localVerificationData});
      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      if (response.statusCode == 200) {
        receipt_data(purchase);
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
}
