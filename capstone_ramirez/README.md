# CSIT284-Capstone-Ramirez

A new Flutter project.

## Clinic Visit Log

Clinic Visit Log is a simple queueing app for a school clinic. Students log a visit by picking their symptom, and the time is recorded automatically. Nurses see the waiting queue, oldest first, and mark each student as “attended” once they’ve been seen. The app tracks only the queue, not medical records or medicine inventory, so it stays small and easy to use.

## Firebase clinic visits

For Android, place the Firebase project's `google-services.json` in `android/app/`. The Android Gradle plugin reads that file, and `main.dart` initializes Firebase before launching the app.

`VisitRepository` in `lib/repositories/visit_repository.dart` creates, reads, lists, updates, and deletes records in the Firestore `visits` collection. Student submissions are saved with an automatic timestamp; nurses see live visit and queue lists, can mark visits attended, and can delete them. The existing demo login still uses local sample accounts.

```dart
import 'package:capstone_ramirez/models/visit_model.dart';
import 'package:capstone_ramirez/repositories/visit_repository.dart';

Future<void> useVisits(VisitRepository visits) async {
  final visit = await visits.create(
    studentId: 'S1003',
    studentName: 'Demo Student',
    symptom: 'Headache',
    details: '',
  );
  await visits.getById(visit.id);
  await visits.getAll();
  await visits.update(visit.copyWith(status: VisitStatus.attended));
  await visits.delete(visit.id);
}
```

The Firebase project is currently in test mode. Use only dummy visit data until you configure authenticated Firestore security rules; never store real student health details with open test rules.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
