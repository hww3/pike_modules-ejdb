constant __author = "Bill Welliver <bill@welliver.org>";
constant __version = "1.1";

// if necessary, inherit the C language module here.
inherit Database.___EJDB;

//!
class Collection
{
  inherit LowCollection;

  //! Insert Documents into a collection.
  //!
  //! @param obj
  //!  a document or array of documents to save.
  //!
  //! @param oid
  //!  if specified, the object id (or array of object ids for multiple documents) of the document to save
  //!
  //! @param merge
  //!  if an object id is specified, should the object be replaced or keys merged?
  //!
  //! @returns
  //!  the object id or an array of object ids of documents saved.
  string|array(string) save(mapping|array(mapping) obj, array(string)|string|void oid, int|void merge)
  {
    if(arrayp(obj))
    {
      array saved = ({});
        
      if(oid && !(arrayp(oid) && (sizeof(oid) == sizeof(obj))))
      {
        throw(Error.Generic("OID specified but not same size list as objects to save.\n"));
      }
      
      foreach(obj; int i; mapping d)
      {
        saved += ({ save(d, oid?oid[i]:0, merge) });
      }
      
      return saved;
    }
    
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
  array find(mapping query, array(mapping) orqueries, mapping|void hints)
  {
    mixed res;
    array borqueries;
    
    if(orqueries)
    {
      borqueries = allocate(sizeof(orqueries));
      foreach(orqueries; int i; mapping q)
        borqueries[i] = Standards.BSON.to_document(q, 1);  
    }
    
    res = low_find(Standards.BSON.to_document(query, 1), borqueries, hints?Standards.BSON.to_document(hints, 1):0);
    foreach(res; int i; mixed e)
    {
      res[i] = Standards.BSON.from_document(e);
    }
    return res;
  }
}
