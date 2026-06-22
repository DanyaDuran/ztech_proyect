class CodeGenerator {
  static String generateNotebookCode(int currentCount) {
    int nextNumber = currentCount + 1;
    String paddedNumber = nextNumber.toString().padLeft(3, '0');
    return 'NB-$paddedNumber';
  }
}