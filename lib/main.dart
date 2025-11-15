import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'config/supabase_config.dart';
import 'utils/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/main_navigation.dart';
import 'services/rituals_provider.dart';
import 'services/orders_provider.dart';
import 'services/user_provider.dart';
import 'services/auth_provider.dart';
import 'services/faq_provider.dart';
import 'services/blog_provider.dart';
import 'services/booking_provider.dart';
import 'services/payment_provider.dart';
import 'services/notification_provider.dart';
import 'services/search_provider.dart';
import 'services/wishlist_provider.dart';
import 'services/review_provider.dart';
import 'services/loyalty_provider.dart';
import 'services/coupon_provider.dart';
import 'services/live_stream_provider.dart';
import 'services/tracking_provider.dart';
import 'services/settings_provider.dart';
import 'services/connectivity_service.dart';
import 'services/sync_provider.dart';
import 'services/queue_manager.dart';
import 'widgets/common/offline_banner.dart';
import 'models/app_settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await SupabaseConfig.initialize();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MandirMitraApp());
}

class MandirMitraApp extends StatelessWidget {
  const MandirMitraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Core Services
        ChangeNotifierProvider(create: (_) => ConnectivityService()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => QueueManager()..loadQueue()),
        
        // Auth & User
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, UserProvider>(
          create: (context) => UserProvider(),
          update: (context, auth, previous) => previous ?? UserProvider(),
        ),
        
        // Sync Provider
        ChangeNotifierProxyProvider2<QueueManager, ConnectivityService, SyncProvider>(
          create: (context) => SyncProvider(
            context.read<QueueManager>(),
            context.read<ConnectivityService>(),
          ),
          update: (_, queue, connectivity, sync) => 
            sync ?? SyncProvider(queue, connectivity),
        ),
        
        // Content Providers
        ChangeNotifierProvider(create: (_) => RitualsProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ChangeNotifierProvider(create: (_) => BlogProvider()),
        ChangeNotifierProvider(create: (_) => FAQProvider()),
        
        // Feature Providers
        ChangeNotifierProvider(create: (_) => LoyaltyProvider()),
        ChangeNotifierProvider(create: (_) => CouponProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => TrackingProvider()),
        ChangeNotifierProvider(create: (_) => LiveStreamProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        
        // Search Provider
        ChangeNotifierProxyProvider2<RitualsProvider, BlogProvider, SearchProvider>(
          create: (context) => SearchProvider(
            context.read<RitualsProvider>(),
            context.read<BlogProvider>(),
          ),
          update: (context, rituals, blog, previous) =>
              previous ?? SearchProvider(rituals, blog),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return MaterialApp(
              title: 'Mandir Mitra',
              debugShowCheckedModeBanner: false,
              
              // Theme - Light mode only
              theme: AppTheme.lightTheme,
              themeMode: ThemeMode.light,
              
              // Localization
              locale: _getLocale(settings.settings.language),
              supportedLocales: const [
                Locale('en', ''),
                Locale('hi', ''),
                Locale('bn', ''),
                Locale('ta', ''),
                Locale('te', ''),
              ],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              localeResolutionCallback: (locale, supportedLocales) {
                if (locale == null) return supportedLocales.first;
                
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale.languageCode) {
                    return supportedLocale;
                  }
                }
                return supportedLocales.first;
              },
              
              // Navigation
              initialRoute: '/',
              routes: {
                '/': (context) => const SplashScreen(),
                '/main': (context) => const MainNavigation(),
              },
              builder: (context, child) {
                return OfflineBanner(child: child ?? const SizedBox());
              },
            );
        },
      ),
    );
  }

  Locale _getLocale(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return const Locale('en', '');
      case AppLanguage.hindi:
        return const Locale('hi', '');
      case AppLanguage.bengali:
        return const Locale('bn', '');
      case AppLanguage.tamil:
        return const Locale('ta', '');
      case AppLanguage.telugu:
        return const Locale('te', '');
    }
  }
}
