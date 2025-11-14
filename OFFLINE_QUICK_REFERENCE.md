# Offline Functionality - Quick Reference Card

## 🚀 Quick Integration (5 Minutes)

### 1. Add Providers (main.dart)
```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => ConnectivityService()),
    ChangeNotifierProvider(create: (_) => QueueManager()..loadQueue()),
    ChangeNotifierProxyProvider2<QueueManager, ConnectivityService, SyncProvider>(
      create: (context) => SyncProvider(
        context.read<QueueManager>(),
        context.read<ConnectivityService>(),
      ),
      update: (_, queue, connectivity, sync) => 
        sync ?? SyncProvider(queue, connectivity),
    ),
  ],
)
```

### 2. Wrap App
```dart
OfflineBanner(
  child: MaterialApp(...),
)
```

### 3. Add Sync Icon (AppBar)
```dart
actions: [
  SyncStatusIndicator(),
]
```

### 4. Add Routes
```dart
'/manage-downloads': (context) => ManageDownloadsScreen(),
'/queue': (context) => QueueScreen(),
'/offline-storage-settings': (context) => OfflineStorageSettingsScreen(),
```

## 📝 Common Code Snippets

### Queue Offline Action
```dart
if (connectivity.isOffline) {
  await queueManager.addToQueue(
    OfflineAction(
      id: 'ACT${DateTime.now().millisecondsSinceEpoch}',
      actionType: 'add_wishlist',
      payload: {'ritualId': ritualId},
      timestamp: DateTime.now(),
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Action queued. Will sync when online.')),
  );
}
```

### Cache Data
```dart
// Cache
await CacheManager.cacheData(
  'rituals_list',
  data,
  expiry: Duration(days: 7),
);

// Retrieve
final cachedData = await CacheManager.getCachedData('rituals_list');

// Check validity
final isValid = await CacheManager.isCacheValid('rituals_list');
```

### Fetch with Cache Fallback
```dart
Future<List<Ritual>> fetchRituals() async {
  // Try cache first
  final cached = await CacheManager.getCachedData('rituals');
  if (cached != null) {
    _rituals = (cached['data'] as List).map((r) => Ritual.fromJson(r)).toList();
    notifyListeners();
  }
  
  // Fetch fresh if online
  if (connectivity.isOnline) {
    try {
      final response = await http.get(Uri.parse('$baseUrl/rituals'));
      final data = json.decode(response.body);
      await CacheManager.cacheData('rituals', data, expiry: Duration(days: 7));
      _rituals = (data['data'] as List).map((r) => Ritual.fromJson(r)).toList();
      notifyListeners();
    } catch (e) {
      if (cached == null) rethrow;
    }
  }
  
  return _rituals;
}
```

### Disable Button When Offline
```dart
Consumer<ConnectivityService>(
  builder: (context, connectivity, child) {
    return ElevatedButton(
      onPressed: connectivity.isOffline ? null : () => _doAction(),
      child: Text(
        connectivity.isOffline ? 'Requires Internet' : 'Book Now',
      ),
    );
  },
)
```

### Show Offline Error
```dart
if (connectivity.isOffline) {
  return OfflineErrorWidget(
    message: 'Search requires an internet connection',
    onRetry: () => _retrySearch(),
  );
}
```

### Add Download
```dart
await syncProvider.addDownload(
  DownloadedContent(
    id: 'DL${DateTime.now().millisecondsSinceEpoch}',
    contentType: 'ritual',
    contentId: ritual.id,
    filePath: 'cache/ritual_${ritual.id}',
    fileSize: 1024 * 100,
    downloadedAt: DateTime.now(),
  ),
);
```

### Show Cached Badge
```dart
FutureBuilder<bool>(
  future: CacheManager.isCacheValid('ritual_${ritual.id}'),
  builder: (context, snapshot) {
    if (snapshot.data != true) return SizedBox.shrink();
    return CachedBadge(cacheKey: 'ritual_${ritual.id}');
  },
)
```

## 🎯 Key Classes & Methods

### ConnectivityService
- `isOnline` - Check if online
- `isOffline` - Check if offline
- `justCameOnline` - Just came online
- `checkConnection()` - Manual check

### CacheManager
- `cacheData(key, data, expiry)` - Cache data
- `getCachedData(key)` - Get cached data
- `isCacheValid(key)` - Check validity
- `clearCache(key)` - Clear specific
- `clearAllCache()` - Clear all
- `getCacheSize()` - Get size in MB
- `cleanExpiredCache()` - Remove expired

### QueueManager
- `addToQueue(action)` - Add action
- `removeFromQueue(id)` - Remove action
- `updateAction(action)` - Update action
- `clearQueue()` - Clear all
- `getPendingActions()` - Get pending
- `getFailedActions()` - Get failed
- `pendingCount` - Count pending

### SyncProvider
- `syncAll()` - Sync all actions
- `retryAction(action)` - Retry failed
- `addDownload(content)` - Track download
- `deleteDownload(id)` - Remove download
- `clearAllDownloads()` - Clear all
- `cleanExpiredCache()` - Clean cache
- `lastSyncTime` - Last sync time
- `isSyncing` - Is syncing now

## 🎨 UI Widgets

### OfflineBanner
```dart
OfflineBanner(
  child: MaterialApp(...),
)
```

