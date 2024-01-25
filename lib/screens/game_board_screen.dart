import 'package:chase_game/components/dead_piece.dart';
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
  ChessPiece? selectedPiece;

  int selectedRow = -1;
  int selectedColumn = -1;

  List<List<int>> validMoves = [];

  //A list of white pieces that have been taken by black piece
  List<ChessPiece> whitePiecesTaken = [];
  //A list of black pieces that have been taken by white piece
  List<ChessPiece> blackPiecesTaken = [];

  //A bool to indicates which turn
  bool isWhiteTurn = true;

  //initial position of king
  List<int> whiteKingPosition = [7, 4];
  List<int> blackKingPosition = [0,4];
  bool checkStatus = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializedBoard();
  }

  //Initialize board
  void _initializedBoard(){
    List<List<ChessPiece?>> newBoard = List.generate(8, (index) => List.generate(8, (index) => null));

    /*newBoard[3][3] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: false,
        imagePath: "assets/images/rook.png"
    );*/

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


    //queens
    newBoard[0][3] = ChessPiece(
      type: ChessPieceType.queen,
      isWhite: false,
      imagePath: "assets/images/queen.png",
    );

    newBoard[7][4] = ChessPiece(
      type: ChessPieceType.queen,
      isWhite: true,
      imagePath: "assets/images/queen.png",
    );


    //king
    newBoard[0][4] = ChessPiece(
      type: ChessPieceType.king,
      isWhite: false,
      imagePath: "assets/images/king.png",
    );

    newBoard[7][3] = ChessPiece(
      type: ChessPieceType.king,
      isWhite: true,
      imagePath: "assets/images/king.png",
    );

    board = newBoard;
  }

  //User select a piece
  void pieceSelected(int row, int column) {
      //No piece has been selected yet
    setState(() {
      //No piece has been selected yet
      if(selectedPiece == null && board[row][column] != null) {
        if(board[row][column]!.isWhite == isWhiteTurn){
          selectedPiece = board[row][column];
          selectedRow = row;
          selectedColumn = column;
        }
      }
      //There is a piece already selected
      else if(board[row][column] != null && board[row][column]!.isWhite == selectedPiece!.isWhite) {
        selectedPiece = board[row][column];
        selectedRow = row;
        selectedColumn = column;
      }

      //There is a piece already selected

      //if there is a piece selected and user tap on a square that ia a valid move
      else if(selectedPiece != null && validMoves.any((element) => element[0] == row && element[1] == column)){
        movePiece(row, column);
      }


      validMoves = calculateRawValidMoves(selectedRow, selectedColumn, selectedPiece);
    });
  }

  //Calculation available moves
  List<List<int>> calculateRawValidMoves(int row, int column, ChessPiece? piece){
    List<List<int>> candidateMoves = [];

    if(piece == null){
      return [];
    }

    int direction = piece.isWhite? -1 : 1;

    switch (piece.type){
      //pawn available path
      case ChessPieceType.pawn:
        //
        if(isInBoard(row + direction, column) && board[row + direction][column] == null){
          candidateMoves.add([row + direction, column]);
        }

        //
        if((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)){
          if(isInBoard(row + 2 * direction, column) && board[row + 2 * direction][column] == null && board[row + direction][column] == null){
            candidateMoves.add([row + 2 * direction, column]);
          }
        }

        //
        if(isInBoard(row + direction, column - 1) && board[row + direction][column - 1] != null && board[row + direction][column - 1]!.isWhite){
          candidateMoves.add([row + direction, column - 1]);
        }
        if(isInBoard(row + direction, column + 1) && board[row + direction][column + 1] != null && board[row + direction][column + 1]!.isWhite){
          candidateMoves.add([row + direction, column + 1]);
        }
        break;

        //rook available path
      case ChessPieceType.rook:
        var directions = [
          [-1,0],
          [1,0],
          [0,-1],
          [0,1]
        ];
        for(var direction in directions){
          var i = 1;
          while(true){
            var newRow = row + i * direction[0];
            var newColumn = column + i * direction[1];
            if(!isInBoard(newRow, newColumn)){
              break;
            }
            if(board[newRow][newColumn] != null){
              if(board[newRow][newColumn]!.isWhite != piece.isWhite){
                candidateMoves.add([newRow, newColumn]);
              }
              break;
            }
            candidateMoves.add([newRow, newColumn]);
            i++;
          }
        }
        break;

      //knight available path
      case ChessPieceType.knight:
        var knightMoves = [
          [-2,-1],
          [-2,1],
          [-1,-2],
          [-1,2],
          [1,-2],
          [1,2],
          [2,-1],
          [2,1],
        ];
        for(var move in knightMoves){
          var newRow = row + move[0];
          var newColumn = column + move[1];
          if(!isInBoard(newRow, newColumn)){
            continue;
          }
          if(board[newRow][newColumn] != null){
            if(board[newRow][newColumn]!.isWhite != piece.isWhite){
              candidateMoves.add([newRow, newColumn]);
            }
            continue;
          }
          candidateMoves.add([newRow, newColumn]);
        }
        break;
      //bishop available move
      case ChessPieceType.bishop:
        var directions = [
          [-1,-1],
          [-1,1],
          [1,-1],
          [1,1],
        ];
        for(var direction in directions){
          var i = 1;
          while(true){
            var newRow = row + i * direction[0];
            var newColumn = column + i * direction[1];
            if(!isInBoard(newRow, newColumn)){
              break;
            }
            if(board[newRow][newColumn] != null){
              if(board[newRow][newColumn]!.isWhite != piece.isWhite){
                candidateMoves.add([newRow, newColumn]);
              }
              break;
            }
            candidateMoves.add([newRow, newColumn]);
            i++;
          }
        }
        break;
      //queen available moves
      case ChessPieceType.queen:
        var directions = [
          [-1,0],
          [1,0],
          [0,-1],
          [0,1],
          [-1,-1],
          [-1,1],
          [1,-1],
          [1,1],
        ];
        for(var direction in directions){
          var i = 1;
          while(true){
            var newRow = row + i * direction[0];
            var newColumn = column + i * direction[1];
            if(!isInBoard(newRow, newColumn)){
              break;
            }
            if(board[newRow][newColumn] != null){
              if(board[newRow][newColumn]!.isWhite != piece.isWhite){
                candidateMoves.add([newRow, newColumn]);
              }
              break;
            }
            candidateMoves.add([newRow, newColumn]);
            i++;
          }
        }
        break;
      //king available moves
      case ChessPieceType.king:
        var directions = [
          [-1,0],
          [1,0],
          [0,-1],
          [0,1],
          [-1,-1],
          [-1,1],
          [1,-1],
          [1,1],
        ];
        for(var direction in directions){
            var newRow = row + direction[0];
            var newColumn = column + direction[1];
            if(!isInBoard(newRow, newColumn)){
              continue;
            }
            if(board[newRow][newColumn] != null){
              if(board[newRow][newColumn]!.isWhite != piece.isWhite){
                candidateMoves.add([newRow, newColumn]);
              }
              continue;
            }
            candidateMoves.add([newRow, newColumn]);
        }
        break;
      default:
    }
    return candidateMoves;
  }

  //Move piece
  void movePiece(int newRow, int newColumn){
    //if the new spot has an enemy piece
    if(board[newRow][newColumn] != null){
      //add the captured piece to the appropriate list
      var capturedPiece = board[newRow][newColumn];
      if(capturedPiece!.isWhite){
        whitePiecesTaken.add(capturedPiece);
      } else{
        blackPiecesTaken.add(capturedPiece);
      }
    }

    //move the piece and clear the old spot
    board[newRow][newColumn] = selectedPiece;
    board[selectedRow][selectedColumn] = null;

    //see if any king is under attack
    if(isKingInCheck(!isWhiteTurn)){
      checkStatus = true;
    } else{
      checkStatus = false;
    }

    //clear selection
    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedColumn = -1;
      validMoves = [];
    });

    //change turn
    isWhiteTurn = !isWhiteTurn;
  }

  // Is king in check
  bool isKingInCheck(bool isWhiteKing){
    //get the position of the king
    List<int> kingPosition = isWhiteKing? whiteKingPosition : blackKingPosition;

    //check if any enemy piece can attack the king
    for(int i = 0; i < 8; i++){
      for(int j = 0; j < 8; j++){
        if(board[i][j] == null || board[i][j]!.isWhite == isWhiteKing){
          continue;
        }

        List<List<int>> pieceValidMoves = calculateRawValidMoves(i, j, board[i][j]);

        //check if the king's position is in this piece's valid moves
        if(pieceValidMoves.any((move) => move[0] == kingPosition[0] && move[1] == kingPosition[1])){
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //White pieces taken
          Expanded(
              child: GridView.builder(
                itemCount: whitePiecesTaken.length,
                physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8,
                  ),
                  itemBuilder: (context, index) => DeadPiece(
                      imagePath: whitePiecesTaken[index].imagePath,
                      isWhite: true,
                  ),
              )
          ),

          //Game status
          Text(checkStatus? "CHECK" : ""),

          //Chess board
          Expanded(
            flex: 3,
            child: GridView.builder(
                itemCount: 8 * 8,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8),
                itemBuilder: (context, index) {

                  int row = index ~/ 8;
                  int column = index % 8;

                  bool isSelected = selectedRow == row && selectedColumn == column;

                  bool isValidMove = false;
                  for(var position in validMoves){
                    if(position[0] == row && position[1] == column){
                      isValidMove = true;
                    }
                  }

                  return Square(
                      isWhite: isWhite(index),
                    piece: board[row][column],
                    isSelected: isSelected,
                    isValidMove: isValidMove,
                    onTap: () => pieceSelected(row, column),
                  );
                }),
          ),

          //Black pieces taken
          Expanded(
              child: GridView.builder(
                itemCount: blackPiecesTaken.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                ),
                itemBuilder: (context, index) => DeadPiece(
                  imagePath: blackPiecesTaken[index].imagePath,
                  isWhite: false,
                ),
              )
          ),
        ],
      ),
    );
  }
}
