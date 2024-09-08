class ChessPiece {
  String type; // 말의 종류 (예: Pawn, Rook, Knight, Bishop, Queen, King)
  String color; // 말의 색상 (White 또는 Black)
  int x; // 현재 말의 x 좌표
  int y; // 현재 말의 y 좌표
  bool hasMoved = false; // 말이 한 번이라도 이동했는지 여부

  ChessPiece(this.type, this.color, this.x, this.y);

  // 말의 이미지 경로를 반환하는 변수
  String get imagePath {
    return 'assets/${color.toLowerCase()}_${type.toLowerCase()}.png';
  }

  // 말의 이동 가능한 경로를 반환하는 함수
  List<List<int>> getPossibleMoves(
      List<List<ChessPiece?>> board, Map<String, dynamic> options) {
    List<List<int>> moves = [];

    if (type == 'Pawn') {
      moves.addAll(_getPawnMoves(board, options));
    } else if (type == 'Rook') {
      moves.addAll(_getRookMoves(board));
    } else if (type == 'Knight') {
      moves.addAll(_getKnightMoves(board));
    } else if (type == 'Bishop') {
      moves.addAll(_getBishopMoves(board));
    } else if (type == 'Queen') {
      moves.addAll(_getQueenMoves(board));
    } else if (type == 'King') {
      moves.addAll(_getKingMoves(board, options));
    }

    return moves;
  }

  // 말 별로 이동 경로를 계산하는 함수들
  List<List<int>> _getPawnMoves(
      List<List<ChessPiece?>> board, Map<String, dynamic> options) {
    List<List<int>> moves = [];
    int direction = (color == 'White') ? -1 : 1;

    // 폰이 앞으로 이동 가능한지 확인
    if (board[y + direction][x] == null) {
      moves.add([x, y + direction]);
      if (!hasMoved && board[y + 2 * direction][x] == null) {
        moves.add([x, y + 2 * direction]); // 첫 이동 시 두 칸 전진 가능
      }
    }

    // 대각선에 적군이 있을 때 공격 가능
    if (x > 0 && board[y + direction][x - 1]?.color != color) {
      moves.add([x - 1, y + direction]);
    }
    if (x < 7 && board[y + direction][x + 1]?.color != color) {
      moves.add([x + 1, y + direction]);
    }

    // 앙파상 처리
    if (options.containsKey('enPassant') && options['enPassant'] != null) {
      List<int> enPassant = options['enPassant'];
      moves.add(enPassant);
    }

    return moves;
  }

  // 룩의 이동 경로 계산 함수
  List<List<int>> _getRookMoves(List<List<ChessPiece?>> board) {
    List<List<int>> moves = [];
    // 가로 및 세로로 이동할 수 있는 경로 계산
    for (int i = x + 1; i < 8 && board[y][i] == null; i++) {
      moves.add([i, y]);
    }
    for (int i = x - 1; i >= 0 && board[y][i] == null; i--) {
      moves.add([i, y]);
    }
    for (int i = y + 1; i < 8 && board[i][x] == null; i++) {
      moves.add([x, i]);
    }
    for (int i = y - 1; i >= 0 && board[i][x] == null; i--) {
      moves.add([x, i]);
    }
    return moves;
  }

  // 나이트의 이동 경로 계산 함수
  List<List<int>> _getKnightMoves(List<List<ChessPiece?>> board) {
    List<List<int>> moves = [];
    List<List<int>> knightMoves = [
      [x + 2, y + 1],
      [x + 2, y - 1],
      [x - 2, y + 1],
      [x - 2, y - 1],
      [x + 1, y + 2],
      [x + 1, y - 2],
      [x - 1, y + 2],
      [x - 1, y - 2],
    ];
    for (var move in knightMoves) {
      if (move[0] >= 0 && move[0] < 8 && move[1] >= 0 && move[1] < 8) {
        ChessPiece? target = board[move[1]][move[0]];
        if (target == null || target.color != color) {
          moves.add(move);
        }
      }
    }
    return moves;
  }

  // 비숍의 이동 경로 계산 함수
  List<List<int>> _getBishopMoves(List<List<ChessPiece?>> board) {
    List<List<int>> moves = [];
    for (int i = 1;
        x + i < 8 && y + i < 8 && board[y + i][x + i] == null;
        i++) {
      moves.add([x + i, y + i]);
    }
    for (int i = 1;
        x - i >= 0 && y - i >= 0 && board[y - i][x - i] == null;
        i++) {
      moves.add([x - i, y - i]);
    }
    for (int i = 1;
        x + i < 8 && y - i >= 0 && board[y - i][x + i] == null;
        i++) {
      moves.add([x + i, y - i]);
    }
    for (int i = 1;
        x - i >= 0 && y + i < 8 && board[y + i][x - i] == null;
        i++) {
      moves.add([x - i, y + i]);
    }
    return moves;
  }

  // 퀸의 이동 경로 계산 함수 (룩과 비숍의 이동을 합침)
  List<List<int>> _getQueenMoves(List<List<ChessPiece?>> board) {
    List<List<int>> moves = [];
    moves.addAll(_getRookMoves(board)); // 가로, 세로 이동
    moves.addAll(_getBishopMoves(board)); // 대각선 이동
    return moves;
  }

  // 킹의 이동 경로 계산 함수
  List<List<int>> _getKingMoves(
      List<List<ChessPiece?>> board, Map<String, dynamic>? options) {
    List<List<int>> moves = [];

    // 킹은 한 칸씩 이동 가능
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        if (i == 0 && j == 0) continue;
        int newX = x + i;
        int newY = y + j;
        if (newX >= 0 && newX < 8 && newY >= 0 && newY < 8) {
          if (board[newY][newX] == null || board[newY][newX]?.color != color) {
            moves.add([newX, newY]);
          }
        }
      }
    }

    // 캐슬링 옵션을 처리할 때만 캐슬링 경로를 추가
    if (options != null &&
        options.containsKey('canCastle') &&
        options['canCastle'] == true &&
        !hasMoved) {
      if (board[y][x + 1] == null && board[y][x + 2] == null) {
        moves.add([x + 2, y]); // 킹사이드 캐슬링
      }
      if (board[y][x - 1] == null &&
          board[y][x - 2] == null &&
          board[y][x - 3] == null) {
        moves.add([x - 2, y]); // 퀸사이드 캐슬링
      }
    }

    return moves;
  }
}