### SyncStatusIndicator
```dart
AppBar(
  actions: [SyncStatusIndicator()],
)
```

### OfflineErrorWidget
```dart
OfflineErrorWidget(
  message: 'Feature requires internet',
  onRetry: () => _retry(),
  showSettings: true,
)
```

### RequiresInternetWidget
```dart
RequiresInternetWidget(
  feature: 'Search',
  child: SearchScreen(),
)
```

### OfflineDisabledButton
```dart
OfflineDisabledButton(
  label: 'Book Now',
  icon: Icons.book,
  onPressed: () => _book(),
  fullWidth: true,
)
```

### CachedBadge
```dart
CachedBadge(cacheKey: 'ritual_123')
```

## 📱 Screens

### ManageDownloadsScreen
```dart
Navigator.pushNamed(context, '/manage-downloads');
```

### QueueScreen
```dart
Navigator.pushNamed(context, '/queue');
```

### OfflineStorageSettingsScreen
```dart
Navigator.pushNamed(context, '/offline-storage-settings');
```

### SyncConflictScreen
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => SyncConflictScreen(
      localData: localData,
      serverData: serverData,
      dataType: 'profile',
    ),
  ),
);
```

## ⚙️ Settings Access

```dart
// Get settings
final settings = context.read<SettingsProvider>();

// Auto-download on WiFi
settings.autoDownloadOnWifi
settings.setAutoDownloadOnWifi(true)

// Auto-sync when online
settings.autoSyncWhenOnline
settings.setAutoSyncWhenOnline(true)

// Download quality
settings.downloadQuality // 'high', 'medium', 'low'
settings.setDownloadQuality('medium')

// Storage limit
settings.storageLimitMB
settings.setStorageLimit(500)

// Auto-delete old cache
settings.autoDeleteOldCache
settings.setAutoDeleteOldCache(true)

// Cache expiry days
settings.cacheExpiryDays
settings.setCacheExpiryDays(7)
```

## 🔄 Action Types

Supported offline action types:
- `add_wishlist` - Add to wishlist
- `remove_wishlist` - Remove from wishlist
- `write_review` - Submit review
- `update_profile` - Update profile
- `submit_feedback` - Submit feedback

## 📊 Status Values

### Sync Status
- `synced` - All synced
- `syncing` - Currently syncing
- `pending` - Has pending actions
- `error` - Sync error

### Action Status
- `pending` - Waiting to sync
- `processing` - Currently processing
- `success` - Successfully synced
- `failed` - Failed after retries

## 🎯 Best Practices

### DO ✅
- Cache data on first view
- Update UI optimistically
- Show clear offline indicators
- Provide retry options
- Handle conflicts gracefully
- Clean expired cache regularly
- Monitor storage usage
- Test offline scenarios

### DON'T ❌
- Block UI during sync
- Lose user data
- Show technical errors
- Retry infinitely
- Cache sensitive data
- Ignore storage limits
- Forget to handle errors
- Skip offline testing

## 🐛 Debugging

### Check Connectivity
```dart
print('Online: ${connectivity.isOnline}');
print('Offline: ${connectivity.isOffline}');
```

### Check Queue
```dart
print('Pending: ${queueManager.pendingCount}');
print('Queue: ${queueManager.queue}');
```

### Check Cache
```dart
final size = await CacheManager.getCacheSize();
print('Cache size: ${size.toStringAsFixed(2)} MB');
```

### Check Sync
```dart
print('Last sync: ${syncProvider.lastSyncTime}');
print('Is syncing: ${syncProvider.isSyncing}');
```

## 📞 Quick Help

### Issue: Banner not showing
**Fix**: Wrap MaterialApp with OfflineBanner

### Issue: Queue not processing
**Fix**: Check SyncProvider initialization

### Issue: Cache not working
**Fix**: Verify cache keys are unique

### Issue: Sync failing
**Fix**: Check network permissions

## 📚 Documentation Files

1. **OFFLINE_SYNC_IMPLEMENTATION.md** - Full technical docs
2. **OFFLINE_INTEGRATION_GUIDE.md** - Step-by-step guide
3. **OFFLINE_TESTING_CHECKLIST.md** - Testing checklist
4. **OFFLINE_FEATURE_SUMMARY.md** - Feature overview
5. **OFFLINE_QUICK_REFERENCE.md** - This file

## ⏱️ Time Estimates

- **Read docs**: 30 minutes
- **Integration**: 2-3 hours
- **Testing**: 2-4 hours
- **Bug fixes**: 1-2 hours
- **Total**: 5-9 hours

## ✅ Integration Checklist

- [ ] Add providers to main.dart
- [ ] Wrap app with OfflineBanner
- [ ] Add SyncStatusIndicator to AppBar
- [ ] Add routes for new screens
- [ ] Update Settings screen
- [ ] Queue actions when offline
- [ ] Cache data in providers
- [ ] Add download buttons
- [ ] Show offline indicators
- [ ] Test thoroughly

---

**Quick Start**: Read this → Follow OFFLINE_INTEGRATION_GUIDE.md → Test with OFFLINE_TESTING_CHECKLIST.md

**Status**: 🟢 Ready for Integration
**Version**: 1.0.0
**Last Updated**: November 14, 2024
