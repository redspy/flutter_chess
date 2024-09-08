import 'package:flutter/material.dart';
import '../models/chess_board.dart';
import '../models/chess_piece.dart';
import '../views/promotion_dialog.dart';

class ChessGameController {
  ChessBoard chessBoard;
  String currentTurn = 'White';
  int? selectedX;
  int? selectedY;
  List<List<int>> possibleMoves = [];
  List<int>? enPassantTarget; // 앙파상 타겟 위치 추적
  late BuildContext context; // BuildContext를 추가
  late Function(String) showEventMessage;

  // 제거된 말 리스트
  List<ChessPiece> whiteCapturedPieces = [];
  List<ChessPiece> blackCapturedPieces = [];

  ChessGameController(this.chessBoard);

  Future<void> _promotePawn(int x, int y, String color) async {
    String? selectedPiece = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PromotionDialog(color: color);
      },
    );

    if (selectedPiece != null) {
      chessBoard.board[y][x] = ChessPiece(selectedPiece, color);
      showEventMessage('${selectedPiece} 프로모션 이벤트가 발동하였습니다.');
      (context as Element).markNeedsBuild();
    }
  }

  void onTap(int x, int y) async {
    ChessPiece? piece = chessBoard.board[y][x];

    if (selectedX == x && selectedY == y) {
      _clearSelection();
    } else if (selectedX == null && selectedY == null) {
      if (piece != null && piece.color == currentTurn) {
        selectedX = x;
        selectedY = y;
        possibleMoves = piece.getPossibleMoves(x, y, chessBoard.board, {
          'enPassant': enPassantTarget,
          'canCastle': (piece.type == 'King' && !piece.hasMoved)
        });
      }
    } else {
      for (List<int> move in possibleMoves) {
        if (move[0] == x && move[1] == y) {
          ChessPiece? capturedPiece = chessBoard.board[y][x];
          if (capturedPiece != null && capturedPiece.color != currentTurn) {
            // 잡힌 말을 리스트에 추가
            if (capturedPiece.color == 'White') {
              whiteCapturedPieces.add(capturedPiece);
            } else {
              blackCapturedPieces.add(capturedPiece);
            }
          }

          chessBoard.movePiece(selectedX!, selectedY!, x, y);
          ChessPiece? movedPiece = chessBoard.board[y][x];

          if (movedPiece != null) {
            movedPiece.hasMoved = true;

            // 앙파상 처리
            if (movedPiece.type == 'Pawn' && enPassantTarget != null) {
              int targetX = enPassantTarget![0];
              int targetY = enPassantTarget![1];
              if (x == targetX && y == targetY) {
                if (movedPiece.color == 'White') {
                  whiteCapturedPieces
                      .add(chessBoard.board[targetY + 1][targetX]!);
                  chessBoard.board[targetY + 1][targetX] = null;
                } else {
                  blackCapturedPieces
                      .add(chessBoard.board[targetY - 1][targetX]!);
                  chessBoard.board[targetY - 1][targetX] = null;
                }

                showEventMessage('앙파상 이벤트가 발동하였습니다.');
              }
            }

            // 앙파상 타겟 설정 (폰이 두 칸 이동한 경우)
            if (movedPiece.type == 'Pawn' && (selectedY! - y).abs() == 2) {
              enPassantTarget = [x, y + ((currentTurn == 'White') ? 1 : -1)];
            } else {
              enPassantTarget = null;
            }

            // 폰 프로모션 처리
            if (movedPiece.type == 'Pawn' && (y == 0 || y == 7)) {
              await _promotePawn(x, y, movedPiece.color);
            }
          }

          _clearSelection();
          currentTurn = (currentTurn == 'White') ? 'Black' : 'White';
          break;
        }
      }
    }
  }

  void _clearSelection() {
    selectedX = null;
    selectedY = null;
    possibleMoves = [];
  }

  bool isPieceSelected(int x, int y) {
    return selectedX == x && selectedY == y;
  }

  bool isPossibleMove(int x, int y) {
    for (List<int> move in possibleMoves) {
      if (move[0] == x && move[1] == y) {
        return true;
      }
    }
    return false;
  }
}
