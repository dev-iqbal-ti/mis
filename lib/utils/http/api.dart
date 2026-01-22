class API {
  static const String baseUrl = 'http://10.0.2.2:3000/api';
  // static const String _baseUrl =
  //     'https://fa28-103-249-6-210.ngrok-free.app/api';

  static final getApis = GetApis();
  static final postApis = PostApis();

  static const String apiVersion = "v1";
  static String stytchSignUpUrl =
      "https://test.stytch.com/v1/passwords/session/reset";
  static String stytchLoginUrl =
      "https://test.stytch.com/v1/passwords/authenticate";
  static String stytchOauthAuthenticate =
      "https://test.stytch.com/v1/oauth/authenticate";
  static String stytchForgetPasswordUrl =
      "https://test.stytch.com/v1/passwords/email/reset/start";
  static String stytchOtpSendUrl =
      "https://test.stytch.com/v1/otps/email/login_or_create";
  static String stytchOtpVerifyUrl =
      "https://test.stytch.com/v1/otps/authenticate";
  static String oAuthGoogleStart =
      "https://test.stytch.com/v1/public/oauth/google/start";
  static String stytchUpdateUser = "https://test.stytch.com/v1/users";
  static String stytchSearchUserUrl = "https://test.stytch.com/v1/users/search";
  static String elevenlabsGetVoices = "https://api.elevenlabs.io/v1/voices";
  static String elevenlabsTextToSpeech =
      "https://api.elevenlabs.io/v1/text-to-speech";
  static String stytchRevokeSessionUrl =
      "https://test.stytch.com/v1/sessions/revoke";
}

class GetApis {
  final String getUser = "/user";
  final String fetchMusic = "/fetch-edls";
  final String fetchVoices = "/fetch-voices";
  final String fetchVideoList = "/fetch-video-list";
  final String createSession = "/create-session";
  final String userDetails = "/user-details";
  final String fetchUsedImages = "/fetch-used-images";
  final String deleteAccount = "/delete-user";
  final String updateView = "/update-view";
  // final String userDetails = "/user-details"
}

class PostApis {
  final String checkUser = "/check-user";
  final String signUp = "/signup";
  final String uploadImage = "/upload";
  final String textToSpeech = "/text-to-speech";
  final String createVideo = "/create-video";
  final String getSignedUrl = "/generate-signed-url";
  final String markAsFavourite = "/favourite";
  final String deleteVideo = "/delete-video";
  final String fetchVideoImages = "/fetch-video-images";
  final String fetchPropertyDetails = "/fetch-property-details";
  final String deleteImage = "/delete-image";
  final String excludeImage = "/exclude-image";
  final String downloadVideo = "/download-video";
  final String updateDetails = "/update-details";
}
