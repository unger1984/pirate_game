import 'package:pirate/domain/entities/target_chest_entity.dart';

enum TargetType {
  moves('moves'),
  timer('timer');

  final String _type;

  const TargetType(this._type);

  @override
  String toString() => _type;
}

class TargetEntity {
  final TargetType type;
  final int limit;
  final TargetChestEntity ches1;
  final TargetChestEntity ches2;
  final TargetChestEntity ches3;
  final int star1;
  final int star2;
  final int star3;

  const TargetEntity({
    required this.type,
    required this.limit,
    required this.ches1,
    required this.ches2,
    required this.ches3,
    required this.star1,
    required this.star2,
    required this.star3,
  });
}
