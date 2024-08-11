// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'selection_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SelectionState _$SelectionStateFromJson(Map<String, dynamic> json) {
  return _SelectionState.fromJson(json);
}

/// @nodoc
mixin _$SelectionState {
  String? get purpose => throw _privateConstructorUsedError;
  String? get goal => throw _privateConstructorUsedError;
  String? get community => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SelectionStateCopyWith<SelectionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SelectionStateCopyWith<$Res> {
  factory $SelectionStateCopyWith(
          SelectionState value, $Res Function(SelectionState) then) =
      _$SelectionStateCopyWithImpl<$Res, SelectionState>;
  @useResult
  $Res call({String? purpose, String? goal, String? community});
}

/// @nodoc
class _$SelectionStateCopyWithImpl<$Res, $Val extends SelectionState>
    implements $SelectionStateCopyWith<$Res> {
  _$SelectionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? purpose = freezed,
    Object? goal = freezed,
    Object? community = freezed,
  }) {
    return _then(_value.copyWith(
      purpose: freezed == purpose
          ? _value.purpose
          : purpose // ignore: cast_nullable_to_non_nullable
              as String?,
      goal: freezed == goal
          ? _value.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as String?,
      community: freezed == community
          ? _value.community
          : community // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SelectionStateImplCopyWith<$Res>
    implements $SelectionStateCopyWith<$Res> {
  factory _$$SelectionStateImplCopyWith(_$SelectionStateImpl value,
          $Res Function(_$SelectionStateImpl) then) =
      __$$SelectionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? purpose, String? goal, String? community});
}

/// @nodoc
class __$$SelectionStateImplCopyWithImpl<$Res>
    extends _$SelectionStateCopyWithImpl<$Res, _$SelectionStateImpl>
    implements _$$SelectionStateImplCopyWith<$Res> {
  __$$SelectionStateImplCopyWithImpl(
      _$SelectionStateImpl _value, $Res Function(_$SelectionStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? purpose = freezed,
    Object? goal = freezed,
    Object? community = freezed,
  }) {
    return _then(_$SelectionStateImpl(
      purpose: freezed == purpose
          ? _value.purpose
          : purpose // ignore: cast_nullable_to_non_nullable
              as String?,
      goal: freezed == goal
          ? _value.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as String?,
      community: freezed == community
          ? _value.community
          : community // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SelectionStateImpl implements _SelectionState {
  const _$SelectionStateImpl({this.purpose, this.goal, this.community});

  factory _$SelectionStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$SelectionStateImplFromJson(json);

  @override
  final String? purpose;
  @override
  final String? goal;
  @override
  final String? community;

  @override
  String toString() {
    return 'SelectionState(purpose: $purpose, goal: $goal, community: $community)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectionStateImpl &&
            (identical(other.purpose, purpose) || other.purpose == purpose) &&
            (identical(other.goal, goal) || other.goal == goal) &&
            (identical(other.community, community) ||
                other.community == community));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, purpose, goal, community);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectionStateImplCopyWith<_$SelectionStateImpl> get copyWith =>
      __$$SelectionStateImplCopyWithImpl<_$SelectionStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SelectionStateImplToJson(
      this,
    );
  }
}

abstract class _SelectionState implements SelectionState {
  const factory _SelectionState(
      {final String? purpose,
      final String? goal,
      final String? community}) = _$SelectionStateImpl;

  factory _SelectionState.fromJson(Map<String, dynamic> json) =
      _$SelectionStateImpl.fromJson;

  @override
  String? get purpose;
  @override
  String? get goal;
  @override
  String? get community;
  @override
  @JsonKey(ignore: true)
  _$$SelectionStateImplCopyWith<_$SelectionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
