import 'package:flutter/material.dart';
import '../models/chess_board.dart';
import '../models/chess_piece.dart';
import '../controllers/chess_game_controller.dart';

class ChessBoardView extends StatefulWidget {
  final ChessBoard chessBoard;
  final ChessGameController gameController;
  final Function(int x, int y) onPieceTap;
  final List<ChessPiece> whiteCapturedPieces; // 백의 제거된 말 리스트
  final List<ChessPiece> blackCapturedPieces; // 흑의 제거된 말 리스트

  ChessBoardView({
    required this.chessBoard,
    required this.gameController,
    required this.onPieceTap,
    required this.whiteCapturedPieces,
    required this.blackCapturedPieces,
  });

  @override
  _ChessBoardViewState createState() => _ChessBoardViewState();
}

class _ChessBoardViewState extends State<ChessBoardView> {
  String? eventMessage;

  @override
  void initState() {
    super.initState();
    widget.gameController.showEventMessage = _showEventMessage;
    widget.gameController.context = context;
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
        // 체스판을 Expanded로 감싸 화면 크기에 맞게 조정
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
            physics: NeverScrollableScrollPhysics(), // 스크롤 방지
          ),
        ),

        // 이벤트 메시지 표시
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

        // 흑과 백의 제거된 말 리스트를 표 형식으로 표시 (제거된 말 모두 표현)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            // 스크롤 가능하게 수정
            child: Column(
              children: [
                // 흑의 제거된 말 리스트 (좌측에 "흑" 표시)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '흑',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 4,
                        runSpacing: 4,
                        children: widget.blackCapturedPieces
                            .map((piece) => Image.asset(
                                  piece.imagePath,
                                  width: 30,
                                  height: 30,
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // 백의 제거된 말 리스트 (좌측에 "백" 표시)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '백',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 4,
                        runSpacing: 4,
                        children: widget.whiteCapturedPieces
                            .map((piece) => Image.asset(
                                  piece.imagePath,
                                  width: 30,
                                  height: 30,
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
