enum ActiveIngredient {
  ibuprofen,
  statin,
  unspecifeid;

  String get getLabel => switch (this) {
    ibuprofen => "Ibuprofenas",
    statin => "Statinas",
    unspecifeid => "Nenurodyta",
  };
}
