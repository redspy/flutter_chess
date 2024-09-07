import 'package:flutter/material.dart';
import '../models/chess_board.dart';
import '../models/chess_piece.dart';
import '../controllers/chess_game_controller.dart';

class ChessBoardView extends StatelessWidget {
  final ChessBoard chessBoard;
  final ChessGameController gameController;
  final Function(int x, int y) onPieceTap;

  ChessBoardView(
      {required this.chessBoard,
      required this.gameController,
      required this.onPieceTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
            itemBuilder: (context, index) {
              int x = index % 8;
              int y = index ~/ 8;
              ChessPiece? piece = chessBoard.board[y][x];
              bool isSelected =
                  gameController.isPieceSelected(x, y); // 선택된 말 여부 확인

              return GestureDetector(
                onTap: () => onPieceTap(x, y),
                child: Container(
                  decoration: BoxDecoration(
                    color: (x + y) % 2 == 0 ? Colors.white : Colors.grey,
                    border: Border.all(color: Colors.black),
                  ),
                  child: Center(
                    child: piece != null
                        ? Image.asset(
                            piece.imagePath, // 체스말 이미지를 표시
                            width: 36,
                            height: 36,
                            color: isSelected
                                ? Colors.blueAccent
                                : null, // 선택된 말 강조
                          )
                        : Container(),
                  ),
                ),
              );
            },
            itemCount: 64,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '${gameController.currentTurn}의 순서 입니다.', // 현재 턴 표시
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
