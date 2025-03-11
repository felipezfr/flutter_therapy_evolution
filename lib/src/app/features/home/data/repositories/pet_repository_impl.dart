import 'package:result_dart/result_dart.dart';

import '../../../../../core/errors/errors.dart';
import '../../../../../core/typedefs/types.dart';
import '../../domain/entities/pet_entity.dart';
import '../../domain/repositories/pet_repository_interface.dart';
import '../datasources/pet_remote_datasource.dart';
import '../models/pet_model.dart';

class PetRepositoryImpl implements IPetRepository {
  final PetRemoteDatasource datasource;

  const PetRepositoryImpl({
    required this.datasource,
  });

  @override
  Output<List<PetEntity>> getPets({
    String? type,
    String? gender,
    String? size,
  }) async {
    throw UnimplementedError();
    //   try {
    //     final result = await datasource.getPets();
    //     final appResponse = List<PetEntity>.fromJson(
    //       result.data,
    //       (json) {
    //         return (json as List).map((json) {
    //           return PetModel.fromMap(
    //             json as Map<String, dynamic>,
    //           );
    //         }).toList();
    //       },
    //     );
    //     return Success(appResponse);
    //   } catch (e) {
    //     return Failure(
    //       ServerException(
    //         message: 'Unexpected error',
    //         error: e.toString(),
    //       ),
    //     );
    //   }
  }
}
