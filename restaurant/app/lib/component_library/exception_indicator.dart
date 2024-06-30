import 'component_library.dart';
import 'package:flutter/material.dart';

class ExceptionIndicator extends StatelessWidget {
  const ExceptionIndicator({
    super.key,
    this.title,
    this.message,
    this.onTryAgain,
  });

  final String? title;
  final String? message;
  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 32,
          horizontal: 16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              title ?? 'Something when wrong',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              title ?? 'could not connect to server, check your connection',
              textAlign: TextAlign.center,
            ),
            if (onTryAgain != null)
              const SizedBox(
                height: 24,
              ),
            if (onTryAgain != null)
              ExpandedElevatedButton(
                onTap: onTryAgain,
                icon: const Icon(
                  Icons.refresh,
                ),
                label: 'Try Again',
              ),
          ],
        ),
      ),
    );
  }
}
