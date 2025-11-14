# Offline Functionality - Testing Checklist

## Pre-Testing Setup

- [ ] Ensure all dependencies are installed
- [ ] Build app in debug mode
- [ ] Have test device/emulator ready
- [ ] Clear app data for fresh start
- [ ] Enable developer options on device

## 1. Connectivity Detection

### Online → Offline Transition
- [ ] Start app while online
- [ ] Enable airplane mode
- [ ] Verify offline banner slides down from top
- [ ] Banner shows: "You're offline. Some features may not be available."
- [ ] Banner has yellow background
- [ ] WiFi-off icon is visible
- [ ] Banner persists while offline

### Offline → Online Transition
- [ ] While offline, disable airplane mode
- [ ] Verify "Back online" message appears
- [ ] Message has green background
- [ ] WiFi icon is visible
- [ ] Message auto-hides after 2 seconds
- [ ] Offline banner disappears

### Offline Banner Details
- [ ] Tap offline banner
- [ ] Modal bottom sheet appears
- [ ] Shows "Offline Mode" title
- [ ] Lists "Available Offline" features
- [ ] Lists "Requires Internet" features
- [ ] "Retry Connection" button works
- [ ] Shows correct connection status after retry

## 2. Sync Status Indicator

### Visual States
- [ ] When synced: Green checkmark (cloud_done) icon
- [ ] When syncing: Rotating progress indicator
- [ ] When pending: Yellow sync icon with count badge
- [ ] When error: Red sync_problem icon
- [ ] Badge shows correct pending count

### Sync Details Modal
- [ ] Tap sync status indicator
- [ ] Modal shows "Last Synced" time
- [ ] Shows "Pending Actions" count
- [ ] Shows "Failed Actions" count
- [ ] "View Queue" button navigates to queue screen
- [ ] "Sync Now" button triggers sync
- [ ] Modal closes after sync starts

## 3. Offline Actions Queue

### Adding to Queue
- [ ] Go offline
- [ ] Add ritual to wishlist
- [ ] Action is queued (not executed)
- [ ] Toast shows: "Action queued. Will sync when online."
- [ ] UI updates optimistically
- [ ] Queue count badge increases

### Queue Screen
- [ ] Navigate to queue screen
- [ ] All queued actions are listed
- [ ] Each action shows:
  - [ ] Correct icon and color
  - [ ] Action title
  - [ ] Timestamp
  - [ ] Status chip (Pending/Processing/Success/Failed)
- [ ] Tap action to see details
- [ ] Details modal shows:
  - [ ] Action title
  - [ ] Status
  - [ ] Created time
  - [ ] Retry count
  - [ ] Payload data

### Processing Queue
- [ ] Have pending actions in queue
- [ ] Go online
- [ ] Verify auto-sync starts
- [ ] Toast shows: "Syncing your changes..."
- [ ] Actions process one by one
- [ ] Successful actions marked as "Success"
- [ ] Failed actions marked as "Failed"
- [ ] Retry count increments on failure
- [ ] After 3 failures, action marked as permanently failed

### Manual Sync
- [ ] Have pending actions
- [ ] Tap "Sync Now" button
- [ ] Sync starts immediately
- [ ] Progress indicator shows
- [ ] Toast confirms completion

### Retry Failed Actions
- [ ] Have failed action in queue
- [ ] Tap failed action
- [ ] Tap "Retry" button
- [ ] Action re-processes
- [ ] Status updates accordingly

### Clear Queue
- [ ] Have successful actions
- [ ] Tap "Clear Successful" button
- [ ] Confirm dialog appears
- [ ] Successful actions removed
- [ ] Pending/failed actions remain

## 4. Data Caching

### Automatic Caching
- [ ] View rituals list while online
- [ ] Data is cached automatically
- [ ] Go offline
- [ ] Rituals still visible
- [ ] "Cached" badge appears on cached items

### Cache Validity
- [ ] View cached data
- [ ] Check "Last updated" timestamp
- [ ] Wait for cache to expire (or manually set short expiry)
- [ ] Go online
- [ ] Fresh data fetched automatically
- [ ] Cache updated

### Cache Size
- [ ] Go to Settings > Offline & Storage
- [ ] Current cache size displayed
- [ ] Size updates after caching data
- [ ] Size decreases after clearing cache

## 5. Downloads Management

