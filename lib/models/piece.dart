class Piece {
  int id;
  int position;
  bool isWhite;
  bool isHighlighted;

  Piece({
    required this.id,
    required this.position,
    required this.isWhite,
    this.isHighlighted = false,
  });
}
