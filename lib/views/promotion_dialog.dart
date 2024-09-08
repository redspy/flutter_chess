import 'package:flutter/material.dart';

class PromotionDialog extends StatelessWidget {
  final String color;

  PromotionDialog({required this.color});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('폰 프로모션'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop('Queen'); // 퀸으로 프로모션
            },
            child: _buildPromotionOption('assets/${color}_queen.png', '퀸'),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop('Rook'); // 룩으로 프로모션
            },
            child: _buildPromotionOption('assets/${color}_rook.png', '룩'),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop('Bishop'); // 비숍으로 프로모션
            },
            child: _buildPromotionOption('assets/${color}_bishop.png', '비숍'),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop('Knight'); // 나이트로 프로모션
            },
            child: _buildPromotionOption('assets/${color}_knight.png', '나이트'),
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

  // 프로모션 선택 옵션을 위한 위젯
  Widget _buildPromotionOption(String imagePath, String label) {
    return Row(
      children: [
        Image.asset(imagePath, width: 40, height: 40),
        SizedBox(width: 10),
        Text(label, style: TextStyle(fontSize: 18)),
      ],
    );
  }
}
