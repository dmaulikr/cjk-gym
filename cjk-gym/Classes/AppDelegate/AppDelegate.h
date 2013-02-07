// Programmers: Carl Dell, Kevin Stewart, Justin Pachter
// Description: Header file of AppDelegate class used for state transitions when
//              views are switched

#import <UIKit/UIKit.h>

@class loginView;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) loginView *viewController;

@end
