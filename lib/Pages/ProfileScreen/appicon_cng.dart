import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';
import 'package:get/get.dart';
import 'package:sneaky_links/Components/constants.dart';
import 'package:sneaky_links/Pages/ProfileScreen/app_icon.dart';
import 'package:sneaky_links/flutter_flow/flutter_flow_theme.dart';

class ChangeIconPage extends StatefulWidget {
  const ChangeIconPage({Key? key}) : super(key: key);

  @override
  State<ChangeIconPage> createState() => _ChangeIconPageState();
}

class _ChangeIconPageState extends State<ChangeIconPage> {
  int select = 0;

  List<IconSelector> lsi = [
    IconSelector(
      appIcon: IconType.Default,
      imageAsset: 'assets/images/logobg.png',
      name: 'Default',
      key: 'logo',
    ),
    IconSelector(
      appIcon: IconType.Book,
      imageAsset: 'assets/icon/book.png',
      name: 'Book',
      key: 'book',
    ),
    // IconSelector(
    //   appIcon: IconType.Beauty,
    //   imageAsset: 'assets/icon/beauty.png',
    //   name: 'Beauty',
    // ),
    IconSelector(
      appIcon: IconType.Doctor,
      imageAsset: 'assets/icon/doctor.png',
      name: 'Doctor',
      key: 'doctor',
    ),
    IconSelector(
      appIcon: IconType.Birds,
      imageAsset: 'assets/icon/birds.png',
      name: 'Birds',
      key: 'birds',
    ),
    IconSelector(
      appIcon: IconType.Lion,
      imageAsset: 'assets/icon/lion.png',
      name: 'Lion',
      key: 'lion',
    ),
    // IconSelector(
    //   appIcon: IconType.MyHeart,
    //   imageAsset: 'assets/icon/myheart.png',
    //   name: 'My Heart',
    // ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterDynamicIcon.getApplicationIconBadgeNumber().then((v) {
      setState(() {
      });
    });

    FlutterDynamicIcon.getAlternateIconName().then((v) {
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Icon(Icons.arrow_back_ios,
              size: MediaQuery.of(context).size.height<750?18:22,),
          ),
          color: Colors.black,
        ),
        backgroundColor: Colors.white.withOpacity(0),
        elevation: 0,
        // automaticallyImplyLeading: false,
        title: Text("Discrete App Icon",style: TextStyle(
          // letterSpacing: 2.0,
          fontSize: MediaQuery.of(context).size.height<750?20:24,
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontFamily: 'Poppins',
        ),
        ),

      ),
      body: Wrap(
        children: List.generate(
            lsi.length,
            (index) => GestureDetector(
                  onTap: () async {
                    // AppIcon.setLauncherIcon(lsi[index].appIcon);
                    // FlutterIconSwitcher.updateIcon('MainActivity');
                    try {
                      if (await FlutterDynamicIcon.supportsAlternateIcons) {
                        await FlutterDynamicIcon.setAlternateIconName(lsi[index].key,
                            showAlert: true);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("App icon change successful"),
                        ));
                        FlutterDynamicIcon.getAlternateIconName().then((v) {
                          setState(() {
                            select = index;
                          });
                        });
                        return;
                      }
                    } on PlatformException {
                    } catch (e) {}
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Failed to change app icon"),
                    ));

                  },
                  child: IconSelector1(lsi[index].appIcon,
                      lsi[index].imageAsset, lsi[index].name,index),
                )),
      ),
    );
  }

  Widget IconSelector1(appIcon, imageAsset, name, index) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: select != index
                  ? FlutterFlowTheme.grey1
                  : FlutterFlowTheme.primaryColor,
              width: 2)),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            imageAsset,
            height: 60,
          ),
          Text(name),
        ],
      ),
    );
  }

}

class IconSelector {
  final IconType appIcon;
  final String imageAsset;
  final String name;
  final String key;

  IconSelector(
      {required this.appIcon, required this.imageAsset, required this.name, required this.key});
}
