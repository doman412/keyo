//
//  LoginVC.h
//  keyo
//
//  Created by Derek Arner on 12/25/13.
//  Copyright (c) 2013 MakoWare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LoginVC : UIViewController<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passField;



- (IBAction)onSignUp:(id)sender;
- (IBAction)onLogin:(id)sender;
- (IBAction)onGuest:(id)sender;


- (void)onLoginReturn:(PFUser *)user error:(NSError *)error;

@end
