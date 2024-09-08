import 'package:flutter/material.dart';
import '../models/chess_board.dart';
import '../models/chess_piece.dart';
import '../views/promotion_dialog.dart'; // 프로모션 다이얼로그 import 추가

class ChessGameController {
  ChessBoard chessBoard;
  String currentTurn = 'White'; // 현재 턴: White부터 시작
  int? selectedX;
  int? selectedY;
  List<List<int>> possibleMoves = [];
  List<int>? enPassantTarget; // 앙파상 타겟 위치 추적
  late BuildContext context; // BuildContext 추가

  ChessGameController(this.chessBoard);

  // 폰 프로모션 처리
  Future<void> _promotePawn(int x, int y, String color) async {
    String? selectedPiece = await showDialog<String>(
      context: context,
      barrierDismissible: false, // 팝업을 닫기 전까지 화면을 사용할 수 없도록 설정
      builder: (BuildContext context) {
        return PromotionDialog(color: color);
      },
    );

    // 선택된 말이 있는 경우 말 교체
    if (selectedPiece != null) {
      chessBoard.board[y][x] = ChessPiece(selectedPiece, color);
      // UI 갱신을 위해 setState를 호출해야 할 수 있음
      (context as Element).markNeedsBuild(); // UI가 즉시 갱신되도록 처리
    }
  }

  // 말 선택 및 이동 로직
  void onTap(int x, int y) async {
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
        possibleMoves = piece.getPossibleMoves(x, y, chessBoard.board, {
          'enPassant': enPassantTarget,
          'canCastle': (piece.type == 'King' && !piece.hasMoved)
        }); // 이동 가능 경로 계산
      }
    }
    // 선택된 말이 있는 상태에서, 이동 가능한 위치를 선택하면 말 이동
    else {
      for (List<int> move in possibleMoves) {
        if (move[0] == x && move[1] == y) {
          // 말 이동
          chessBoard.movePiece(selectedX!, selectedY!, x, y);

          // 이동 후의 말 가져오기
          ChessPiece? movedPiece = chessBoard.board[y][x];

          if (movedPiece != null) {
            // 첫 이동 처리: 폰이 첫 이동을 마쳤으므로 hasMoved를 true로 설정
            movedPiece.hasMoved = true;

            // 앙파상 타겟 설정 (폰이 두 칸 이동한 경우)
            if (movedPiece.type == 'Pawn' && (selectedY! - y).abs() == 2) {
              enPassantTarget = [x, y + ((currentTurn == 'White') ? 1 : -1)];
            } else {
              enPassantTarget = null;
            }

            // 폰 프로모션: 폰이 끝에 도달하면 승격
            if (movedPiece.type == 'Pawn' && (y == 0 || y == 7)) {
              await _promotePawn(x, y, movedPiece.color); // 비동기적으로 팝업 띄우기
            }
          }

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
