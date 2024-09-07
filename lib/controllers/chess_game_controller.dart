import '../models/chess_board.dart';
import '../models/chess_piece.dart'; // ChessPiece import 추가

class ChessGameController {
  ChessBoard chessBoard;
  String currentTurn = 'White'; // 현재 턴: White부터 시작
  int? selectedX;
  int? selectedY;
  List<List<int>> possibleMoves = [];

  ChessGameController(this.chessBoard);

  // 말 선택 및 이동 로직
  void onTap(int x, int y) {
    ChessPiece? piece = chessBoard.board[y][x];

    // 선택된 말을 다시 선택하면 선택을 취소
    if (selectedX == x && selectedY == y) {
      _clearSelection();
    }
    // 현재 선택된 말이 없고, 선택한 말이 현재 턴의 말인 경우 선택
    else if (selectedX == null && selectedY == null) {
      if (piece != null && piece.color == currentTurn) {
        selectedX = x;
        selectedY = y;
        possibleMoves =
            piece.getPossibleMoves(x, y, chessBoard.board); // 이동 가능 경로 계산
      }
    }
    // 선택된 말이 있는 상태에서, 이동 가능한 위치를 선택하면 말 이동
    else {
      // 좌표 리스트를 비교하기 위해 명시적으로 비교
      for (List<int> move in possibleMoves) {
        if (move[0] == x && move[1] == y) {
          chessBoard.movePiece(selectedX!, selectedY!, x, y);
          _clearSelection();
          currentTurn = (currentTurn == 'White') ? 'Black' : 'White'; // 턴 교체
          break;
        }
      }
    }
  }

  // 선택을 취소하거나 초기화하는 메서드
  void _clearSelection() {
    selectedX = null;
    selectedY = null;
    possibleMoves = [];
  }

  // 선택된 말 여부 확인
  bool isPieceSelected(int x, int y) {
    return selectedX == x && selectedY == y;
  }

  // 이동 가능 영역 여부 확인
  bool isPossibleMove(int x, int y) {
    for (List<int> move in possibleMoves) {
      if (move[0] == x && move[1] == y) {
        return true;
      }
    }
    return false;
  }
}
