import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  String _email;
  String _userType;
  DateTime _expiryDate;
  Timer _authTimer;
  DateTime _timeToRefreshToken;
  Timer _timerToRefreshToken;
  String _refreshToken;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _token != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  String get email {
    return _email;
  }

  Future<void> login({String email, String password,String userType ='patient'}) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBcnTCcGjCJhBJPD3gFGzY4pm6O_glZwAw';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _email =email;
      _userType = userType;
      _refreshToken = responseData['refreshToken'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _timeToRefreshToken = _expiryDate.subtract(Duration(minutes: 20));

      _funStaySignIn();

      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final dataToSignIn =json.encode({
        'email': email,
        'password': password,
      });
      prefs.setString('dataToSignIn', dataToSignIn);
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'refreshToken': _refreshToken,
        'expiryDate': _expiryDate.toIso8601String(),
        'timeToRefreshToken': _timeToRefreshToken.toIso8601String(),
      });
      prefs.setString('dataToReload', userData);
    } catch (e) {
      throw e;
    }
  }
  Future<bool> tryToLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('dataToSignIn')) {
      return false;
    }
    final dataToSignIn =
    json.decode(prefs.getString('dataToSignIn')) as Map<String, Object>;
    print('${dataToSignIn['password']}');
    print('${dataToSignIn['email']}');
    login(password:dataToSignIn['password'], email:dataToSignIn['email']);
    notifyListeners();
    return true;
  }
  void _funStaySignIn() {
    if (_timerToRefreshToken != null) {
      _timerToRefreshToken.cancel();
    }
    _timerToRefreshToken = Timer(
        Duration(
            seconds: (_timeToRefreshToken.difference(DateTime.now()))
                .inSeconds),
        _funRefreshToken);
  }

  Future<void> _funRefreshToken() async {
    final url =
        'https://securetoken.googleapis.com/v1/token?key=AIzaSyBcnTCcGjCJhBJPD3gFGzY4pm6O_glZwAw';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'grant_type': "refresh_token",
            'refresh_token': _refreshToken,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['access_token'];
      _refreshToken = responseData['refresh_token'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expires_in'])));
      _timeToRefreshToken = _expiryDate.subtract(Duration(minutes: 20));
      _funStaySignIn();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final dataToReload = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'refreshToken': _refreshToken,
          'expiryDate': _expiryDate.toIso8601String(),
          'timeToRefreshToken': _timeToRefreshToken.toIso8601String(),
        },
      );
      prefs.clear();
      prefs.setString('dataToReload', dataToReload);
    } catch (e) {
      throw e;
    }
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }


}
