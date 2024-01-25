bool isWhite(int index) {
  int x = index ~/ 8;
  int y = index % 8;

  bool isWhite = (x + y) % 2 == 0;
  return isWhite;
}


bool isInBoard(int row, int column){
 return row >= 0 && row < 8 && column >= 0 && column < 8;
}