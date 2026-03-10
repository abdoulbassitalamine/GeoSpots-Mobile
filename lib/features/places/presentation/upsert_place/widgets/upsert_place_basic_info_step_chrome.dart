part of 'upsert_place_basic_info_step.dart';

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.isEditMode});

  final bool isEditMode;

  @override
  Widget build(BuildContext context) {
    return Text(
      isEditMode ? 'Modifiez les informations' : 'Décrivez votre lieu',
      style: GSTypography.bodyDefaultMedium.copyWith(
        color: GSColors.neutral600,
      ),
    );
  }
}

class _LocationInfoBanner extends StatelessWidget {
  const _LocationInfoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(GSSpacing.xl),
      decoration: BoxDecoration(
        color: GSColors.info100,
        borderRadius: BorderRadius.circular(GSRadius.m),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: GSColors.info600, size: 20),
          const SizedBox(width: GSSpacing.m),
          Expanded(
            child: Text(
              'La localisation GPS sera capturée à l\'étape suivante',
              style: GSTypography.bodyDefaultSmall.copyWith(
                color: GSColors.info600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
