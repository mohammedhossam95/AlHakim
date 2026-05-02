import 'dart:convert';
import 'dart:developer';

import 'package:alhakim/features/auth/data/models/auth_resp_model.dart';
import 'package:alhakim/features/auth/data/models/get_setting_response_model.dart';
import 'package:alhakim/features/auth/domain/entities/auth_entity.dart';
import 'package:alhakim/features/auth/domain/entities/setting_entity.dart';
import 'package:alhakim/injection_container.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/enums.dart';
import '../../utils/extension.dart';

abstract class _AppSharedPreferencesKeys {
  static const countryId = 'countryId';
  static const userId = 'userId';
  static const user = 'user';
  static const appTheme = 'appTheme';
  static const languageCode = 'languageCode';

  static const userCycle = 'userCycle';
  static const userType = 'userType';
  static const deviceUuid = 'deviceUuid';
  static const cartProviderId = 'cartProviderId';
  static const serviceTypeId = 'service_type_Id';
  static const salesselectedBooksKey = 'salesSelectedBooksKey';
  static const returnsSelectedBooksKey = 'returnsSelectedBooksKey';
  static const minProducts = 'minProducts';
  static const minInvoiceValue = 'minInvoiceValue';
  static const sessionId = 'sessionId';
  static const branches = 'branches';
  static const lastSyncedUserId = 'lastSyncedUserId';
  static const isAddressSynced = 'isAddressSynced';

  static const settings = 'settings';
}

abstract class AppSharedPreferences {
  final SharedPreferences instance;

  const AppSharedPreferences(Object object, {required this.instance});

  Future<void> clearSecureStorageOnFreshInstall();

  //region:: Country Id
  int? getCountryId();
  Future<bool> saveCountryId(int countryId);
  Future<bool> removeCountryId();

  //region:: Provider Id
  String? getCartProviderId();
  Future<bool> saveCartProviderId(String providerId);
  Future<bool> removeCartProviderId();

  //region:: getServiceType Id
  String? getServiceTypeId();
  Future<bool> saveServiceTypeId(String typeId);
  //-----------setting
  String? getMinProducts();
  Future<bool> saveMinProducts(String minProducts);
  String? getMinInvoicValue();
  Future<bool> saveMinInvoiceValue(String typeId);
  //-------------
  Future<bool> removeServiceTypeId();

  //region:: user Id
  int? getUserId();
  Future<bool> saveUserId(int id);
  Future<bool> removeUserId();

  //region:: user
  UserEntity? getUser();
  Future<bool> saveUser(UserModel user);
  Future<bool> removeUser();

  //endregion

  //region:: Language Code
  LanguageCode getLanguageCode();
  Future<bool> saveLanguageCode(String value);
  Future<bool> removeLanguageCode();

  //endregion

  //region:: App Theme
  Themes getAppTheme();

  Future<bool> saveAppTheme(Themes theme);

  Future<bool> removeAppTheme();

  //endregion

  // Session status
  Future<bool> saveSessionStatus(SessionStatus value);
  SessionStatus getSessionStatus();
  Future<bool> removeSessionStatus();

  // User type
  Future<bool> saveUserType(UserType value);
  UserType getUserType();
  Future<bool> removeUserType();

  // Device UUID
  Future<bool> saveDeviceUuid(String value);
  String? getDeviceUuid();
  Future<bool> removeDeviceUuid();

  //cart
  Future<void> saveSalesSelectedBooks(Map<int, int> selectedBooks);
  Future<Map<int, int>> loadSalesSelectedBooks();
  Future<void> saveReturnsSelectedBooks(Map<int, int> selectedBooks);
  Future<Map<int, int>> loadReturnsSelectedBooks();
  //------saveSessionId
  String? getSessionId();
  Future<void> saveSessionId(String sessionId);
  Future<void> removeSessionId();
  //endregion
  // Branches
  Future<bool> saveBranches(List<Map<String, dynamic>> branches);
  List<Map<String, dynamic>> getBranches();
  Future<bool> removeBranches();
  //endregion

  //region:: Address Sync
  int? getLastSyncedUserId();
  Future<bool> saveLastSyncedUserId(int userId);
  Future<bool> removeLastSyncedUserId();

  bool getIsAddressSynced();
  Future<bool> saveIsAddressSynced(bool isSynced);
  Future<bool> removeIsAddressSynced();
  //endregion

  Future<bool> saveSettings(SettingModel? data);
  SettingEntity? getSettings();

  Future<bool> clearAll();
}

class AppSharedPreferencesImpl extends AppSharedPreferences {
  AppSharedPreferencesImpl({required SharedPreferences instance})
    : super(Object(), instance: instance);

  @override
  Future<void> clearSecureStorageOnFreshInstall() async {
    final isFirstLaunch = instance.getBool('first_launch') ?? true;

    if (isFirstLaunch) {
      await secureStorage.clearAll(); // 🔥 clears token
      await instance.setBool('first_launch', false);
    }
  }

