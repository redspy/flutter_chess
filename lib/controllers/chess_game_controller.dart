import 'package:flutter/material.dart';
import '../models/chess_board.dart';
import '../models/chess_piece.dart';
import '../helpers/move_helper.dart';
import '../helpers/special_move_helper.dart';
import '../helpers/checkmate_helper.dart';
import '../views/castling_dialog.dart';
import '../views/promotion_dialog.dart';

class ChessGameController {
  ChessBoard chessBoard;
  String currentTurn = 'White';
  int? selectedX;
  int? selectedY;
  List<List<int>> possibleMoves = [];
  List<int>? enPassantTarget;
  late BuildContext context;
  late Function(String) showEventMessage;

  ChessGameController(this.chessBoard);

  void onTap(int x, int y) async {
    ChessPiece? piece = chessBoard.board[y][x];

    if (piece == null) {
      return;
    }
    if (selectedX == x && selectedY == y) {
      _clearSelection();
    } else if (selectedX == null && selectedY == null) {
      if (piece.color == currentTurn) {
        selectedX = x;
        selectedY = y;

        // Check if enPassantTarget is null and set a default value
        Map<String, dynamic> moveOptions = {
          'enPassant': enPassantTarget ?? null, // Set default value or logic
          'canCastle':
              SpecialMoveHelper.canCastle(piece, x, y, chessBoard, currentTurn),
        };

        // Handle enPassant logic based on move type
        if (piece.type == ChessPieceType.pawn && (y == 3 || y == 4)) {
          enPassantTarget =
              SpecialMoveHelper.getEnPassantTarget(piece, x, y) as List<int>?;
          moveOptions['enPassant'] = enPassantTarget;
        }

        possibleMoves = MoveHelper.getPossibleMoves(
            piece, x, y, chessBoard.board, moveOptions);
      }
    } else {
      MoveHelper.processMove(
        chessBoard,
        selectedX!,
        selectedY!,
        x,
        y,
        currentTurn,
        enPassantTarget,
        [],
        [],
        showEventMessage,
      );

      if (piece != null) {
        await SpecialMoveHelper.handlePromotion(
            piece, x, y, currentTurn, context, showEventMessage);
      }

      _clearSelection();
      currentTurn = (currentTurn == 'White') ? 'Black' : 'White';
    }

    if (CheckmateHelper.isCheckmate(
        chessBoard, currentTurn == 'White' ? 'Black' : 'White')) {
      await _showCheckmateDialog(currentTurn == 'White' ? '백' : '흑',
          currentTurn == 'White' ? '흑' : '백');
    }
    print('Selected piece: $piece');
    print('Possible moves: $possibleMoves');
  }

  void _clearSelection() {
    selectedX = null;
    selectedY = null;
    possibleMoves = [];
  }

  Future<void> _showCastlingDialog(List<List<int>> castlingMoves,
      List<int> kingPosition, String kingColor) async {
    List<int>? selectedMove = await showDialog<List<int>>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CastlingDialog(
            possibleMoves: castlingMoves, kingColor: kingColor);
      },
    );
    if (selectedMove != null) {
      SpecialMoveHelper.performCastling(chessBoard, selectedMove, kingPosition);
      showEventMessage('캐슬링 이벤트가 발동하였습니다.');
    }
  }

  Future<void> _showCheckmateDialog(String winner, String loser) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('체크메이트'),
          content: Text('$winner가 $loser에게 체크메이트 하였습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  // 선택된 말인지 확인하는 함수
  bool isPieceSelected(int x, int y) {
    return selectedX == x && selectedY == y;
  }

  // 이동 가능한 경로인지 확인하는 함수
  bool isPossibleMove(int x, int y) {
    for (List<int> move in possibleMoves) {
      if (move[0] == x && move[1] == y) {
        return true;
      }
    }
    return false;
  }
}
