import 'chess_piece.dart';

class ChessBoard {
  List<List<ChessPiece?>> board;

  ChessBoard()
      : board = List.generate(8, (i) => List.generate(8, (j) => null)) {
    _initializeBoard();
  }

  void _initializeBoard() {
    // 흑 말 배치
    board[0] = [
      ChessPiece('Rook', 'Black'),
      ChessPiece('Knight', 'Black'),
      ChessPiece('Bishop', 'Black'),
      ChessPiece('Queen', 'Black'),
      ChessPiece('King', 'Black'),
      ChessPiece('Bishop', 'Black'),
      ChessPiece('Knight', 'Black'),
      ChessPiece('Rook', 'Black'),
    ];
    board[1] = List.generate(8, (i) => ChessPiece('Pawn', 'Black'));

    // 백 말 배치
    board[7] = [
      ChessPiece('Rook', 'White'),
      ChessPiece('Knight', 'White'),
      ChessPiece('Bishop', 'White'),
      ChessPiece('Queen', 'White'),
      ChessPiece('King', 'White'),
      ChessPiece('Bishop', 'White'),
      ChessPiece('Knight', 'White'),
      ChessPiece('Rook', 'White'),
    ];
    board[6] = List.generate(8, (i) => ChessPiece('Pawn', 'White'));
  }

  // 말 이동 함수
  void movePiece(int fromX, int fromY, int toX, int toY) {
    board[toY][toX] = board[fromY][fromX];
    board[fromY][fromX] = null;
  }
}
