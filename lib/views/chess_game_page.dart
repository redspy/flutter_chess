import 'package:flutter/material.dart';
import '../models/chess_board.dart';
import '../controllers/chess_game_controller.dart';
import '../views/chess_board_view.dart';

class ChessGamePage extends StatefulWidget {
  final bool isVsAI; // 게임 모드 (AI vs Player 또는 Player vs Player)

  ChessGamePage({required this.isVsAI});

  @override
  _ChessGamePageState createState() => _ChessGamePageState();
}

class _ChessGamePageState extends State<ChessGamePage> {
  late ChessGameController _gameController;
  late ChessBoard _chessBoard;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  // 게임을 초기화하는 함수
  void _initializeGame() {
    _chessBoard = ChessBoard(); // 체스 보드 초기화
    _gameController =
        ChessGameController(_chessBoard, isVsAI: widget.isVsAI); // 게임 컨트롤러 초기화
  }

  // 체스판에서 말을 선택했을 때 호출되는 함수
  void _onPieceTap(int x, int y) {
    setState(() {
      _gameController.onTap(
          x, y, context, () => setState(() {})); // 말 이동 처리 후 UI 업데이트
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
                _initializeGame(); // 리셋 버튼 눌렀을 때 게임을 초기화
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
