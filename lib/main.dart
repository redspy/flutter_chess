import 'package:flutter/material.dart';
import 'views/chess_game_page.dart';

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

class ChessHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chess Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Choose Game Mode',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // AI 대전 모드로 게임 시작
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChessGamePage(isVsAI: true)),
                );
              },
              child: Text('Player vs AI'),
            ),
            ElevatedButton(
              onPressed: () {
                // 플레이어 대 플레이어 모드로 게임 시작
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChessGamePage(isVsAI: false)),
                );
              },
              child: Text('Player vs Player'),
            ),
          ],
        ),
      ),
    );
  }
}
