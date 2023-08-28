import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mytetris/piece.dart';
import 'package:mytetris/pixel.dart';
import 'package:mytetris/value.dart';

List<List<Tetromino?>> gameBoard = List.generate(
  colLength,
  (i) => List.generate(
    rowLength,
    (j) => null,
  ),
);

class TheBoard extends StatefulWidget {
  const TheBoard({super.key});

  @override
  State<TheBoard> createState() => _TheBoardState();
}

class _TheBoardState extends State<TheBoard> {
  Piece currentPiece = Piece(type: Tetromino.L);
  int currentScore = 0;
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    currentPiece.initializePieces();
    Duration frameRate = const Duration(milliseconds: 500);
    gameLoop(frameRate);
  }

  void gameLoop(Duration frameRate) {
    Timer.periodic(
      frameRate,
      (timer) {
        setState(
          () {
            clearLines();
            checkLanding();
            if (gameOver == true) {
              timer.cancel();
              gameOverMessage();
            }
            currentPiece.movePiece(Direction.down);
          },
        );
      },
    );
  }

  void gameOverMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Game Over',
        ),
        content: Text(
          "Your score is: $currentScore",
        ),
        actions: [
          TextButton(
            onPressed: () {
              resetGame();
              Navigator.pop(context);
            },
            child: Text(
              'Play Again',
            ),
          )
        ],
      ),
    );
  }

  void resetGame() {
    gameBoard = List.generate(
      colLength,
      (i) => List.generate(
        rowLength,
        (j) => null,
      ),
    );
    gameOver = false;
    currentScore = 0;

    createNewPiece();
    startGame();
  }

  bool checkCollision(Direction direction) {
    for (int i = 0; i < currentPiece.position.length; i++) {
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;

      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      if (row >= colLength || col < 0 || col >= rowLength) {
        return true;
      }

      if (row >= 0 && col >= 0) {
        if (gameBoard[row][col] != null) {
          return true;
        }
      }
    }
    return false;
  }

  void checkLanding() {
    if (checkCollision(Direction.down)) {
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = currentPiece.position[i] % rowLength;
        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }
      createNewPiece();
    }
  }

  void createNewPiece() {
    Random rand = Random();
    Tetromino randomType = Tetromino.values[rand.nextInt(
      Tetromino.values.length,
    )];
    currentPiece = Piece(type: randomType);
    currentPiece.initializePieces();

    if (isGameOver()) {
      gameOver = true;
    }
  }

  void moveLeft() {
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  void rotatePiece() {
    setState(() {
      currentPiece.rotatePiece();
    });
  }

  void moveRight() {
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  void clearLines() {
    for (int row = colLength - 1; row >= 0; row--) {
      bool rowIsFull = true;
      for (int col = 0; col < rowLength; col++) {
        if (gameBoard[row][col] == null) {
          rowIsFull = false;
          break;
        }
      }

      if (rowIsFull) {
        for (int r = row; r > 0; r--) {
          gameBoard[r] = List.from(gameBoard[r - 1]);
        }
        gameBoard[0] = List.generate(row, (index) => null);
        currentScore++;
      }
    }
  }

  bool isGameOver() {
    for (int col = 0; col < rowLength; col++) {
      if (gameBoard[0][col] != null) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(1000, 154, 59, 59),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: rowLength * colLength,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rowLength),
              itemBuilder: (context, index) {
                int row = (index / rowLength).floor();
                int col = index % rowLength;
                if (currentPiece.position.contains(index)) {
                  return MyPixel(
                    color: Colors.yellow,
                  );
                } else if (gameBoard[row][col] != null) {
                  final Tetromino? tetrominoType = gameBoard[row][col];
                  return MyPixel(
                    color: tetrominoColors[tetrominoType],
                  );
                } else {
                  return MyPixel(
                    color: Colors.white30,
                  );
                }
              },
            ),
          ),
          Text(
            'Score: $currentScore',
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 60, top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: moveLeft,
                  color: Colors.black,
                  icon: const Icon(
                    Icons.arrow_back_ios,
                  ),
                ),
                IconButton(
                  onPressed: rotatePiece,
                  color: Colors.black,
                  icon: const Icon(
                    Icons.rotate_right,
                  ),
                ),
                IconButton(
                  onPressed: moveRight,
                  color: Colors.black,
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
