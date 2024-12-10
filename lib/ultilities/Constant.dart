import 'dart:ui';

class Constant {

  // ignore: constant_identifier_names
  static const BACKEND_URL = "http://10.0.2.2:8080/nserve";

  // ignore: constant_identifier_names
  static const GENERATE_OTP_URL = "$BACKEND_URL/auth/generateOTP";

  // ignore: constant_identifier_names
  static const GENERATE_OTP_DRIVER_URL = "$BACKEND_URL/auth/driver/generateOTP";

  // ignore: constant_identifier_names
  static const REGISTER_DRIVER_URL = "$BACKEND_URL/users/registerDriver";

  // ignore: constant_identifier_names
  static const UPDATE_DRIVER_URL = "$BACKEND_URL/users/updateDriver";

  // ignore: constant_identifier_names
  static const VERIFY_OTP_URL = "$BACKEND_URL/auth/verifyOTP";

  // ignore: constant_identifier_names
  static const LOGOUT_URL = "$BACKEND_URL/auth/logout";

  // ignore: constant_identifier_names
  static const INTROSPECT_URL = "$BACKEND_URL/auth/introspect";

  // ignore: constant_identifier_names
  static const IMAGE_URL = "$BACKEND_URL/images/";

  // ignore: constant_identifier_names
  static const RESTAURANT_URL = "$BACKEND_URL/restaurants";

  // ignore: constant_identifier_names
  static const RESTAURANT_INFO_URL = "$RESTAURANT_URL/info";

  // ignore: constant_identifier_names
  static const CATEGORY_URL = "$BACKEND_URL/categories";

  // ignore: constant_identifier_names
  static const DRIVER_URL = "$BACKEND_URL/drivers";

  // ignore: constant_identifier_names
  static const DRIVER_INFO_URL = "$DRIVER_URL/info";

  // ignore: constant_identifier_names
  static const DRIVER_STATUS_URL = "$DRIVER_URL/status";

  // ignore: constant_identifier_names
  static const FOOD_URL = "$BACKEND_URL/foods";

  // ignore: constant_identifier_names
  static const ORDER_URL = "$BACKEND_URL/orders";

  // ignore: constant_identifier_names
  static const ORDER_DRIVER_URL = "$ORDER_URL/driver";

  // ignore: constant_identifier_names
  static const SHIPPING_FEE_URL = "$BACKEND_URL/orders/calculate-shipping-fee";

  // ignore: constant_identifier_names
  static const DRIVER_LOCATION_URL = "$DRIVER_URL/location";

  // ignore: constant_identifier_names
  static const DRIVER_DEPOSIT_URL = "$DRIVER_URL/deposit";


  // ignore: constant_identifier_names
  static const WEBSOCKET_URL = "$BACKEND_URL/ws";

  // ignore: constant_identifier_names
  static const IMG_URL = "https://res.cloudinary.com/dsdowcig9";

  static const JWT = "eyJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJxbmdvYzA3MDEyMDAyIiwic3ViIjoiOTQwZjJlM2ItNDY1Yi00ZjI1LWIzNTQtZDM2YWUxOGZiZjMyIiwiZXhwIjozNjE3MzM1MTQyMzksImlhdCI6MTczMzUxNDIzOSwianRpIjoiNjY1MjMwMTEtMzE4ZS00ZTUwLWI3NzktMWE1ZGRhMzkyYmU1Iiwic2NvcGUiOiJST0xFX0FETUlOIFJPTEVfUkVTVEFVUkFOVCBST0xFX0NVU1RPTUVSIFJPTEVfRFJJVkVSIn0.fyad8YgYSOMfiqFW7cdfIvjQGt2xuYyB45oM6PK-ze2HXMh_KrWFtjmJ26atRJsgyjuebTcGWJsBWosi-XMfQg";

  static const stripePublishableKey = "pk_test_51MPfTSA5vKPlbljEeTnHusfYFriKpHPpUJe0KNQIc9xB638GPdWRWO5RnzrLBeD6Am9NInVocj4AtJKSBUUA9GS700cQv3HfFQ";
//Nếu là Emulator ở máy thì dùng 10.0.2.2 nếu ngoài thì vào ipconfig check ipv4
}