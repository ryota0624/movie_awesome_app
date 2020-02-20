class PagingCollection<E> {
  PagingCollection(this.page, this._list);

  final Page page;
  final List<E> _list;


  List<E> toList() => _list;

  bool equalPage(Page other) {
    return other.toString() == page.toString();
  }
}

class Page {
  const Page(this._n);

  final int _n;
  static const initial = Page(1);
  Page next() => Page(_n + 1);

  int asInt() => _n;
}