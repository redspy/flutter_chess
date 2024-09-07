import '../models/chess_board.dart';

class ChessGameController {
  ChessBoard chessBoard;
  int? selectedX;
  int? selectedY;

  ChessGameController(this.chessBoard);

  // 말 선택 및 이동 로직
  void onTap(int x, int y) {
    if (selectedX == null || selectedY == null) {
      // 말 선택
      if (chessBoard.board[y][x] != null) {
        selectedX = x;
        selectedY = y;
      }
    } else {
      // 말 이동
      chessBoard.movePiece(selectedX!, selectedY!, x, y);
      selectedX = null;
      selectedY = null;
    }
  }
}
