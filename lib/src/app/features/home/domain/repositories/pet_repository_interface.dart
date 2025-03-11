import '../../../../../core/typedefs/types.dart';
import '../entities/pet_entity.dart';

abstract interface class IPetRepository {
  Output<List<PetEntity>> getPets({
    String? type,
    String? gender,
    String? size,
  });
}
