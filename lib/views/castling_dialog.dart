import 'package:flutter/material.dart';

class CastlingDialog extends StatelessWidget {
  final List<List<int>> possibleMoves; // 캐슬링 가능한 이동 경로 리스트
  final List<int> currentKingPosition; // 현재 왕의 위치
  final List<int> currentRookPosition; // 현재 룩의 위치
  final String kingColor; // 왕의 색 (백 또는 흑)

  CastlingDialog({
    required this.possibleMoves,
    required this.currentKingPosition,
    required this.currentRookPosition,
    required this.kingColor,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('캐슬링 가능한 경로'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // "현재 위치" 캡션과 함께 현재 왕과 룩의 위치 시각화
          Text('현재 위치'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildCurrentPosition(),
          ),
          SizedBox(height: 16),

          // 캐슬링 후 이동 가능한 경로를 선택할 수 있도록 시각적으로 표시
          Text('캐슬링 가능 위치'),
          Column(
            children: possibleMoves.map((move) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(move); // 선택된 경로 반환
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildCastlingPath(move),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text('취소'),
          onPressed: () {
            Navigator.of(context).pop(); // 다이얼로그 닫기
          },
        ),
      ],
    );
  }

  // 현재 위치 시각화 (캐슬링 전)
  List<Widget> _buildCurrentPosition() {
    return [
      _buildSquare('assets/${kingColor}_king.png'), // 왕 이미지
      _buildSquare(''), // 빈칸
      _buildSquare(''), // 빈칸
      _buildSquare('assets/${kingColor}_rook.png'), // 룩 이미지
    ];
  }

  // 캐슬링 후 이동 경로를 시각적으로 보여주는 함수
  List<Widget> _buildCastlingPath(List<int> move) {
    // 캐슬링 후의 위치 결정 (move[0]는 킹의 열 위치)
    bool isKingSide = move[0] == 6; // 킹사이드 캐슬링
    return [
      isKingSide
          ? _buildSquare('')
          : _buildSquare('assets/${kingColor}_rook.png'), // 룩이 퀸사이드에서 이동한 위치
      _buildSquare('assets/${kingColor}_king.png'), // 킹이 이동한 위치
      isKingSide
          ? _buildSquare('assets/${kingColor}_rook.png')
          : _buildSquare(''), // 룩이 킹사이드에서 이동한 위치
      _buildSquare(''), // 빈칸
    ];
  }

  // 사각형 칸을 만드는 함수 (이미지를 표시)
  Widget _buildSquare(String imagePath) {
    return Container(
      margin: EdgeInsets.all(2.0),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: imagePath.isEmpty ? Colors.white : Colors.transparent,
        border: Border.all(color: Colors.black),
      ),
      child: imagePath.isNotEmpty
          ? Image.asset(imagePath, fit: BoxFit.contain)
          : null,
    );
  }
}