  //region:: Country Id
  @override
  int? getCountryId() => instance.getInt(_AppSharedPreferencesKeys.countryId);

  @override
  Future<bool> saveCountryId(int countryId) =>
      instance.setInt(_AppSharedPreferencesKeys.countryId, countryId);

  @override
  Future<bool> removeCountryId() =>
      instance.remove(_AppSharedPreferencesKeys.countryId);

  //region:: CartProvider Id
  @override
  String? getCartProviderId() =>
      instance.getString(_AppSharedPreferencesKeys.cartProviderId);

  @override
  Future<bool> saveCartProviderId(String providerId) =>
      instance.setString(_AppSharedPreferencesKeys.cartProviderId, providerId);

  @override
  Future<bool> removeCartProviderId() =>
      instance.remove(_AppSharedPreferencesKeys.cartProviderId);

  //region:: Service Type Id
  @override
  String? getServiceTypeId() =>
      instance.getString(_AppSharedPreferencesKeys.serviceTypeId);

  @override
  Future<bool> saveServiceTypeId(String typeId) =>
      instance.setString(_AppSharedPreferencesKeys.serviceTypeId, typeId);
  //-----------settting
  @override
  String? getMinProducts() =>
      instance.getString(_AppSharedPreferencesKeys.minProducts);

  @override
  Future<bool> saveMinProducts(String minProducts) =>
      instance.setString(_AppSharedPreferencesKeys.minProducts, minProducts);
  @override
  String? getMinInvoicValue() =>
      instance.getString(_AppSharedPreferencesKeys.minInvoiceValue);

  @override
  Future<bool> saveMinInvoiceValue(String minInvoiceValue) => instance
      .setString(_AppSharedPreferencesKeys.minInvoiceValue, minInvoiceValue);
  //---------

  @override
  Future<bool> removeServiceTypeId() =>
      instance.remove(_AppSharedPreferencesKeys.serviceTypeId);

  //region:: User Id
  @override
  int? getUserId() => instance.getInt(_AppSharedPreferencesKeys.userId);

  @override
  Future<bool> saveUserId(int id) =>
      instance.setInt(_AppSharedPreferencesKeys.userId, id);

  @override
  Future<bool> removeUserId() =>
      instance.remove(_AppSharedPreferencesKeys.userId);

  //endregion

  //region:: Language Code
  @override
  LanguageCode getLanguageCode() {
    String value =
        instance.getString(_AppSharedPreferencesKeys.languageCode) ?? "ar";
    // Intl.systemLocale.split('_').first;
    final lang = LanguageCodeExtension.fromString(value);
    log('getLanguageCode Intl.systemLocale: ${Intl.systemLocale}');
    log('getLanguageCode lang: $lang');
    return lang;
  }

  @override
  Future<bool> saveLanguageCode(String value) {
    final languageCode = LanguageCodeExtension.fromString(value);
    return instance.setString(
      _AppSharedPreferencesKeys.languageCode,
      languageCode.name,
    );
  }

  @override
  Future<bool> removeLanguageCode() =>
      instance.remove(_AppSharedPreferencesKeys.languageCode);

  //endregion

  //region:: App Theme
  @override
  Themes getAppTheme() {
    String value = instance.getString(_AppSharedPreferencesKeys.appTheme) ?? '';
    return ThemesExtension.fromString(value);
  }

  @override
  Future<bool> saveAppTheme(Themes theme) =>
      instance.setString(_AppSharedPreferencesKeys.appTheme, theme.name);

  @override
  Future<bool> removeAppTheme() =>
      instance.remove(_AppSharedPreferencesKeys.appTheme);

  // Session status
  @override
  SessionStatus getSessionStatus() => SessionStatusExtension.fromString(
    instance.getString(_AppSharedPreferencesKeys.userCycle) ?? '',
  );

  @override
  Future<bool> saveSessionStatus(SessionStatus value) =>
      instance.setString(_AppSharedPreferencesKeys.userCycle, value.name);

  @override
  Future<bool> removeSessionStatus() =>
      instance.remove(_AppSharedPreferencesKeys.userCycle);

  // User type
  @override
  UserType getUserType() => UserTypeExtension.fromString(
    instance.getString(_AppSharedPreferencesKeys.userType) ?? '',
  );

  @override
  Future<bool> saveUserType(UserType value) =>
      instance.setString(_AppSharedPreferencesKeys.userType, value.name);

  @override
  Future<bool> removeUserType() =>
      instance.remove(_AppSharedPreferencesKeys.userType);

  // Device UUID
  @override
  String? getDeviceUuid() => instance.getString(_AppSharedPreferencesKeys.deviceUuid);

  @override
  Future<bool> saveDeviceUuid(String value) =>
      instance.setString(_AppSharedPreferencesKeys.deviceUuid, value);

  @override
  Future<bool> removeDeviceUuid() =>
      instance.remove(_AppSharedPreferencesKeys.deviceUuid);

