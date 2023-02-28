import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:sneaky_links/controllers/users_controller.dart';
import 'package:sneaky_links/flutter_flow/flutter_flow_theme.dart';

class FiltersItemWidget extends StatefulWidget {
  FiltersItemWidget(this.name);
  String name;

  @override
  State<FiltersItemWidget> createState() => _FiltersItemWidgetState();
}

class _FiltersItemWidgetState extends State<FiltersItemWidget> {

  var _choices = [
    "Yes",
    "No",
  ];
  var tags=0;
  final myController=Get.put(UsersController());

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(
          top: 19.40,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 27,
                right: 27,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        widget.name,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getSize(22),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 20,
                        right: 10,
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
                                onTap: () {
                                  setState(() {
                                    if(widget.name=="Party Favors") {
                                      print("Party" + tags.toString());
                                      myController.pFavors=tags.toString();
                                    }

                                    if(widget.name=="Profile Picture"){
                                      print("Profile" + tags.toString());
                                      myController.pPicture=tags.toString();
                                    }
                                    tags=index;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 44,
                                  width: 54,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: tags==index
                                          ? FlutterFlowTheme.primaryColor
                                          : ColorConstant.gray400,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    _choices[index],
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: tags==index
                                          ? FlutterFlowTheme.primaryColor
                                          : ColorConstant.black900,
                                      fontSize: getSize(14),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.10,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 12,
                right: 12,
              ),
              child: Container(
                height: 1,
                margin: EdgeInsets.only(
                  top:28,
                ),
                decoration: BoxDecoration(
                  color: ColorConstant.gray400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}