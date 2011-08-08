ruleset a169x379 {
  meta {
    name "KySQL"
    description <<
      KySQL - KRL MySQL Module
    >>

    author "Ed Orcutt, LOBOSLLC"
    logging on

    provides KyQuery, KyResult, KyStatus, KyError, KyInsertString
    configure using apikey   = ""
              and   callback = ""
              and   username = ""
              and   password = ""
              and   database = ""
  }

  dispatch { }

  global {
    KyKey  = apikey   || "YOUR-TEST-KEY-HERE";
    KyURL  = callback || "http://example.org/KySQL.php";
    dbUser = username || "test-database-username";
    dbPass = password || "test-database-password";
    dbName = database || "test-database-name";

    // --------------------------------------------
    // build the options hash for making a POST

    postOptions = function(queryStr) {
      {
       "params":  {
                   "kykey"  : "#{KyKey}",
                   "dbuser" : "#{dbUser}",
                   "dbpass" : "#{dbPass}",
                   "dbname" : "#{dbName}",
                   "kquery" : "#{queryStr}"
                   },
       "response_headers": ["status-message"]
      }
    };

    // --------------------------------------------
    // send MySQL query to remote service

    KyQuery = function(queryStr) {
      opts = postOptions(queryStr);
      http:post("#{KyURL}", opts)
    };

    // --------------------------------------------
    KyResult = function(KyObject) {
      KyObject.pick("$.content").decode();
    };

    // --------------------------------------------
    KyStatus = function(KyObject) {
      KyObject.pick("$.status_code");
    };

    // --------------------------------------------
    KyError = function(KyObject) {
      KyObject.pick("$.status-message");
    };

    // --------------------------------------------
    KyInsertString = function(KyTable, KyRow) {
      // array of database table column names, sorted
      colNameArray  = KyRow.keys().sort();
      // join into single string, with each column name within single quotes
      colNameString = (colNameArray.map(function(x) {"'#{x}'"})).join(",");

      // extract array of database table column values
      valuesArray   = colNameArray.map(function(x) {KyRow.pick("$..#{x}")});
      // join into single string, with each value within single quotes
      valuesString  = (valuesArray.map(function(x) {"'#{x}'"})).join(",");

      "INSERT INTO #{KyTable} (#{colNameString}) VALUES (#{valuesString})"
    };
  }

  // ------------------------------------------------------------------------
  rule test_query is inactive {
    select when pageview ".*"
    pre {
      KyObject = KyQuery("SELECT * FROM neubook");
      KyJSON   = KyResult(KyObject);
      status   = KyStatus(KyObject);
      errorMsg = KyError(KyObject);

      myHash = {
        "name"  : "Ed Orcutt",
        "email" : "edo@example.org",
        "phone" : "(801) 555-1234"
      };
      kyInsert = KyInsertString("neubook", myHash);
    }
    {
      notify("KyStatus: " + status, errorMsg) with sticky = true;
    }
  }

  // ------------------------------------------------------------------------
  // Beyond here there be dragons :)
  // ------------------------------------------------------------------------
}