import 'package:movie_awesome_app/model/paging_collection.dart';

abstract class RemoteData<D> {}

class Loading<D> extends RemoteData<D> {}

class Success<D> extends RemoteData<D> {
  Success(this.data);

  final D data;
}

class Failure<D> extends RemoteData<D> {
  Failure(this.err);

  final Exception err;
}

class None<D> extends RemoteData<D> {}

class AppendableRemotePagingCollection<E> {
  AppendableRemotePagingCollection._(this.loaded, this.lastLoaded);

  factory AppendableRemotePagingCollection.withLoading() =>
      AppendableRemotePagingCollection._([], Loading());

  factory AppendableRemotePagingCollection.empty() =>
      AppendableRemotePagingCollection._([], None());

  final List<PagingCollection<E>> loaded;
  final RemoteData<PagingCollection<E>> lastLoaded;

  AppendableRemotePagingCollection<E> append(
      RemoteData<PagingCollection<E>> received) {
    return AppendableRemotePagingCollection._(loaded, received);
  }

  AppendableRemotePagingCollection<E> loadNext() {
    final updatedLoaded = [...loaded];
    return AppendableRemotePagingCollection._(updatedLoaded, Loading());
  }

}
