import '../../domain/entities/location.dart';
import 'model.dart';

/// `/location` resource.
class LocationModel extends Model<Location> {
  const LocationModel({
    required this.id,
    required this.name,
    this.type = '',
    this.dimension = '',
    this.residentCount = 0,
  });

  factory LocationModel.fromJson(Json json) => LocationModel(
    id: json['id']! as int,
    name: json['name']! as String,
    type: json['type'] as String? ?? '',
    dimension: json['dimension'] as String? ?? '',
    residentCount: countOf(json['residents']),
  );

  final int id;
  final String name;
  final String type;
  final String dimension;
  final int residentCount;

  @override
  Location toEntity() => Location(
    id: id,
    name: name,
    type: type,
    dimension: dimension,
    residentCount: residentCount,
  );
}
