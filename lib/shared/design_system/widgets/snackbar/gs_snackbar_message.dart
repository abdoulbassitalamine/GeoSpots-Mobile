import 'package:flutter/material.dart';

import 'gs_scaffold_snackbar.dart';
import 'gs_snackbar_type.dart';
import 'gs_top_snackbar_helper.dart';

enum GSSnackbarPresentation { top, scaffold }

class GSSnackbarMessage {
  const GSSnackbarMessage({
    required this.message,
    this.type = GSSnackbarType.info,
    this.presentation = GSSnackbarPresentation.top,
  });

  final String message;
  final GSSnackbarType type;
  final GSSnackbarPresentation presentation;

  void show(BuildContext context) {
    switch (presentation) {
      case GSSnackbarPresentation.top:
        GSTopSnackbar.show(context, message: message, type: type);
      case GSSnackbarPresentation.scaffold:
        GSScaffoldSnackbar.show(context, message: message, type: type);
    }
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is GSSnackbarMessage &&
            runtimeType == other.runtimeType &&
            message == other.message &&
            type == other.type &&
            presentation == other.presentation;
  }

  @override
  int get hashCode => Object.hash(message, type, presentation);
}
