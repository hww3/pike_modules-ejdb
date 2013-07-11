constant __author = "Bill Welliver <bill@welliver.org>";
constant __version = "1.2";

// if necessary, inherit the C language module here.
inherit Database.___EJDB;

//! Object representing a collection of records stored in an EJDB databsase.
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
      return save_bson(Standards.BSON.encode(obj), oid, merge);
    else
      return save_bson(Standards.BSON.encode(obj), UNDEFINED, merge);
  }
  
  //! Load a record from the current collection using the record's OID.
  mapping|array load(string oid)
  {
    string ret = load_bson(oid);

    if(ret)
      return Standards.BSON.decode(ret);
    else 
      return 0;
  }

  //! Remove a record from the current collection using the record's OID.
  int delete(Standards.BSON.ObjectId id)
  {
    return delete_bson((string)id);
  }  

  //! Retrieve records from the current collection. For details of query syntax
  //! and query hints, please see the relevant EJDB documentation.
  //!
  //! @param query 
  //!  a mapping specifying the set of fields to match.
  //!
  //! @param orqueries
  //!  an array of additional field sets to match in an or-fashion.
  //!
  //! @param hints
  //!  mapping containing query hints.
  //!
  array(mapping|array) find(mapping query, array(mapping) orqueries, mapping|void hints)
  {
    mixed res;
    array borqueries;
    
//werror("find(%O, %O, %O)\n", query, orqueries, hints);
    if(orqueries)
    {
      borqueries = allocate(sizeof(orqueries));
      foreach(orqueries; int i; mapping q)
        borqueries[i] = Standards.BSON.encode(q, 1);  
    }
    int countonly;
    if(hints && hints["$onlycount"])
    {
//      hints = hints + ([]);
//      m_delete(hints, "$onlycount");
      countonly = 1;
    }
    res = low_find(Standards.BSON.encode(query, 1), borqueries, hints?Standards.BSON.encode(hints, 1):0, countonly);

    if(countonly)
      return res;

    foreach(res; int i; mixed e)
    {
      res[i] = Standards.BSON.decode(e);
    }
    return res;
  }
}
