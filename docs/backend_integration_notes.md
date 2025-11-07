# Backend Integration Notes

## Device Upsert (`/api/device/upsert`)
- **Request model**: `DeviceRequest`
  - `deviceId` (string, UUID generated client side via `DeviceService`)
  - `platform` (Android/iOS)
  - `locale` (Intl.systemLocale)
  - `timezone` (FlutterNativeTimezone)
- **Response model**: `DeviceStateResponse`
  - `deviceState.lastLocation.geohash6` drives geohash comparisons on the client.
  - `deviceState.lastPrayerCache` is parsed into the shared `PrayerTimes` model.
  - Dates are parsed as ISO strings (`createdAt`, `lastSeenAt`, `deviceState.lastPrayerDate`).

### Client Behaviour
1. `AppInitCubit` now retries the upsert up to 3 times with exponential backoff.
2. Successful responses are persisted via `DeviceService.persistDeviceState` so the UI can cold-start offline.
3. When no network is available the cached snapshot is emitted until the API call succeeds.

## Prayer Times (`/api/prayer-times`)
- **Request model**: `PrayerTimesRequest`
  - Includes `deviceId`, lat/lng, date (UTC yyyy-MM-dd), `calcMethod`, `madhab`.
- **Response model**: `PrayerTimes` without envelope; backend should return times in 24h `HH:mm` format.

### Client Behaviour
1. `PrayerTimesBloc` computes geohash6 with frontend precision = 6.
2. Flow:
   - Check local cache (`PrayerCacheService`, keyed by geohash + date).
   - Fallback to backend-provided cache (`DeviceStateSnapshot.hasCacheFor`).
   - As a last resort call `getPrayerTimes` with retry (3x).
3. Fresh responses are stored in SharedPreferences through `PrayerCacheService`.
4. The bloc emits `isFromCache` flag so UI can surface freshness affordances if needed.

## Background Hooks (WIP)
- Stubs added in `BackgroundTaskService` for significant location change and daily refresh handlers.
- Native layer should invoke `onSignificantLocationChange` with a `Position` + `geohash` computation; the bloc exposes `FetchPrayerTimes` event for manual triggers.
- `onDailyRefreshTick` should trigger when the calendar day changes while the app is suspended (WorkManager, Background App Refresh, etc.).
- Registration methods (`registerBackgroundTasks/cancelBackgroundTasks`) allow runtime toggling (e.g., user disables background updates).

## Background Refresh
- `BackgroundTaskService` now exposes `hasDayChanged(lastRefresh, {reference})` so native layers can apply locale-aware comparisons when deciding to wake Flutter.
- `PrayerTimesBloc` tracks the last successful refresh date and falls back to cached data with a warning if network calls fail during day changes.
- `HomeScreen` observes lifecycle + a minute cadence timer to dispatch `RefreshPrayerTimesIfDayChanged`; when the date rolls over in the foreground we automatically enqueue a fresh `FetchPrayerTimes`.
- Native integrations should continue to call `onDailyRefreshTick()` which will dispatch the same refresh event—duplicate triggers are guarded by the stored `_lastRefreshDate`.

## Outstanding Questions for Backend
1. Confirm geohash precision (currently using 6) and whether backend returns the calculated value on `getPrayerTimes`.
2. Verify that `/api/prayer-times` updates the stored cache on the backend so subsequent `upsertDevice` invocations reflect the latest data.
3. Clarify error payload structure to enrich retry logging and UI messaging.
4. Specify rate limits / throttling expectations for manual refresh (`pull-to-refresh`).

These notes ensure both teams stay aligned while Burak finalises API endpoints.
