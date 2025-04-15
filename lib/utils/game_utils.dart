class GameUtils {
  static int calculateInitialPosition(int index, bool isWhite) {
    if (isWhite) {
      //
      switch (index) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
          return 18;
        case 5:
        case 6:
        case 7:
          return 16;
        case 8:
        case 9:
        case 10:
        case 11:
        case 12:
          return 11;
        case 13:
        case 14:
          return 0;

        default:
          return 28;
      }
    } else {
      switch (index) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
          return 5;
        case 5:
        case 6:
        case 7:
          return 7;
        case 8:
        case 9:
        case 10:
        case 11:
        case 12:
          return 12;
        case 13:
        case 14:
          return 23;

        default:
          return 28;
      }
    }
  }
}
