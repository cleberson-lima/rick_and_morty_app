part of 'search_bloc.dart';

sealed class SearchEvent {
  const SearchEvent();
}

/// The user typed. Debounced, and a newer one replaces an older one.
final class SearchQueryChanged extends SearchEvent {
  const SearchQueryChanged(this.query);

  final String query;
}

/// Search right away: first load, tab switch, keyboard submit or retry.
final class SearchSubmitted extends SearchEvent {
  const SearchSubmitted(this.query);

  final String query;
}

/// The list scrolled near its end. [retry] is set by the "try again" button
/// after a failed page, so scrolling alone doesn't hammer a failing API.
final class SearchNextPageRequested extends SearchEvent {
  const SearchNextPageRequested({this.retry = false});

  final bool retry;
}
