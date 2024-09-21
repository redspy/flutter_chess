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
    switch (piece.type) {
      case 'Pawn':
        break;
      case 'Knight':
        break;
      case 'Bishop':
        break;
      case 'Rook':
        break;
      case 'Queen':
        break;
      case 'King':
        break;
      default:
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
