class ChessPiece {
  final String type;
  final String color;

  ChessPiece(this.type, this.color);

  // 체스말 이미지 경로 반환
  String get imagePath {
    if (color == 'White') {
      switch (type) {
        case 'King':
          return 'assets/white_king.png';
        case 'Queen':
          return 'assets/white_queen.png';
        case 'Rook':
          return 'assets/white_rook.png';
        case 'Bishop':
          return 'assets/white_bishop.png';
        case 'Knight':
          return 'assets/white_knight.png';
        case 'Pawn':
          return 'assets/white_pawn.png';
      }
    } else {
      switch (type) {
        case 'King':
          return 'assets/black_king.png';
        case 'Queen':
          return 'assets/black_queen.png';
        case 'Rook':
          return 'assets/black_rook.png';
        case 'Bishop':
          return 'assets/black_bishop.png';
        case 'Knight':
          return 'assets/black_knight.png';
        case 'Pawn':
          return 'assets/black_pawn.png';
      }
    }
    return '';
  }
}
