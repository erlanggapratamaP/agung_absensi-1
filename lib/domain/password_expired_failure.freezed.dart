// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'password_expired_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PasswordExpiredFailure {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) errorParsing,
    required TResult Function() empty,
    required TResult Function(int? errorCode, String? message) unknown,
    required TResult Function() storage,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message)? errorParsing,
    TResult? Function()? empty,
    TResult? Function(int? errorCode, String? message)? unknown,
    TResult? Function()? storage,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? errorParsing,
    TResult Function()? empty,
    TResult Function(int? errorCode, String? message)? unknown,
    TResult Function()? storage,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ErrorParsing value) errorParsing,
    required TResult Function(_Empty value) empty,
    required TResult Function(_Unknown value) unknown,
    required TResult Function(_Storage value) storage,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ErrorParsing value)? errorParsing,
    TResult? Function(_Empty value)? empty,
    TResult? Function(_Unknown value)? unknown,
    TResult? Function(_Storage value)? storage,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ErrorParsing value)? errorParsing,
    TResult Function(_Empty value)? empty,
    TResult Function(_Unknown value)? unknown,
    TResult Function(_Storage value)? storage,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PasswordExpiredFailureCopyWith<$Res> {
  factory $PasswordExpiredFailureCopyWith(PasswordExpiredFailure value,
          $Res Function(PasswordExpiredFailure) then) =
      _$PasswordExpiredFailureCopyWithImpl<$Res, PasswordExpiredFailure>;
}

/// @nodoc
class _$PasswordExpiredFailureCopyWithImpl<$Res,
        $Val extends PasswordExpiredFailure>
    implements $PasswordExpiredFailureCopyWith<$Res> {
  _$PasswordExpiredFailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_ErrorParsingCopyWith<$Res> {
  factory _$$_ErrorParsingCopyWith(
          _$_ErrorParsing value, $Res Function(_$_ErrorParsing) then) =
      __$$_ErrorParsingCopyWithImpl<$Res>;
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$_ErrorParsingCopyWithImpl<$Res>
    extends _$PasswordExpiredFailureCopyWithImpl<$Res, _$_ErrorParsing>
    implements _$$_ErrorParsingCopyWith<$Res> {
  __$$_ErrorParsingCopyWithImpl(
      _$_ErrorParsing _value, $Res Function(_$_ErrorParsing) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$_ErrorParsing(
      freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_ErrorParsing implements _ErrorParsing {
  const _$_ErrorParsing([this.message]);

  @override
  final String? message;

  @override
  String toString() {
    return 'PasswordExpiredFailure.errorParsing(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ErrorParsing &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ErrorParsingCopyWith<_$_ErrorParsing> get copyWith =>
      __$$_ErrorParsingCopyWithImpl<_$_ErrorParsing>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) errorParsing,
    required TResult Function() empty,
    required TResult Function(int? errorCode, String? message) unknown,
    required TResult Function() storage,
  }) {
    return errorParsing(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message)? errorParsing,
    TResult? Function()? empty,
    TResult? Function(int? errorCode, String? message)? unknown,
    TResult? Function()? storage,
  }) {
    return errorParsing?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? errorParsing,
    TResult Function()? empty,
    TResult Function(int? errorCode, String? message)? unknown,
    TResult Function()? storage,
    required TResult orElse(),
  }) {
    if (errorParsing != null) {
      return errorParsing(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ErrorParsing value) errorParsing,
    required TResult Function(_Empty value) empty,
    required TResult Function(_Unknown value) unknown,
    required TResult Function(_Storage value) storage,
  }) {
    return errorParsing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ErrorParsing value)? errorParsing,
    TResult? Function(_Empty value)? empty,
    TResult? Function(_Unknown value)? unknown,
    TResult? Function(_Storage value)? storage,
  }) {
    return errorParsing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ErrorParsing value)? errorParsing,
    TResult Function(_Empty value)? empty,
    TResult Function(_Unknown value)? unknown,
    TResult Function(_Storage value)? storage,
    required TResult orElse(),
  }) {
    if (errorParsing != null) {
      return errorParsing(this);
    }
    return orElse();
  }
}

abstract class _ErrorParsing implements PasswordExpiredFailure {
  const factory _ErrorParsing([final String? message]) = _$_ErrorParsing;

  String? get message;
  @JsonKey(ignore: true)
  _$$_ErrorParsingCopyWith<_$_ErrorParsing> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_EmptyCopyWith<$Res> {
  factory _$$_EmptyCopyWith(_$_Empty value, $Res Function(_$_Empty) then) =
      __$$_EmptyCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_EmptyCopyWithImpl<$Res>
    extends _$PasswordExpiredFailureCopyWithImpl<$Res, _$_Empty>
    implements _$$_EmptyCopyWith<$Res> {
  __$$_EmptyCopyWithImpl(_$_Empty _value, $Res Function(_$_Empty) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_Empty implements _Empty {
  const _$_Empty();

  @override
  String toString() {
    return 'PasswordExpiredFailure.empty()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_Empty);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) errorParsing,
    required TResult Function() empty,
    required TResult Function(int? errorCode, String? message) unknown,
    required TResult Function() storage,
  }) {
    return empty();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message)? errorParsing,
    TResult? Function()? empty,
    TResult? Function(int? errorCode, String? message)? unknown,
    TResult? Function()? storage,
  }) {
    return empty?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? errorParsing,
    TResult Function()? empty,
    TResult Function(int? errorCode, String? message)? unknown,
    TResult Function()? storage,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ErrorParsing value) errorParsing,
    required TResult Function(_Empty value) empty,
    required TResult Function(_Unknown value) unknown,
    required TResult Function(_Storage value) storage,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ErrorParsing value)? errorParsing,
    TResult? Function(_Empty value)? empty,
    TResult? Function(_Unknown value)? unknown,
    TResult? Function(_Storage value)? storage,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ErrorParsing value)? errorParsing,
    TResult Function(_Empty value)? empty,
    TResult Function(_Unknown value)? unknown,
    TResult Function(_Storage value)? storage,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class _Empty implements PasswordExpiredFailure {
  const factory _Empty() = _$_Empty;
}

