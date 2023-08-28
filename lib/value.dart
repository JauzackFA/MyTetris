import 'dart:ui';

enum Direction {
  left,
  right,
  down,
}

enum Tetromino {
  L,
  J,
  I,
  O,
  S,
  Z,
  T,
}

const Map<Tetromino, Color> tetrominoColors = {
  Tetromino.L: Color.fromARGB(1000, 251, 240, 178),
  Tetromino.J: Color.fromARGB(1000, 255, 199, 234),
  Tetromino.I: Color.fromARGB(1000, 216, 180, 248),
  Tetromino.O: Color.fromARGB(1000, 202, 237, 255),
  Tetromino.S: Color.fromARGB(1000, 69, 255, 202),
  Tetromino.Z: Color.fromARGB(1000, 111, 97, 192),
  Tetromino.T: Color.fromARGB(1000, 85, 113, 83),
};
