import '../../domain/entity/public_location_entity.dart';

class LiveLocationState {
  const LiveLocationState({
    this.location,
    this.isLoading = false,
    this.errorMessage,
    this.isExpired = false,
  });

  final PublicLocationEntity? location;
  final bool isLoading;
  final String? errorMessage;
  final bool isExpired;

  LiveLocationState copyWith({
    PublicLocationEntity? location,
    bool? isLoading,
    String? errorMessage,
    bool? isExpired,
    bool clearError = false,
  }) {
    return LiveLocationState(
      location: location ?? this.location,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isExpired: isExpired ?? this.isExpired,
    );
  }
}
