import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class SplashLogoWidget extends StatelessWidget {
  final bool isDatabaseInitialized;
  final bool arePreferencesLoaded;

  const SplashLogoWidget({
    super.key,
    required this.isDatabaseInitialized,
    required this.arePreferencesLoaded,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Main Logo Container
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Wallet Icon
              CustomIconWidget(
                iconName: 'account_balance_wallet',
                color: AppTheme.lightTheme.primaryColor,
                size: 48,
              ),
              const SizedBox(height: 8),
              // Ruble Symbol
              Text(
                '₽',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // App Name
        Text(
          'Трекер Расходов',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        // App Subtitle
        Text(
          'Личный финансовый помощник',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),

        const SizedBox(height: 16),

        // Status Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStatusIndicator(
              isActive: isDatabaseInitialized,
              icon: 'storage',
              label: 'БД',
            ),
            const SizedBox(width: 16),
            _buildStatusIndicator(
              isActive: arePreferencesLoaded,
              icon: 'settings',
              label: 'Настройки',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusIndicator({
    required bool isActive,
    required String icon,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive
                  ? Colors.white.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: isActive
              ? CustomIconWidget(
                  iconName: 'check',
                  color: Colors.white,
                  size: 16,
                )
              : CustomIconWidget(
                  iconName: icon,
                  color: Colors.white.withValues(alpha: 0.6),
                  size: 16,
                ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
