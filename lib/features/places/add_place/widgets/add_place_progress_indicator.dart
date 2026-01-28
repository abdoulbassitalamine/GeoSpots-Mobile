import 'package:flutter/material.dart';
import '../../../../../shared/design_system/design_system.dart';

class AddPlaceProgressIndicator extends StatelessWidget {
  const AddPlaceProgressIndicator({
    super.key,
    required this.currentIndex,
    required this.size,
  });

  final int currentIndex;
  final int size;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var index = 0; index < size; index++) ...[
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: GSColors.neutral300,
                    borderRadius: BorderRadius.circular(GSRadius.full),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: index < currentIndex
                      ? 1
                      : index == currentIndex
                      ? 0.5
                      : 0,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: GSColors.primary600,
                      borderRadius: BorderRadius.circular(GSRadius.full),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (index < size - 1) const SizedBox(width: GSSpacing.s),
        ],
      ],
    );
  }
}
