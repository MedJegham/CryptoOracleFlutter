class AppConstants {
  // API Configuration - Binance Public API (No rate limits for public endpoints)
  static const String baseUrl = 'https://api.binance.com/api/v3';
  static const String binanceWsUrl = 'wss://stream.binance.com:9443/ws';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxRetries = 3;
  
  // Cache Duration
  static const Duration cacheDuration = Duration(minutes: 5);
  
  // Prediction Horizons
  static const String predictionH1 = 'H+1';
  static const String predictionH4 = 'H+4';
  
  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String themeKey = 'theme_mode';
  static const String lastSyncKey = 'last_sync';
  static const String priceHistoryKey = 'price_history';

  // Hive Boxes
  static const String marketDataBox = 'market_data';
  static const String userPrefsBox = 'user_prefs';
  
  // Top trading pairs on Binance (expanded list)
  static const List<String> topSymbols = [
    'BTCUSDT',
    'ETHUSDT',
    'BNBUSDT',
    'SOLUSDT',
    'XRPUSDT',
    'ADAUSDT',
    'DOGEUSDT',
    'MATICUSDT',
    'DOTUSDT',
    'LTCUSDT',
    'AVAXUSDT',
    'LINKUSDT',
    'ATOMUSDT',
    'UNIUSDT',
    'ETCUSDT',
    'XLMUSDT',
    'NEARUSDT',
    'ALGOUSDT',
    'APTUSDT',
    'ARBUSDT',
  ];

  // Extended list for search (100+ coins)
  static const List<String> allSymbols = [
    'BTCUSDT', 'ETHUSDT', 'BNBUSDT', 'SOLUSDT', 'XRPUSDT',
    'ADAUSDT', 'DOGEUSDT', 'MATICUSDT', 'DOTUSDT', 'LTCUSDT',
    'AVAXUSDT', 'LINKUSDT', 'ATOMUSDT', 'UNIUSDT', 'ETCUSDT',
    'XLMUSDT', 'NEARUSDT', 'ALGOUSDT', 'APTUSDT', 'ARBUSDT',
    'TRXUSDT', 'TONUSDT', 'SHIBUSDT', 'WBTCUSDT', 'DAIUSDT',
    'BCHUSDT', 'LEOUSDT', 'OKBUSDT', 'SUIUSDT', 'INJUSDT',
    'FILUSDT', 'LDOUSDT', 'IMXUSDT', 'STXUSDT', 'MKRUSDT',
    'AAVEUSDT', 'GRTUSDT', 'SANDUSDT', 'MANAUSDT', 'FTMUSDT',
    'AXSUSDT', 'THETAUSDT', 'EOSUSDT', 'XTZUSDT', 'FLOWUSDT',
    'ICPUSDT', 'VETUSDT', 'EGLDUSDT', 'HBARUSDT', 'QNTUSDT',
    'RNDRUSDT', 'RUNEUSDT', 'ARUSDT', 'OPUSDT', 'TIAUSDT',
    'SEIUSDT', 'BEAMUSDT', 'FETUSDT', 'TAOUSDT', 'WLDUSDT',
    'PEPEUSDT', 'FLOKIUSDT', 'BONKUSDT', 'ORDIUSDT', 'WIFUSDT',
    'ENAUSDT', 'PENDLEUSDT', 'JUPUSDT', 'PYTHUSDT', 'DYMUSDT',
    'JTOUSDT', 'STRKUSDT', 'METISUSDT', 'MANTAUSDT', 'ALTUSDT',
    'AIUSDT', 'XAIUSDT', 'ACEUSDT', 'NFPUSDT', 'PORTALUSDT',
    'PIXELUSDT', 'RONINUSDT', 'PDAUSDT', 'AXLUSDT', 'WUSDT',
    'REZUSDT', 'OMNIUSDT', 'SAGAUSDT', 'NOTUSDT', 'IOUSDT',
    'ZKUSDT', 'LISTAUSDT', 'ZROUSDT', 'RENDERUSDT', 'BOMEUSDT',
    'MEWUSDT', 'TURBOUSDT', 'BRETTUSDT', 'SUNUSDT', 'NEIROUSDT',
  ];
}
