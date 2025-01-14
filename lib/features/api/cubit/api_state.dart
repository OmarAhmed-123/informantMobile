// api_state.dart

part of 'api_cubit.dart';

@freezed
class ApiState with _$ApiState {
  /// Initial state
  const factory ApiState.initial() = Initial;

  /// Loading state while request is in progress
  const factory ApiState.loading() = Loading;

  /// Success state with response data
  const factory ApiState.success({required dynamic data}) = Success;

  /// Unverified state when OTP verification is needed
  const factory ApiState.unverified() =
      Unverified; // Define as a separate state class

  /// Error state with error details
  const factory ApiState.error({required NetworkException error}) = Error;
}
