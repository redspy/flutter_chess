class ChessPiece {
  final String type;
  final String color;
  bool hasMoved = false;

  ChessPiece(this.type, this.color);

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
  List<List<int>> getPossibleMoves(int x, int y, List<List<ChessPiece?>> board,
      [Map<String, dynamic>? options]) {
    List<List<int>> possibleMoves = [];

    switch (type) {
      case 'Pawn':
        _getPawnMoves(x, y, board, possibleMoves, options);
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
        _getKingMoves(x, y, board, possibleMoves, options);
        break;
    }
    return possibleMoves;
  }

  void _getPawnMoves(
      int x, int y, List<List<ChessPiece?>> board, List<List<int>> moves,
      [Map<String, dynamic>? options]) {
    int direction = (color == 'White') ? -1 : 1;
    bool isFirstMove = !hasMoved;
    try {
      if (board[y + direction][x] == null) {
        moves.add([x, y + direction]);
      }

      if (isFirstMove &&
          board[y + direction * 2][x] == null &&
          board[y + direction][x] == null) {
        moves.add([x, y + direction * 2]);
      }

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
    } catch (e) {}
    if (options != null &&
        options.containsKey('enPassant') &&
        options['enPassant'] != null) {
      List<int> enPassantTarget = options['enPassant'];
      if ((x - 1 == enPassantTarget[0] || x + 1 == enPassantTarget[0]) &&
          y + direction == enPassantTarget[1]) {
        moves.add([enPassantTarget[0], enPassantTarget[1]]);
      }
    }
  }

  // 룩의 이동 경로 처리
  void _getRookMoves(
      int x, int y, List<List<ChessPiece?>> board, List<List<int>> moves) {
    _getLinearMoves(x, y, board, moves, [
      [0, 1],
      [0, -1],
      [1, 0],
      [-1, 0]
    ]);
  }

  // 비숍의 이동 경로 처리
  void _getBishopMoves(
      int x, int y, List<List<ChessPiece?>> board, List<List<int>> moves) {
    _getLinearMoves(x, y, board, moves, [
      [1, 1],
      [1, -1],
      [-1, 1],
      [-1, -1]
    ]);
  }

  // 퀸의 이동 경로 처리
  void _getQueenMoves(
      int x, int y, List<List<ChessPiece?>> board, List<List<int>> moves) {
    _getRookMoves(x, y, board, moves);
    _getBishopMoves(x, y, board, moves);
  }

  // 나이트의 이동 경로 처리
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

  // 선형 이동 경로 계산 (룩, 비숍, 퀸의 이동에 사용)
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

  // 킹의 이동 경로 (캐슬링 포함)
  void _getKingMoves(
      int x, int y, List<List<ChessPiece?>> board, List<List<int>> moves,
      [Map<String, dynamic>? options]) {
    List<List<int>> directions = [
      [1, 0], [-1, 0], [0, 1], [0, -1], // 상하좌우
      [1, 1], [1, -1], [-1, 1], [-1, -1] // 대각선
    ];

    for (var direction in directions) {
      int newX = x + direction[0];
      int newY = y + direction[1];
      if (_isValidMove(newX, newY, board)) {
        moves.add([newX, newY]);
      }
    }

    // 캐슬링 처리
    if (options != null &&
        options.containsKey('canCastle') &&
        options['canCastle'] == true) {
      if (!hasMoved) {
        // 킹 측 캐슬링
        if (board[y][x + 1] == null &&
            board[y][x + 2] == null &&
            board[y][x + 3]?.type == 'Rook' &&
            !board[y][x + 3]!.hasMoved) {
          moves.add([x + 2, y]);
        }
        // 퀸 측 캐슬링
        if (board[y][x - 1] == null &&
            board[y][x - 2] == null &&
            board[y][x - 3] == null &&
            board[y][x - 4]?.type == 'Rook' &&
            !board[y][x - 4]!.hasMoved) {
          moves.add([x - 2, y]);
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
