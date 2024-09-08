import 'chess_piece.dart';

class ChessBoard {
  List<List<ChessPiece?>> board;

  ChessBoard(this.board);

  // 초기 체스 말 배치 설정 함수
  static ChessBoard initialBoard() {
    return ChessBoard(List.generate(8, (y) => List.generate(8, (x) => null))
      ..[0] = [
        ChessPiece('Rook', 'Black', 0, 0),
        ChessPiece('Knight', 'Black', 1, 0),
        ChessPiece('Bishop', 'Black', 2, 0),
        ChessPiece('Queen', 'Black', 3, 0),
        ChessPiece('King', 'Black', 4, 0),
        ChessPiece('Bishop', 'Black', 5, 0),
        ChessPiece('Knight', 'Black', 6, 0),
        ChessPiece('Rook', 'Black', 7, 0),
      ]
      ..[1] = List.generate(8, (x) => ChessPiece('Pawn', 'Black', x, 1))
      ..[6] = List.generate(8, (x) => ChessPiece('Pawn', 'White', x, 6))
      ..[7] = [
        ChessPiece('Rook', 'White', 0, 7),
        ChessPiece('Knight', 'White', 1, 7),
        ChessPiece('Bishop', 'White', 2, 7),
        ChessPiece('Queen', 'White', 3, 7),
        ChessPiece('King', 'White', 4, 7),
        ChessPiece('Bishop', 'White', 5, 7),
        ChessPiece('Knight', 'White', 6, 7),
        ChessPiece('Rook', 'White', 7, 7),
      ]);
  }

  // 특정 색상의 왕의 위치를 찾는 함수
  ChessPiece? findKing(String color) {
    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 8; x++) {
        ChessPiece? piece = board[y][x];
        if (piece != null && piece.type == 'King' && piece.color == color) {
          return piece;
        }
      }
    }
    return null;
  }

  // 현재 보드 상태에서 특정 색상의 왕이 체크 상태인지 확인하는 함수
  bool isInCheck(String color) {
    ChessPiece? king = findKing(color);
    if (king == null) return false;

    // 모든 적의 말을 확인하여 왕이 공격받고 있는지 확인
    String opponentColor = (color == 'White') ? 'Black' : 'White';
    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 8; x++) {
        ChessPiece? piece = board[y][x];
        if (piece != null && piece.color == opponentColor) {
          // getPossibleMoves 호출 시 options 파라미터 전달
          List<List<int>> moves =
              piece.getPossibleMoves(board, {'canCastle': false});
          for (List<int> move in moves) {
            if (move[0] == king.x && move[1] == king.y) {
              return true; // 왕이 공격받고 있음
            }
          }
        }
      }
    }
    return false; // 왕이 공격받지 않음
  }

  // 말의 이동 함수
  void movePiece(int fromX, int fromY, int toX, int toY) {
    ChessPiece? movingPiece = board[fromY][fromX];
    if (movingPiece != null) {
      board[toY][toX] = movingPiece;
      board[fromY][fromX] = null;
      movingPiece.x = toX;
      movingPiece.y = toY;
    }
  }
}
