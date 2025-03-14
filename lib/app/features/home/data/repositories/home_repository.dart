import '../../../../core/typedefs/result_typedef.dart';
import '../../domain/entities/home_entity.dart';

abstract class IHomeRepository {
  Output<HomeEntity> fetchData();
}
