// Programmers: Carl Dell, Kevin Stewart, Justin Pachter
// Description: Header file describing the mainView class. The mainView class is used to 
//              add functionality to mainView.xib

#import <UIKit/UIKit.h>
#import "loginView.h"
#import "constants.h"

@interface mainView : UIViewController {
}

@property NSString *user;                                   // Currently logged in user

@property (weak, nonatomic) IBOutlet UILabel *welcome;      // Welcome text
@property (weak, nonatomic) IBOutlet UILabel *count;        // Current count
@property (weak, nonatomic) IBOutlet UIStepper *upDown;     // Stepper

-(IBAction) goToLogin:(id)sender;                           // Go to login view
-(IBAction) changeUpDown:(id)sender;                        // Adjust value of stepper

@end