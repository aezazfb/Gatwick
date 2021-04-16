class CarsType {
  String _carName, _imagePath;
  int _passengers, _suitcases;

  CarsType(this._carName, this._imagePath, this._passengers, this._suitcases);

  get suitcases => _suitcases;

  int get passengers => _passengers;

  get imagePath => _imagePath;

  String get carName => _carName;
}