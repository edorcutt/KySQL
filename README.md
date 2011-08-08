KySQL - Kynetx MySQL Module
===========================

The KySQL module provides a MySQL query function `KyQuery()` function to remote database servers within a Kynetx Ruleset. In addtion there are a couple of helper functions to retrieve the query results in JSON format, access request status and simpilify the process of writing database insert statements.

Functions
---------

### KySQL:KyQuery();

To submit a query, use the following function:

    KySQL:KyQuery('YOUR QUERY HERE');

The `KyQuery()` function returns a database result object when "read" type queries are run, which you can use to show your results. When "write" type queries are run it simply returns TRUE or FALSE depending on success or failure. When retrieving data you will typically assign the query to your own variable, like this:

    KyObject = KySQL:KyQuery('YOUR QUERY HERE');

### KySQL:KyResult();

This function returns the query result as a JSON object:

    KyJSON = KySQL:KyResult(KyObject);

For example:

    KyObject = KySQL:KyQuery('SELECT * FROM addressbook');
    KyJSON = KySQL:KyResult(KyObject);

Returns the following JSON object:

    {
        'results': [
            {
                'uid': 1,
                'name': 'Ed Orcutt'
                'email': 'edo@foo.org',
            },
            {
                'uid': 2,
                'name': 'LauraOrcutt'
                'email': 'laura@example.org',
            }
        ]
    }

### KySQL:KyStatus();

This function returns the status code from the query:

    Status = KySQL:KyStatus(KyObject);

200
401 Unauthorized
503 Service Unavailable

### KySQL:KyError();

This function returns the MySQL error message when a status code of 503 is returned by the query:

    Message = KySQL:KyError(KyObject);

Here is a sample error message would be of the following form:

    Access denied for user 'foobar'@'localhost'(using password:YES)

### KySQL:KyInsertString();

This function simplifies the process of writing database inserts. It returns a corretly formatted SQL insert string. Example:

    kyData = {
      "name"  : "Ed Orcutt",
      "email" : "edo@example.org",
      "phone" : "(801) 555-1234"
    };
    
    kyInsert = KyInsertString("addressbook", kyData);

The first parameter is the table name, the second is a hash with the to be inserted. The above example produces:

    INSERT INTO neubook ('email','name','phone') VALUES ('edo@example.org','Ed Orcutt','(801) 555-1234')
