enum ActiveIngredient {
  ibuprofen,
  statin;

  String get getLabel => switch (this) {
    ibuprofen => "Ibuprofenas",
    statin => "Statinas",
  };
}
