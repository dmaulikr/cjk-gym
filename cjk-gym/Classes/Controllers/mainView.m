// Programmers: Carl Dell, Kevin Stewart, Justin Pachter
// Description: Implemenation of the mainView class. The mainView class is used to 
//              add functionality to mainView.xib

#import "mainView.h"

@implementation mainView

@synthesize welcome;
@synthesize user;
@synthesize upDown;
@synthesize count;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
// Built in constructor
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
// POST: Adds event listener for 'didEnterBackground' and set welcome text
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(updateCount)
                                                 name: @"didEnterBackground"
                                               object: nil];
    
    // Set count from database for current user
    [self getCount];
    
    // Set the welcome text
    [welcome setText:[NSString stringWithFormat:@"Welcome, %@", user]];
}

- (void)getCount {
// POST: Gets the count from the database and stores the value in upDown and count
    NSURL *url;                 // URL used to communicate with web service
    NSString* responseString;   // String returned from web service
    UIAlertView* invalidAlert;  // Alert to show if there was an error
    ASIFormDataRequest *request;// Object used for web service communication
    
    // Build URL to communicate with web service
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",
                                hostURL, getCountScript]];
    
    // Build request to run using URL
    request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:user forKey:userName];
    [request setDelegate:self];
    
    // Start request
    [request startSynchronous];
    
    // Store response string
    responseString = [request responseString];
    
    if(request.responseStatusCode == 200){   // username and password are correct
        upDown.value = [self getCountValue:responseString];
        [count setText: [NSString stringWithFormat:@"%d", (int)upDown.value ]];
    } else {                                 // username or password are incorrect
        // initialize alert
        invalidAlert = [loginView generateAlert:@"Error retrieving count"];
        
        // show alert
        [invalidAlert show];
    }
}

-(NSInteger)getCountValue:(NSString *)response {
// PRE:  response is initialized and contains web service response
// POST: Parses the value of count out of response and returns the result
    NSString *cValue;           // Value of count
    NSRange range;              // Range to use for taking the substring of cValue
    
    
    // Get value of count starting at the first colon
    cValue = [[response componentsSeparatedByString:@"Count:"] lastObject];
    
    // Find the ending colon
    range = [cValue rangeOfString:@":"];
    
    // Take a substring from the beginning of cValue to range
    cValue= [cValue substringToIndex:range.location];
    
    return [cValue intValue];
}

- (void)didReceiveMemoryWarning
// Built in didReceiveMemoryWarning function
{
    [super didReceiveMemoryWarning];
}

// Return to login if user chooses to log out
-(IBAction) goToLogin:(id)sender {
// PRE:  sender is initialized
// POST: Switches the current view to loginView.xib
    [self updateCount];
    
    loginView *login;           // Instance of loginView
    
    // Create new instance of loginView
    login = [[loginView alloc] initWithNibName: nil bundle:nil];
    
    // Set transition view
    login.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    // Switch view controller to login
    [self presentViewController:login animated:YES completion:nil];
}

-(void) updateCount {
// POST: Updates the count stored in the database through a web service
    NSString *countString;      // Value of upDown
    NSURL *url;                 // URL of web service to communicate with
    ASIFormDataRequest *request;// Object used for web service communication
    UIAlertView* invalidAlert;  // Alert to show if there was an error
    
    // Convert stepper counter to string
    countString = [NSString stringWithFormat:@"%d", (int)upDown.value];
    
    // Build URL of update count PHP script
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",
                                hostURL, updateCountScript]];
    
    // Build request to run using URL
    request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:user forKey:userName];
    [request setPostValue:countString forKey:@"count"];
    [request setDelegate:self];
    
    // Start request
    [request startSynchronous];
    
    // Throw alert if request is unsuccessful
    if(request.responseStatusCode != 200){
        invalidAlert = [loginView generateAlert:@"Error retrieving count"];
        
        [invalidAlert show];
    }
    
}

//Stepper
-(IBAction) changeUpDown:(id)sender{
// PRE:  sender is initialized
// POST: updates the text in count to the value of upDown
    [count setText:[NSString stringWithFormat:@"%d", (int)upDown.value]];
}

@end