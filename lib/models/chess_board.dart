import 'chess_piece.dart';

class ChessBoard {
  late List<List<ChessPiece?>> board;

  ChessBoard() {
    board = List.generate(8, (_) => List.filled(8, null)); // board 초기화
    _initializeBoard(); // 체스판 초기화
  }

  // 체스판 초기화
  void _initializeBoard() {
    // 흑 말 배치 (상단 7, 8번째 줄)
    board[0][0] = ChessPiece('Rook', 'Black');
    board[0][1] = ChessPiece('Knight', 'Black');
    board[0][2] = ChessPiece('Bishop', 'Black');
    board[0][3] = ChessPiece('Queen', 'Black');
    board[0][4] = ChessPiece('King', 'Black');
    board[0][5] = ChessPiece('Bishop', 'Black');
    board[0][6] = ChessPiece('Knight', 'Black');
    board[0][7] = ChessPiece('Rook', 'Black');
    for (int i = 0; i < 8; i++) {
      board[1][i] = ChessPiece('Pawn', 'Black');
    }

    // 백 말 배치 (하단 1, 2번째 줄)
    board[7][0] = ChessPiece('Rook', 'White');
    board[7][1] = ChessPiece('Knight', 'White');
    board[7][2] = ChessPiece('Bishop', 'White');
    board[7][3] = ChessPiece('Queen', 'White');
    board[7][4] = ChessPiece('King', 'White');
    board[7][5] = ChessPiece('Bishop', 'White');
    board[7][6] = ChessPiece('Knight', 'White');
    board[7][7] = ChessPiece('Rook', 'White');
    for (int i = 0; i < 8; i++) {
      board[6][i] = ChessPiece('Pawn', 'White');
    }
  }

  // 체스판 복사 (체크메이트 검사 시 사용)
  ChessBoard clone() {
    ChessBoard newBoard = ChessBoard();
    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 8; x++) {
        newBoard.board[y][x] = board[y][x];
      }
    }
    return newBoard;
  }

  // 말 이동
  void movePiece(int fromX, int fromY, int toX, int toY) {
    board[toY][toX] = board[fromY][fromX];
    board[fromY][fromX] = null;
  }

  // 왕의 위치 찾기
  List<int>? findKingPosition(String color) {
    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 8; x++) {
        ChessPiece? piece = board[y][x];
        if (piece != null && piece.type == 'King' && piece.color == color) {
          return [x, y];
        }
      }
    }
    return null; // 왕을 찾지 못한 경우
  }
}
