import 'package:flutter/material.dart';
import '../models/chess_board.dart';
import '../models/chess_piece.dart';
import '../controllers/chess_game_controller.dart';

class ChessBoardView extends StatefulWidget {
  final ChessBoard chessBoard;
  final ChessGameController gameController;
  final Function(int x, int y) onPieceTap;

  ChessBoardView(
      {required this.chessBoard,
      required this.gameController,
      required this.onPieceTap});

  @override
  _ChessBoardViewState createState() => _ChessBoardViewState();
}

class _ChessBoardViewState extends State<ChessBoardView> {
  String? eventMessage;

  @override
  void initState() {
    super.initState();
    // ChessGameController에 showEventMessage 콜백을 초기화
    widget.gameController.showEventMessage = _showEventMessage;
    widget.gameController.context = context; // BuildContext 초기화
  }

  // 이벤트 메시지를 표시하는 함수
  void _showEventMessage(String message) {
    setState(() {
      eventMessage = message;
    });

    // 5초 후에 메시지 지우기
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        eventMessage = null;
      });
    });
  }

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
              ChessPiece? piece = widget.chessBoard.board[y][x];
              bool isSelected = widget.gameController.isPieceSelected(x, y);
              bool isPossibleMove = widget.gameController.isPossibleMove(x, y);

              return GestureDetector(
                onTap: () => widget.onPieceTap(x, y),
                child: Container(
                  decoration: BoxDecoration(
                    color: isPossibleMove
                        ? Colors.greenAccent
                        : (x + y) % 2 == 0
                            ? Colors.white
                            : Colors.grey,
                    border: Border.all(color: Colors.black),
                  ),
                  child: Center(
                    child: piece != null
                        ? Image.asset(
                            piece.imagePath,
                            width: 36,
                            height: 36,
                            color: isSelected ? Colors.blueAccent : null,
                          )
                        : Container(),
                  ),
                ),
              );
            },
            itemCount: 64,
          ),
        ),
        if (eventMessage != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              eventMessage!,
              style: TextStyle(fontSize: 18, color: Colors.redAccent),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '${widget.gameController.currentTurn}의 순서입니다.',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
