import 'package:flutter/material.dart';
import 'package:fadeev_practice_5/features/movies/models/movie.dart';
import 'package:fadeev_practice_5/features/movies/screens/movie_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MovieTile extends StatelessWidget {
  final Movie movie;
  final VoidCallback onDelete;
  final Function(bool) onToggleWatched;
  final Function(int) onRate;
  final Function(Movie) onUpdate;

  const MovieTile({
    super.key,
    required this.movie,
    required this.onDelete,
    required this.onToggleWatched,
    required this.onRate,
    required this.onUpdate,
  });

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Оценить фильм'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(10, (index) {
            final rating = index + 1;
            final active = rating <= (movie.rating ?? 0);
            return IconButton(
              icon: Icon(
                active ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),
              onPressed: () {
                onRate(rating);
                Navigator.pop(context);
              },
            );
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить фильм?'),
        content: Text('Вы уверены, что хотите удалить "${movie.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailScreen(
          movie: movie,
          onDelete: onDelete,
          onToggleWatched: onToggleWatched,
          onRate: onRate,
          onUpdate: onUpdate,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      color: cs.surface,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _navigateToDetail(context),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  if (movie.imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: movie.imageUrl != null
                          ? CachedNetworkImage(
                        imageUrl: movie.imageUrl!,
                        width: 60,
                        height: 85,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 60,
                          height: 85,
                          color: Colors.grey[900],
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 60,
                          height: 85,
                          color: Colors.grey[800],
                          child: const Icon(
                            Icons.movie_outlined,
                            color: Colors.white70,
                            size: 32,
                          ),
                        ),
                      )
                          : Container(
                        width: 60,
                        height: 85,
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.movie_outlined,
                          color: Colors.white70,
                          size: 32,
                        ),
                      ),
                    ),

                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: movie.isWatched ? Colors.green : Colors.orange,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(
                        movie.isWatched ? Icons.check : Icons.schedule,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: cs.onSurface,
                        decoration: movie.isWatched
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      movie.director,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: cs.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: cs.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            movie.genre,
                            style: TextStyle(
                              fontSize: 12,
                              color: cs.onPrimaryContainer,
                            ),
                          ),
                        ),
                        if (movie.rating != null) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          Text(
                            movie.rating.toString(),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: movie.isWatched
                        ? 'Отметить как непросмотренный'
                        : 'Просмотрен',
                    icon: Icon(
                      movie.isWatched
                          ? Icons.check_circle
                          : Icons.check_circle_outline,
                      color:
                      movie.isWatched ? Colors.greenAccent : Colors.green,
                    ),
                    onPressed: () => onToggleWatched(!movie.isWatched),
                  ),
                  IconButton(
                    tooltip: 'Оценить',
                    icon: const Icon(Icons.star, color: Colors.amber),
                    onPressed: () => _showRatingDialog(context),
                  ),
                  IconButton(
                    tooltip: 'Удалить',
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _showDeleteConfirmation(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
