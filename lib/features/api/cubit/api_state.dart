part of 'api_cubit.dart';

@freezed
class ApiState with _$ApiState {
  const factory ApiState.initial() = Initial;
  const factory ApiState.loading() = Loading;
  const factory ApiState.success({required dynamic data}) = Success;
  const factory ApiState.error({required NetworkException error}) = Error;
}
