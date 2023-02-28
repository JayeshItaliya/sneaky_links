import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaky_links/Components/constants.dart';
import 'package:sneaky_links/Models/LoginModal.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sneaky_links/Pages/AuthScreen/signIn.dart';
import 'package:sneaky_links/Pages/main_page.dart';
import 'package:sneaky_links/flutter_flow/flutter_flow_theme.dart';
import '../../Services/api_repository.dart';

class SetProfile extends StatefulWidget {
  const SetProfile({Key? key}) : super(key: key);

  @override
  _Profile1State createState() => _Profile1State();
}

class _Profile1State extends State<SetProfile> {
  GlobalKey<FormState> _formKeyp = GlobalKey<FormState>();
  GlobalKey<FormState> _formKeypInterest = GlobalKey<FormState>();
  var item = [];
  late String valueText;
  late String codeDialog;

  Future<void> _displayTextInputDialog(BuildContext context) async {
    TextEditingController _textFieldController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return Form(
            key:_formKeypInterest ,
            child:  AlertDialog(
              title: const Text('Interests'),
              content: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return ("Please Enter Interests");
                  }
                },
                onChanged: (value) {
                  setState(() {
                    valueText = value;
                  });
                },
                controller: _textFieldController,
                decoration:
                InputDecoration(hintText: "Enter Your Field Of Interest"),
              ),
              actions: <Widget>[
                FlatButton(
                  textColor: Colors.black,
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
                    if(_formKeypInterest.currentState!.validate()){
                      setState(() {
                        item.add(valueText);
                        codeDialog = valueText;
                        Get.back();
                      });
                    }
                  },
                ),
              ],
            ),
          );
        });
  }

  var selectedValue = "Choose Gender";
  List<String> Gender = ['Male', 'Female', 'Trans','Other'];


  var selectedValue7 = "Choose Interest In";
  List<String> Interested = [];
  var InterestInid = new Map<String, String>();

  var selectedValue5 = "Choose Body Type";
  List<String> BodyType = [];
  var BodyTypeid = new Map<String, String>();
  var yourActiveIndex = 0;

  final unmcontroller = TextEditingController();
  final agecontroller = TextEditingController();
  final loccontroller = TextEditingController();
  final zipcontroller = TextEditingController();
  final workcontroller = TextEditingController();

  late GetProfile userdata;
  late DynamicModel devModel;

  PickedFile? _imageFile;
  String userImage = "";
  final ImagePicker _picker = ImagePicker();
  Position? position;
  int pos=0;
  bool isloading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      unmcontroller.text = Constant.name;
    });
    getData();
    determinePosition().then((value) {
      if (value != null) {
        setState(() {
          position = value;
        });
      }
    });
    checkpermission_opencamera();
  }

  getData() {
    getProfile().then((value) {
      if (value != null) {
        setState(() {
          userdata = value;
          isloading = false;

          setState(() {
            unmcontroller.text = userdata.username;
            agecontroller.text = userdata.age.toString();
            loccontroller.text = userdata.location;
            zipcontroller.text = userdata.zipcode;
            Constant.avatarUrl = userdata.profilePicture;
            userImage = userdata.profilePicture;
            item.addAll(userdata.interests);
            selectedValue = userdata.gender;
            selectedValue5 = userdata.bodyType == ""
                ? selectedValue5
                : userdata.bodyType['name'];
            selectedValue7 = userdata.interestIn == ""
                ? selectedValue7
                : userdata.interestIn['name'];
          });
        });
      }
    });
    getDev().then((value) {
      if (value != null) {
        setState(() {
          devModel = value;
          setState(() {
            devModel.bodytype.forEach((element) {
              setState(() {
                BodyType.add(element['name']);
                BodyTypeid[element['name']] = element['id'].toString();
              });
            });

            devModel.interestIn.forEach((element) {
              setState(() {
                Interested.add(element['name']);
                InterestInid[element['name']] = element['id'].toString();
              });
            });
          });
        });
      }
    });
  }

  checkpermission_opencamera() async {
    var photosStatus = await Permission.photos.status;
    if (!photosStatus.isGranted) {
      await Permission.photos.request();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: MediaQuery.of(context).size.height < 750
            ? Size.fromHeight(50.0)
            : Size.fromHeight(55.0),
        child: AppBar(
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child:  Image.asset(
              "assets/images/back.png",
              scale: 1.6,
            ),
          ),
          backgroundColor: Colors.white.withOpacity(0),
          elevation: 0,
          centerTitle: true,
          // automaticallyImplyLeading: false,
          title: Image.asset(
          "assets/images/sneaky.png",
          height: 40,
          width: 40,
          fit: BoxFit.cover,
        ),
        ),
      ),
      body: SingleChildScrollView(
        child: isloading
            ? Center(child: CircularProgressIndicator())
            : Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 200),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 0.0, right: 0.0, bottom: 18.0, top: 0.0),
                          child: SizedBox(
                              height:
                              MediaQuery.of(context).size.height / 3 - 40,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: userdata.photos.length > 0
                                      ? Carousel(
                                    images: userdata.photos
                                        .map((e) =>
                                        CachedNetworkImage(
                                          imageUrl:
                                          e['photo'],
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder:
                                              (context, url,
                                              downloadProgress) =>
                                              Center(
                                                child: CircularProgressIndicator(
                                                    value: downloadProgress
                                                        .progress),
                                              ),
                                          errorWidget: (context,
                                              url,
                                              error) =>
                                              Image.asset(
                                                "assets/images/discover.png",
                                                fit: BoxFit
                                                    .cover,
                                              ),
                                        ))
                                        .toList(),
                                    autoplay: false,
                                    boxFit: BoxFit.cover,
                                    showIndicator: false,
                                    dotSize: 5.0,
                                    dotSpacing: 15.0,
                                    dotColor: Colors.white,
                                    indicatorBgPadding: 5.0,
                                    // noRadiusForIndicator: true,
                                    // moveIndicatorFromBottom: 180.0,
                                    dotBgColor: Colors.black
                                        .withOpacity(0.3),
                                    // borderRadius: false,
                                    // showIndicator: false,
                                    borderRadius: false,
                                    moveIndicatorFromBottom:
                                    180.0,
                                    noRadiusForIndicator: true,
                                    overlayShadow: true,
                                    overlayShadowColors: Colors
                                        .white
                                        .withOpacity(0.3),
                                    overlayShadowSize: 0.1,
                                    onImageChange:
                                        (ind, index) {
                                      setState(() {
                                        yourActiveIndex = index;
                                      });
                                    },
                                  )
                                      : Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: userdata.profilePicture != ""
                                          ? CachedNetworkImage(
                                          imageUrl:
                                          "${userdata.profilePicture ?? ""}",
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder:
                                              (context, url,
                                              downloadProgress) =>
                                              Center(
                                                child: CircularProgressIndicator(
                                                    value:
                                                    downloadProgress
                                                        .progress),
                                              ),
                                          errorWidget:
                                              (context, url, error) =>
                                              Image.asset(
                                                "assets/images/discover.png",
                                                fit: BoxFit.cover,
                                              ))
                                          : Image.asset(
                                        "assets/images/discover.png",
                                        fit: BoxFit.cover,
                                      )))),
                        ),
                        // Container(
                        //   height:
                        //       MediaQuery.of(context).size.height / 3 -
                        //           60,
                        //   padding: EdgeInsets.only(right: 8),
                        //   child: Align(
                        //     alignment: Alignment.bottomRight,
                        //     child: AnimatedSmoothIndicator(
                        //       activeIndex: yourActiveIndex,
                        //       count: userdata.photos.length > 0
                        //           ? userdata.photos.length
                        //           : 1,
                        //       effect: ExpandingDotsEffect(
                        //           dotHeight: 5,
                        //           dotWidth: 5,
                        //           activeDotColor: Colors.white,
                        //           dotColor: Colors.grey.shade100),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 90.0,
                      height: 90.0,
                      decoration: BoxDecoration(
                        color: const Color(0xff7c94b6),
                        image: DecorationImage(
                          image: NetworkImage(
                            userImage,
                          ),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        border: Border.all(
                          color: Colors.white,
                          width: 4.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: (){
                          showProfileDialog(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: ColorConstant.pinkA500,
                              width: getHorizontalSize(
                                1.00,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Update Profile",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: ColorConstant.pinkA500,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Full Name",
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Form(
                    key: _formKeyp,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          cursorColor: Colors.grey,
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14.0,
                              // height: 0.6,
                              color: Colors.black),
                          autofocus: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("Please Enter Your UserName");
                            }
                            return null;

                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10, top: 10),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:  Color(0xFFF7006A),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(05),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(05),
                                borderSide: BorderSide(
                                    color:  Color(0xFFF7006A),width: 1)),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFF7006A), width: 1),
                              borderRadius: BorderRadius.circular(05),
                            ),
                          ),
                          controller: unmcontroller,
                          keyboardType: TextInputType.text,
                          onSaved: (value) {
                            unmcontroller.text = value!;
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        // Basic Section Starts


                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 14, 0, 10),
                          child: Text(
                            "Age",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextFormField(
                          cursorColor: Colors.grey,
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14.0,
                              // height: 0.6,
                              color: Colors.black),
                          autofocus: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("Please Enter Your Age");
                            }
                            else if (int.parse(value)<18) {
                              return ("Please Enter Your Age Above 18");
                            }
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10, top: 10),
                            filled: true,
                            fillColor:  Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFF7006A),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(05),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(05),
                                borderSide: BorderSide(
                                    color:  Color(0xFFF7006A), width: 1)),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:  Color(0xFFF7006A), width: 1),
                              borderRadius: BorderRadius.circular(05),
                            ),
                          ),
                          controller: agecontroller,
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            agecontroller.text = value!;
                          },
                          textInputAction: TextInputAction.next,
                        ),
                       /* Padding(
                          padding: const EdgeInsets.fromLTRB(0, 14, 0, 10),
                          child: Text(
                            "Work",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextFormField(
                          cursorColor: Colors.grey,
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14.0,
                              // height: 0.6,
                              color: Colors.black),
                          autofocus: false,
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return ("Please Enter Your work");
                          //   }
                          // },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10, top: 10),
                            filled: true,
                            fillColor:  Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:Color(0xFFF7006A),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(05),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(05),
                                borderSide: BorderSide(
                                    color:  Color(0xFFF7006A), width: 1)),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:  Color(0xFFF7006A), width: 1),
                              borderRadius: BorderRadius.circular(05),
                            ),
                          ),
                          controller: workcontroller,
                          keyboardType: TextInputType.text,
                          onSaved: (value) {
                            workcontroller.text = value!;
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 14, 0, 10),
                          child: Text(
                            "Location",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextFormField(
                          cursorColor: Colors.grey,
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14.0,
                              // height: 0.6,
                              color: Colors.black),
                          autofocus: false,
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return ("Please Enter Your Location");
                          //   }
                          // },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10, top: 10),
                            filled: true,
                            suffixIcon: Icon(Icons.location_on_outlined),
                            fillColor:  Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFF7006A),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(05),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(05),
                                borderSide: BorderSide(
                                    color:  Color(0xFFF7006A),width: 1)),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFF7006A),width: 1),
                              borderRadius: BorderRadius.circular(05),
                            ),
                          ),
                          controller: loccontroller,
                          keyboardType: TextInputType.text,
                          onSaved: (value) {
                            loccontroller.text = value!;
                          },
                          textInputAction: TextInputAction.next,
                        ),*/
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 14, 0, 10),
                          child: Text(
                            "About",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextFormField(
                          cursorColor: Colors.grey,
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14.0,
                              // height: 0.6,
                              color: Colors.black),
                          autofocus: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("Please Enter Your About");
                            }
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10, top: 10),
                            filled: true,
                            fillColor:  Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFF7006A),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(05),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(05),
                                borderSide: BorderSide(
                                    color: Color(0xFFF7006A), width: 1)),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFF7006A),width: 1),
                              borderRadius: BorderRadius.circular(05),
                            ),
                          ),
                          controller: agecontroller,
                          keyboardType: TextInputType.text,
                          onSaved: (value) {
                            agecontroller.text = value!;
                          },
                          textInputAction: TextInputAction.next,
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 14, 0, 10),
                          child: Text(
                            "Zip Code",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextFormField(
                          cursorColor: Colors.grey,
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14.0,
                              // height: 0.6,
                              color: Colors.black),
                          autofocus: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("Please Enter Your Zipcode");
                            }
                            return null;

                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10, top: 10),
                            filled: true,
                            fillColor:  Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFF7006A),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(05),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(05),
                                borderSide: BorderSide(
                                    color: Color(0xFFF7006A), width: 1)),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:  Color(0xFFF7006A), width: 1),
                              borderRadius: BorderRadius.circular(05),
                            ),
                          ),
                          controller: zipcontroller,
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            zipcontroller.text = value!;
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 14, 0, 10),
                          child: Text(
                            "Gender",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        DropdownButtonFormField(
                          validator: (value) =>selectedValue == "Choose Gender" ? 'Gender required' : null,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(left: 25, right: 10),
                            filled: true,
                            fillColor:  Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFF7006A),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(05),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(05),
                                borderSide: BorderSide(
                                    color:  Color(0xFFF7006A), width: 1)),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFF7006A),width: 1),
                              borderRadius: BorderRadius.circular(05),
                            ),
                          ),
                          dropdownColor: Color(0xFFF9F9F9),
                          icon: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            size: 30,
                          ),
                          iconSize: 38,
                          // value: selectedValue,
                          hint: Text(selectedValue.toString()),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValue = newValue!;
                            });
                          },
                          items: Gender.map((value) => DropdownMenuItem(
                              value: value,
                              child: Text(
                                "$value",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                ),
                              ))).toList(),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 14, 0, 10),
                          child: Text(
                            "Body Type",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        DropdownButtonFormField(
                          validator: (value) => selectedValue5=="Choose Body Type" ? 'Body Type required' : null,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(left: 25, right: 10),
                            filled: true,
                            fillColor:  Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:Color(0xFFF7006A),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(05),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(05),
                                borderSide: BorderSide(
                                    color: Color(0xFFF7006A), width: 1)),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:Color(0xFFF7006A), width: 1),
                              borderRadius: BorderRadius.circular(05),
                            ),
                          ),
                          dropdownColor: Color(0xFFF9F9F9),
                          icon: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            size: 30,
                          ),
                          iconSize: 38,
                          hint: Text(selectedValue5.toString()),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValue5 = newValue!;
                              // print(BodyTypeid[selectedValue5]);
                            });
                          },
                          items: BodyType.map((value) => DropdownMenuItem(
                              value: value,
                              child: Text(
                                "$value",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                ),
                              ))).toList(),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 14, 0, 10),
                          child: Text(
                            "Interested In",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        DropdownButtonFormField(
                          validator: (value) => selectedValue7 == "Choose Interest In" ? 'Interested In required' : null,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(left: 25, right: 10),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFF7006A),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(05),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(05),
                                borderSide: BorderSide(
                                    color:Color(0xFFF7006A), width: 1)),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFF7006A), width: 1),
                              borderRadius: BorderRadius.circular(05),
                            ),
                          ),
                          dropdownColor: Color(0xFFF9F9F9),
                          icon: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            size: 30,
                          ),
                          iconSize: 38,
                          hint: Text(selectedValue7),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValue7 = newValue!;
                            });
                          },
                          items: Interested.map((value) => DropdownMenuItem(
                              value: value,
                              child: Text(
                                "$value",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                ),
                              ))).toList(),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 14, 0, 10),
                              child: Text(
                                "Interests",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            // InkWell(
                            //     onTap: () {
                            //       _displayTextInputDialog(context);
                            //     },
                            //     child: Icon(
                            //       Icons.edit,
                            //       size: 21,
                            //     )),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: ColorConstant.pinkA500,
                                  width: 1
                              )
                          ),
                          child: item.length==0?
                          Row(
                            children: [
                              SizedBox(width: 10,),
                              Container(
                                padding:EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xFFE6E6E6)),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(5)),
                                  color: Color(0xFFFEE5F0),
                                ),
                                child: InkWell(
                                    onTap: () {
                                      _displayTextInputDialog(context);
                                    },
                                    child: Icon(
                                      Icons.add,
                                      size: 21,
                                      color: Colors.black,

                                    )),
                              ),
                            ],
                          )
                                :Wrap(
                            direction: Axis.horizontal,

                            children: List.generate(
                                item.length,
                                    (index) {
                                 if (item.length - 1 == index)
                                   return  Row(
                                      children: [
                                        Stack(
                                          children: [
                                            InkWell(
                                              onTap:(){
                                                print(index);
                                              },
                                              child: Container(
                                                  height: 40,
                                                  width: 73,
                                                  // padding: EdgeInsets.all(2),
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 3, vertical: 5),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Color(0xFFE6E6E6)),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(5)),
                                                    color: pos == index
                                                        ? Color(0xFFF7006A)
                                                        : Color(0xFFFEE5F0),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "${item[index]}",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: 'Poppins',
                                                          color: pos == index?Colors.white:Colors.black),
                                                    ),
                                                  )),
                                            ),

                                            Positioned(
                                              left: 47,
                                              bottom: 18,
                                              child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    item.removeAt(index);
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.clear,
                                                  color:  Colors.black,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                          Row(
                                            children: [
                                              SizedBox(width: 10,),
                                              Container(
                                                padding:EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Color(0xFFE6E6E6)),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(5)),
                                                  color: Color(0xFFFEE5F0),
                                                ),
                                                child: InkWell(
                                                    onTap: () {
                                                      _displayTextInputDialog(context);
                                                    },
                                                    child: Icon(
                                                      Icons.add,
                                                      size: 21,
                                                      color: Colors.black,

                                                    )),
                                              ),
                                            ],
                                          ),
                                      ],
                                    );
                                 return  Stack(
                                   children: [
                                     InkWell(
                                       onTap:(){
                                         print(index);
                                       },
                                       child: Container(
                                           height: 40,
                                           width: 73,
                                           // padding: EdgeInsets.all(2),
                                           margin: EdgeInsets.symmetric(
                                               horizontal: 3, vertical: 5),
                                           decoration: BoxDecoration(
                                             border: Border.all(
                                                 color: Color(0xFFE6E6E6)),
                                             borderRadius: BorderRadius.all(
                                                 Radius.circular(5)),
                                             color: pos == index
                                                 ? Color(0xFFF7006A)
                                                 : Color(0xFFFEE5F0),
                                           ),
                                           child: Center(
                                             child: Text(
                                               "${item[index]}",
                                               textAlign: TextAlign.center,
                                               style: TextStyle(
                                                   fontSize: 14,
                                                   fontFamily: 'Poppins',
                                                   color: pos == index?Colors.white:Colors.black),
                                             ),
                                           )),
                                     ),

                                     Positioned(
                                       left: 47,
                                       bottom: 18,
                                       child: IconButton(
                                         onPressed: () {
                                           setState(() {
                                             item.removeAt(index);
                                           });
                                         },
                                         icon: Icon(
                                           Icons.clear,
                                           color:  Colors.black,
                                         ),
                                       ),
                                     )
                                   ],
                                 );
                                }
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if(_formKeyp.currentState!.validate()&&userImage.isNotEmpty) {
                              if (item.isNotEmpty) {
                                determinePosition().then((value) {
                                  if (value != null)
                                    setState(() {
                                      position = value;
                                      _updateProfile();
                                    });
                                });
                              }
                              else {
                                showLongToast("Add Your interests");
                              }
                            }
                            else {
                              if(userImage.isEmpty)
                              showLongToast("Update Your Profile Picture");
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: getHorizontalSize(
                                27.00,
                              ),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              height: 40.00,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  getHorizontalSize(
                                    10.00,
                                  ),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment(
                                    0.5,
                                    -3.0616171314629196e-17,
                                  ),
                                  end: Alignment(
                                    0.5,
                                    0.9999999999999999,
                                  ),
                                  colors: [
                                    ColorConstant.pinkA500,
                                    ColorConstant.pinkA500,
                                  ],
                                ),
                              ),
                              child: Text(
                                "Save",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: ColorConstant.whiteA700,
                                  fontSize: getFontSize(
                                    20,
                                  ),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
      imageQuality: 70,
      maxHeight: 280,
      maxWidth: 640
    );
    setState(() {
      _imageFile = pickedFile;
      print(_imageFile);
      if (_imageFile?.path != null) {
        updateImage();

      }
    });
  }

  //to ensure image is uploading from the native android
  bool isFileUploading = false;

  showProfileDialog(context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text("Choose Action"),
        // content: new Text("Do you want to logout?"),
        actions: [
          CupertinoDialogAction(
              onPressed: () {
                takePhoto(ImageSource.camera);
                Get.back();
              },
              isDefaultAction: true,
              child: new Text(
                "Camera",
                style: TextStyle(color: FlutterFlowTheme.blue),
              )),
          CupertinoDialogAction(
              onPressed: () {
                takePhoto(ImageSource.gallery);
                Get.back();
              },
              isDefaultAction: true,
              child: new Text(
                "Gallery",
                style: TextStyle(color: FlutterFlowTheme.blue),
              ))
        ],
      ),
    );
  }

  Future updateImage() async {
    EasyLoading.show(status: "Loading...");
    var headers = {'Authorization': 'Bearer ' + Constant.access_token};

    try {
      var request =
          http.MultipartRequest('POST', Uri.parse(Constant.updateImage));
      request.fields.addAll({
        'mediaType': '1',
        'folderName': 'profiles',
        'contentType': 'image/jpeg'});
      request.files.add(
          await http.MultipartFile.fromPath('media', _imageFile!.path));
      request.headers.addAll(headers);


      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      if (response.statusCode == 200) {
        print(jsonBody['data']['media']);

        setState(() {
          userImage=jsonBody['data']['media'];
        });
        EasyLoading.dismiss();
      } else if (response.statusCode == 401) {
        EasyLoading.dismiss();
        SharedPreferences pref = await SharedPreferences.getInstance();

        pref.setString("username", "");
        pref.setString("email", "");
        // pref.setString("accessToken", "");
        pref.setBool("isLogin", false);
        Get.offAll(SignIn());
      } else {

        EasyLoading.showError(jsonBody['message']);
        // EasyLoading.showError("The email you entered doesn't appear to belong to an account. Please check your email and try again.");
      }
    } catch (e) {
      print(e.toString());
      EasyLoading.showError("Oops!");
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
    }
  }

  Future _updateProfile() async {
    EasyLoading.show(status: "Loading...");
    SharedPreferences pref = await SharedPreferences.getInstance();


    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };

    try {
      var request = http.Request('POST', Uri.parse(Constant.updateProfile));
      request.body = json.encode({
        "username": unmcontroller.text,
        "gender": selectedValue.toLowerCase(),
        "age": agecontroller.text,
        // "work": workcontroller.text,
        // "location": loccontroller.text,
        "zipcode": zipcontroller.text,
        "interests" :item,
        "latitude": position!.latitude,
        "longitude": position!.longitude,
        "bodyTypeId": BodyTypeid[selectedValue5],
        "interestInId": InterestInid[selectedValue7],
        "profilePicture":userImage
      });
      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      print(jsonBody.toString());
      if (response.statusCode == 200) {
        // print("hello");

        // GetProfile user = GetProfile.fromJson(jsonBody['data']);
        pref.setString("username", unmcontroller.text);
        pref.setString("avatarUrl", userImage);
        pref.setBool(Constant.user_id+"updateProfile", true);


        setState(() {
          Constant.name = unmcontroller.text;
          Constant.avatarUrl=userImage;

        });
        EasyLoading.showSuccess("Updated");

        Get.offAll(NavBarPage(currentPage: 'DiscoverScreen',));



      } else {
        EasyLoading.showError(jsonBody['message']);
        print(jsonBody.toString());
        // EasyLoading.showError("The email you entered doesn't appear to belong to an account. Please check your email and try again.");
      }
    } catch (e) {
      print(e.toString());
      EasyLoading.showError("Oops!");
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
    }
  }

}