  //User

  @override
  UserEntity getUser() {
    String? userStr = instance.getString(_AppSharedPreferencesKeys.user);
    return userStr != null
        ? UserModel.fromJson(jsonDecode(userStr)) as UserEntity
        : UserEntity();
  }

  @override
  Future<bool> saveUser(UserModel user) =>
      instance.setString(_AppSharedPreferencesKeys.user, jsonEncode(user.toJson()));

  @override
  Future<bool> removeUser() => instance.remove(_AppSharedPreferencesKeys.user);

  //endregion

  @override
  Future<bool> clearAll() => instance.clear();

  @override
  Future<void> saveSalesSelectedBooks(Map<int, int> selectedBooks) async {
    final stringMap = selectedBooks.map(
      (key, value) => MapEntry(key.toString(), value),
    );
    final jsonString = jsonEncode(stringMap);
    await instance.setString(
      _AppSharedPreferencesKeys.salesselectedBooksKey,
      jsonString,
    );
    log('from cache data stores succefully');
  }

  @override
  Future<Map<int, int>> loadSalesSelectedBooks() async {
    final jsonString = instance.getString(
      _AppSharedPreferencesKeys.salesselectedBooksKey,
    );

    if (jsonString == null) return {};

    final Map<String, dynamic> stringMap = jsonDecode(jsonString);
    log(
      'from cache load data${stringMap.map((key, value) => MapEntry(int.parse(key), value as int))}',
    );
    return stringMap.map(
      (key, value) => MapEntry(int.parse(key), value as int),
    );
  }

  @override
  Future<void> saveReturnsSelectedBooks(Map<int, int> selectedBooks) async {
    final stringMap = selectedBooks.map(
      (key, value) => MapEntry(key.toString(), value),
    );
    final jsonString = jsonEncode(stringMap);
    await instance.setString(
      _AppSharedPreferencesKeys.returnsSelectedBooksKey,
      jsonString,
    );
    log('from cache data stores succefully');
  }

  @override
  Future<Map<int, int>> loadReturnsSelectedBooks() async {
    final jsonString = instance.getString(
      _AppSharedPreferencesKeys.returnsSelectedBooksKey,
    );

    if (jsonString == null) return {};

    final Map<String, dynamic> stringMap = jsonDecode(jsonString);
    log(
      'from cache load data${stringMap.map((key, value) => MapEntry(int.parse(key), value as int))}',
    );
    return stringMap.map(
      (key, value) => MapEntry(int.parse(key), value as int),
    );
  }

  @override
  String? getSessionId() {
    return instance.getString(_AppSharedPreferencesKeys.sessionId);
  }

  @override
  Future<void> saveSessionId(String sessionId) async {
    instance.setString(_AppSharedPreferencesKeys.sessionId, sessionId);
  }

  @override
  Future<void> removeSessionId() async {
    instance.remove(_AppSharedPreferencesKeys.sessionId);
  }

  @override
  Future<bool> saveBranches(List<Map<String, dynamic>> branches) {
    return instance.setString(
      _AppSharedPreferencesKeys.branches,
      jsonEncode(branches),
    );
  }

  @override
  List<Map<String, dynamic>> getBranches() {
    final jsonString = instance.getString(_AppSharedPreferencesKeys.branches);
    if (jsonString == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(jsonString));
  }

  @override
  Future<bool> removeBranches() {
    return instance.remove(_AppSharedPreferencesKeys.branches);
  }

  //region:: Address Sync
  @override
  int? getLastSyncedUserId() =>
      instance.getInt(_AppSharedPreferencesKeys.lastSyncedUserId);

  @override
  Future<bool> saveLastSyncedUserId(int userId) =>
      instance.setInt(_AppSharedPreferencesKeys.lastSyncedUserId, userId);

  @override
  Future<bool> removeLastSyncedUserId() =>
      instance.remove(_AppSharedPreferencesKeys.lastSyncedUserId);

  @override
  bool getIsAddressSynced() =>
      instance.getBool(_AppSharedPreferencesKeys.isAddressSynced) ?? false;

  @override
  Future<bool> saveIsAddressSynced(bool isSynced) =>
      instance.setBool(_AppSharedPreferencesKeys.isAddressSynced, isSynced);

  @override
  Future<bool> removeIsAddressSynced() =>
      instance.remove(_AppSharedPreferencesKeys.isAddressSynced);

  @override
  SettingEntity? getSettings() {
    String? settingsStr = instance.getString(
      _AppSharedPreferencesKeys.settings,
    );
    return settingsStr != null
        ? SettingModel.fromJson(jsonDecode(settingsStr)) as SettingEntity
        : SettingEntity();
  }

  @override
  Future<bool> saveSettings(SettingModel? settings) => instance.setString(
    _AppSharedPreferencesKeys.settings,
    jsonEncode(settings),
  );

  //endregion
}
