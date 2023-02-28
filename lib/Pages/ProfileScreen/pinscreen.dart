import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaky_links/Components/constants.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<PinScreen> {
  late SharedPreferences pref;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    pref = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: MediaQuery.of(context).size.height < 750
            ? Size.fromHeight(50.0)
            : Size.fromHeight(55.0),
        child: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Icon(
                Icons.arrow_back_ios,
                size: MediaQuery.of(context).size.height < 750 ? 18 : 22,
              ),
            ),
            color: Colors.black,
          ),
          backgroundColor: Colors.white.withOpacity(0),
          elevation: 0,
          title: Text(
            "Optional Pin",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height < 750 ? 20 : 24,
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
      body: Container(
        child: Padding(
          padding: MediaQuery.of(context).size.height < 750
              ? const EdgeInsets.fromLTRB(28, 0, 28, 0)
              : const EdgeInsets.fromLTRB(32, 0, 32, 0),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: MediaQuery.of(context).size.height < 750
                          ? const EdgeInsets.only(top: 20.0)
                          : const EdgeInsets.only(top: 28.0),
                      child: ListTile(
                        leading: Text(
                          "Allow Passcode",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height < 750
                                  ? 12.5
                                  : 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        dense: true,
                        minLeadingWidth: 0,
                        contentPadding: EdgeInsets.zero,
                        minVerticalPadding: 0,
                        trailing: Switch(
                          activeTrackColor: Color(0xFFFF99D6),
                          activeColor: Colors.white,
                          activeThumbImage: AssetImage(
                            'assets/images/img.png',
                          ),
                          inactiveThumbImage:
                              AssetImage('assets/images/img_1.png'),
                          value: Constant.islock,
                          onChanged: (value) {
                            // save(value);
                            if (value) {
                              screenLock<void>(
                                context: context,
                                title: Text("Enter New Password"),
                                correctString: "1234",
                                confirmation: true,
                                didConfirmed: (matchedText) {
                                  print(matchedText);
                                  Constant.locknum = matchedText;
                                  pref.setBool("islock", value);
                                  pref.setString("locknum", matchedText);
                                  setState(() {
                                    Constant.islock = value;
                                  });
                                  Navigator.pop(context);
                                },
                                didUnlocked: () {
                                  // Navigator.pop(context);
                                  // screenLock<void>(
                                  //   context: context,
                                  //   title: Text("Confirm New Password"),
                                  //   correctString: Constant.locknum.toString(),
                                  //
                                  // );
                                },
                              );
                            } else {
                              pref.setBool("islock", value);
                              setState(() {
                                Constant.islock = value;
                              });
                            }
                          },
                        ),
                        onTap: () {
                          // setState(() {
                          //   Constant.islock = true;
                          //   pref.setBool("islock", true);
                          // });
                        },
                      ),
                    ),
                    if (Constant.islock)
                      Padding(
                        padding: MediaQuery.of(context).size.height < 750
                            ? const EdgeInsets.only(top: 6.0)
                            : const EdgeInsets.only(top: 10.0),
                        child: ListTile(
                          leading: Text(
                            "Change Passcode",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height < 750
                                        ? 12.5
                                        : 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          minLeadingWidth: 0,
                          visualDensity:
                              VisualDensity(horizontal: 0, vertical: -4),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          minVerticalPadding: 0,
                          // trailing: Switch(
                          //   activeTrackColor: Color(0xFFFF99D6),
                          //   activeColor: Colors.white,
                          //   activeThumbImage: AssetImage(
                          //     'assets/images/img.png',
                          //   ),
                          //   inactiveThumbImage:
                          //       AssetImage('assets/images/img_1.png'),
                          //   value: status1,
                          //   onChanged: (value) {
                          //     // save(value);
                          //     setState(() {
                          //       status1 = value;
                          //     });
                          //   },
                          // ),
                          selectedTileColor: Colors.green[400],
                          onTap: () {
                            if (!Constant.islock) {
                              screenLock<void>(
                                context: context,
                                title: Text("Please Enter Old Password"),
                                correctString: Constant.locknum,
                                didUnlocked: () {
                                  screenLock<void>(
                                    context: context,
                                    title: Text("Enter New Password"),
                                    correctString: "1234",
                                    confirmation: true,
                                    didConfirmed: (matchedText) {
                                      print(matchedText);
                                      Constant.locknum = matchedText;
                                      pref.setString("locknum", matchedText);

                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              );
                            } else {
                              screenLock<void>(
                                context: context,
                                title: Text("Enter New Password"),
                                correctString: "1234",
                                confirmation: true,
                                didConfirmed: (matchedText) {
                                  print(matchedText);
                                  Constant.locknum = matchedText;
                                  pref.setString("locknum", matchedText);
                                  setState(() {
                                    Constant.islock = true;
                                  });
                                  Navigator.pop(context);
                                },
                                didUnlocked: () {
                                  // Navigator.pop(context);
                                  // screenLock<void>(
                                  //   context: context,
                                  //   title: Text("Confirm New Password"),
                                  //   correctString: Constant.locknum.toString(),
                                  //
                                  // );
                                },
                              );
                            }
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
