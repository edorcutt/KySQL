ruleset a169x380 {
  meta {
    name "Hello-KySQL"
    description <<
      Hello World for KySQL Module
    >>

    author "Ed Orcutt, LOBOSLLC"
    logging on

    use module a169x379 alias KySQL
        with apikey   = "YOUR-KEY-HERE"
        and  callback = "http://example.org/KySQL.php"
        and  username = "database-username"
        and  password = "database-password"
        and  database = "database-name"
  }

  dispatch { }

  global {  }

  // ------------------------------------------------------------------------
  rule hello_KySQL {
    select when pageview ".*"
    pre {
      KyObject = KySQL:KyQuery("SELECT * FROM addressbook");
      KyJSON   = KySQL:KyResult(KyObject);
      status   = KySQL:KyStatus(KyObject);
      errorMsg = KySQL:KyError(KyObject);

      myHash = {
        "name"  : "Ed Orcutt",
        "email" : "edo@example.org",
        "phone" : "(801) 555-1234"
      };
      kyInsert = KySQL:KyInsertString("addressbook", myHash);
    }
    {
      notify("KyStatus: " + status, errorMsg) with sticky = true;
    }
  }

  // ------------------------------------------------------------------------
  // Beyond here there be dragons :)
  // ------------------------------------------------------------------------
}