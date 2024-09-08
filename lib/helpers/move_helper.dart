// import '../models/chess_board.dart';
// import '../models/chess_piece.dart';

// class MoveHelper {
//   static List<List<int>> getPossibleMoves(ChessPiece piece, int x, int y,
//       List<List<ChessPiece?>> board, Map<String, dynamic> options) {
//     // getPossibleMoves 호출 시 board와 options를 모두 전달
//     return piece.getPossibleMoves(board, options);
//   }

//   static void processMove(
//       ChessBoard chessBoard,
//       int fromX,
//       int fromY,
//       int toX,
//       int toY,
//       String currentTurn,
//       List<int>? enPassantTarget,
//       List<ChessPiece> whiteCapturedPieces,
//       List<ChessPiece> blackCapturedPieces,
//       Function(String) showEventMessage) {
//     ChessPiece? capturedPiece = chessBoard.board[toY][toX];
//     if (capturedPiece != null && capturedPiece.color != currentTurn) {
//       if (capturedPiece.color == 'White') {
//         whiteCapturedPieces.add(capturedPiece);
//       } else {
//         blackCapturedPieces.add(capturedPiece);
//       }
//     }

//     chessBoard.movePiece(fromX, fromY, toX, toY);

//     ChessPiece? movedPiece = chessBoard.board[toY][toX];

//     if (movedPiece != null &&
//         movedPiece.type == 'Pawn' &&
//         enPassantTarget != null) {
//       int targetX = enPassantTarget[0];
//       int targetY = enPassantTarget[1];
//       if (toX == targetX && toY == targetY) {
//         chessBoard.board[targetY - ((currentTurn == 'White') ? 1 : -1)]
//             [targetX] = null;
//         showEventMessage('앙파상 이벤트가 발동하였습니다.');
//       }
//     }
//   }
// }
