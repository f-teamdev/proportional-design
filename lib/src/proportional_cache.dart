/// Sistema de cache inteligente para cálculos proporcionais
class ProportionalCache {
  ProportionalCache._();

  static final Map<String, double> _cache = {};
  static bool _enabled = true;
  static int _maxCacheSize = 1000;

  /// Habilita o sistema de cache
  static void enable() => _enabled = true;

  /// Desabilita o sistema de cache
  static void disable() => _enabled = false;

  /// Verifica se o cache está habilitado
  static bool get isEnabled => _enabled;

  /// Limpa todo o cache
  static void clear() => _cache.clear();

  /// Define o tamanho máximo do cache
  static void setMaxCacheSize(int size) {
    assert(size > 0, 'Cache size must be positive');
    _maxCacheSize = size;
    _evictIfNeeded();
  }

  /// Retorna o tamanho atual do cache
  static int get cacheSize => _cache.length;

  /// Retorna estatísticas do cache
  static Map<String, dynamic> get statistics => {
        'enabled': _enabled,
        'size': _cache.length,
        'maxSize': _maxCacheSize,
        'hitRate': _hitRate,
      };

  static int _hits = 0;
  static int _misses = 0;

  static double get _hitRate {
    final total = _hits + _misses;
    return total > 0 ? _hits / total : 0.0;
  }

  /// Obtém um valor do cache ou calcula usando a função fornecida
  static double getCachedSize(String key, double Function() calculator) {
    if (!_enabled) {
      return calculator();
    }

    if (_cache.containsKey(key)) {
      _hits++;
      return _cache[key]!;
    }

    _misses++;
    final value = calculator();
    _cache[key] = value;
    _evictIfNeeded();

    return value;
  }

  /// Remove entradas antigas se o cache exceder o tamanho máximo (FIFO)
  static void _evictIfNeeded() {
    if (_cache.length > _maxCacheSize) {
      final keysToRemove = _cache.keys.take(_cache.length - _maxCacheSize);
      for (final key in keysToRemove) {
        _cache.remove(key);
      }
    }
  }

  /// Gera chave única para cache
  static String generateKey(
    double value,
    bool isWidth,
    double screenSize, {
    String? prefix,
  }) {
    final baseKey = '${value}_${isWidth}_${screenSize.toStringAsFixed(0)}';
    return prefix != null ? '${prefix}_$baseKey' : baseKey;
  }

  /// Gera chave para cálculos com device type
  static String generateDeviceKey(
    double value,
    String deviceType,
    bool isWidth,
  ) {
    return '${deviceType}_${value}_${isWidth}';
  }
}
