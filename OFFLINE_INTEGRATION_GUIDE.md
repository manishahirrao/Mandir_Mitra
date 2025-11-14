# Offline Functionality - Quick Integration Guide

## Step-by-Step Integration

### Step 1: Update main.dart Provider Setup

Add the new providers to your MultiProvider:

```dart
MultiProvider(
  providers: [
    // Existing providers...
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
    // ... other providers
  ],
  child: MyApp(),
)
```

### Step 2: Wrap MaterialApp with OfflineBanner

In your `MyApp` widget:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OfflineBanner(
      child: MaterialApp(
        title: 'Mandir Mitra',
        theme: ThemeData(...),
        home: SplashScreen(),
        routes: {
          // Existing routes...
          '/manage-downloads': (context) => ManageDownloadsScreen(),
          '/queue': (context) => QueueScreen(),
          '/offline-storage-settings': (context) => OfflineStorageSettingsScreen(),
          '/sync-conflict': (context) => SyncConflictScreen(
            localData: {},
            serverData: {},
            dataType: '',
          ),
        },
      ),
    );
  }
}
```

### Step 3: Update CustomAppBar

Add SyncStatusIndicator to your app bar:

```dart
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Mandir Mitra'),
      actions: [
        SyncStatusIndicator(), // Add this
        IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () => Navigator.pushNamed(context, '/notifications'),
        ),
      ],
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
```

### Step 4: Update Settings Screen

Add "Offline & Storage" option to settings:

```dart
// In settings_screen.dart
ListTile(
  leading: Icon(Icons.cloud_off, color: AppTheme.sacredBlue),
  title: Text('Offline & Storage'),
  subtitle: Text('Manage downloads and cache'),
  trailing: Icon(Icons.chevron_right),
  onTap: () => Navigator.pushNamed(context, '/offline-storage-settings'),
),
```

### Step 5: Queue Offline Actions

Example: Wishlist (update wishlist_provider.dart):

```dart
Future<void> toggleWishlist(String ritualId) async {
  final connectivity = context.read<ConnectivityService>();
  
  if (connectivity.isOffline) {
    // Queue action for later
    final queueManager = context.read<QueueManager>();
    await queueManager.addToQueue(
      OfflineAction(
        id: 'ACT${DateTime.now().millisecondsSinceEpoch}',
        actionType: isInWishlist(ritualId) ? 'remove_wishlist' : 'add_wishlist',
        payload: {'ritualId': ritualId},
        timestamp: DateTime.now(),
      ),
    );
    
    // Update local state optimistically
    if (isInWishlist(ritualId)) {
      _wishlistItems.removeWhere((item) => item.ritualId == ritualId);
    } else {
      // Add to local wishlist
    }
    notifyListeners();
    
    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Action queued. Will sync when online.'),
        action: SnackBarAction(
          label: 'View Queue',
          onPressed: () => Navigator.pushNamed(context, '/queue'),
        ),
      ),
    );
  } else {
    // Normal online flow
    await _apiCall();
  }
}
```

### Step 6: Cache Data

Example: Rituals Provider (update rituals_provider.dart):

```dart
Future<void> fetchRituals() async {
  final connectivity = context.read<ConnectivityService>();
  
  // Try cache first
  final cachedData = await CacheManager.getCachedData('rituals_list');
  if (cachedData != null) {
    _rituals = (cachedData['rituals'] as List)
        .map((r) => Ritual.fromJson(r))
        .toList();
    notifyListeners();
  }
  
  // If online, fetch fresh data
  if (connectivity.isOnline) {
    try {
      final response = await http.get(Uri.parse('$baseUrl/rituals'));
      final data = json.decode(response.body);
      
      // Update cache
      await CacheManager.cacheData(
        'rituals_list',
        data,
        expiry: Duration(days: 7),
      );
      
      _rituals = (data['rituals'] as List)
          .map((r) => Ritual.fromJson(r))
          .toList();
      notifyListeners();
    } catch (e) {
      // If fetch fails but we have cache, use it
      if (cachedData == null) rethrow;
    }
  } else if (cachedData == null) {
    throw Exception('No cached data available offline');
  }
}
```

### Step 7: Add Download Buttons

Example: Ritual Detail Screen:

```dart
// In ritual_detail_screen.dart
ElevatedButton.icon(
  icon: Icon(Icons.download),
  label: Text('Download for Offline'),
  onPressed: () async {
    final syncProvider = context.read<SyncProvider>();
    
    // Show progress
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Downloading ritual details...'),
          ],
        ),
      ),
    );
    
    try {
      // Cache ritual data
      await CacheManager.cacheData(
        'ritual_${ritual.id}',
        ritual.toJson(),
        expiry: Duration(days: 30),
      );
      
      // Track download
      await syncProvider.addDownload(
        DownloadedContent(
          id: 'DL${DateTime.now().millisecondsSinceEpoch}',
          contentType: 'ritual',
          contentId: ritual.id,
          filePath: 'cache/ritual_${ritual.id}',
          fileSize: 1024 * 100, // Estimate
          downloadedAt: DateTime.now(),
        ),
      );
      
      Navigator.pop(context); // Close progress dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Downloaded successfully'),
          action: SnackBarAction(
            label: 'Manage',
            onPressed: () => Navigator.pushNamed(context, '/manage-downloads'),
          ),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed: $e')),
      );
    }
  },
),
```

### Step 8: Show Offline Indicators

Example: Disable features when offline:

```dart
// In booking_screen.dart
Consumer<ConnectivityService>(
  builder: (context, connectivity, child) {
    return ElevatedButton(
      onPressed: connectivity.isOffline
          ? null
          : () => _proceedToPayment(),
      child: Text(
        connectivity.isOffline
            ? 'Connect to internet to book'
            : 'Proceed to Payment',
      ),
    );
  },
)
```

### Step 9: Handle Cached Data Display

Show "Cached" badge on cached content:

```dart
// In ritual_card.dart
FutureBuilder<bool>(
  future: CacheManager.isCacheValid('ritual_${ritual.id}'),
  builder: (context, snapshot) {
    final isCached = snapshot.data ?? false;
    
    return Stack(
      children: [
        // Ritual card content
        RitualCardContent(ritual: ritual),
        
        // Cached badge
        if (isCached)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cloud_done, size: 12, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    'Cached',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  },
)
```

### Step 10: Test Everything

1. **Test Offline Mode**:
   ```
   - Enable airplane mode
   - Verify offline banner appears
   - Try adding to wishlist (should queue)
   - Check queue screen
   - Disable airplane mode
   - Verify auto-sync
   ```

2. **Test Caching**:
   ```
   - View rituals while online
   - Go offline
   - Verify rituals still visible
   - Check "Cached" badge appears
   ```

3. **Test Downloads**:
   ```
   - Download ritual details
   - Go to Manage Downloads
   - Verify file size and date
   - Delete download
   ```

4. **Test Settings**:
   ```
   - Go to Settings > Offline & Storage
   - Adjust storage limit
   - Change download quality
   - Toggle auto-sync
   - Clear cache
   ```

## Quick Checklist

- [ ] Add providers to main.dart
- [ ] Wrap app with OfflineBanner
- [ ] Add SyncStatusIndicator to AppBar
- [ ] Add routes for new screens
- [ ] Update Settings screen with offline option
- [ ] Queue offline actions in providers
- [ ] Implement caching in data providers
- [ ] Add download buttons where needed
- [ ] Show offline indicators on disabled features
- [ ] Display "Cached" badges
- [ ] Test all offline scenarios

## Common Issues & Solutions

### Issue: Offline banner not showing
**Solution**: Ensure ConnectivityService is initialized and OfflineBanner wraps MaterialApp

### Issue: Queue not processing
**Solution**: Check that SyncProvider is listening to ConnectivityService changes

### Issue: Cache not working
**Solution**: Verify SharedPreferences permissions and cache keys are unique

### Issue: Downloads not tracked
**Solution**: Ensure addDownload() is called after successful cache

## Performance Tips

1. **Lazy Load**: Only cache data when user views it
2. **Background Sync**: Use WorkManager for periodic background sync
3. **Compress**: Compress images before caching
4. **Prioritize**: Cache user's data first (orders, wishlist)
5. **Clean Up**: Regularly clean expired cache

## Support

For issues or questions:
1. Check OFFLINE_SYNC_IMPLEMENTATION.md for detailed docs
2. Review example code in this guide
3. Test with developer mode "Simulate Offline" toggle

---

**Estimated Integration Time**: 2-3 hours
**Difficulty**: Medium
**Priority**: High (Core feature)
