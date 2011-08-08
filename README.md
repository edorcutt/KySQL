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

