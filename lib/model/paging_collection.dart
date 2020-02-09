class PagingCollection<E> {
  PagingCollection(this._page, this._list);

  final Page _page;
  final List<E> _list;


  List<E> toList() => _list;
}

class Page {}