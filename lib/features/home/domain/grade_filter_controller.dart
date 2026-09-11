import 'package:flutter/foundation.dart';

enum GradeFilterOption {
  all,
  grades0to1,
  grades1to2,
}

class GradeFilterController extends ChangeNotifier {
  GradeFilterOption _selectedFilter = GradeFilterOption.all;

  GradeFilterOption get selectedFilter => _selectedFilter;

  void setFilter(GradeFilterOption option) {
    if (_selectedFilter != option) {
      _selectedFilter = option;
      notifyListeners();
    }
  }

  bool matchesGrade({required int minGrade, required int maxGrade}) {
    switch (_selectedFilter) {
      case GradeFilterOption.all:
        return true;
      case GradeFilterOption.grades0to1:
        return minGrade <= 0 && maxGrade <= 1;
      case GradeFilterOption.grades1to2:
        return minGrade >= 1 && maxGrade >= 2;
    }
  }

  void cycleFilter() {
    switch (_selectedFilter) {
      case GradeFilterOption.all:
        setFilter(GradeFilterOption.grades0to1);
        break;
      case GradeFilterOption.grades0to1:
        setFilter(GradeFilterOption.grades1to2);
        break;
      case GradeFilterOption.grades1to2:
        setFilter(GradeFilterOption.all);
        break;
    }
  }
}

