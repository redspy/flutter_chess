import 'package:flutter/material.dart';
import 'views/chess_board_view.dart';
import 'controllers/chess_game_controller.dart';
import 'models/chess_board.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chess',
      home: ChessGameScreen(),
    );
  }
}

class ChessGameScreen extends StatefulWidget {
  @override
  _ChessGameScreenState createState() => _ChessGameScreenState();
}

class _ChessGameScreenState extends State<ChessGameScreen> {
  late ChessGameController _controller;

  @override
  void initState() {
    super.initState();
    ChessBoard chessBoard = ChessBoard.initialBoard();
    _controller = ChessGameController(chessBoard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chess'),
      ),
      body: ChessBoardView(
        chessBoard: _controller.chessBoard,
        gameController: _controller,
        onPieceTap: (x, y) => _controller.onTap(x, y),
        whiteCapturedPieces: [],
        blackCapturedPieces: [],
      ),
    );
  }
}
