import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/shared/theme_shared.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_project/model/auth.dart'; 
import 'package:flutter_project/model/account.dart'; 
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

part 'welcome_pages.dart';
part 'login.dart';
part 'home.dart';
part 'editprofile.dart';
part 'transfersaldo.dart';
part 'mutasi.dart';

const String _apiUrl= 'http://localhost:8080';
final _dio = Dio();
final _storage = GetStorage();