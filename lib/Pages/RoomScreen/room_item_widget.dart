import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sneaky_links/Models/PartyModel.dart';
import 'package:sneaky_links/flutter_flow/flutter_flow_theme.dart';

class RoomsItemWidget extends StatelessWidget {
  PartyModel item;

  RoomsItemWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: getVerticalSize(
          10.00,
        ),
        bottom: getVerticalSize(
          10.00,
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          getHorizontalSize(
            10.00,
          ),
        ),
        image: item.coverPhoto == "" || item.coverPhoto == "AWS media URL"
            ? const DecorationImage(
                image: AssetImage(
                  'assets/images/img_2.png',
                ),
                fit: BoxFit.cover)
            : DecorationImage(
                image: NetworkImage(
                  item.coverPhoto,
                ),
                fit: BoxFit.cover),
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
            ColorConstant.gray30000,
            ColorConstant.gray500A1,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: getVerticalSize(
                26.00,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: getHorizontalSize(
                        28.00,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "${item.roomName}",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: ColorConstant.whiteA700,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 3.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                              Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 8.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ],
                            fontSize: getFontSize(
                              20,
                            ),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: getVerticalSize(
                              6.00,
                            ),
                            right: getHorizontalSize(
                              10.00,
                            ),
                          ),
                          child: Text(
                            item.location,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: ColorConstant.whiteA700,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 3.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                                Shadow(
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 8.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ],
                              fontSize: getFontSize(
                                12,
                              ),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
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
              top: getVerticalSize(
                48.00,
              ),
              bottom: getVerticalSize(
                9.99,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: getVerticalSize(
                    56.01,
                  ),
                  width: getHorizontalSize(
                    122.00,
                  ),
                  margin: EdgeInsets.only(
                    left: getHorizontalSize(
                      15.00,
                    ),
                  ),
                  child: Stack(
                      alignment: Alignment.center,
                      children: List.generate(
                          item.participants.length < 3
                              ? item.participants.length
                              : 3,
                          (index) => Align(
                                alignment: index == 0
                                    ? Alignment.centerLeft
                                    : index == 1
                                        ? Alignment.center
                                        : Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: getHorizontalSize(
                                      10.00,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          getSize(
                                            28.00,
                                          ),
                                        ),
                                        child: item.participants[index]
                                                    .profilePicture ==
                                                ""
                                            ? Image.asset(
                                                'assets/images/discover.png',
                                                height: getSize(
                                                  50.06,
                                                ),
                                                width: getSize(
                                                  50.06,
                                                ),
                                                fit: BoxFit.cover,
                                              )
                                            : CachedNetworkImage(
                                                imageUrl: item
                                                    .participants[index]
                                                    .profilePicture,
                                                height: getSize(
                                                  50.06,
                                                ),
                                                width: getSize(
                                                  50.06,
                                                ),
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    Center(
                                                        child: Image.asset(
                                                  "assets/images/discover.png",
                                                  height: getSize(
                                                    50.06,
                                                  ),
                                                  width: getSize(
                                                    50.06,
                                                  ),
                                                  fit: BoxFit.cover,
                                                )),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Center(
                                                            child: Image.asset(
                                                  "assets/images/discover.png",
                                                  height: getSize(
                                                    50.06,
                                                  ),
                                                  width: getSize(
                                                    50.06,
                                                  ),
                                                  fit: BoxFit.cover,
                                                )),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ))),
                ),
                /* Container(
                  margin: EdgeInsets.only(
                    top: getVerticalSize(
                      6.00,
                    ),
                    right: getHorizontalSize(
                      27.00,
                    ),
                    bottom: getVerticalSize(
                      4.01,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: ColorConstant.whiteA700,
                    borderRadius: BorderRadius.circular(
                      getHorizontalSize(
                        10.00,
                      ),
                    ),
                    border: Border.all(
                      color: ColorConstant.gray400,
                      width: getHorizontalSize(
                        1.00,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if(item.price>0)
                      Padding(
                        padding: EdgeInsets.only(
                          left: getHorizontalSize(
                            8.00,
                          ),
                          top: getVerticalSize(
                            8.00,
                          ),
                          bottom: getVerticalSize(
                            8.00,
                          ),
                        ),
                        child: Container(
                          height: getVerticalSize(
                            23.64,
                          ),
                          width: getHorizontalSize(
                            2.00,
                          ),
                          // child: Image.asset(
                          //   'assets/images/coin.png',
                          //   fit: BoxFit.fill,
                          // ),
                        ),
                      ),
                      if(item.price>0)
                        Padding(
                        padding: EdgeInsets.only(
                          left: getHorizontalSize(
                            8.00,
                          ),
                          top: getVerticalSize(
                            5.00,
                          ),
                          right: getHorizontalSize(
                            8.00,
                          ),
                          bottom: getVerticalSize(
                            5.00,
                          ),
                        ),
                        child: Text(
                          "\$ ${item.price}",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: ColorConstant.black900,
                            fontSize: getFontSize(
                              22,
                            ),
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }
}
