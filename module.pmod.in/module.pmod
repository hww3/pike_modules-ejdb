constant __author = "Bill Welliver <bill@welliver.org>";
constant __version = "1.0";

// if necessary, inherit the C language module here.
inherit Database.___EJDB;

class Collection
{
  inherit LowCollection;

  int save(mapping obj, string|void oid, int|void merge)
  {
    if(oid)
      return save_bson(BSON.toDocument(obj), oid, merge);
    else
      return save_bson(BSON.toDocument(obj), UNDEFINED, merge);
  }
  
  int load(string oid)
  {
    string ret = load_bson(oid);

    if(ret)
      return BSON.fromDocument(ret);
    else 
      return 0;
  }
  
  array find(mapping query, mapping|void hints)
  {
    mixed res;
    res = low_find(BSON.toDocument(query, 1), hints?BSON.toDocument(hints, 1):0);
    foreach(res; int i; mixed e)
    {
      res[i] = BSON.fromDocument(e);
    }
    return res;
  }
}
