import 'package:face_net_authentication/infrastructures/credentials_storage/credentials_storage.dart';

class ImeiIntroductionRepository {
  ImeiIntroductionRepository(this._storage);

  final CredentialsStorage _storage;

  Future<String?> getSaved() async {
    final response = await _storage.read();

    if (response != null) {
      return response;
    } else {
      return null;
    }
  }

  Future<void> save(String visited) async {
    await _storage.save(visited);
  }

  Future<void> clear() async {
    await _storage.clear();
  }
}
