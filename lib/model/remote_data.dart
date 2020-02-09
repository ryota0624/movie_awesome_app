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
