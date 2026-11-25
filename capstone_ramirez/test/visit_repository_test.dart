import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:capstone_ramirez/models/visit_model.dart';
import 'package:capstone_ramirez/repositories/visit_repository.dart';

void main() {
  late VisitRepository repository;

  setUp(() {
    repository = VisitRepository(firestore: FakeFirebaseFirestore());
  });

  test('creates, reads, updates, and deletes a visit', () async {
    final created = await repository.create(
      studentId: 'S1001',
      studentName: 'Demo Student',
      symptom: 'Headache',
      details: 'Started this morning',
    );

    expect(created.id, isNotEmpty);
    expect(created.status, VisitStatus.waiting);

    final read = await repository.getById(created.id);
    expect(read?.studentId, 'S1001');
    expect(read?.symptom, 'Headache');
    expect(read?.details, 'Started this morning');

    await repository.update(created.copyWith(status: VisitStatus.attended));
    expect(
      (await repository.getById(created.id))?.status,
      VisitStatus.attended,
    );
    expect((await repository.getAll()).single.status, VisitStatus.attended);

    await repository.delete(created.id);
    expect(await repository.getById(created.id), isNull);
    expect(await repository.getAll(), isEmpty);
  });
}
