import 'dart:math';
import '../models/chess_board.dart';
import '../models/chess_piece.dart';
import 'move.dart';
import '../AI/BoardEvaluator.dart';

class ChessAI {
  final int depth;
  final ChessBoard chessBoard;
  final BoardEvaluator evaluator;

  ChessAI(this.chessBoard, {this.depth = 5}) : evaluator = BoardEvaluator();

  Move? findBestMove(String playerColor) {
    Move? bestMove;
    double bestEval = double.negativeInfinity;

    List<Move> possibleMoves = _getAllPossibleMoves(playerColor);
    for (Move move in possibleMoves) {
      ChessBoard tempBoard = chessBoard.clone();
      tempBoard.movePiece(move.fromX, move.fromY, move.toX, move.toY);
      double eval = _minimax(tempBoard, depth - 1, double.negativeInfinity,
          double.infinity, false);

      if (eval > bestEval) {
        bestEval = eval;
        bestMove = move;
      }
    }
    return bestMove;
  }

  double _minimax(ChessBoard board, int depth, double alpha, double beta,
      bool isMaximizingPlayer) {
    if (depth == 0 || _isGameOver(board)) {
      return evaluator.evaluateBoard(board); // 평가 함수 호출
    }

    if (isMaximizingPlayer) {
      double maxEval = double.negativeInfinity;
      List<Move> moves = _getAllPossibleMoves('White', board);
      for (Move move in moves) {
        ChessBoard tempBoard = board.clone();
        tempBoard.movePiece(move.fromX, move.fromY, move.toX, move.toY);
        double eval = _minimax(tempBoard, depth - 1, alpha, beta, false);
        maxEval = max(maxEval, eval);
        alpha = max(alpha, eval);
        if (beta <= alpha) {
          break; // 베타 컷
        }
      }
      return maxEval;
    } else {
      double minEval = double.infinity;
      List<Move> moves = _getAllPossibleMoves('Black', board);
      for (Move move in moves) {
        ChessBoard tempBoard = board.clone();
        tempBoard.movePiece(move.fromX, move.fromY, move.toX, move.toY);
        double eval = _minimax(tempBoard, depth - 1, alpha, beta, true);
        minEval = min(minEval, eval);
        beta = min(beta, eval);
        if (beta <= alpha) {
          break; // 알파 컷
        }
      }
      return minEval;
    }
  }

  List<Move> _getAllPossibleMoves(String color, [ChessBoard? board]) {
    board ??= chessBoard;
    List<Move> moves = [];
    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 8; x++) {
        ChessPiece? piece = board.board[y][x];
        if (piece != null && piece.color == color) {
          List<List<int>> possibleMoves =
              piece.getPossibleMoves(x, y, board.board);
          for (List<int> move in possibleMoves) {
            moves.add(Move(x, y, move[0], move[1]));
          }
        }
      }
    }
    return moves;
  }

  bool _isGameOver(ChessBoard board) {
    return _getAllPossibleMoves('White', board).isEmpty ||
        _getAllPossibleMoves('Black', board).isEmpty;
  }
}
