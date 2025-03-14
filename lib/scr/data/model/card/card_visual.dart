import 'dart:ui';

class CardVisual {
  final String front;
  final String back;
  final Color dataColor;
  final bool dataInBack;
  final double nameXOffset;
  final double nameYOffset;
  final double companyXOffset;
  final double companyYOffset;
  final double numberXOffset;
  final double numberYOffset;
  final double openDateXOffset;
  final double openDateYOffset;
  final double expiryDateXOffset;
  final double expiryDateYOffset;

  CardVisual({
    required this.front,
    required this.back,
    required this.dataColor,
    required this.dataInBack,
    required this.nameXOffset,
    required this.nameYOffset,
    required this.companyXOffset,
    required this.companyYOffset,
    required this.numberXOffset,
    required this.numberYOffset,
    required this.openDateXOffset,
    required this.openDateYOffset,
    required this.expiryDateXOffset,
    required this.expiryDateYOffset,
  });
}
