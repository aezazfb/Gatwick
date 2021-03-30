class GooglePlaces {
  var id = '';
  String placeid = "ChIJt3-FKDsKdkgRrsljcgmJThU";
  String address = 'Surbiton KT6 7QD, UK';
  String postcode = "KT6 7QD";
  String outcode = "KT6";
  double lattitude = 51.3751638;
  String country = "United Kingdom";
  String city = "";
  double longitude = -0.293779;

  GooglePlaces();

  GooglePlaces.paramterizedConstructor(
      {this.id,
      this.placeid,
      this.address,
      this.postcode,
      this.outcode,
      this.lattitude,
      this.country,
      this.city,
      this.longitude});
}
