<?php
// Programmers:  Carl Dell, Kevin Stewart, Justin Pachter
// Description:  PHP web service that verifies a user's login information with an online
//               database.


function sendResponse($status){
// PRE:  $status is either 200 or 400
// POST: Sets the HTTP response header for proper handling.
    $status_header = 'HTTP/1.1 ' . $status . ' ' . 
                      ($status == 200 ? 'OK' : 'Invalid Login');
    header($status_header);
    header('Content-type: ' . 'text/html');
}
    
class VerifyLogin{
    private $db;                 // connection between PHP and the MySQL database     
     
    function __construct(){
     // POST: Creates the connection between the script and the MySQL database, sets auto 
     // commit to false (not modifying data)
     
        $this->db = new mysqli('sql2.freesqldatabase.com',   // database host
                               'sql21443',                   // database username
                               'nA7*dI1!',                   // database password
                               'sql21443');                  // database name
        $this->db->autocommit(FALSE);
    }
    
    function verify(){
    // POST: Verifies login information
    
        // userName and password key/value pairs were passed to the script
        if(isset($_POST["userName"]) && isset($_POST["password"])){
        
            // Store userName and password from values that were posted through Xcode
            $userName = $_POST["userName"];
            $password = $_POST["password"];
           
            // Create and store SQL query in stmt that counts the number of rows where 
            // userName in the table matches $userName and password in the table matches 
            // $password (case-sensitive)
            $stmt = $this->db->prepare('SELECT count(*) count FROM users WHERE 
                                       userName=?' . ' AND BINARY password=?');
                                            
            // Replace '?' characters in SQL query with their proper variables
            $stmt->bind_param("ss", $userName, $password);
           
            // Executes the prepared query
            $stmt->execute();
            
            // Set $numRows to query result
            $stmt->bind_result($numRows);
            
            // Fetch results returned from stmt. Since the stmt should only return one
            // result, the loop only needs to be executed once.
            while ($stmt->fetch()) {
                break;
            }
        
            // Close the connection
            $stmt->close();
                
            // One valid login found, success
            if($numRows == 1){
                sendResponse(200);
                return true;
            }
            // Login not found
            else{
                sendResponse(400);
                return false;
            }               
        }
        // Invalid key/value pairs passed to the script
        else{
            sendResponse(400);
            return false;
        }
    }
}
 
// This is the first thing that gets called when this page is loaded
// Creates a new instance of the VerifyLogin class and calls the verify method
$api = new VerifyLogin;
$api->verify();
?>