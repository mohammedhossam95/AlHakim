import 'package:alhakim/core/error/exceptions.dart';
import 'package:alhakim/features/delegate/data/models/representative_stats_model.dart';
import 'package:alhakim/injection_container.dart';

abstract class RepresentativeStatsRemoteDataSource {
  Future<RepresentativeStatsRespModel> getRepresentativeStats();
}

class RepresentativeStatsRemoteDataSourceImpl
    implements RepresentativeStatsRemoteDataSource {
  @override
  Future<RepresentativeStatsRespModel> getRepresentativeStats() async {
    try {
      final response = await dioConsumer.get('/representative/stats');

      if (response['status'] == true) {
        return RepresentativeStatsRespModel.fromJson(response);
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (e) {
      rethrow;
    }
  }
}
