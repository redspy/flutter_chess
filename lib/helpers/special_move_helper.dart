import '../models/chess_board.dart';
import '../models/chess_piece.dart';
import 'package:flutter/material.dart';
import '../views/promotion_dialog.dart';

enum ChessPieceType { king, queen, rook, bishop, knight, pawn }

enum ChessColor { white, black }

class SpecialMoveHelper {
  static bool canCastle(ChessPiece king, int x, int y, ChessBoard chessBoard,
      String currentTurn) {
    if (king.hasMoved) return false;
    return (currentTurn == 'White' && y == 7 && x == 4) ||
        (currentTurn == 'Black' && y == 0 && x == 4);
  }

  static List<List<int>> getCastlingMoves(
      int x, int y, ChessBoard chessBoard, String currentTurn) {
    List<List<int>> castlingMoves = [];
    if (currentTurn == 'White' && y == 7) {
      if (chessBoard.board[7][5] == null && chessBoard.board[7][6] == null) {
        castlingMoves.add([6, 7]);
      }
      if (chessBoard.board[7][1] == null &&
          chessBoard.board[7][2] == null &&
          chessBoard.board[7][3] == null) {
        castlingMoves.add([2, 7]);
      }
    } else if (currentTurn == 'Black' && y == 0) {
      if (chessBoard.board[0][5] == null && chessBoard.board[0][6] == null) {
        castlingMoves.add([6, 0]);
      }
      if (chessBoard.board[0][1] == null &&
          chessBoard.board[0][2] == null &&
          chessBoard.board[0][3] == null) {
        castlingMoves.add([2, 0]);
      }
    }
    return castlingMoves;
  }

  static void performCastling(
      ChessBoard chessBoard, List<int> selectedMove, List<int> kingPosition) {
    int targetX = selectedMove[0];
    int targetY = selectedMove[1];
    chessBoard.movePiece(kingPosition[0], kingPosition[1], targetX, targetY);
    if (targetX == 6) {
      chessBoard.movePiece(7, targetY, 5, targetY);
    } else if (targetX == 2) {
      chessBoard.movePiece(0, targetY, 3, targetY);
    }
  }

  static Future<void> handlePromotion(
    ChessPiece piece,
    int x,
    int y,
    String currentTurn,
    BuildContext context,
    Function(String) showEventMessage,
  ) async {
    // 'piece'가 폰인지 확인
    if (piece.type == 'Pawn' && (y == 0 || y == 7)) {
      // 프로모션 다이얼로그 띄우기
      String? selectedPiece = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PromotionDialog(color: piece.color); // 색상에 따른 다이얼로그
        },
      );

      if (selectedPiece != null) {
        piece.type = selectedPiece; // 폰을 선택된 말로 승격
        showEventMessage('$selectedPiece 프로모션 이벤트가 발동하였습니다.');
        (context as Element).markNeedsBuild(); // UI 갱신
      }
    }
  }

  static int? getEnPassantTarget(ChessPiece piece, int x, int y) {
    // Assuming enPassant is only for pawns and occurs on specific rows
    if (piece.type == ChessPieceType.pawn) {
      // Check if the pawn has moved two squares forward
      if ((piece.color == ChessColor.white && y == 3) ||
          (piece.color == ChessColor.black && y == 4)) {
        return x; // enPassant target is the current x position
      }
    }
    return null; // No enPassant target available
  }
}
