import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is AuthException) {
      return _getAuthErrorMessage(error);
    } else if (error is PostgrestException) {
      return _getDatabaseErrorMessage(error);
    } else if (error is StorageException) {
      return _getStorageErrorMessage(error);
    } else {
      return 'Something went wrong. Please try again.';
    }
  }

  static String _getAuthErrorMessage(AuthException error) {
    switch (error.statusCode) {
      case '400':
        if (error.message.contains('Invalid login credentials')) {
          return 'Invalid email or password. Please try again.';
        }
        return 'Invalid request. Please check your input.';
      case '422':
        if (error.message.contains('User already registered')) {
          return 'This email is already registered. Please login instead.';
        }
        return 'Unable to process your request. Please try again.';
      case '429':
        return 'Too many attempts. Please try again later.';
      default:
        return error.message;
    }
  }

  static String _getDatabaseErrorMessage(PostgrestException error) {
    if (error.code == '23505') {
      return 'This item already exists.';
    } else if (error.code == '23503') {
      return 'Related data not found.';
    } else if (error.code == 'PGRST116') {
      return 'No data found.';
    }
    return 'Database error. Please try again.';
  }

  static String _getStorageErrorMessage(StorageException error) {
    if (error.statusCode == '413') {
      return 'File is too large. Maximum size is 5MB.';
    } else if (error.statusCode == '415') {
      return 'File type not supported.';
    }
    return 'Upload failed. Please try again.';
  }

  static void showErrorSnackBar(BuildContext context, dynamic error) {
    final message = getErrorMessage(error);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  static void showErrorDialog(
    BuildContext context,
    dynamic error, {
    VoidCallback? onRetry,
  }) {
    final message = getErrorMessage(error);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onRetry();
              },
              child: const Text('Retry'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String? errorMessage;
  final String? errorCode;
  final VoidCallback? onRetry;
  final VoidCallback? onGoHome;

  const ErrorScreen({
    super.key,
    this.errorMessage,
    this.errorCode,
    this.onRetry,
    this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 100,
                color: Colors.red[300],
              ),
              const SizedBox(height: 24),
              const Text(
                'Oops! Something went wrong',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                errorMessage ?? 'An unexpected error occurred. Please try again.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              if (errorCode != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Error Code: $errorCode',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontFamily: 'monospace',
                  ),
                ),
              ],
              const SizedBox(height: 32),
              if (onRetry != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              if (onRetry != null && onGoHome != null) const SizedBox(height: 12),
              if (onGoHome != null)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onGoHome,
                    icon: const Icon(Icons.home),
                    label: const Text('Go Home'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () {
                  // TODO: Implement contact support
                },
                icon: const Icon(Icons.support_agent),
                label: const Text('Contact Support'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Global error handler
void setupGlobalErrorHandler() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
    // TODO: Send to error tracking service (Sentry, Crashlytics, etc.)
  };
}