### Download Content
- [ ] Open ritual detail screen
- [ ] Tap "Download for Offline" button
- [ ] Progress dialog appears
- [ ] Download completes
- [ ] Success toast shown
- [ ] Download icon/badge appears on item

### Manage Downloads Screen
- [ ] Navigate to Manage Downloads
- [ ] All downloads listed
- [ ] Each download shows:
  - [ ] Content type icon
  - [ ] Title
  - [ ] File size
  - [ ] Download date
- [ ] Total storage used shown at top

### Delete Download
- [ ] Tap delete icon on download
- [ ] Confirmation dialog appears
- [ ] Confirm deletion
- [ ] Download removed from list
- [ ] Storage size updates

### Bulk Delete
- [ ] Long-press download item
- [ ] Selection mode activates
- [ ] Select multiple items
- [ ] Tap delete icon
- [ ] Confirm bulk deletion
- [ ] All selected items removed

### Delete All
- [ ] Tap "Delete All" button
- [ ] Confirmation dialog appears
- [ ] Confirm deletion
- [ ] All downloads removed
- [ ] Empty state shown

## 6. Offline Settings

### Auto-Download on WiFi
- [ ] Go to Offline & Storage settings
- [ ] Toggle "Auto-download on WiFi"
- [ ] Setting saves
- [ ] Connect to WiFi
- [ ] New content auto-downloads (if enabled)

### Download Quality
- [ ] Tap "Download Quality"
- [ ] Dialog shows three options:
  - [ ] High (Original quality)
  - [ ] Medium (Compressed)
  - [ ] Low (Highly compressed)
- [ ] Select option
- [ ] Setting saves
- [ ] Future downloads use selected quality

### Auto-Sync When Online
- [ ] Toggle "Auto-sync when online"
- [ ] Setting saves
- [ ] Go offline, queue actions
- [ ] Go online
- [ ] If enabled: Auto-sync starts
- [ ] If disabled: Manual sync required

### Storage Limit
- [ ] Adjust storage limit slider
- [ ] Range: 100 MB - 2 GB
- [ ] Current usage vs limit shown
- [ ] Setting saves
- [ ] Warning when approaching limit

### Auto-Delete Old Cache
- [ ] Toggle "Auto-delete old cache"
- [ ] If enabled, days slider appears
- [ ] Adjust days (1-30)
- [ ] Setting saves
- [ ] Old cache auto-deleted based on setting

### Clear Expired Cache
- [ ] Tap "Clear Expired Cache"
- [ ] Confirmation dialog appears
- [ ] Confirm action
- [ ] Expired cache removed
- [ ] Success toast shown
- [ ] Storage size updates

### Clear All Cache
- [ ] Tap "Clear All Cache"
- [ ] Warning dialog appears
- [ ] Confirm action
- [ ] All cache cleared
- [ ] Success toast shown
- [ ] Storage size resets to 0

## 7. Offline UI Indicators

### Disabled Features
- [ ] Go offline
- [ ] Search bar is disabled
- [ ] Shows "Search unavailable offline" message
- [ ] Booking button disabled
- [ ] Shows "Connect to internet to book"
- [ ] Live stream disabled
- [ ] Shows "Cannot stream offline"
- [ ] Payment features disabled
- [ ] Tooltips explain why disabled

### Cached Badges
- [ ] View cached content
- [ ] "Cached" badge visible
- [ ] Badge shows cloud_done icon
- [ ] Badge has grey background
- [ ] Badge positioned correctly (top-right)

### Offline Error States
- [ ] Try to access online-only feature while offline
- [ ] Error screen appears
- [ ] Shows cloud_off icon
- [ ] Shows "No Internet Connection" title
- [ ] Shows descriptive message
- [ ] "Retry" button available
- [ ] "Offline Settings" button available

## 8. Conflict Resolution

### Detect Conflicts
- [ ] Edit profile while offline
- [ ] Same field edited on server
- [ ] Go online and sync
- [ ] Conflict detected
- [ ] SyncConflictScreen appears

### Resolve Conflicts
- [ ] Conflict screen shows side-by-side comparison
- [ ] Left: "Your Changes (Offline)"
- [ ] Right: "Server Data (Online)"
- [ ] Differences highlighted
- [ ] Radio buttons for each field
- [ ] Select preferred version per field
- [ ] "Keep Server" button auto-resolves
- [ ] "Apply Selected Changes" button applies choices
- [ ] Resolved data synced to server

