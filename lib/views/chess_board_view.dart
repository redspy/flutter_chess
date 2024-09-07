import 'package:flutter/material.dart';
import '../models/chess_board.dart';
import '../models/chess_piece.dart';

class ChessBoardView extends StatelessWidget {
  final ChessBoard chessBoard;
  final Function(int x, int y) onPieceTap;

  ChessBoardView({required this.chessBoard, required this.onPieceTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
      itemBuilder: (context, index) {
        int x = index % 8;
        int y = index ~/ 8;
        ChessPiece? piece = chessBoard.board[y][x]; // y, x 좌표 순서를 맞춰줍니다.
        return GestureDetector(
          onTap: () => onPieceTap(x, y),
          child: Container(
            decoration: BoxDecoration(
              color: (x + y) % 2 == 0 ? Colors.white : Colors.grey,
              border: Border.all(color: Colors.black),
            ),
            child: Center(
              child: piece != null
                  ? Text(
                      piece.symbol, // 체스말 이모티콘으로 표시
                      style: TextStyle(fontSize: 36),
                    )
                  : Container(),
            ),
          ),
        );
      },
      itemCount: 64,
    );
  }
}