/// @nodoc
abstract class _$$_UnknownCopyWith<$Res> {
  factory _$$_UnknownCopyWith(
          _$_Unknown value, $Res Function(_$_Unknown) then) =
      __$$_UnknownCopyWithImpl<$Res>;
  @useResult
  $Res call({int? errorCode, String? message});
}

/// @nodoc
class __$$_UnknownCopyWithImpl<$Res>
    extends _$PasswordExpiredFailureCopyWithImpl<$Res, _$_Unknown>
    implements _$$_UnknownCopyWith<$Res> {
  __$$_UnknownCopyWithImpl(_$_Unknown _value, $Res Function(_$_Unknown) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errorCode = freezed,
    Object? message = freezed,
  }) {
    return _then(_$_Unknown(
      freezed == errorCode
          ? _value.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_Unknown implements _Unknown {
  const _$_Unknown([this.errorCode, this.message]);

  @override
  final int? errorCode;
  @override
  final String? message;

  @override
  String toString() {
    return 'PasswordExpiredFailure.unknown(errorCode: $errorCode, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Unknown &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, errorCode, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UnknownCopyWith<_$_Unknown> get copyWith =>
      __$$_UnknownCopyWithImpl<_$_Unknown>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) errorParsing,
    required TResult Function() empty,
    required TResult Function(int? errorCode, String? message) unknown,
    required TResult Function() storage,
  }) {
    return unknown(errorCode, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message)? errorParsing,
    TResult? Function()? empty,
    TResult? Function(int? errorCode, String? message)? unknown,
    TResult? Function()? storage,
  }) {
    return unknown?.call(errorCode, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? errorParsing,
    TResult Function()? empty,
    TResult Function(int? errorCode, String? message)? unknown,
    TResult Function()? storage,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(errorCode, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ErrorParsing value) errorParsing,
    required TResult Function(_Empty value) empty,
    required TResult Function(_Unknown value) unknown,
    required TResult Function(_Storage value) storage,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ErrorParsing value)? errorParsing,
    TResult? Function(_Empty value)? empty,
    TResult? Function(_Unknown value)? unknown,
    TResult? Function(_Storage value)? storage,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ErrorParsing value)? errorParsing,
    TResult Function(_Empty value)? empty,
    TResult Function(_Unknown value)? unknown,
    TResult Function(_Storage value)? storage,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class _Unknown implements PasswordExpiredFailure {
  const factory _Unknown([final int? errorCode, final String? message]) =
      _$_Unknown;

  int? get errorCode;
  String? get message;
  @JsonKey(ignore: true)
  _$$_UnknownCopyWith<_$_Unknown> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_StorageCopyWith<$Res> {
  factory _$$_StorageCopyWith(
          _$_Storage value, $Res Function(_$_Storage) then) =
      __$$_StorageCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_StorageCopyWithImpl<$Res>
    extends _$PasswordExpiredFailureCopyWithImpl<$Res, _$_Storage>
    implements _$$_StorageCopyWith<$Res> {
  __$$_StorageCopyWithImpl(_$_Storage _value, $Res Function(_$_Storage) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_Storage implements _Storage {
  const _$_Storage();

  @override
  String toString() {
    return 'PasswordExpiredFailure.storage()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_Storage);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) errorParsing,
    required TResult Function() empty,
    required TResult Function(int? errorCode, String? message) unknown,
    required TResult Function() storage,
  }) {
    return storage();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message)? errorParsing,
    TResult? Function()? empty,
    TResult? Function(int? errorCode, String? message)? unknown,
    TResult? Function()? storage,
  }) {
    return storage?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? errorParsing,
    TResult Function()? empty,
    TResult Function(int? errorCode, String? message)? unknown,
    TResult Function()? storage,
    required TResult orElse(),
  }) {
    if (storage != null) {
      return storage();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ErrorParsing value) errorParsing,
    required TResult Function(_Empty value) empty,
    required TResult Function(_Unknown value) unknown,
    required TResult Function(_Storage value) storage,
  }) {
    return storage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ErrorParsing value)? errorParsing,
    TResult? Function(_Empty value)? empty,
    TResult? Function(_Unknown value)? unknown,
    TResult? Function(_Storage value)? storage,
  }) {
    return storage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ErrorParsing value)? errorParsing,
    TResult Function(_Empty value)? empty,
    TResult Function(_Unknown value)? unknown,
    TResult Function(_Storage value)? storage,
    required TResult orElse(),
  }) {
    if (storage != null) {
      return storage(this);
    }
    return orElse();
  }
}

abstract class _Storage implements PasswordExpiredFailure {
  const factory _Storage() = _$_Storage;
}