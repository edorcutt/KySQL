<?php

// ------------------------------------------------------------------------
// KySQL.php - KRL MySQL Module
//
// Ed Orcutt, LOBOSLLC
// ------------------------------------------------------------------------

error_reporting(0);

$THEKEY = "YOUR-KEY-HERE";
$dbhost = "localhost";
$rowcnt = 0;

// ========================================================================
// It all begins here

// --------------------------------------------
// Access key is required to proceed ...
if(!isset($_POST['kykey']) || $_POST['kykey'] != $THEKEY) {
  unauthorized();
  exit;
}

// --------------------------------------------
// soak in the passed variables or set our own

$dbuser = isset($_POST['dbuser']) ? $_POST['dbuser'] : "";
$dbpass = isset($_POST['dbpass']) ? $_POST['dbpass'] : "";
$dbname = isset($_POST['dbname']) ? $_POST['dbname'] : "";
$kquery = isset($_POST['kquery']) ? stripslashes($_POST['kquery']) : "";

// Make connection to database ...
$dblink = mysql_connect($dbhost,$dbuser,$dbpass);
if (!$dblink) {
  serviceUnavailable(mysql_error());
  exit;
};

// Select database to use ...
$dbselect = mysql_select_db($dbname,$dblink);
if (!$dbselect) {
  serviceUnavailable(mysql_error($dblink));
  exit;
};

// Query the database ...
$dbresult = mysql_query($kquery,$dblink);
if (!$dbresult) {
  serviceUnavailable(mysql_error($dblink));
  exit;
};

// INSERT, UPDATE, DELETE
if ( substr(strtoupper($kquery),0,6) == 'INSERT' ||
     substr(strtoupper($kquery),0,5) == 'UPDATE' ||
     substr(strtoupper($kquery),0,5) == 'DELETE') {
  exit;
};

// SELECT
if ( substr(strtoupper($kquery),0,6) == 'SELECT') {
  $rowcnt = mysql_num_rows($dbresult);
};

// create one master array of the records
$rows = array();
if(mysql_num_rows($dbresult)) {
  while($row = mysql_fetch_assoc($dbresult)) {
    $rows[] = $row;
  }
}

// output in JSON format
header('Content-type: application/json');
header('row-count: ' . $rowcnt);
echo json_encode(array('results'=>$rows));

// Close database connection ...
mysql_close($dblink);

// ========================================================================
// There are support routines

// --------------------------------------------
// Send a HTTP 401 response header.

function unauthorized() {
    header('HTTP/1.0 401 Unauthorized');
}

// --------------------------------------------
// Send a HTTP 503 response header.
function serviceUnavailable($msg) {
  header('HTTP/1.0 503 Service Unavailable');
  header('status-message: ' . $msg);
}

// ------------------------------------------------------------------------
// Beyond here there be dragons :)
// ------------------------------------------------------------------------
?>
