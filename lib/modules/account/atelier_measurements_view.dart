import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/account_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/haptic_service.dart';
import 'widgets/account_ui.dart';

/// Editable body measurements with live size recommendation.
class AtelierMeasurementsView extends StatelessWidget {
  const AtelierMeasurementsView({super.key});

  static const _ranges = <String, (double, double)>{
    'Height': (140, 210),
    'Bust': (70, 130),
    'Waist': (50, 120),
    'Hips': (75, 135),
    'Inseam': (60, 95),
    'Shoulder': (32, 54),
  };

  static const _fits = ['Slim', 'Regular', 'Relaxed', 'Oversized'];

  @override
  Widget build(BuildContext context) {
    final account = AccountController.to;
    return Scaffold(
      backgroundColor: AccountUi.canvas(context),
      appBar: AccountUi.appBar(context, 'My Measurements'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        physics: const BouncingScrollPhysics(),
        children: [
          // Recommended size hero
          Obx(() {
            final size = account.recommendedSize;
            return Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: AppColors.signatureGradient,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'YOUR SILOU SIZE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.6,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${account.preferredFit.value} fit • updated live',
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
                    child: Container(
                      key: ValueKey(size),
                      width: 72,
                      height: 72,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Text(
                        size,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 24),
          AccountUi.sectionLabel(context, 'PREFERRED FIT'),
          Obx(() => Row(
                children: [
                  for (final f in _fits)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: GestureDetector(
                          onTap: () {
                            HapticService.selection();
                            account.preferredFit.value = f;
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: account.preferredFit.value == f
                                  ? AppColors.champagneGold
                                  : AccountUi.surface(context),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AccountUi.border(context)),
                            ),
                            child: Text(
                              f,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: account.preferredFit.value == f
                                    ? Colors.white
                                    : AccountUi.text(context),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              )),
          const SizedBox(height: 24),
          AccountUi.sectionLabel(context, 'BODY (CM)'),
          Container(
            decoration: AccountUi.card(context),
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: [
                for (final entry in _ranges.entries)
                  _MeasurementRow(name: entry.key, min: entry.value.$1, max: entry.value.$2),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(CupertinoIcons.info_circle, size: 16, color: AccountUi.muted(context)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Measure over light clothing. Your size is applied to every product page.',
                  style: TextStyle(fontSize: 12, color: AccountUi.muted(context)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          AccountPrimaryButton(
            label: 'Save measurements',
            icon: CupertinoIcons.checkmark_alt,
            onPressed: () {
              Get.back<void>();
              AccountUi.toast('Measurements saved', 'Recommended size: ${account.recommendedSize}');
            },
          ),
        ],
      ),
    );
  }
}

class _MeasurementRow extends StatelessWidget {
  const _MeasurementRow({required this.name, required this.min, required this.max});

  final String name;
  final double min;
  final double max;

  @override
  Widget build(BuildContext context) {
    final account = AccountController.to;
    return Obx(() {
      final value = account.measurements[name]!;
      return Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 8, 0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.w600, color: AccountUi.text(context)),
                ),
                const Spacer(),
                _StepButton(
                  icon: CupertinoIcons.minus,
                  onTap: value > min ? () => account.updateMeasurement(name, value - 1) : null,
                ),
                SizedBox(
                  width: 64,
                  child: Text(
                    '${value.round()} cm',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.champagneGold,
                    ),
                  ),
                ),
                _StepButton(
                  icon: CupertinoIcons.add,
                  onTap: value < max ? () => account.updateMeasurement(name, value + 1) : null,
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                activeTrackColor: AppColors.champagneGold,
                inactiveTrackColor: AccountUi.border(context),
                thumbColor: AppColors.champagneGold,
                overlayColor: AppColors.champagneGold.withValues(alpha: 0.15),
              ),
              child: Slider(
                value: value.clamp(min, max),
                min: min,
                max: max,
                divisions: (max - min).round(),
                onChanged: (v) {
                  if (v.round() != value.round()) HapticService.selection();
                  account.updateMeasurement(name, v.roundToDouble());
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      onPressed: onTap == null
          ? null
          : () {
              HapticService.selection();
              onTap!();
            },
      icon: Icon(icon, size: 16),
      color: AccountUi.text(context),
    );
  }
}
