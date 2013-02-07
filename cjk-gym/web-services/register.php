<?php
// Programmers: Carl Dell, Kevin Stewart, Justin Pachter
// Description: PHP web service that registers (adds) a new user to the database, and
//              verifies that this new user is unique.

function sendResponse($status){
// PRE:  $status is either 200 or 400
// POST: Sets the HTTP response header for proper handling.
    $status_header = 'HTTP/1.1 ' . $status . ' ' . 
                     ($status == 200 ? 'OK' : 'Invalid Login');
    header($status_header);
    header('Content-type: ' . 'text/html');
}
 
class DoRegister {
    private $db;                // connection between PHP and the MySQL database
 
    function __construct(){
    // POST: Creates the connection between the script and the MySQL database, sets auto 
    // commit to true (modifying data)
        $this->db = new mysqli('sql2.freesqldatabase.com',   // database host
                               'sql21443',                   // database username
                               'nA7*dI1!',                   // database password
                               'sql21443');                  // database name
        $this->db->autocommit(TRUE);
    }

    function register() {
    // POST: Registers a user in the database
    
        // userName, password, and email key/value pairs were passed to the script
        if(isset($_POST["userName"]) && isset($_POST["email"]) && 
           isset($_POST["password"])){
            //----------------------------------------------------------------------------
            // Check for duplicate username
            //----------------------------------------------------------------------------
           
            // Store userName, email, and password from the values that were posted
            // through Xcode. Also stores count as 0 for a new user
            $userName = $_POST["userName"];
            $email = $_POST["email"];
            $password = $_POST["password"];
            $count = 0;
        
            // Create and store SQL query in stmt that counts the number of rows where 
            // userName in the table matches $userName
            $stmt = $this->db->prepare('SELECT count(*) count FROM users WHERE 
                                       userName=?');
           
            // Replace '?' characters in SQL query with their proper variables
            $stmt->bind_param("s", $userName);
            
            // Executes the prepared query
            $stmt->execute();
            
            // Set $userExists to query result
            $stmt->bind_result($userExists);
           
            // Fetch results returned from stmt. Since the stmt should only return one
            // result, the loop only needs to be executed once.  
            while ($stmt->fetch()) {
                break;
            }
       
            // Close the connection
            $stmt->close();
           
            //----------------------------------------------------------------------------
            // Check for duplicate email
            //----------------------------------------------------------------------------
            
            // Create and store SQL query in stmt that counts the number of rows where 
            // email in the table matches $email
            $stmt = $this->db->prepare('SELECT count(*) count FROM users WHERE email=?');
            $stmt->bind_param("s", $email);
            $stmt->execute();
            
            //Set $emailExists to query result
            $stmt->bind_result($emailExists);
            while ($stmt->fetch()) {
                break;
            }
            
            $stmt->close();
                
            // both username and email exists already
            if($userExists > 0 && $emailExists > 0){
                sendResponse(203); // throw error
                return true;
            }
            // email exists already
            if($emailExists > 0){
                sendResponse(202); // throw error
                return true;
            }
            // user exists already
            if($userExists > 0){
                sendResponse(201); // throw error
                return true;
            }
            //----------------------------------------------------------------------------
            // If no conflicts, add new user to the database
            //----------------------------------------------------------------------------
            
            // Create and store SQL query in stmt that creates a new entry in the table
            // with userName, email, and password set to $userName, $email, and $password
            $stmt = $this->db->prepare("INSERT INTO users (userName, email, password) 
                                        VALUES (?,?,?)");
            $stmt->bind_param("sss", $userName, $email, $password);
            $stmt->execute();
            $stmt->close();
            
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
// Creates a new instance of the DoRegister class and calls the register method
$api = new DoRegister;
$api->register();
 
?>