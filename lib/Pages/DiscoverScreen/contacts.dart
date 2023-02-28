import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sneaky_links/Models/HideModel.dart';
import 'package:sneaky_links/Pages/DiscoverScreen/app-contact.class.dart';
import 'package:sneaky_links/controllers/task_provider.dart';

import '../../flutter_flow/flutter_flow_theme.dart';
import 'contacts-list.dart';

class ContactListScreen extends StatefulWidget {
  String search;

  ContactListScreen({Key? key, required this.search}) : super(key: key);

  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  List<HideModel> list = [];
  List<dynamic> list1 = [];

  List<AppContact> contacts = [];
  List<AppContact> contactsFiltered = [];
  Map<String, Color> contactsColorMap = new Map();
  TextEditingController searchController = new TextEditingController();
  bool contactsLoaded = false;

  @override
  void initState() {
    super.initState();
    getPermissions();

    setState(() {
      searchController.text = widget.search;
    });
  }

  Future<PermissionStatus?> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts];
    } else if (permission == PermissionStatus.permanentlyDenied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts];
    } else {
      return permission;
    }
  }

  getPermissions() async {
    final PermissionStatus? permissionStatus =
        await _onAddcontactsClicked(context);
    if (permissionStatus == PermissionStatus.granted) {
      getAllContacts();
      searchController.addListener(() {
        filterContacts();
      });
    } else if (permissionStatus == PermissionStatus.denied) {
      getAllContacts();
      searchController.addListener(() {
        filterContacts();
      });
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      await Permission.microphone.request();
      await Permission.contacts.request();
    } else {
      print("getPermissions+++++");
      _showOpenAppSettingsDialog(context);
    }
    // _onAddcontactsClicked(context);
  }

  Future<PermissionStatus?> _onAddcontactsClicked(context) async {
    Permission permission;

    permission = Permission.microphone;

    PermissionStatus permissionStatus = await permission.status;
    if (!permissionStatus.isGranted) {
      await Permission.contacts.request();
      await Permission.microphone.request();
    } else {
      print("permission");
      await Permission.contacts.request();
      await Permission.microphone.request();
    }

    print(permissionStatus);

    if (permissionStatus == PermissionStatus.restricted) {
      print("getPermissions+++++restricted");
      _showOpenAppSettingsDialog(context);

      permissionStatus = await permission.status;

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted

        return permissionStatus;
      }
    }

    if (permissionStatus == PermissionStatus.permanentlyDenied) {
      print("getPermissions+++++permanentlyDenied");
      _showOpenAppSettingsDialog(context);

      permissionStatus = await permission.status;

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted

        return permissionStatus;
      }
    }

    if (permissionStatus == PermissionStatus.denied) {
      if (Platform.isIOS) {
        // print("getPermissions+++++Denied");
        // _showOpenAppSettingsDialog(context);
      } else {
        permissionStatus = await permission.request();
      }

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted

        return permissionStatus;
      }
    }

    if (permissionStatus == PermissionStatus.granted) {
      print('Permission granted');

      return permissionStatus;
    }
  }

  _showOpenAppSettingsDialog(context) async {
    print('Permission denied');
    await openAppSettings();
    // return CustomDialog.show(
    //   context,
    //   'Permission needed',
    //   'Photos permission is needed to select photos',
    //   'Open settings',
    //   openAppSettings,
    // );
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      final snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      final snackBar =
          SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  getAllContacts() async {
    List<AppContact> _contacts =
        (await ContactsService.getContacts()).map((contact) {
      return new AppContact(info: contact, hide: false);
    }).toList();
    print(_contacts.length);
    if (_contacts.length > 0) {
      setState(() {
        contacts = _contacts;
        // contacts.forEach((element) {
        //   if (list1.isNotEmpty) {
        //     print(list1.toString());
        //     if (list1
        //         .toString()
        //         .contains(element.info.phones!.elementAt(0).value.toString())) {
        //       setState(() {
        //         element.hide = true;
        //       });
        //     } else {
        //       setState(() {
        //         element.hide = false;
        //       });
        //     }
        //   }
        // });
        getData();
        // contactsLoaded = true;
      });
    } else {
      setState(() {
        contacts = _contacts;
        contactsLoaded = false;
      });
    }
  }

  filterContacts() {
    List<AppContact> _contacts = [];
    _contacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String searchTermFlatten = flattenPhoneNumber(searchTerm);
        String contactName = contact.info.displayName!.toLowerCase();
        bool nameMatches = contactName.contains(searchTerm);
        if (nameMatches == true) {
          return true;
        }
        if (searchTermFlatten.isEmpty) {
          return false;
        }
        var phone = contact.info.phones!.firstWhere(
          (phn) {
            String phnFlattened = flattenPhoneNumber(phn.value.toString());
            return phnFlattened.contains(searchTermFlatten);
          },
        );
        return phone != null;
      });
    }
    setState(() {
      contactsFiltered = _contacts;
    });
  }

  getData() {
    TaskProvider().fetchHideList().then((resp) {
      if (this.mounted)
        setState(() {
          if (resp != null) {
            setState(() {
              list = resp;
              list.forEach((element) {
                list1.add(element.phone);
              });
            });

            if (contacts.isNotEmpty) {
              contacts.forEach((element) {
                if (list1.isNotEmpty) {
                  if (element.info.phones!.length > 0) {
                    if (list1.toString().contains(
                        element.info.phones!.elementAt(0).value.toString())) {
                      setState(() {
                        element.hide = true;
                      });
                    } else {
                      setState(() {
                        element.hide = false;
                      });
                    }
                  } else {
                    setState(() {
                      element.hide = false;
                    });
                  }
                }
              });
            }
            contactsLoaded = true;
          }
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    bool listItemsExist =
        ((isSearching == true && contactsFiltered.length > 0) ||
            (isSearching != true && contacts.length > 0));
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only(top: 10,left: 18,right: 18),
      child: Column(
        children: <Widget>[
          Container(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                errorBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: FlutterFlowTheme.grey1, width: 1),
                  borderRadius: BorderRadius.circular(15),
                ),
                contentPadding: EdgeInsets.zero,
                prefixIcon: Icon(
                  Icons.search,
                  color: FlutterFlowTheme.grey1,
                ),
                hintText: "Search",
                focusColor: FlutterFlowTheme.grey3,
// labelStyle: texts,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.grey3,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.grey3,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          contactsLoaded == true
              ? // if the contacts have not been loaded yet
              listItemsExist == true
                  ? // if we have contacts to show
                  ContactsList(
                      reloadContacts: () {
                        getAllContacts();
                      },
                      contacts:
                          isSearching == true ? contactsFiltered : contacts,
                    )
                  : Container(
                      padding: EdgeInsets.only(top: 40),
                      child: Text(
                        isSearching
                            ? 'No search results to show'
                            : 'No contacts exist',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ))
              : Container(
                  // still loading contacts
                  padding: EdgeInsets.only(top: 40),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
        ],
      ),
    );
  }
}
