// Programmers: Carl Dell, Kevin Stewart, Justin Pachter
// Description: Header file describing the registerView class. The registerView class is
//              used to handle functionality for registerView.xib

#import <UIKit/UIKit.h>
#import "loginView.h"
#import "constants.h"

@interface registerView : UIViewController<UIAlertViewDelegate> {
    bool success;                       // Indicates if registration was successful
}

@property NSString *userName;
@property NSString *password;
@property NSString *email;
@property NSString *confirm;

@property (weak, nonatomic) IBOutlet UITextField *usernameField;    // username text field
@property (weak, nonatomic) IBOutlet UITextField *passwordField;    // password text field
@property (weak, nonatomic) IBOutlet UITextField *emailField;       // email text field
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;  // confirm text field

- (NSInteger) doRegister;
- (bool) validateEmail:(NSString*)e;
- (void) requestFinished:(ASIHTTPRequest *)request;
- (IBAction) registerClicked:(id)sender;
- (IBAction) goToLogin:(id)sender ;
- (IBAction) dismissKeyboard:(id)sender;

@end
