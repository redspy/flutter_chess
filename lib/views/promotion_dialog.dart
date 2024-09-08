import 'package:flutter/material.dart';

class PromotionDialog extends StatelessWidget {
  final String color;

  const PromotionDialog({required this.color});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('승격할 말을 선택하세요'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _promotionOption(
              context, 'Queen', 'assets/${color.toLowerCase()}_queen.png'),
          _promotionOption(
              context, 'Rook', 'assets/${color.toLowerCase()}_rook.png'),
          _promotionOption(
              context, 'Bishop', 'assets/${color.toLowerCase()}_bishop.png'),
          _promotionOption(
              context, 'Knight', 'assets/${color.toLowerCase()}_knight.png'),
        ],
      ),
    );
  }

  Widget _promotionOption(
      BuildContext context, String piece, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(piece); // 선택한 말의 타입을 반환
      },
      child: Image.asset(
        imagePath,
        width: 50,
        height: 50,
      ),
    );
  }
}
