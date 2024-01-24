import 'package:chase_game/components/piece.dart';
import 'package:chase_game/components/square.dart';
import 'package:flutter/material.dart';

import '../helper/helper_method.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {

  late List<List<ChessPiece?>> board;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializedBoard();
  }

  void _initializedBoard(){
    List<List<ChessPiece?>> newBoard = List.generate(8, (index) => List.generate(8, (index) => null));

    //pawn
    for(int i = 0; i < 8; i++){
      newBoard[1][i] = ChessPiece(
          type: ChessPieceType.pawn,
          isWhite: false,
          imagePath: "assets/images/pawn.png",
      );
      newBoard[6][i] = ChessPiece(
        type: ChessPieceType.pawn,
        isWhite: true,
        imagePath: "assets/images/pawn.png",
      );
    }

    //rook
    newBoard[0][0] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: false,
        imagePath: "assets/images/rook.png",
    );

    newBoard[0][7] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: "assets/images/rook.png",
    );

    newBoard[7][0] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: "assets/images/rook.png",
    );

    newBoard[7][7] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: "assets/images/rook.png",
    );

    //knight
    newBoard[0][1] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: false,
      imagePath: "assets/images/knight.png",
    );

    newBoard[0][6] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: false,
      imagePath: "assets/images/knight.png",
    );

    newBoard[7][1] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: true,
      imagePath: "assets/images/knight.png",
    );

    newBoard[7][6] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: true,
      imagePath: "assets/images/knight.png",
    );


    //bishops
    newBoard[0][2] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: false,
      imagePath: "assets/images/bishop.png",
    );

    newBoard[0][5] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: false,
      imagePath: "assets/images/bishop.png",
    );

    newBoard[7][2] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: true,
      imagePath: "assets/images/bishop.png",
    );

    newBoard[7][5] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: true,
      imagePath: "assets/images/bishop.png",
    );




    board = newBoard;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
          itemCount: 8 * 8,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8),
          itemBuilder: (context, index) {

            int row = index ~/ 8;
            int column = index % 8;

            return Square(
                isWhite: isWhite(index),
              piece: board[row][column],
            );
          }),
    );
  }
}
