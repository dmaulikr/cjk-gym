<?php
// Programmers: Carl Dell, Kevin Stewart, Justin Pachter
// Description: PHP web service that gets a user's count information from an online
//              database.


function sendResponse($status)
// PRE:  $status is either 200 or 400
// POST: Sets the HTTP response header for proper handling.
{
    $status_header = 'HTTP/1.1 ' . $status . ' ' . 
                     ($status == 200 ? 'OK' : 'Invalid Login');
    header($status_header);
    header('Content-type: ' . 'text/html');
}
 
class GetCount {
    private $db;                  // connection between PHP and the MySQL database
 
    function __construct(){
    // POST: Creates the connection between the script and the MySQL database, sets auto 
    // commit to false (not modifying data)
        $this->db = new mysqli('sql2.freesqldatabase.com',   // database host
                               'sql21443',                   // database username
                               'nA7*dI1!',                   // database password
                               'sql21443');                  // database name
        $this->db->autocommit(FALSE);
    }

    // Main method to retrieve login information
    function retrieve() {
    
        // userName and password key/value pairs were passed to the script
        if(isset($_POST["userName"])){
        
            // Store userName from the value that were posted through Xcode
            $userName = $_POST["userName"];
            
            // Create and store SQL query in stmt that gets the count value for user with
            // username = $userName
            $stmt = $this->db->prepare('SELECT count FROM users WHERE userName=?');
            
            // Replace '?' characters in SQL query with their proper variables
            $stmt->bind_param("s", $userName);
            
            // Executes the prepared query
            $stmt->execute();
            
            //Set $count to query result
            $stmt->bind_result($count);
            
            // Fetch results returned from stmt. Since the stmt should only return one
            // result, the loop only needs to be executed once.
            while ($stmt->fetch()) {
                break;
            }
            
            // Close the connection
            $stmt->close();
            
            // Adds the count to the HTTP response for proper parsing within the iOS app
            echo ("Count:$count:");
            
            // Success
            sendResponse(200);
            return true;
                
        }
        // Invalid key/value pairs passed to the script
        else{
                sendResponse(400);
                return false;
        }
    }
}
 
// This is the first thing that gets called when this page is loaded
// Creates a new instance of the GetCount class and calls the retrieve method
$api = new GetCount;
$api->retrieve();
 
?>