import 'package:sneaky_links/Models/message.dart';

class MessagesModel {
  static late final Message messages;

  static updateMessages(dynamic message) async {
    messages=message;
  }
}