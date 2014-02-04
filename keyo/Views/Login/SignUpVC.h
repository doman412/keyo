//
//  SignUpVC.h
//  keyo
//
//  Created by Derek Arner on 12/25/13.
//  Copyright (c) 2013 MakoWare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SignUpVC : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *confirmEmail;
@property (weak, nonatomic) IBOutlet UITextField *passField;

- (IBAction)onSignUp:(id)sender;
- (IBAction)onCancel:(id)sender;


@end
