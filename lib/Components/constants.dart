import 'package:fluttertoast/fluttertoast.dart';

class Constant {
  static const String Appname = "Sneaky Links";

  // static const String base_url = "http://54.167.189.102/api/v1/";
  static const String base_url = "http://52.201.16.168/api/v1/";
  static const int Per_Page = 10;

  static String login = base_url + "auth/login";
  static String register = base_url + "auth/register";
  static String forgot_pwd = base_url + "forgot-passwords/start";
  static String verify_pwd = base_url + "forgot-passwords/verify";
  static String reset_pwd = base_url + "forgot-passwords/reset-password";
  static String getProfile = base_url + "users/get-profile";
  static String updateToken = base_url + "fcm/token";
  static String help = base_url + "help";
  static String createRoom = base_url + "rooms";
  static String userPosts = base_url + "posts";
  static String createAccount = base_url + "stripe/get-account";
  static String savePayment = base_url + "stripe/save-payment";
  static String createPosts = base_url + "posts";
  static String createComments = base_url + "comments";
  static String updateProfile = base_url + "users/edit-profile";
  static String getUsers = base_url + "users/all";
  static String profile_views = base_url + "users/profile-views";
  static String getUsershide = base_url + "users/hide";
  static String getUsersId = base_url + "users";
  static String logout = base_url + "users/logout";
  static String getMylike = base_url + "users/like/my";
  static String getUserslike = base_url + "users/like/list";
  static String getUsersPhotos = base_url + "users/get-photos";
  static String getdev = base_url + "dev";
  static String getchat = base_url + "chats";
  static String chatMsg = base_url + "chats/user";
  static String updateOptions = base_url + "chats/preferences";
  static String updateImage = base_url + "aws/s3-upload";
  static String rtctoken = base_url + "notification/rtctoken";
  static String updatedPhotos = base_url + "/users/multiple-photos";
  static String auto_delete_interval = base_url + "chats/user";
  static String reject_call = base_url + "notification/reject-call";
  static String getNoti = base_url + "notification";
  static String report = base_url + "user-reports";
  static String subscription = base_url + "user-subscription";

  static String termsUrl = "http://52.201.16.168/terms-of-use";
  static String privacyUrl = "http://52.201.16.168/privacy-policy";

  // static String SERVER_URL = "http://54.167.189.102/";
  static String SERVER_URL = "http://52.201.16.168/";
  static String AppId = '639e91ae67c2434db563d9e6241a90c7';
  static String Token = '';
  static int Uid = 0;
  static String channel = "";
  static String profilePicture = "";
  static String username = "";
  static String senderId = "0";
  static String type = "";

  static const publishableKey =
      "pk_live_51KIfWjKxHMI6m1cAw9zIKWiyiLK0byUFkm7tQ0c8MFkiCVeyb8FHfhDpssspABVYZRJZnDymY8W2e0Aj0Il3v4dr005VM8FAD7";
  static const String Server_KEY =
      "AAAAZuuHPjs:APA91bEVhALFOUeyXpO2UoxTkbGgxcSEz2M35TUXttSSLPLa4SXEq7nDudA0S4aU615l4DnLtjRjPfZztNDofeCaQKFJ7nkg-DrtN0LOY-UA3UMKV6HeYtPx8uw3E51xHDCXav_9Cdvq";

  static bool isLogin = false;
  static bool islock = false;
  static String locknum = "1234";
  static String name = "";
  static String replyunm = "";
  static String user_id = "";
  static String email = "";
  static String image = "";

  static String avatarUrl = "";
  static String phone = "";
  static String ccode = "";
  static String access_token = "";
  static String refreshToken = "";
  static String deviceId = "";
  static String device_type = "";
  static String device_token = "";

  static String receipt = "receipt";
  static String productID = "productID";
  static String expiredate = "expiredate";

  static String current_plan = "FREE";
  static int plan_active = 0;
  static bool upgradedMembermsg = false;
  static bool membersWithProfile = false;
  static String gender = "null";
  static int AutoIntervals = 0;
  static int currentM = 1;

  static String titleText = "Your Membership Plan has reached its limit.";
  static String description =
      "To continue enjoying Sneaky Links, please upgrade your account.";

  static String inviteCode = "SneakyLife";
  static String inviteCode1 = "SneakyLifeFree";
  static String inviteCode2 = "SneakyLifeElite";
  static String inviteCode3 = "SneakyLifeDiamond";
}

showLongToast(String s) {
  Fluttertoast.showToast(
    msg: s,
    toastLength: Toast.LENGTH_LONG,
  );
}

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}