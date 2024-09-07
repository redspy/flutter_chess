import 'chess_piece.dart';

class ChessBoard {
  List<List<ChessPiece?>> board = List.generate(8, (_) => List.filled(8, null));

  ChessBoard() {
    _initializeBoard();
  }

  // 체스판 초기화
  void _initializeBoard() {
    for (int i = 0; i < 8; i++) {
      board[1][i] = ChessPiece('Pawn', 'Black');
      board[6][i] = ChessPiece('Pawn', 'White');
    }

    board[0][0] = board[0][7] = ChessPiece('Rook', 'Black');
    board[7][0] = board[7][7] = ChessPiece('Rook', 'White');

    board[0][1] = board[0][6] = ChessPiece('Knight', 'Black');
    board[7][1] = board[7][6] = ChessPiece('Knight', 'White');

    board[0][2] = board[0][5] = ChessPiece('Bishop', 'Black');
    board[7][2] = board[7][5] = ChessPiece('Bishop', 'White');

    board[0][3] = ChessPiece('Queen', 'Black');
    board[7][3] = ChessPiece('Queen', 'White');

    board[0][4] = ChessPiece('King', 'Black');
    board[7][4] = ChessPiece('King', 'White');
  }

  // 말 이동 로직
  void movePiece(int fromX, int fromY, int toX, int toY) {
    board[toY][toX] = board[fromY][fromX];
    board[fromY][fromX] = null;
  }
}
