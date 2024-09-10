import '../models/chess_board.dart';
import '../models/chess_piece.dart';

class BoardEvaluator {
  // 체스판 평가 함수
  double evaluateBoard(ChessBoard board) {
    double score = 0.0;
    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 8; x++) {
        ChessPiece? piece = board.board[y][x];
        if (piece != null) {
          double pieceValue = _getPieceValue(piece, x, y);
          score += piece.color == 'White' ? pieceValue : -pieceValue;
        }
      }
    }
    return score;
  }

  // 말의 가치를 계산하는 함수
  double _getPieceValue(ChessPiece piece, int x, int y) {
    double baseValue;
    switch (piece.type) {
      case 'Pawn':
        baseValue = 1.0;
        break;
      case 'Knight':
        baseValue = 3.0;
        break;
      case 'Bishop':
        baseValue = 3.3;
        break;
      case 'Rook':
        baseValue = 5.0;
        break;
      case 'Queen':
        baseValue = 9.0;
        break;
      case 'King':
        baseValue = 100.0;
        break;
      default:
        baseValue = 0.0;
    }

    double centrality = 0.5 * (4 - (x - 3.5).abs()) * (4 - (y - 3.5).abs());
    if (piece.type == 'Pawn') {
      return piece.color == 'White'
          ? (y * 0.1 + centrality)
          : ((7 - y) * 0.1 + centrality);
    }
    return centrality;
  }
}
