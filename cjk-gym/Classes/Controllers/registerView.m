// Programmers: Carl Dell, Kevin Stewart, Justin Pachter
// Description: Implementation of the registerView class. The registerView class is
//              used to handle functionality for registerView.xib

#import "registerView.h"

@implementation registerView

@synthesize usernameField;
@synthesize passwordField;
@synthesize emailField;
@synthesize confirmPassword;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
// Built in constructor
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
// POST: Sets passwordField and confirmPasswordField to use secure text entry
    [super viewDidLoad];
    passwordField.secureTextEntry = TRUE;
    confirmPassword.secureTextEntry = TRUE;

    success = false;
}

- (void)didReceiveMemoryWarning {
// Built in didReceiveMemoryWarning function
    [super didReceiveMemoryWarning];
}


- (IBAction)registerClicked:(id)sender {
// PRE:  sender is initialized
// POST: Sends the data from the registration form to a web service to register the user.
//       If the form data is not valid or if there was an error communicating with the web
//       serviece, an alert is shown.
    UIAlertView *invalidAlert;          // Alert to show if an error occured
    NSString *password;                 // String from password field
    NSString *confirm;                  // String from confirm password field
    NSInteger status;                   // Status code returned from web service
    
    // Store password and confirm password
    password = passwordField.text;
    confirm = confirmPassword.text;
    
    if (![password isEqualToString:confirm]) {  // password and confirm are not equal
        invalidAlert = [loginView generateAlert:@"Passwords don't match"];
    } else if([self validateEmail:emailField.text]){    // email is valid

        // Attempt to register a new account
        status = [self doRegister];
        
        if (status == 200) {            // No problems, registered successfully
            success = true;
            invalidAlert = [loginView generateAlert:@"Registration Complete"];
            [self goToLogin:nil];
        } else if (status == 201) {     // Desired username is taken
            invalidAlert = [loginView generateAlert:@"Username already exists"];
        } else if (status == 202) {     // Desired email is taken
            invalidAlert = [loginView generateAlert:@"Email already exists"];
        } else {                        // Desired username and email are taken
            invalidAlert = [loginView generateAlert:@"Username and Email already exist"];
        }  
    } else {
        invalidAlert = [loginView generateAlert:@"Not a valid email address"];
    }
    
    [invalidAlert show];
}

- (NSInteger)doRegister {
// POST: Attempt to call a register web service to register the user with the database
    NSURL *url;                         // URL of web service
    NSString *newUser;                  // username of new user
    NSString *newEmail;                 // email of new user
    NSString *newPassword;              // password of new user
    ASIFormDataRequest *request;        // Object used for web service communication
    UIAlertView* invalidAlert;          // Alert to show if an error occured
    
    // Build URL to communicate with Webserver
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",
                                hostURL, registerScript]];
    
    // Pull information from the textboxes
    newUser = usernameField.text;
    newEmail = emailField.text;
    newPassword = passwordField.text;
    
    // Build request to send to PHP script
    request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:newUser forKey:@"userName"];
    [request setPostValue:newEmail forKey:@"email"];
    [request setPostValue:newPassword forKey:@"password"];
    [request setDelegate:self];
    
    // Start request
    [request startSynchronous];
    
    if(request.responseStatusCode != 400) {  
        // no error occured, registration was successful
        return request.responseStatusCode;  
    } else {
        // Error occured while registering
        invalidAlert = [loginView generateAlert:@"Error registering new user"];
            
        [invalidAlert show];
        return -1;
    }
}

- (bool)validateEmail:(NSString*)e
// PRE:  e is initialized
// POST: Returns true if e is a valid email and false if e is an invalid email
{
    NSCharacterSet* set;            // Set of valid characters
    
    // generate valid email character set
    set = [[NSCharacterSet characterSetWithCharactersInString:@"@.abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789"] invertedSet];
    
    // must contain an @ sign
    if ([e rangeOfString:@"@"].location == NSNotFound)
        return false;
    
    // must contain a .
    if ([e rangeOfString:@"."].location == NSNotFound)
        return false;
    
    // make sure all characters are valid
    return ([e rangeOfCharacterFromSet:set].location == NSNotFound);
}        
         
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
// PRE:  alertView is initialized
// POST: Calls goToLogin() if success = true
    if (success){
        [self goToLogin:nil];
    }
}

- (IBAction)dismissKeyboard:(id)sender {
// PRE:  sender is initialized
// POST: hides the keyboard and removes focus from usernameField and passwordField
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    [emailField resignFirstResponder];
    [confirmPassword resignFirstResponder];
}

-(IBAction) goToLogin:(id)sender {
// PRE:  sender is initialzed
// POST: Changes views to loginView.xib
    loginView *login;               // Instance of loginView
    
    // Initialize login
    login = [[loginView alloc] initWithNibName: nil bundle:nil];
    login.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    // Switch views
    [self presentViewController:login animated:YES completion:nil];
}

@end