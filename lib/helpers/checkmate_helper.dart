// import '../models/chess_board.dart';
// import '../models/chess_piece.dart';

// class CheckmateHelper {
//   static bool isCheckmate(ChessBoard chessBoard, String color) {
//     ChessPiece? king = chessBoard.findKing(color);
//     if (king == null) return false;

//     // 기본적으로 캐슬링은 체크메이트를 확인할 때 고려하지 않음
//     List<List<int>> kingMoves =
//         king.getPossibleMoves(chessBoard.board, {'canCastle': false});

//     // 왕이 체크 상태이고 움직일 수 있는 경로가 없으면 체크메이트로 간주
//     if (chessBoard.isInCheck(color) && kingMoves.isEmpty) {
//       return true;
//     }

//     return false;
//   }
// }
