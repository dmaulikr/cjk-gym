// Programmers: Carl Dell, Kevin Stewart, Justin Pachter
// Description: Set of constants used for web service communication

#import "constants.h"

@implementation constants

NSString* const hostURL = @"http://www.cjkgym.site11.com/"; // URL of web service host

// Name of PHP web service. These strings will be appended to hostURL to generate the URL
// of the desired web service
NSString* const getCountScript = @"getcount.php";           // name of getcount script
NSString* const updateCountScript = @"updatecount.php";     // name of updatecount script
NSString* const verifyLoginScript = @"verifylogin.php";     // name of verifylogin script
NSString* const registerScript = @"register.php";           // name of register script

// Field names used for the query string sent to a web service
NSString* const userName = @"userName";                     // username field name
NSString* const count = @"count";                           // count field name
NSString* const email = @"email";                           // email field name
NSString* const password = @"password";                     // password field name

@end