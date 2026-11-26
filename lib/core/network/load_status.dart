/// Lifecycle of data a controller loads from a repository.
enum LoadStatus {
  /// A request is in flight and nothing has loaded yet.
  loading,

  /// Data loaded successfully.
  ready,

  /// The last request failed; the controller exposes a message and a retry.
  error,
}
