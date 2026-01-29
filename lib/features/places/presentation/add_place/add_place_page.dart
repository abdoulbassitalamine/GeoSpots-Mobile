import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geo_spots/features/places/presentation/add_place/widgets/add_place_location_step.dart';
import 'package:geo_spots/features/places/presentation/add_place/widgets/add_place_progress_indicator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../view_model/add_place_view_model.dart';
import 'widgets/add_place_basic_info_step.dart';

class AddPlacePage extends HookConsumerWidget {
  const AddPlacePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = useState(0);

    final steps = [
      const AddPlaceBasicInfoStepView(),
      const AddPlaceLocationStepView(),
    ];

    return Scaffold(
      backgroundColor: GSColors.neutral050,
      body: Column(
        children: [
          _AddPlaceHeader(currentStep: currentStep.value),
          Padding(
            padding: const EdgeInsets.all(GSSpacing.xl),
            child: AddPlaceProgressIndicator(
              currentIndex: currentStep.value,
              size: steps.length,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(GSSpacing.xl),
              child: steps[currentStep.value],
            ),
          ),
          _AddPlaceBottomActions(
            currentStep: currentStep,
            totalSteps: steps.length,
          ),
        ],
      ),
    );
  }
}

class _AddPlaceHeader extends StatelessWidget {
  final int currentStep;

  const _AddPlaceHeader({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final titles = ['Informations de base', 'Position et organisation'];

    return Container(
      decoration: const BoxDecoration(
        gradient: GSColorTokens.primaryGradientVertical,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            GSSpacing.xl,
            GSSpacing.xl,
            GSSpacing.xl,
            GSSpacing.xl3,
          ),
          child: Row(
            children: [
              GSBackButton(
                color: GSColors.neutral000,
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: GSSpacing.l),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nouveau lieu',
                      style: GSTypography.headingMedium.copyWith(
                        color: GSColors.neutral000,
                        fontSize: GSFontScale.sf07,
                      ),
                    ),
                    const SizedBox(height: GSSpacing.xs),
                    Text(
                      titles[currentStep],
                      style: GSTypography.bodyDefaultMedium.copyWith(
                        color: GSColors.neutral000.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddPlaceBottomActions extends ConsumerWidget {
  final ValueNotifier<int> currentStep;
  final int totalSteps;

  const _AddPlaceBottomActions({
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addPlaceViewModelProvider);
    final viewModel = ref.read(addPlaceViewModelProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(GSSpacing.xl),
      decoration: BoxDecoration(
        color: GSColors.neutral000,
        boxShadow: [GSShadows.m(direction: GSShadowsDirection.top)],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (currentStep.value > 0) ...[
              Expanded(
                child: GSOutlinedButton(
                  onPressed: () => currentStep.value--,
                  text: 'Retour',
                ),
              ),
              const SizedBox(width: GSSpacing.l),
            ],
            Expanded(
              child: currentStep.value == totalSteps - 1
                  ? GSFilledButton(
                      onPressed: state.isSaving
                          ? () {}
                          : () async {
                              await viewModel.savePlace();
                              if (context.mounted &&
                                  state.errorMessage == null) {
                                Navigator.of(context).pop();
                              }
                            },
                      text: state.isSaving
                          ? 'Enregistrement...'
                          : 'Enregistrer le lieu',
                      isLoading: state.isSaving,
                    )
                  : GSFilledButton(
                      enabled: viewModel.isStep0Valid,
                      onPressed: viewModel.isStepValid(currentStep.value)
                          ? () => currentStep.value++
                          : () {},
                      text: 'Suivant',
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
