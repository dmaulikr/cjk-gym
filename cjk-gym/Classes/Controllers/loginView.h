// Programmers: Carl Dell, Kevin Stewart, Justin Pachter
// Description: Header file describing the loginView class. The loginView class
//				implements functions for use with the loginView.xib

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"


@interface loginView : UIViewController <UITextFieldDelegate> {
    
//No instance variables

}


@property (weak, nonatomic) IBOutlet UITextField *usernameField; //username text field 
@property (weak, nonatomic) IBOutlet UITextField *passwordField; //password text field

@property CGPoint originalCenter; 							 //Center of screen           

- (void)textFieldDidBeginEditing:(UITextField *)textField;	 //Text field gains focus

- (void)textFieldDidEndEditing:(UITextField *)textField;	 //Text field loses focus

-(IBAction)goToMain:(id)sender;								 //Go to main view

-(IBAction)switchRegister:(id)sender;						 //Go to register view

+(UIAlertView*)generateAlert:(NSString*)message;			 //Generate invalidAlert

- (IBAction)dismissKeyboard:(id)sender;					     //Hides keyboard from view

@end
