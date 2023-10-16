class ReceipeModel {
  late String label;
  late String image;
  late double Calories;
  late double TotalWeight;
  late String url;
  ReceipeModel(
      {this.label = "label",
      this.image = "image",
      this.Calories = 0.00,
      this.TotalWeight = 0.00,
      this.url = "url"});

  factory ReceipeModel.fromMap(Map recipe) {
    return ReceipeModel(
      label: recipe["label"],
      image: recipe["image"],
      Calories: recipe["calories"],
      TotalWeight: recipe["totalWeight"],
      url: recipe["url"],
    );
  }
}
