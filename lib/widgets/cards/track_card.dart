import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../screens/course/course_view_screen.dart';

class TrackCard extends StatelessWidget {
  final Map<String, dynamic> track;

  const TrackCard({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (track['isAccessible']) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CourseViewScreen(track: track),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('مسار ${track['title']} مقفل حالياً!'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Card(
        elevation: AppConstants.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppConstants.defaultBorderRadius),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(track['image'] ?? '/placeholder.svg?height=200&width=300&text=Track Image'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      track['isAccessible'] ? Icons.lock_open : Icons.lock,
                      color: track['isAccessible'] ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track['title'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    track['description'],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (track['progress'] as double?) ?? 0.0,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${((track['progress'] as double? ?? 0.0) * 100).toInt()}% مكتمل',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
