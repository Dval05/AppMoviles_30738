import '../models/driver_model.dart';
class PayrollController {
  final List<Driver> _drivers = [];
  List<Driver> get drivers => _drivers;

  void addDriver(Driver driver) {
    if (_drivers.length < 5) {
      _drivers.add(driver);
    }
  }
  void clearDrivers() {
    _drivers.clear();
  }
  double calculateTotalGeneral() {
    return _drivers.fold(0, (sum, driver) => sum + driver.weeklySalary);
  }
  String getDriverWithMostMondayHours() {
    if (_drivers.isEmpty) return "N/A";
    
    Driver maxDriver = _drivers[0];
    for (var driver in _drivers) {
      if (driver.dailyHours[0] > maxDriver.dailyHours[0]) {
        maxDriver = driver;
      }
    }
    return maxDriver.name;
  }
}
