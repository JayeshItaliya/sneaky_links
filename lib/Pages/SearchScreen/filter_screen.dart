
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sneaky_links/Components/constants.dart';
import 'package:sneaky_links/Models/LoginModal.dart';
import 'package:sneaky_links/Pages/SearchScreen/filter_item_widget.dart';
import 'package:sneaky_links/Pages/SearchScreen/fusers_list.dart';
import 'package:sneaky_links/Pages/SearchScreen/search_screen.dart';
import 'package:sneaky_links/Pages/main_page.dart';
import 'package:sneaky_links/Services/api_repository.dart';
import 'package:sneaky_links/controllers/users_controller.dart';
import 'package:sneaky_links/flutter_flow/flutter_flow_theme.dart';

class FiltersScreen extends StatefulWidget {
  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  RangeValues ageRange   = const RangeValues(0, 100);
  RangeValues heightRange = const RangeValues(0, 250);
  RangeValues endwH = const RangeValues(2, 20);
  RangeValues endwW = const RangeValues(0, 10);
  RangeValues salRange   = const RangeValues(23, 52);
  final myController=Get.put(UsersController());
  late DynamicModel devModel;

  var _choices = [
    "Male",
    "Female",
    "Trans",
    "Other"
  ];
  var tags=0;
  bool isLoading=true;

  var _interestedType = [
    "Man | Woman",
    "Man | Man",
    "Woman | Woman",
    "Trans | Man",
    "Trans | Woman",
    "Man+Man | Woman",
    "Woman+Woman | Man",
    "BDSM",
    "Group",
  ];
  List<int> intertags=[];
  var _bodyType = ["Slim", "Normal", "Mascular", "Large"];
  List<int> bodytags=[];
  var _ethnicity = ["Asian", "Europin", "African", "India"];
  List<int> citytags=[];

  var _education = ["College", "Bachelor's", "Master", "Phd","Doctor"];
  List<int> edutags=[];



  List<String> Education = [];
  var Educationid = new Map<String, String>();

  List<String> Ethnicity = [];
  var Ethnicityid = new Map<String, String>();

