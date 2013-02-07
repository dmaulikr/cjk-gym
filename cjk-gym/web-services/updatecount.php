<?php
// Programmers: Carl Dell, Kevin Stewart, Justin Pachter
// Description: PHP web service that updates a user's count information on an online
//              database.

    
function sendResponse($status){
// PRE:  $status is either 200 or 400
// POST: Sets the HTTP response header for proper handling.
    $status_header = 'HTTP/1.1 ' . $status . ' ' . 
                     ($status == 200 ? 'OK' : 'Invalid Login');
    header($status_header);
    header('Content-type: ' . 'text/html');
}
    
class UpdateCount {
    private $db;               // connection between PHP and the MySQL database
 
    function __construct(){
    // POST: Creates the connection between the script and the MySQL database, sets auto 
    // commit to true (modifying data)
        $this->db = new mysqli('sql2.freesqldatabase.com',   // database host
                               'sql21443',                   // database username
                               'nA7*dI1!',                   // database password
                               'sql21443');                  // database name
        $this->db->autocommit(TRUE);
    }
    
    function updCount(){
    // POST: Updates the count field of a user
    
        // userName and password key/value pairs were passed to the script
        if(isset($_POST["userName"]) && isset($_POST["count"])){
         
            // Store userName and count from the values that were posted through Xcode
            $userName = $_POST["userName"];
            $count = $_POST["count"];
            
            // Create and store SQL query in stmt that updates the count value for any
            // user with username = $userName
            $stmt = $this->db->prepare('UPDATE users SET count=? WHERE userName=?');
            
            // Replace '?' characters in SQL query with their proper variables
            $stmt->bind_param('is', $count, $userName);
            
            // Executes the prepared query
            $stmt->execute();            
            
            // Close the connection
            $stmt->close();
            
            //Success
            sendResponse(200);
            return false;
        }
        // Invalid key/value pairs passed to the script
        else{
            sendResponse(400);
            return false;
        }
    }
}
 
// This is the first thing that gets called when this page is loaded
// Creates a new instance of the UpdateCount class and calls the updCount method
$api = new UpdateCount;
$api->updCount();
 
?>