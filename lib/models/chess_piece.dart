class ChessPiece {
  final String type;
  final String color;

  ChessPiece(this.type, this.color);

  // 체스 말 이모티콘 반환
  String get symbol {
    if (color == 'White') {
      switch (type) {
        case 'King':
          return '♔';
        case 'Queen':
          return '♕';
        case 'Rook':
          return '♖';
        case 'Bishop':
          return '♗';
        case 'Knight':
          return '♘';
        case 'Pawn':
          return '♙';
      }
    } else {
      switch (type) {
        case 'King':
          return '♚';
        case 'Queen':
          return '♛';
        case 'Rook':
          return '♜';
        case 'Bishop':
          return '♝';
        case 'Knight':
          return '♞';
        case 'Pawn':
          return '♟';
      }
    }
    return '';
  }
}
