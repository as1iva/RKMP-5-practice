class Movie {
  final String id;
  final String title;
  final String director;
  final String genre;
  final String? description;
  final int? durationMinutes;
  bool isWatched;
  int? rating;
  final DateTime dateAdded;
  DateTime? dateWatched;

  Movie({
    required this.id,
    required this.title,
    required this.director,
    required this.genre,
    this.description,
    this.durationMinutes,
    this.isWatched = false,
    this.rating,
    DateTime? dateAdded,
    this.dateWatched,
  }) : dateAdded = dateAdded ?? DateTime.now();

  Movie copyWith({
    String? id,
    String? title,
    String? director,
    String? genre,
    String? description,
    int? durationMinutes,
    bool? isWatched,
    int? rating,
    DateTime? dateAdded,
    DateTime? dateWatched,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      director: director ?? this.director,
      genre: genre ?? this.genre,
      description: description ?? this.description,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isWatched: isWatched ?? this.isWatched,
      rating: rating ?? this.rating,
      dateAdded: dateAdded ?? this.dateAdded,
      dateWatched: dateWatched ?? this.dateWatched,
    );
  }
}
