import 'package:flutter/material.dart';
import 'package:fadeev_practice_5/features/movies/models/movie.dart';
import 'package:go_router/go_router.dart';
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

  void _navigateToDetail(BuildContext context) {
    context.push('/home/movie/${movie.id}');
  }

  void _toggleWatched(bool value) {
    onToggleWatched(value);
  }

  void _rateMovie(int rating) {
    onRate(rating);
  }

  void _editMovie(BuildContext context) {
    onUpdate(movie);
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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => _navigateToDetail(context),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      color: Colors.grey[900],
                      child: const Icon(Icons.broken_image),
                    ),
                  )
                      : const SizedBox.shrink(),
                ),
              if (movie.imageUrl != null) const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Заголовок
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            movie.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          movie.isWatched
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                          color: movie.isWatched ? cs.primary : cs.outline,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Директор / жанр / длительность
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        if (movie.director.isNotEmpty)
                          _Chip(icon: Icons.person_outline, text: movie.director),
                        if (movie.genre.isNotEmpty)
                          _Chip(icon: Icons.category_outlined, text: movie.genre),
                        if (movie.durationMinutes != null)
                          _Chip(
                            icon: Icons.timer_outlined,
                            text: '${movie.durationMinutes} мин',
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Описание
                    if (movie.description != null &&
                        movie.description!.isNotEmpty)
                      Text(
                        movie.description!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[400],
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),

                    const SizedBox(height: 10),

                    // Рейтинг и действия
                    Row(
                      children: [
                        // Рейтинг звёздами
                        Wrap(
                          spacing: 2,
                          children: List.generate(10, (i) {
                            final r = i + 1;
                            final selected = (movie.rating ?? 0) >= r;
                            return InkWell(
                              onTap: () => _rateMovie(r),
                              child: Icon(
                                Icons.star,
                                size: 18,
                                color: selected ? Colors.amber : cs.outline,
                              ),
                            );
                          }),
                        ),
                        const Spacer(),
                        IconButton(
                          tooltip: movie.isWatched
                              ? 'Снять просмотрено'
                              : 'Отметить просмотрено',
                          icon: Icon(
                            movie.isWatched
                                ? Icons.remove_red_eye
                                : Icons.remove_red_eye_outlined,
                          ),
                          onPressed: () => _toggleWatched(!movie.isWatched),
                        ),
                        IconButton(
                          tooltip: 'Редактировать',
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editMovie(context),
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
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Chip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[900],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[400]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
