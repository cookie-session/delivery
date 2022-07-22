class BillDBService {
  BillDBService._();

  static BillDBService? _instance;

  static BillDBService get instance{
    _instance ??= BillDBService._();
    return _instance!;
  }
}