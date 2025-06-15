import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class SplashLoadingWidget extends StatelessWidget {
  final AnimationController animationController;
  final String loadingStatus;
  final bool isDatabaseInitialized;
  final bool arePreferencesLoaded;

  const SplashLoadingWidget({
    super.key,
    required this.animationController,
    required this.loadingStatus,
    required this.isDatabaseInitialized,
    required this.arePreferencesLoaded,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Loading Progress Bar
        Container(
          width: 200,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Stack(
            children: [
              // Background
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Progress
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: _getProgressWidth(),
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Loading Status Text
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            loadingStatus,
            key: ValueKey(loadingStatus),
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 24),

        // Animated Loading Indicator
        AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Transform.rotate(
              angle: animationController.value * 2 * 3.14159,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        // Loading Steps
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLoadingStep(
              isCompleted: isDatabaseInitialized,
              isActive: !isDatabaseInitialized,
              label: '1',
            ),
            Container(
              width: 24,
              height: 2,
              color: isDatabaseInitialized
                  ? Colors.white.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.2),
            ),
            _buildLoadingStep(
              isCompleted: arePreferencesLoaded,
              isActive: isDatabaseInitialized && !arePreferencesLoaded,
              label: '2',
            ),
            Container(
              width: 24,
              height: 2,
              color: arePreferencesLoaded
                  ? Colors.white.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.2),
            ),
            _buildLoadingStep(
              isCompleted: isDatabaseInitialized && arePreferencesLoaded,
              isActive: arePreferencesLoaded,
              label: '3',
            ),
          ],
        ),
      ],
    );
  }

  double _getProgressWidth() {
    if (arePreferencesLoaded) return 200.0;
    if (isDatabaseInitialized) return 133.0;
    return 66.0;
  }

  Widget _buildLoadingStep({
    required bool isCompleted,
    required bool isActive,
    required String label,
  }) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isCompleted
            ? Colors.white
            : isActive
                ? Colors.white.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted || isActive
              ? Colors.white
              : Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Center(
        child: isCompleted
            ? CustomIconWidget(
                iconName: 'check',
                color: AppTheme.lightTheme.primaryColor,
                size: 14,
              )
            : Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isActive
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.5),
                ),
              ),
      ),
    );
  }
}
