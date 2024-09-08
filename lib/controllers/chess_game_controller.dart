import 'package:flutter/material.dart';
import '../models/chess_board.dart';
import '../models/chess_piece.dart';
import '../views/promotion_dialog.dart';
import '../views/castling_dialog.dart';

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

  // 캐슬링 팝업 호출
  Future<void> _showCastlingDialog(List<List<int>> castlingMoves,
      List<int> kingPosition, List<int> rookPosition, String kingColor) async {
    List<int>? selectedMove = await showDialog<List<int>>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CastlingDialog(
          possibleMoves: castlingMoves,
          currentKingPosition: kingPosition,
          currentRookPosition: rookPosition,
          kingColor: kingColor,
        );
      },
    );

    if (selectedMove != null) {
      int targetX = selectedMove[0];
      int targetY = selectedMove[1];
      chessBoard.movePiece(selectedX!, selectedY!, targetX, targetY); // 왕 이동
      if (targetX == 6) {
        chessBoard.movePiece(7, targetY, 5, targetY); // 킹사이드 캐슬링: 룩 이동
      } else if (targetX == 2) {
        chessBoard.movePiece(0, targetY, 3, targetY); // 퀸사이드 캐슬링: 룩 이동
      }
      showEventMessage('캐슬링 이벤트가 발동하였습니다.');
      _clearSelection();
      currentTurn = (currentTurn == 'White') ? 'Black' : 'White';
    }
  }

  // 캐슬링 가능 여부 확인
  bool _canCastle(ChessPiece king, int x, int y) {
    if (king.hasMoved) return false;
    if (x != 4) return false;

    if (currentTurn == 'White' && y == 7) {
      if (chessBoard.board[7][5] == null &&
          chessBoard.board[7][6] == null &&
          chessBoard.board[7][7]?.type == 'Rook' &&
          !chessBoard.board[7][7]!.hasMoved) {
        return true;
      }
      if (chessBoard.board[7][1] == null &&
          chessBoard.board[7][2] == null &&
          chessBoard.board[7][3] == null &&
          chessBoard.board[7][0]?.type == 'Rook' &&
          !chessBoard.board[7][0]!.hasMoved) {
        return true;
      }
    } else if (currentTurn == 'Black' && y == 0) {
      if (chessBoard.board[0][5] == null &&
          chessBoard.board[0][6] == null &&
          chessBoard.board[0][7]?.type == 'Rook' &&
          !chessBoard.board[0][7]!.hasMoved) {
        return true;
      }
      if (chessBoard.board[0][1] == null &&
          chessBoard.board[0][2] == null &&
          chessBoard.board[0][3] == null &&
          chessBoard.board[0][0]?.type == 'Rook' &&
          !chessBoard.board[0][0]!.hasMoved) {
        return true;
      }
    }
    return false;
  }

  // 캐슬링 가능한 이동 경로 가져오기
  List<List<int>> _getCastlingMoves(int x, int y) {
    List<List<int>> castlingMoves = [];
    if (currentTurn == 'White' && y == 7) {
      if (chessBoard.board[7][5] == null &&
          chessBoard.board[7][6] == null &&
          chessBoard.board[7][7]?.type == 'Rook') {
        castlingMoves.add([6, 7]); // 킹사이드 캐슬링
      }
      if (chessBoard.board[7][1] == null &&
          chessBoard.board[7][2] == null &&
          chessBoard.board[7][3] == null &&
          chessBoard.board[7][0]?.type == 'Rook') {
        castlingMoves.add([2, 7]); // 퀸사이드 캐슬링
      }
    } else if (currentTurn == 'Black' && y == 0) {
      if (chessBoard.board[0][5] == null &&
          chessBoard.board[0][6] == null &&
          chessBoard.board[0][7]?.type == 'Rook') {
        castlingMoves.add([6, 0]); // 킹사이드 캐슬링
      }
      if (chessBoard.board[0][1] == null &&
          chessBoard.board[0][2] == null &&
          chessBoard.board[0][3] == null &&
          chessBoard.board[0][0]?.type == 'Rook') {
        castlingMoves.add([2, 0]); // 퀸사이드 캐슬링
      }
    }
    return castlingMoves;
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
          'canCastle': _canCastle(piece, x, y)
        });
        // 캐슬링 가능한 상황이면 팝업 다이얼로그 표시
        if (piece.type == 'King' && _canCastle(piece, x, y)) {
          List<List<int>> castlingMoves = _getCastlingMoves(x, y);
          List<int> rookPosition =
              (x == 4 && y == 7) ? [7, 7] : [0, 7]; // 룩 위치 설정
          String kingColor =
              piece.color.toLowerCase(); // 왕의 색상 결정 (white/black)
          if (castlingMoves.isNotEmpty) {
            await _showCastlingDialog(
                castlingMoves, [x, y], rookPosition, kingColor);
          }
        }
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
