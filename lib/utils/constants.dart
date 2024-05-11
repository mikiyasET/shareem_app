import 'package:flutter/material.dart';
import 'package:shareem_app/utils/enums.dart';

const BASE_URL = 'http://127.0.0.1:3100/api/v1';
const String accessToken_ = 'accessToken';
const String refreshToken_ = 'refreshToken';
const String draft_ = 'draft';

// --- Auth Routes ---
const String signInRoute = '/auth/signIn';
const String signUpRoute = '/auth/signUp';
const String confirmEmailRoute = '/auth/confirmEmail';
const String verifyEmailRoute = '/auth/verifyEmail';
const String forgotPasswordRoute = '/auth/forgot';
const String forgotPasswordVerifyRoute = '/auth/forgot/verify';
const String resetPasswordRoute = '/auth/forgot/reset';
const String refreshTokenRoute = '/auth/refresh';

const String completeProfileRoute = '/user/complete-reg';
const String meRoute = '/user/me';

const String createVentRoute = '/vent';
const String getVentsRoute = '/vent';
const String createCommentsRoute = '/comment';
const String getVentCommentsRoute = '/comment';
const String reactVentRoute = '/vent/like';
const String saveVentRoute = '/vent/save';
const String getSavedRoute = '/vent/saved';
const String getLikedRoute = '/vent/liked';
const String getVentedRoute = '/vent/vented';

const String getTagsRoute = '/tags/';

List<Map<String, dynamic>> genderList = [
  {"title": "Male", "preset": Gender.male, "iconData": Icons.male_rounded},
  {
    "title": "Female",
    "preset": Gender.female,
    "iconData": Icons.female_rounded
  },
  {
    "title": "None",
    "preset": Gender.none,
    "iconData": Icons.no_accounts_rounded
  },
];
final feelingList = [
  {'name': 'Happy', 'preset': 'happy'},
  {'name': 'Sad', 'preset': 'sad'},
  {'name': 'Angry', 'preset': 'angry'},
  {'name': 'Neutral', 'preset': 'none'}
];