  List<String> BodyType = [];
  var BodyTypeid = new Map<String, String>();
  List<String> Interested = [];
  var InterestInid = new Map<String, String>();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getData();
    });

  }




  getData() {

    getDev().then((value) {
      if (value != null) {
        setState(() {
          devModel = value;

          setState(() {
            devModel.bodytype.forEach((element) {
              setState(() {
                BodyType.add(element['name']);
                BodyTypeid[element['name']]=element['id'].toString();
              });
            });
            devModel.education.forEach((element) {
              setState(() {
                Education.add(element['name']);
                Educationid[element['name']]=element['id'].toString();
              });
            });
            devModel.ethnicity.forEach((element) {
              setState(() {
                Ethnicity.add(element['name']);
                Ethnicityid[element['name']]=element['id'].toString();
              });
            });
            devModel.interestIn.forEach((element) {
              setState(() {
                Interested.add(element['name']);
                InterestInid[element['name']]=element['id'].toString();
              });
            });

            setState(() {
              isLoading=false;
            });

          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: getHorizontalSize(
          12.00,
        ),
        top: getVerticalSize(
          10.00,
        ),
        right: getHorizontalSize(
          12.00,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: getHorizontalSize(
                      27.50,
                    ),
                    right: getHorizontalSize(
                      27.50,
                    ),
                  ),
                  child: Text(
                    "Age",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: ColorConstant.black900,
                      fontSize: getFontSize(
                        20,
                      ),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: getVerticalSize(
                      9.00,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: getHorizontalSize(
                            12.50,
                          ),
                          right: getHorizontalSize(
                            12.50,
                          ),
                        ),
                        child: SliderTheme(
                          data: SliderThemeData(
                            trackShape: RoundedRectSliderTrackShape(),
                            inactiveTrackColor: ColorConstant.gray400,
                            thumbShape: RoundSliderThumbShape(),
                          ),
                          child: RangeSlider(
                            values: ageRange,
                            min: 0.0,
                            max: 100.0,
                            onChanged: (value) {
                              setState(() {
                                ageRange = value;
                                myController.Age =
                                    ageRange.start.toStringAsFixed(0) + "," +
                                        ageRange.end.toStringAsFixed(0);
                              });
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: getHorizontalSize(
                                  33.00,
                                ),
                                top: getVerticalSize(
                                  6.00,
                                ),
                              ),
                              child: Text(
                                "${ageRange.start.toStringAsFixed(0)}",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: ColorConstant.black900,
                                  fontSize: getFontSize(
                                    16,
                                  ),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                right: getHorizontalSize(
                                  33.00,
                                ),
                                top: getVerticalSize(
                                  6.00,
                                ),
                              ),
                              child: Text(
                                "${ageRange.end.toStringAsFixed(0)}",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: ColorConstant.black900,
                                  fontSize: getFontSize(
                                    16,
                                  ),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (Constant.plan_active ==0) ...[
            Container()
          ] else
            if(Constant.current_plan!='FREE')...[
              Padding(
                padding: EdgeInsets.only(
                  left: getHorizontalSize(
                    12.00,
                  ),
                  right: getHorizontalSize(
                    12.00,
                  ),
                ),
                child: Container(
                  height: getVerticalSize(
                    1.00,
                  ),

                  margin: EdgeInsets.only(
                    top: getVerticalSize(
                      34.00,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: ColorConstant.gray400,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: getVerticalSize(
                    33.00,
                  ),
                ),
                child:Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: getHorizontalSize(
                                27.00,
                              ),
                            ),
                            child: Text(
                              "Zipcode",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: ColorConstant.black900,
                                fontSize: getFontSize(
                                  20,
                                ),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: getVerticalSize(
                                3.00,
                              ),
                              right: getHorizontalSize(
                                27.00,
                              ),
                              bottom: getVerticalSize(
                                3.00,
                              ),
                            ),
                            child: InkWell(
                              onTap: (){
                                _displayTextInputDialog(context);
                              },
                              child: Container(
                                  height: getSize(
                                    24.00,
                                  ),
                                  width: getSize(
                                    24.00,
                                  ),
                                  child: Icon(
                                    Icons.edit,
                                    size: 20,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: getHorizontalSize(
                            27.00,
                          ),
                          top: getVerticalSize(
                            20.00,
                          ),
                          right: getHorizontalSize(
                            27.00,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(right: 12,bottom: 12),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                // _location="";
                              });
                            },
                            child: Container(
                              alignment: Alignment.centerLeft,
                              height: 46,
                              width: getVerticalSize(
                                120.00,
                              ),
                              // decoration: BoxDecoration(
                              // border: Border.all(
                              //   color: ColorConstant.gray400,
                              //   width: getHorizontalSize(
                              //     1.00,
                              //   ),
                              // ),
                              // ),
                              child: Text(
                                myController.zip,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: ColorConstant.black900,
                                  fontSize: getFontSize(
                                    22,
                                  ),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.10,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: getHorizontalSize(
                    12.00,
                  ),
                  right: getHorizontalSize(
                    12.00,
                  ),
                ),
                child: Container(
                  height: getVerticalSize(
                    1.00,
                  ),
                  margin: EdgeInsets.only(
                    top: getVerticalSize(
                      22.00,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: ColorConstant.gray400,
                  ),
                ),
              ),
            ]else...[
              Container(
              )
            ],

          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: getHorizontalSize(
                  29.25,
                ),
                top: getVerticalSize(
                  33.00,
                ),
                right: getHorizontalSize(
                  29.25,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      right: getHorizontalSize(
                        10.00,
                      ),
                    ),
                    child: Text(
                      "Gender",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: ColorConstant.black900,
                        fontSize: getFontSize(
                          20,
                        ),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: getVerticalSize(
                        20.00,
                      ),
                    ),
                    child: Container(
                      height: 34.00,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _choices.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: InkWell(
                              child: Container(
                                alignment: Alignment.center,
                                height: 44,
                                width: getVerticalSize(
                                  90.00,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: tags==index
                                        ? FlutterFlowTheme.primaryColor
                                        : ColorConstant.gray400,
                                    width: getHorizontalSize(
                                      1.00,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  _choices[index],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: tags==index
                                        ? FlutterFlowTheme.primaryColor
                                        : ColorConstant.black900,
                                    fontSize: getFontSize(
                                      14,
                                    ),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.10,
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  print(_choices[index]);
                                  myController.choice=_choices[index];
                                  tags=index;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: getHorizontalSize(
                12.00,
              ),
              right: getHorizontalSize(
                12.00,
              ),
            ),
            child: Container(
              height: getVerticalSize(
                1.00,
              ),

              margin: EdgeInsets.only(
                top: getVerticalSize(
                  34.00,
                ),
              ),
              decoration: BoxDecoration(
                color: ColorConstant.gray400,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: getVerticalSize(
                33.00,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: getHorizontalSize(
                        27.00,
                      ),
                      right: getHorizontalSize(
                        27.00,
                      ),
                    ),
                    child: Text(
                      "Height (Inches)",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: ColorConstant.black900,
                        fontSize: getFontSize(
                          20,
                        ),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: getVerticalSize(
                        9.00,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: getHorizontalSize(
                              12.50,
                            ),
                            right: getHorizontalSize(
                              12.50,
                            ),
                          ),
                          child: SliderTheme(
                            data: SliderThemeData(
                              trackShape: RoundedRectSliderTrackShape(),
                              inactiveTrackColor: ColorConstant.gray400,
                              thumbShape: RoundSliderThumbShape(),
                            ),
                            child: RangeSlider(
                              values: heightRange,
                              min: 0.0,
                              max: 250.0,
                              onChanged: (value) {
                                setState(() {
                                  heightRange = value;
                                  myController.Height =
                                      heightRange.start.toStringAsFixed(0) + "," +
                                          heightRange.end.toStringAsFixed(0);
                                });
                              },
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: getHorizontalSize(
                                    33.00,
                                  ),
                                  top: getVerticalSize(
                                    6.00,
                                  ),
                                ),
                                child: Text(
                                  heightRange.start.toStringAsFixed(0),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: ColorConstant.black900,
                                    fontSize: getFontSize(
                                      16,
                                    ),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  right: getHorizontalSize(
                                    33.00,
                                  ),
                                  top: getVerticalSize(
                                    6.00,
                                  ),
                                ),
                                child: Text(
                                  "${heightRange.end.toStringAsFixed(0)}",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: ColorConstant.black900,
                                    fontSize: getFontSize(
                                      16,
                                    ),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(
              left: getHorizontalSize(
                12.00,
              ),
              right: getHorizontalSize(
                12.00,
              ),
            ),
            child: Container(
              height: getVerticalSize(
                1.00,
              ),

              margin: EdgeInsets.only(
                top: getVerticalSize(
                  34.00,
                ),
              ),
              decoration: BoxDecoration(
                color: ColorConstant.gray400,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: getVerticalSize(
                33.00,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: getHorizontalSize(
                        27.00,
                      ),
                      right: getHorizontalSize(
                        27.00,
                      ),
                    ),
                    child: Text(
                      "Endowment Length (Inches)",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: ColorConstant.black900,
                        fontSize: getFontSize(
                          20,
                        ),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: getVerticalSize(
                        9.00,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: getHorizontalSize(
                              12.50,
                            ),
                            right: getHorizontalSize(
                              12.50,
                            ),
                          ),
                          child: SliderTheme(
                            data: SliderThemeData(
                              trackShape: RoundedRectSliderTrackShape(),
                              inactiveTrackColor: ColorConstant.gray400,
                              thumbShape: RoundSliderThumbShape(),
                            ),
                            child: RangeSlider(
                              values: endwH,
                              min: 2.0,
                              max: 20.0,
                              onChanged: (value) {
                                setState(() {
                                  endwH = value;
                                  myController.eHeight =
                                      endwH.start.toStringAsFixed(0) + "," +
                                          endwH.end.toStringAsFixed(0);
                                });
                              },
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: getHorizontalSize(
                                    33.00,
                                  ),
                                  top: getVerticalSize(
                                    6.00,
                                  ),
                                ),
                                child: Text(
                                  "${endwH.start.toStringAsFixed(0)}",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: ColorConstant.black900,
                                    fontSize: getFontSize(
                                      16,
                                    ),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  right: getHorizontalSize(
                                    33.00,
                                  ),
                                  top: getVerticalSize(
                                    6.00,
                                  ),
                                ),
                                child: Text(
                                  "${endwH.end.toStringAsFixed(0)}",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: ColorConstant.black900,
                                    fontSize: getFontSize(
                                      16,
                                    ),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(
              left: getHorizontalSize(
                12.00,
              ),
              right: getHorizontalSize(
                12.00,
              ),
            ),
            child: Container(
              height: getVerticalSize(
                1.00,
              ),

              margin: EdgeInsets.only(
                top: getVerticalSize(
                  34.00,
                ),
              ),
              decoration: BoxDecoration(
                color: ColorConstant.gray400,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: getVerticalSize(
                33.00,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: getHorizontalSize(
                        27.00,
                      ),
                      right: getHorizontalSize(
                        27.00,
                      ),
                    ),
                    child: Text(
                      "Endowment Width (Inches)",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: ColorConstant.black900,
                        fontSize: getFontSize(
                          20,
                        ),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: getVerticalSize(
                        9.00,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: getHorizontalSize(
                              12.50,
                            ),
                            right: getHorizontalSize(
                              12.50,
                            ),
                          ),
                          child: SliderTheme(
                            data: SliderThemeData(
                              trackShape: RoundedRectSliderTrackShape(),
                              inactiveTrackColor: ColorConstant.gray400,
                              thumbShape: RoundSliderThumbShape(),
                            ),
                            child: RangeSlider(
                              values: endwW,
                              min: 0.0,
                              max: 10.0,
                              onChanged: (value) {
                                setState(() {
                                  endwW = value;
                                  myController.eWidth =
                                      endwW.start.toStringAsFixed(0) + "," +
                                          endwW.end.toStringAsFixed(0);
                                });
                              },
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: getHorizontalSize(
                                    33.00,
                                  ),
                                  top: getVerticalSize(
                                    6.00,
                                  ),
                                ),
                                child: Text(
                                  "${endwW.start.toStringAsFixed(0)}",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: ColorConstant.black900,
                                    fontSize: getFontSize(
                                      16,
                                    ),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  right: getHorizontalSize(
                                    33.00,
                                  ),
                                  top: getVerticalSize(
                                    6.00,
                                  ),
                                ),
                                child: Text(
                                  "${endwW.end.toStringAsFixed(0)}",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: ColorConstant.black900,
                                    fontSize: getFontSize(
                                      16,
                                    ),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: getHorizontalSize(
                12.00,
              ),
              top: getVerticalSize(
                33.00,
              ),
              right: getHorizontalSize(
                12.00,
              ),
            ),
            child: Container(
              height: getVerticalSize(
                1.00,
              ),

              decoration: BoxDecoration(
                color: ColorConstant.gray400,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: getHorizontalSize(
                0.00,
              ),
              top: getVerticalSize(
                33.00,
              ),
              right: getHorizontalSize(
                0.00,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: getHorizontalSize(
                      27.00,
                    ),
                    right: getHorizontalSize(
                      27.00,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Education",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getFontSize(
                            20,
                          ),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: getVerticalSize(
                              20.00,
                            ),
                          ),
                          child:Wrap(
                            children: List.generate(
                                isLoading?0:devModel.education.length,
                                    (index) => Padding(
                                  padding: EdgeInsets.only(right: 12,bottom: 12),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {

                                        if(edutags.contains(devModel.education[index]['id'])) {
                                          edutags.removeWhere((
                                              element) => element == devModel.education[index]['id']);
                                        }
                                        else {
                                          edutags.add(devModel.education[index]['id']);
                                          print(edutags);
                                        }


                                        myController.EduType=edutags;

                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 40,
                                      width: getVerticalSize(
                                        120.00,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: edutags.contains(devModel.education[index]['id'])
                                              ? FlutterFlowTheme
                                              .primaryColor
                                              : ColorConstant.gray400,
                                          width: getHorizontalSize(
                                            1.00,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        devModel.education[index]['name'],
                                        style: TextStyle(
                                          color: edutags.contains(devModel.education[index]['id'])
                                              ? FlutterFlowTheme
                                              .primaryColor
                                              : ColorConstant.black900,
                                          fontSize: getFontSize(
                                            14,
                                          ),
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.10,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: getHorizontalSize(
                      12.00,
                    ),
                    top: getVerticalSize(
                      21.00,
                    ),
                    right: getHorizontalSize(
                      12.00,
                    ),
                  ),
                  child: Container(
                    height: getVerticalSize(
                      1.00,
                    ),

                    decoration: BoxDecoration(
                      color: ColorConstant.gray400,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: getHorizontalSize(
                      27.00,
                    ),
                    top: getVerticalSize(
                      33.00,
                    ),
                    right: getHorizontalSize(
                      27.00,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          right: getHorizontalSize(
                            10.00,
                          ),
                        ),
                        child: Text(
                          "Ethnicity",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: ColorConstant.black900,
                            fontSize: getFontSize(
                              20,
                            ),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: getVerticalSize(
                              20.00,
                            ),
                          ),
                          child:Wrap(
                            children: List.generate(
                                isLoading?0:devModel.ethnicity.length,                                    (index) => Padding(
                              padding: EdgeInsets.only(right: 12,bottom: 12),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if(citytags.contains(devModel.ethnicity[index]['id']))
                                      citytags.removeWhere((element) => element==devModel.ethnicity[index]['id']);
                                    else
                                      citytags.add(devModel.ethnicity[index]['id']);


                                    myController.EthniType=citytags;

                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  width: getVerticalSize(
                                    120.00,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: citytags.contains(devModel.ethnicity[index]['id'])
                                          ? FlutterFlowTheme
                                          .primaryColor
                                          : ColorConstant.gray400,
                                      width: getHorizontalSize(
                                        1.00,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    devModel.ethnicity[index]['name'],
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: citytags.contains(devModel.ethnicity[index]['id'])
                                          ? FlutterFlowTheme
                                          .primaryColor
                                          : ColorConstant.black900,
                                      fontSize: getFontSize(
                                        14,
                                      ),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.10,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: getHorizontalSize(
                      12.00,
                    ),
                    top: getVerticalSize(
                      33.00,
                    ),
                    right: getHorizontalSize(
                      12.00,
                    ),
                  ),
                  child: Container(
                    height: getVerticalSize(
                      1.00,
                    ),

                    decoration: BoxDecoration(
                      color: ColorConstant.gray400,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: getHorizontalSize(
                        27.00,
                      ),
                      top: getVerticalSize(
                        33.00,
                      ),
                      right: getHorizontalSize(
                        27.00,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            right: getHorizontalSize(
                              10.00,
                            ),
                          ),
                          child: Text(
                            "Body Type",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: ColorConstant.black900,
                              fontSize: getFontSize(
                                20,
                              ),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: getVerticalSize(
                                20.00,
                              ),
                            ),
                            child:Wrap(
                              children: List.generate(
                                  isLoading?0:devModel.bodytype.length,
                                      (index) => Padding(
                                    padding: EdgeInsets.only(right: 12,bottom: 12),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {

                                          if(bodytags.contains(devModel.bodytype[index]['id']))
                                            bodytags.removeWhere((element) => element==devModel.bodytype[index]['id']);
                                          else
                                            bodytags.add(devModel.bodytype[index]['id']);

                                          myController.BType=bodytags;

                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 40,
                                        width: getVerticalSize(
                                          120.00,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: bodytags.contains(devModel.bodytype[index]['id'])
                                                ? FlutterFlowTheme
                                                .primaryColor
                                                : ColorConstant.gray400,
                                            width: getHorizontalSize(
                                              1.00,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          devModel.bodytype[index]['name'],
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: bodytags.contains(devModel.bodytype[index]['id'])
                                                ? FlutterFlowTheme
                                                .primaryColor
                                                : ColorConstant.black900,
                                            fontSize: getFontSize(
                                              14,
                                            ),
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: 0.10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: getHorizontalSize(
                      12.00,
                    ),
                    top: getVerticalSize(
                      33.00,
                    ),
                    right: getHorizontalSize(
                      12.00,
                    ),
                  ),
                  child: Container(
                    height: getVerticalSize(
                      1.00,
                    ),

                    decoration: BoxDecoration(
                      color: ColorConstant.gray400,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: getVerticalSize(
                        33.00,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: getHorizontalSize(
                                27.00,
                              ),
                              right: getHorizontalSize(
                                27.00,
                              ),
                            ),
                            child: Text(
                              "Income (Dollars Per Year)",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: ColorConstant.black900,
                                fontSize: getFontSize(
                                  20,
                                ),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: getVerticalSize(
                                9.00,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: getHorizontalSize(
                                      12.50,
                                    ),
                                    right: getHorizontalSize(
                                      12.50,
                                    ),
                                  ),
                                  child: SliderTheme(
                                    data: SliderThemeData(
                                      trackShape: RoundedRectSliderTrackShape(),
                                      inactiveTrackColor: ColorConstant.gray400,
                                      thumbShape: RoundSliderThumbShape(),
                                    ),
                                    child: RangeSlider(
                                      values: salRange,
                                      min: 0.0,
                                      max: 100.0,
                                      onChanged: (value) {
                                        setState(() {
                                          salRange = value;
                                          myController.Sal =
                                              salRange.start.toStringAsFixed(0)+"000" + "," +
                                                  salRange.end.toStringAsFixed(0)+"000";
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: getHorizontalSize(
                                            33.00,
                                          ),
                                          top: getVerticalSize(
                                            6.00,
                                          ),
                                        ),
                                        child: Text(
                                          "${salRange.start.toStringAsFixed(0)}",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: ColorConstant.black900,
                                            fontSize: getFontSize(
                                              16,
                                            ),
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: getHorizontalSize(
                                            33.00,
                                          ),
                                          top: getVerticalSize(
                                            6.00,
                                          ),
                                        ),
                                        child: Text(
                                          "${salRange.end.toStringAsFixed(0)}M",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: ColorConstant.black900,
                                            fontSize: getFontSize(
                                              16,
                                            ),
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
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
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: getHorizontalSize(
                12.00,
              ),
              right: getHorizontalSize(
                12.00,
              ),
            ),
            child: Container(
              height: getVerticalSize(
                1.00,
              ),

              margin: EdgeInsets.only(
                top: getVerticalSize(
                  34.00,
                ),
              ),
              decoration: BoxDecoration(
                color: ColorConstant.gray400,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: getVerticalSize(
                18.00,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return FiltersItemWidget(index==0?"Party Favors":"Profile Picture");
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: getHorizontalSize(
                      27.75,
                    ),
                    top: getVerticalSize(
                      33.00,
                    ),
                    right: getHorizontalSize(
                      27.75,
                    ),
                  ),
                  child: Text(
                    "Interested In",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: ColorConstant.black900,
                      fontSize: getFontSize(
                        20,
                      ),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: getHorizontalSize(
                        27.00,
                      ),
                      top: getVerticalSize(
                        20.00,
                      ),
                      right: getHorizontalSize(
                        27.00,
                      ),

                    ),
                    child:Wrap(
                      children: List.generate(
                          isLoading?0:devModel.interestIn.length-1,
                              (index) => Padding(
                            padding: EdgeInsets.only(right: 12,bottom: 12),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if(intertags.contains(devModel.interestIn[index]['id']))
                                    intertags.removeWhere((element) => element==devModel.interestIn[index]['id']);
                                  else
                                    intertags.add(devModel.interestIn[index]['id']);

                                  myController.InterestedType=intertags;
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 44,
                                width: MediaQuery.of(context).size.width/2.9,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: intertags.contains(devModel.interestIn[index]['id'])
                                        ? FlutterFlowTheme
                                        .primaryColor
                                        : ColorConstant.gray400,
                                    width: getHorizontalSize(
                                      1.00,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  devModel.interestIn[index]['name'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: intertags.contains(devModel.interestIn[index]['id'])
                                        ? FlutterFlowTheme
                                        .primaryColor
                                        : ColorConstant.black900,
                                    fontSize: getFontSize(
                                      14,
                                    ),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.10,
                                  ),
                                ),
                              ),
                            ),
                          )
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: getVerticalSize(
                      184.40,
                    ),
                    bottom: getVerticalSize(
                      33.40,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      InkWell(
                        onTap: (){
                          setState(() {
                            myController.nearby.value=true;
                            myController.choice = "";
                            myController.zip = "";
                            myController.Age = "";
                            myController.Height = "";
                            myController.Sal = "";
                            myController.pFavors = "";
                            myController.pPicture = "";
                            myController.EduType = [];
                            myController.EthniType = [];
                            myController.BType = [];
                            myController.InterestedType = [];
                          });

                          Get.offAll(NavBarPage(currentPage:'SearchScreen',));

                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: getHorizontalSize(
                              27.00,
                            ),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            height: getVerticalSize(
                              45.00,
                            ),
                            width: getHorizontalSize(
                              87.00,
                            ),
                            decoration: BoxDecoration(
                              color: ColorConstant.bluegray100,
                              borderRadius: BorderRadius.circular(
                                getHorizontalSize(
                                  10.00,
                                ),
                              ),
                            ),
                            child: Text(
                              "Reset",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: ColorConstant.black900,
                                fontSize: getFontSize(
                                  14,
                                ),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          setState(() {
                            myController.nearby.value = false;
                          });
                          Get.to(FUsersList(false));
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: getHorizontalSize(
                              27.00,
                            ),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            height: getVerticalSize(
                              45.00,
                            ),
                            width: getHorizontalSize(
                              87.00,
                            ),
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
                                  ColorConstant.pinkA400,
                                  ColorConstant.pink500,
                                ],
                              ),
                            ),
                            child: Text(
                              "Done",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: ColorConstant.whiteA700,
                                fontSize: getFontSize(
                                  14,
                                ),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    final txtController=TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Zipcode'),
            content: TextField(
              controller: txtController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(hintText: "Zipcode"),
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
                child:const Text('OK'),
                onPressed: () {
                  setState(() {
                    if(txtController.text.isNotEmpty) {
                      myController.zip=txtController.text;
                      Get.back();
                    }
                    else{
                      Get.snackbar("", "Zipcode cannot be empty");
                    }
                  });
                },
              ),
            ],
          );
        });
  }
}
