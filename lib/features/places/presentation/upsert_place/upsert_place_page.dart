import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../view_model/upsert_place_view_model.dart';
import 'widgets/upsert_place_basic_info_step.dart';
import 'widgets/upsert_place_location_step.dart';
import 'widgets/upsert_place_progress_indicator.dart';

class UpsertPlacePage extends HookConsumerWidget {

  const UpsertPlacePage({super.key, required this.placeId});
  final String placeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = useState(0);
    final state = ref.watch(upsertPlaceViewModelProvider(placeId));
    final viewModel = ref.read(upsertPlaceViewModelProvider(placeId).notifier);

    if (state.isLoading) {
      return GSScaffold(
        backgroundColor: GSColorTokens.backgroundPrimary,
        body: Center(child: GSCircularLoader()),
      );
    }

    final steps = [
      UpsertPlaceBasicInfoStepView(state: state, notifier: viewModel),
      UpsertPlaceLocationStepView(state: state, notifier: viewModel),
    ];

    return GSScaffold(
      backgroundColor: GSColorTokens.backgroundPrimary,
      body: Column(
        children: [
          _UpsertPlaceHeader(
            currentStep: currentStep.value,
            isEditMode: state.isEditMode,
          ),
          Padding(
            padding: const EdgeInsets.all(GSSpacing.xl),
            child: UpsertPlaceProgressIndicator(
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
          _UpsertPlaceBottomActions(
            currentStep: currentStep,
            totalSteps: steps.length,
            placeId: placeId,
          ),
        ],
      ),
    );
  }
}

class _UpsertPlaceHeader extends StatelessWidget {

  const _UpsertPlaceHeader({
    required this.currentStep,
    required this.isEditMode,
  });
  final int currentStep;
  final bool isEditMode;

  @override
  Widget build(BuildContext context) {
    final titles = ['Informations de base', 'Position et organisation'];

    return DecoratedBox(
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
                      isEditMode ? 'Modifier le lieu' : 'Nouveau lieu',
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

class _UpsertPlaceBottomActions extends ConsumerWidget {

  const _UpsertPlaceBottomActions({
    required this.currentStep,
    required this.totalSteps,
    required this.placeId,
  });
  final ValueNotifier<int> currentStep;
  final int totalSteps;
  final String placeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(upsertPlaceViewModelProvider(placeId));
    final viewModel = ref.read(upsertPlaceViewModelProvider(placeId).notifier);

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
                      enabled: viewModel.isStep1Valid,
                      onPressed: () async {
                        await viewModel.savePlace();
                        if (context.mounted && state.errorMessage == null) {
                          Navigator.of(context).pop();
                        }
                      },
                      text: state.isSaving
                          ? 'Enregistrement...'
                          : state.isEditMode
                          ? 'Mettre à jour'
                          : 'Créer le lieu',
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
