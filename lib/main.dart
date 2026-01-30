import 'launch.dart';

void main() async {
  const envFile = 'env/.env';
  await launch(envFile);
}
