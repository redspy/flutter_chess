import '../models/chess_board.dart';
import '../models/chess_piece.dart';

class ChessGameController {
  ChessBoard chessBoard;
  String currentTurn = 'White'; // 현재 턴: White부터 시작
  int? selectedX;
  int? selectedY;

  ChessGameController(this.chessBoard);

  // 말 선택 및 이동 로직
  void onTap(int x, int y) {
    ChessPiece? piece = chessBoard.board[y][x];

    // 현재 턴인 말만 선택 가능
    if (selectedX == null && selectedY == null) {
      if (piece != null && piece.color == currentTurn) {
        // 선택된 말
        selectedX = x;
        selectedY = y;
      }
    } else {
      // 선택된 말이 있는 상태에서 다른 칸을 클릭하면 이동
      chessBoard.movePiece(selectedX!, selectedY!, x, y);
      selectedX = null;
      selectedY = null;

      // 턴을 흑과 백으로 교체
      currentTurn = (currentTurn == 'White') ? 'Black' : 'White';
    }
  }

  // 선택된 말 여부 확인
  bool isPieceSelected(int x, int y) {
    return selectedX == x && selectedY == y;
  }
}
