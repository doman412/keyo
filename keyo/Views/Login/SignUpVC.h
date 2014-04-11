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


@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passField;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *signUpButton;

- (IBAction)onSignUp:(id)sender;
- (IBAction)onCancel:(id)sender;


@end
