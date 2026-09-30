class ExternalFileService {
  static Future<String?> saveBytes({
    required String suggestedName,
    required List<int> bytes,
    required List<String> allowedExtensions,
  }) async {
    throw UnsupportedError('Salvar arquivos externos não está disponível nesta plataforma.');
  }

  static Future<List<int>?> pickJsonBytes() async {
    throw UnsupportedError('Seleção de arquivos não está disponível nesta plataforma.');
  }

  static Future<void> sharePath(String path, {String? text}) async {
    throw UnsupportedError('Compartilhamento de arquivos não está disponível nesta plataforma.');
  }
}
