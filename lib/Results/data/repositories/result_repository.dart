import 'package:college_management_saas/Results/data/data_sources/result_remote_datasource.dart';
import 'package:college_management_saas/Results/domain/result_entity.dart';
import 'package:college_management_saas/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class ResultRepository {
  Future<Either<Failure, ResultPage>> getResults(ResultQuery query);
}

class ResultRepositoryImpl implements ResultRepository {
  final ResultRemoteDataSource _remote;

  ResultRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, ResultPage>> getResults(ResultQuery query) async {
    try {
      return Right(await _remote.getResults(query));
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map
          ? data['error']?.toString() ?? data['message']?.toString()
          : null;

      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure(message ?? 'Session expired'));
      }

      return Left(ServerFailure(message ?? 'Unable to load results'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}