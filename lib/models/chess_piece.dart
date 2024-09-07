class ChessPiece {
  final String type;
  final String color;

  ChessPiece(this.type, this.color);

  // 말의 이미지 경로 반환
  String get imagePath {
    if (color == 'White') {
      switch (type) {
        case 'King':
          return 'assets/white_king.png';
        case 'Queen':
          return 'assets/white_queen.png';
        case 'Rook':
          return 'assets/white_rook.png';
        case 'Bishop':
          return 'assets/white_bishop.png';
        case 'Knight':
          return 'assets/white_knight.png';
        case 'Pawn':
          return 'assets/white_pawn.png';
        default:
          return '';
      }
    } else {
      switch (type) {
        case 'King':
          return 'assets/black_king.png';
        case 'Queen':
          return 'assets/black_queen.png';
        case 'Rook':
          return 'assets/black_rook.png';
        case 'Bishop':
          return 'assets/black_bishop.png';
        case 'Knight':
          return 'assets/black_knight.png';
        case 'Pawn':
          return 'assets/black_pawn.png';
        default:
          return '';
      }
    }
  }

  // 말의 이동 가능 경로 계산
  List<List<int>> getPossibleMoves(
      int x, int y, List<List<ChessPiece?>> board) {
    List<List<int>> possibleMoves = [];

    switch (type) {
      case 'Pawn':
        _getPawnMoves(x, y, board, possibleMoves);
        break;
      case 'Rook':
        _getRookMoves(x, y, board, possibleMoves);
        break;
      case 'Knight':
        _getKnightMoves(x, y, board, possibleMoves);
        break;
      case 'Bishop':
        _getBishopMoves(x, y, board, possibleMoves);
        break;
      case 'Queen':
        _getQueenMoves(x, y, board, possibleMoves);
        break;
      case 'King':
        _getKingMoves(x, y, board, possibleMoves);
        break;
    }
    return possibleMoves;
  }

  // 폰의 이동 경로
  void _getPawnMoves(
      int x, int y, List<List<ChessPiece?>> board, List<List<int>> moves) {
    int direction = (color == 'White') ? -1 : 1; // 흰색은 위로, 검은색은 아래로 이동

    if (board[y + direction][x] == null) {
      moves.add([x, y + direction]); // 직진 가능
    }

    // 대각선에 적 말이 있는 경우
    if (x > 0 &&
        board[y + direction][x - 1]?.color != color &&
        board[y + direction][x - 1] != null) {
      moves.add([x - 1, y + direction]);
    }
    if (x < 7 &&
        board[y + direction][x + 1]?.color != color &&
        board[y + direction][x + 1] != null) {
      moves.add([x + 1, y + direction]);
    }
  }

  // 룩의 이동 경로
  void _getRookMoves(
      int x, int y, List<List<ChessPiece?>> board, List<List<int>> moves) {
    _getLinearMoves(x, y, board, moves, [
      [0, 1],
      [0, -1],
      [1, 0],
      [-1, 0]
    ]);
  }

  // 비숍의 이동 경로
  void _getBishopMoves(
      int x, int y, List<List<ChessPiece?>> board, List<List<int>> moves) {
    _getLinearMoves(x, y, board, moves, [
      [1, 1],
      [1, -1],
      [-1, 1],
      [-1, -1]
    ]);
  }

  // 퀸의 이동 경로
  void _getQueenMoves(
      int x, int y, List<List<ChessPiece?>> board, List<List<int>> moves) {
    _getRookMoves(x, y, board, moves);
    _getBishopMoves(x, y, board, moves);
  }

  // 킹의 이동 경로
  void _getKingMoves(
      int x, int y, List<List<ChessPiece?>> board, List<List<int>> moves) {
    List<List<int>> directions = [
      [1, 0],
      [-1, 0],
      [0, 1],
      [0, -1],
      [1, 1],
      [1, -1],
      [-1, 1],
      [-1, -1]
    ];

    for (var direction in directions) {
      int newX = x + direction[0];
      int newY = y + direction[1];
      if (_isValidMove(newX, newY, board)) {
        moves.add([newX, newY]);
      }
    }
  }

  // 나이트의 이동 경로
  void _getKnightMoves(
      int x, int y, List<List<ChessPiece?>> board, List<List<int>> moves) {
    List<List<int>> knightMoves = [
      [2, 1],
      [2, -1],
      [-2, 1],
      [-2, -1],
      [1, 2],
      [1, -2],
      [-1, 2],
      [-1, -2]
    ];

    for (var move in knightMoves) {
      int newX = x + move[0];
      int newY = y + move[1];
      if (_isValidMove(newX, newY, board)) {
        moves.add([newX, newY]);
      }
    }
  }

  // 선형 이동 경로 계산 (룩, 비숍, 퀸)
  void _getLinearMoves(int x, int y, List<List<ChessPiece?>> board,
      List<List<int>> moves, List<List<int>> directions) {
    for (var direction in directions) {
      int newX = x;
      int newY = y;
      while (true) {
        newX += direction[0];
        newY += direction[1];
        if (_isValidMove(newX, newY, board)) {
          moves.add([newX, newY]);
          if (board[newY][newX] != null) break; // 적군이 있으면 멈춤
        } else {
          break;
        }
      }
    }
  }

  // 유효한 이동인지 확인
  bool _isValidMove(int x, int y, List<List<ChessPiece?>> board) {
    return x >= 0 &&
        x < 8 &&
        y >= 0 &&
        y < 8 &&
        (board[y][x] == null || board[y][x]?.color != color);
  }
}
