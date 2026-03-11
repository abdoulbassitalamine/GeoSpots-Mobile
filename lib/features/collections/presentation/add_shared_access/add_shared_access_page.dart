import 'package:flutter/material.dart';

import '../../../../../shared/design_system/design_system.dart';
import 'view/add_shared_access_view.dart';

class AddSharedAccessPage extends StatelessWidget {
  const AddSharedAccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GSScaffold(
      body: AddSharedAccessView(),
    );
  }
}
