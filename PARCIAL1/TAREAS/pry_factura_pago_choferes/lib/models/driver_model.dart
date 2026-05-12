class Driver {
  String name;
  List<double> dailyHours; // 6 days
  double hourlyWage;
  bool isActive;
  bool receivesBonus;
  String driverType;

  Driver({
    required this.name,
    required this.dailyHours,
    required this.hourlyWage,
    this.isActive = true,
    this.receivesBonus = false,
    required this.driverType,
  });

  double get totalWeeklyHours => dailyHours.reduce((a, b) => a + b);

  double get weeklySalary {
    double baseSalary = totalWeeklyHours * hourlyWage;
    if (receivesBonus) {
      baseSalary += 50.0; // Example bonus
    }
    return baseSalary;
  }
}
