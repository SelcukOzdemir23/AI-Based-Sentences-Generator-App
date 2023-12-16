import '../data/repositories/sentences_repositor_iml.dart';
import '../domain/repositories/abstract/sentences_repository.dart';

class SentencesController {
  final PoemRepository poemRepository = PoemRepositoryImpl();

  Future<String> getPoem(String productName) {
    return poemRepository.getPoems(productName);
  }
}
