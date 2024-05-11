import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

typedef UserID = String;

@freezed
class AppUser with _$AppUser {
  factory AppUser({
    required String id,
    required String email,
    required DateTime createdDate,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}
