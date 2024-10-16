part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class ImagePickerLoading extends HomeState {}

final class ImagePickerLoaded extends HomeState {
  final File? image;
  final String email;
  final String address;
  final String name;
  final List phoneNumber;

  ImagePickerLoaded(
      {required this.image,
      required this.email,
      required this.address,
      required this.name,
      required this.phoneNumber});
}

final class ImagePickerFailed extends HomeState {
  final String errorMessage;

  ImagePickerFailed({required this.errorMessage});
}

final class fetchSavedDataLoaded extends HomeState {
  final List<CardData> cardData;

  fetchSavedDataLoaded({required this.cardData});
}

final class fetchSavedDataLoading extends HomeState {}

final class fetchSavedDataFailed extends HomeState {
  final String errorMessage;

  fetchSavedDataFailed({required this.errorMessage});
}
