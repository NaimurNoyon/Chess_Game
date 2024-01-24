import 'package:chase_game/components/piece.dart';
import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;
  const Square({super.key, required this.isWhite, required this.piece});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5.0),
      color: isWhite? Colors.grey[400] : Colors.grey[600],
      child: piece!= null ?
      Image.asset(
        piece!.imagePath,
        color: piece!.isWhite ? Colors.white : Colors.black,
      ) : null,
    );
  }
}
