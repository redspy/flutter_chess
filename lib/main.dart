import 'package:flutter/material.dart';
import 'controllers/chess_game_controller.dart';
import 'models/chess_board.dart';
import 'views/chess_board_view.dart';

void main() {
  runApp(ChessApp());
}

class ChessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChessGamePage(),
    );
  }
}

class ChessGamePage extends StatefulWidget {
  @override
  _ChessGamePageState createState() => _ChessGamePageState();
}

class _ChessGamePageState extends State<ChessGamePage> {
  late ChessBoard chessBoard;
  late ChessGameController gameController;

  @override
  void initState() {
    super.initState();
    chessBoard = ChessBoard();
    gameController = ChessGameController(chessBoard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chess'),
      ),
      body: ChessBoardView(
        chessBoard: chessBoard,
        onPieceTap: (x, y) {
          setState(() {
            gameController.onTap(x, y);
          });
        },
      ),
    );
  }
}
