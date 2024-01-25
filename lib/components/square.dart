import 'package:chase_game/components/piece.dart';
import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;
  final bool isSelected;
  final bool isValidMove;
  final void Function()? onTap;
  const Square({
    super.key,
    required this.isWhite,
    required this.piece,
    required this.isSelected,
    required this.isValidMove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color? squareColor;
    if(isSelected) {
      squareColor = Colors.green;
    }else if(isValidMove) {
      squareColor = Colors.green[300];
    }else {
      squareColor = isWhite? Colors.grey[400] : Colors.grey[600];
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 5.0),
        margin: EdgeInsets.all(isValidMove? 5 : 0),
        color: squareColor,
        child: piece!= null ?
        Image.asset(
          piece!.imagePath,
          color: piece!.isWhite ? Colors.white : Colors.black,
        ) : null,
      ),
    );
  }
}
