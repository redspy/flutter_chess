import 'package:flutter/material.dart';
import 'models/chess_board.dart';
import 'models/chess_piece.dart';
import 'controllers/chess_game_controller.dart';
import 'views/chess_board_view.dart';

void main() {
  runApp(ChessApp());
}

class ChessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chess',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChessHomePage(),
    );
  }
}

class ChessHomePage extends StatefulWidget {
  @override
  _ChessHomePageState createState() => _ChessHomePageState();
}

class _ChessHomePageState extends State<ChessHomePage> {
  late ChessGameController _gameController;
  late ChessBoard _chessBoard;

  @override
  void initState() {
    super.initState();
    _chessBoard = ChessBoard(); // 체스 보드 초기화
    _gameController = ChessGameController(_chessBoard); // 게임 컨트롤러 초기화
  }

  // 체스판에서 말을 선택했을 때 호출되는 함수
  void _onPieceTap(int x, int y) {
    setState(() {
      _gameController.onTap(x, y); // 말 이동 처리
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chess'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _chessBoard = ChessBoard(); // 새 체스판 초기화
                _gameController =
                    ChessGameController(_chessBoard); // 새로운 게임 컨트롤러 초기화
              });
            },
          ),
        ],
      ),
      body: ChessBoardView(
        chessBoard: _chessBoard, // 체스판 전달
        gameController: _gameController, // 게임 컨트롤러 전달
        onPieceTap: _onPieceTap, // 말 선택 시 호출되는 콜백 함수
        whiteCapturedPieces:
            _gameController.whiteCapturedPieces, // 백의 제거된 말 리스트
        blackCapturedPieces:
            _gameController.blackCapturedPieces, // 흑의 제거된 말 리스트
      ),
    );
  }
}
