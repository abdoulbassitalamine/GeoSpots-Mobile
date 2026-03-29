import 'package:geo_spots/core/utils/extensions/validators_ext.dart';
import 'package:geo_spots/core/utils/validator/validator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'add_shared_access_state.dart';

part 'add_shared_access_view_model.g.dart';

@riverpod
class AddSharedAccessViewModel extends _$AddSharedAccessViewModel {
  final _requiredValidator = ValidatorRequired();
  final _urlValidator = ValidatorUrl();

  ValidatorRequired get requiredValidator => _requiredValidator;
  ValidatorUrl get urlValidator => _urlValidator;

  late final urlValidators = Validators(
    validators: [_requiredValidator, _urlValidator],
  );
  late final tokenValidators = Validators(validators: [_requiredValidator]);

  @override
  AddSharedAccessState build() {
    return const AddSharedAccessState();
  }

  Future<AddSharedAccessState> updateState(AddSharedAccessState state) async {
    this.state = state;
    return state;
  }

  void setupValidatorMessages() {
    _requiredValidator.withErrorMessage('Champ requis');
    _urlValidator.withErrorMessage('URL invalide');
  }

  bool get isFormValid =>
      urlValidators.execute(state.url).isEmpty &&
      tokenValidators.execute(state.token).isEmpty;
}
