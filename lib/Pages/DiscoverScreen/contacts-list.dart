import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart'as http;
import 'package:sneaky_links/Models/HideModel.dart';
import 'package:sneaky_links/Pages/DiscoverScreen/app-contact.class.dart';
import 'package:sneaky_links/flutter_flow/flutter_flow_theme.dart';

import '../../Components/constants.dart';
import '../../controllers/task_provider.dart';

class ContactsList extends StatefulWidget {
  final List<AppContact> contacts;
  Function() reloadContacts;

  ContactsList({Key? key, required this.contacts, required this.reloadContacts})
      : super(key: key);

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {



  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: ListView.builder(
        // physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.contacts.length,
        itemBuilder: (context, index) {
          AppContact contact = widget.contacts[index];
          return InkWell(
            onTap: () {
              setState(() {
                contact.hide = !contact.hide;
                unHide(contact.info.phones!.elementAt(0).value.toString());
              });
            },
            child: Column(
              children: [
                ListTile(
                  tileColor: contact.hide
                      ? FlutterFlowTheme.secondaryColor
                      : Colors.white,
                  title: Text(contact.info.displayName.toString()),
                  subtitle: Text(contact.info.phones!.length > 0
                      ? contact.info.phones!.elementAt(0).value.toString()
                      : ''),
                  contentPadding: EdgeInsets.only(left: 20),
                  // leading: ContactAvatar(contact, 36)
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future unHide(num) async {
    EasyLoading.show(status: "Loading...");

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer '+Constant.access_token
    };

    try {
      var request = http.Request(
          'POST', Uri.parse(Constant.getUsershide));
      request.body = json.encode({
        "phone": num
      });
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      print("++++++++"+jsonBody.toString());
      if (response.statusCode == 200) {
        EasyLoading.showSuccess(jsonBody['message']);

        // list.removeWhere(((item) => item.phone == num));


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
