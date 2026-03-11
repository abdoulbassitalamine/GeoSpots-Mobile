import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const _modalClosingDurationDelta = Duration(milliseconds: 100);
const kDefaultTransitionDuration = Duration(milliseconds: 200);

class DialogManager {
  static DialogManager? _instance;

  static DialogManager get instance => _instance ??= DialogManager();

  int _nbOfModals = 0;

  Future<void> clearDialogs(BuildContext context) async {
    while (_nbOfModals > 0) {
      context.pop();
      _nbOfModals--;
    }

    await Future<void>.delayed(
      kDefaultTransitionDuration + _modalClosingDurationDelta,
    );
  }

  // TODO(team): Add customizable options
  Future<T?> show<T>(
    BuildContext context, {
    String? barrierLabel,
    bool barrierDismissible = true,
    ScrollController? scrollController,
  }) async {
    _nbOfModals++;

    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return const SizedBox(height: 200, child: Center(child: Text('TODO')));
      },
    ).then((result) {
      _nbOfModals--;
      return result;
    });
    return null;
  }
}
