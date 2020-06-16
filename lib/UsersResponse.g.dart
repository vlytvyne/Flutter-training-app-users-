// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UsersResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsersResponse _$UsersResponseFromJson(Map<String, dynamic> json) {
  return UsersResponse(
    (json['results'] as List)
        ?.map((e) =>
            e == null ? null : UserModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['info'] == null
        ? null
        : Info.fromJson(json['info'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UsersResponseToJson(UsersResponse instance) =>
    <String, dynamic>{
      'results': instance.users,
      'info': instance.info,
    };

Info _$InfoFromJson(Map<String, dynamic> json) {
  return Info(
    json['page'] as int,
  );
}

Map<String, dynamic> _$InfoToJson(Info instance) => <String, dynamic>{
      'page': instance.page,
    };

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    json['name'] == null
        ? null
        : UserName.fromJson(json['name'] as Map<String, dynamic>),
    json['picture'] == null
        ? null
        : UserPicture.fromJson(json['picture'] as Map<String, dynamic>),
    json['email'] as String,
    json['gender'] as String,
    json['phone'] as String,
  )..isFavorite = json['isFavorite'] as bool ?? false;
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'name': instance.name,
      'picture': instance.picture,
      'email': instance.email,
      'gender': instance.gender,
      'phone': instance.phone,
      'isFavorite': instance.isFavorite,
    };

UserName _$UserNameFromJson(Map<String, dynamic> json) {
  return UserName(
    json['first'] as String,
    json['last'] as String,
  );
}

Map<String, dynamic> _$UserNameToJson(UserName instance) => <String, dynamic>{
      'first': instance.first,
      'last': instance.last,
    };

UserPicture _$UserPictureFromJson(Map<String, dynamic> json) {
  return UserPicture(
    json['large'] as String,
    json['medium'] as String,
    json['thumbnail'] as String,
  );
}

Map<String, dynamic> _$UserPictureToJson(UserPicture instance) =>
    <String, dynamic>{
      'large': instance.large,
      'medium': instance.medium,
      'thumbnail': instance.thumbnail,
    };