## 9. Edge Cases

### Intermittent Connection
- [ ] Simulate poor connection (toggle airplane mode rapidly)
- [ ] App handles gracefully
- [ ] No crashes or data loss
- [ ] Sync retries appropriately

### App Restart While Offline
- [ ] Queue actions while offline
- [ ] Close app completely
- [ ] Reopen app (still offline)
- [ ] Queue persists
- [ ] Cached data still available

### Storage Full
- [ ] Fill storage to limit
- [ ] Try to download more
- [ ] Warning shown
- [ ] Option to increase limit or clear cache
- [ ] No data corruption

### Expired Cache
- [ ] Cache data with short expiry
- [ ] Wait for expiry
- [ ] Go offline
- [ ] Try to access expired data
- [ ] Appropriate error message
- [ ] Option to retry when online

### Multiple Failed Retries
- [ ] Queue action that will fail
- [ ] Let it retry 3 times
- [ ] After 3rd failure, marked as permanently failed
- [ ] Manual retry still available
- [ ] No infinite retry loop

## 10. Performance

### App Launch
- [ ] Launch app while offline
- [ ] Loads within 3 seconds
- [ ] Shows cached data immediately
- [ ] No blocking operations

### Sync Performance
- [ ] Queue 10+ actions
- [ ] Go online
- [ ] All actions sync within 10 seconds
- [ ] UI remains responsive during sync
- [ ] No ANR (Application Not Responding)

### Cache Performance
- [ ] Cache 50+ items
- [ ] Access cached data
- [ ] Loads instantly
- [ ] No lag or stuttering
- [ ] Memory usage reasonable

### Storage Management
- [ ] Fill cache to 500 MB
- [ ] Clear cache
- [ ] Storage freed immediately
- [ ] No orphaned files

## 11. Integration Testing

### Wishlist Integration
- [ ] Add to wishlist while offline
- [ ] Action queued
- [ ] UI updates
- [ ] Go online
- [ ] Action syncs
- [ ] Server updated
- [ ] UI reflects server state

### Review Integration
- [ ] Write review while offline
- [ ] Review saved as draft
- [ ] Go online
- [ ] Review submitted
- [ ] Appears in reviews list

### Profile Integration
- [ ] Edit profile while offline
- [ ] Changes saved locally
- [ ] Go online
- [ ] Changes synced
- [ ] Profile updated on server

### Orders Integration
- [ ] View orders while offline
- [ ] Cached orders displayed
- [ ] Order details accessible
- [ ] Invoice downloadable (if cached)

## 12. User Experience

### Clear Communication
- [ ] All offline states clearly communicated
- [ ] Helpful error messages
- [ ] No confusing technical jargon
- [ ] Actionable suggestions provided

### Smooth Transitions
- [ ] Online/offline transitions smooth
- [ ] No jarring UI changes
- [ ] Animations work correctly
- [ ] No flashing or flickering

### Feedback
- [ ] Actions provide immediate feedback
- [ ] Toasts/snackbars informative
- [ ] Progress indicators accurate
- [ ] Success/error states clear

## Test Results Template

```
Date: ___________
Tester: ___________
Device: ___________
OS Version: ___________

Total Tests: ___
Passed: ___
Failed: ___
Blocked: ___

Critical Issues:
1. 
2. 
3. 

Minor Issues:
1. 
2. 
3. 

Notes:


Signature: ___________
```

## Automated Testing (Optional)

### Unit Tests
- [ ] ConnectivityService tests
- [ ] CacheManager tests
- [ ] QueueManager tests
- [ ] SyncProvider tests

### Widget Tests
- [ ] OfflineBanner widget test
- [ ] SyncStatusIndicator widget test
- [ ] OfflineErrorWidget widget test

### Integration Tests
- [ ] End-to-end offline flow
- [ ] Queue processing flow
- [ ] Conflict resolution flow

## Sign-Off

- [ ] All critical tests passed
- [ ] No blocking issues
- [ ] Performance acceptable
- [ ] User experience smooth
- [ ] Documentation complete
- [ ] Ready for production

---

**Testing Status**: ⬜ Not Started | 🟡 In Progress | ✅ Complete
**Last Updated**: ___________
**Next Review**: ___________
