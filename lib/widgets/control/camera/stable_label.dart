class StableLabel {
  String label = 'Unknown';

  final List<String> _history = [];
  static const int _window = 6;

  void vote(String name) {
    _history.add(name);
    if (_history.length > _window) _history.removeAt(0);

    final counts = <String, int>{};
    for (final n in _history) {
      counts[n] = (counts[n] ?? 0) + 1;
    }

    label = counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }
}
