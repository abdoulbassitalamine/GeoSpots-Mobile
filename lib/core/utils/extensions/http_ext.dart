extension HttpStatusExt on int {
  bool isSuccessful() => this >= 200 && this <= 299;
}
