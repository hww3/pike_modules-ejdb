constant __author = "Bill Welliver <bill@welliver.org>";
constant __version = "1.1";

// if necessary, inherit the C language module here.
inherit Database.___EJDB;

//!
class Collection
{
  inherit LowCollection;

  //!
  int save(mapping obj, string|void oid, int|void merge)
  {
    if(oid)
      return save_bson(Standards.BSON.to_document(obj), oid, merge);
    else
      return save_bson(Standards.BSON.to_document(obj), UNDEFINED, merge);
  }
  
  //!
  int load(string oid)
  {
    string ret = load_bson(oid);

    if(ret)
      return Standards.BSON.from_document(ret);
    else 
      return 0;
  }
  
  //!
  array find(mapping query, mapping|void hints)
  {
    mixed res;
    res = low_find(Standards.BSON.to_document(query, 1), hints?Standards.BSON.to_document(hints, 1):0);
    foreach(res; int i; mixed e)
    {
      res[i] = Standards.BSON.from_document(e);
    }
    return res;
  }
}
