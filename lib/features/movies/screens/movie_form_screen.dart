import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fadeev_practice_5/features/movies/models/movie.dart';

class MovieFormScreen extends StatefulWidget {
  final void Function(Movie movie) onSave;

  const MovieFormScreen({super.key, required this.onSave});

  @override
  State<MovieFormScreen> createState() => _MovieFormScreenState();
}

class _MovieFormScreenState extends State<MovieFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _directorController = TextEditingController();
  final _genreController = TextEditingController();
  final _durationController = TextEditingController();
  final _descController = TextEditingController();

  bool _isWatched = false;
  int? _rating;

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final duration = _durationController.text.trim().isEmpty
        ? null
        : int.tryParse(_durationController.text.trim());

    final movie = Movie(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      director: _directorController.text.trim().isEmpty
          ? 'Не указан'
          : _directorController.text.trim(),
      genre: _genreController.text.trim().isEmpty
          ? 'Без жанра'
          : _genreController.text.trim(),
      description: _descController.text.trim().isEmpty
          ? null
          : _descController.text.trim(),
      durationMinutes: duration,
      isWatched: _isWatched,
      rating: _rating,
      dateAdded: DateTime.now(),
      dateWatched: _isWatched ? DateTime.now() : null,
      imageUrl: null,
    );

    widget.onSave(movie);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить фильм'),
        backgroundColor: cs.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Название',
                      prefixIcon: Icon(Icons.movie_creation_outlined),
                    ),
                    validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Введите название' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _directorController,
                    decoration: const InputDecoration(
                      labelText: 'Режиссёр',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _genreController,
                    decoration: const InputDecoration(
                      labelText: 'Жанр',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _durationController,
                    decoration: const InputDecoration(
                      labelText: 'Длительность (мин)',
                      prefixIcon: Icon(Icons.timer_outlined),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descController,
                    decoration: const InputDecoration(
                      labelText: 'Описание',
                      prefixIcon: Icon(Icons.notes_outlined),
                    ),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Checkbox(
                        value: _isWatched,
                        onChanged: (v) => setState(() => _isWatched = v ?? false),
                      ),
                      const Text('Просмотрено'),
                      const Spacer(),
                      DropdownButton<int>(
                        value: _rating,
                        hint: const Text('Оценка'),
                        items: List.generate(
                          5,
                              (i) => DropdownMenuItem(
                            value: i + 1,
                            child: Text('${i + 1}'),
                          ),
                        ),
                        onChanged: (v) => setState(() => _rating = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.save),
                      label: const Text('Сохранить'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
