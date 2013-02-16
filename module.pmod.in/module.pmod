constant __author = "Bill Welliver <bill@welliver.org>";
constant __version = "1.0";

// if necessary, inherit the C language module here.
inherit Database.___EJDB;

class Collection
{
  inherit LowCollection;

  array find(mapping query)
  {
    mixed res;
    res = low_find(BSON.toDocument(query, 1));
    return res;
    foreach(res; int i; mixed e)
    {
      res[i] = BSON.fromDocument(e);
    }
    return res;
  }
}
