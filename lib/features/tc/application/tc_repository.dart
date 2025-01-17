import 'package:face_net_authentication/infrastructures/credentials_storage/credentials_storage.dart';

class TCRepository {
  TCRepository(this._storage);

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
    return _storage.save(visited);
  }

  Future<void> clear() async {
    return _storage.clear();
  }
}
