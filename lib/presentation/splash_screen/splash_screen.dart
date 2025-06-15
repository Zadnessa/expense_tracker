import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/splash_loading_widget.dart';
import './widgets/splash_logo_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _loadingAnimationController;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;

  bool _isDatabaseInitialized = false;
  bool _arePreferencesLoaded = false;
  String _loadingStatus = 'Инициализация базы данных...';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
  }

  void _initializeAnimations() {
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.easeInOut,
    ));

    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    _logoAnimationController.forward();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _loadingAnimationController.repeat();
      }
    });
  }

  Future<void> _initializeApp() async {
    try {
      // Simulate database initialization
      await _initializeDatabase();

      // Load user preferences
      await _loadUserPreferences();

      // Initialize haptic feedback
      await _initializeHapticFeedback();

      // Prepare category data
      await _prepareCategoryData();

      // Navigate to main app after minimum splash duration
      await Future.delayed(const Duration(milliseconds: 2500));

      if (mounted) {
        _navigateToMainApp();
      }
    } catch (e) {
      if (mounted) {
        _handleInitializationError(e);
      }
    }
  }

  Future<void> _initializeDatabase() async {
    setState(() {
      _loadingStatus = 'Инициализация базы данных...';
    });

    // Simulate database initialization
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _isDatabaseInitialized = true;
      _loadingStatus = 'Загрузка настроек...';
    });
  }

  Future<void> _loadUserPreferences() async {
    // Simulate loading currency preferences and settings
    await Future.delayed(const Duration(milliseconds: 600));

    setState(() {
      _arePreferencesLoaded = true;
      _loadingStatus = 'Подготовка данных...';
    });
  }

  Future<void> _initializeHapticFeedback() async {
    try {
      await HapticFeedback.lightImpact();
    } catch (e) {
      // Haptic feedback not available on this device
    }
  }

  Future<void> _prepareCategoryData() async {
    // Simulate preparing Russian category data
    await Future.delayed(const Duration(milliseconds: 400));

    setState(() {
      _loadingStatus = 'Готово!';
    });
  }

  void _navigateToMainApp() {
    Navigator.pushReplacementNamed(context, '/expense-entry-screen');
  }

  void _handleInitializationError(dynamic error) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Ошибка инициализации'),
        content: const Text(
          'Произошла ошибка при запуске приложения. Проверьте доступное место на устройстве и перезапустите приложение.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: const Text('Закрыть'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _initializeApp();
            },
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _loadingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.primaryColor,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.lightTheme.primaryColor,
                AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Logo Section
              AnimatedBuilder(
                animation: _logoAnimationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _logoScaleAnimation.value,
                    child: Opacity(
                      opacity: _logoFadeAnimation.value,
                      child: SplashLogoWidget(
                        isDatabaseInitialized: _isDatabaseInitialized,
                        arePreferencesLoaded: _arePreferencesLoaded,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 48),

              // Loading Section
              SplashLoadingWidget(
                animationController: _loadingAnimationController,
                loadingStatus: _loadingStatus,
                isDatabaseInitialized: _isDatabaseInitialized,
                arePreferencesLoaded: _arePreferencesLoaded,
              ),

              const Spacer(flex: 3),

              // App Version
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Text(
                  'Версия 1.0.0',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
