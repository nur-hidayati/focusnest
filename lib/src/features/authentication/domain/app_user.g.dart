// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppUserImpl _$$AppUserImplFromJson(Map<String, dynamic> json) =>
    _$AppUserImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      isVerified: json['isVerified'] as bool? ?? false,
      createdDate:
          const TimestampConverter().fromJson(json['createdDate'] as Timestamp),
    );

Map<String, dynamic> _$$AppUserImplToJson(_$AppUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'isVerified': instance.isVerified,
      'createdDate': const TimestampConverter().toJson(instance.createdDate),
    };
