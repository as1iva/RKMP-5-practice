import 'package:flutter/material.dart';
import 'package:fadeev_practice_5/features/service/image_service.dart';
import 'package:fadeev_practice_5/features/movies/models/movie.dart';

class MoviesContainer extends StatefulWidget {
  final Widget Function(
      BuildContext context,
      List<Movie> movies,
      Function(Movie) onAddMovie,
      Function(String) onDeleteMovie,
      Function(String, bool) onToggleWatched,
      Function(String, int) onRateMovie,
      Function(Movie) onUpdateMovie,
      ) builder;

  const MoviesContainer({
    super.key,
    required this.builder,
  });

  @override
  State<MoviesContainer> createState() => _MoviesContainerState();
}

class _MoviesContainerState extends State<MoviesContainer> {
  final List<Movie> _movies = [];
  final ImageService _imageService = ImageService();


  void _addMovie(Movie movie) async {
    final imageUrl = await _imageService.getNextMovieImage();
    final withImage = movie.copyWith(imageUrl: imageUrl);

    setState(() => _movies.add(withImage));
  }

  void _updateMovie(Movie updatedMovie) {
    setState(() {
      final index = _movies.indexWhere((movie) => movie.id == updatedMovie.id);
      if (index != -1) {
        _movies[index] = updatedMovie;
      }
    });
  }

  void _deleteMovie(String id) async {
    final movie = _movies.firstWhere((movie) => movie.id == id);

    if (movie.imageUrl != null) {
      await _imageService.releaseImage(movie.imageUrl!);
    }

    setState(() {
      _movies.removeWhere((movie) => movie.id == id);
    });
  }

  void _toggleWatched(String id, bool isWatched) {
    setState(() {
      final index = _movies.indexWhere((movie) => movie.id == id);
      if (index != -1) {
        _movies[index].isWatched = isWatched;
        _movies[index].dateWatched = isWatched ? DateTime.now() : null;
      }
    });
  }

  void _rateMovie(String id, int rating) {
    setState(() {
      final index = _movies.indexWhere((movie) => movie.id == id);
      if (index != -1) {
        _movies[index].rating = rating;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      _movies,
      _addMovie,
      _deleteMovie,
      _toggleWatched,
      _rateMovie,
      _updateMovie,
    );
  }
}
