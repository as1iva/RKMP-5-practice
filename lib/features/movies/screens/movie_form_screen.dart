import 'package:flutter/material.dart';
import 'package:fadeev_practice_5/features/movies/models/movie.dart';
import 'package:fadeev_practice_5/shared/constants.dart';

class MovieFormScreen extends StatefulWidget {
  final Function(Movie) onSave;
  final Movie? movie;

  const MovieFormScreen({
    super.key,
    required this.onSave,
    this.movie,
  });

  @override
  State<MovieFormScreen> createState() => _MovieFormScreenState();
}

class _MovieFormScreenState extends State<MovieFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _directorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  String _selectedGenre = AppConstants.genres.first;

  @override
  void initState() {
    super.initState();
    if (widget.movie != null) {
      _titleController.text = widget.movie!.title;
      _directorController.text = widget.movie!.director;
      _selectedGenre = widget.movie!.genre;
      _descriptionController.text = widget.movie!.description ?? '';
      _durationController.text =
          widget.movie!.durationMinutes?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _directorController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _saveMovie() {
    if (_formKey.currentState!.validate()) {
      final movie = widget.movie?.copyWith(
        title: _titleController.text.trim(),
        director: _directorController.text.trim(),
        genre: _selectedGenre,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        durationMinutes: _durationController.text.trim().isEmpty
            ? null
            : int.tryParse(_durationController.text.trim()),
      ) ??
          Movie(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: _titleController.text.trim(),
            director: _directorController.text.trim(),
            genre: _selectedGenre,
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            durationMinutes: _durationController.text.trim().isEmpty
                ? null
                : int.tryParse(_durationController.text.trim()),
          );
      widget.onSave(movie);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.movie != null;

    return Scaffold(
      appBar: AppBar(
        title:
        Text(isEditing ? 'Редактировать фильм' : 'Добавить фильм'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Название фильма *',
                  hintText: 'Введите название',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.movie),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Пожалуйста, введите название фильма';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _directorController,
                decoration: const InputDecoration(
                  labelText: 'Режиссёр *',
                  hintText: 'Введите имя режиссёра',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Пожалуйста, введите режиссёра';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Жанр *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                value: _selectedGenre,
                items: AppConstants.genres.map((genre) {
                  return DropdownMenuItem(
                    value: genre,
                    child: Text(genre),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGenre = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Длительность (в минутах)',
                  hintText: 'Введите длительность фильма',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.timer),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    if (int.tryParse(value.trim()) == null) {
                      return 'Введите корректное число';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Описание',
                  hintText: 'Краткое описание фильма',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _saveMovie,
                icon: Icon(isEditing ? Icons.save : Icons.add),
                label: Text(isEditing
                    ? 'Сохранить изменения'
                    : 'Добавить фильм'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
