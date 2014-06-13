//
//  SignUpVC.m
//  keyo
//
//  Created by Derek Arner on 12/25/13.
//  Copyright (c) 2013 MakoWare. All rights reserved.
//

#import "SignUpVC.h"
#import "Theme.h"

@interface SignUpVC ()

@end

@implementation SignUpVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [Theme backgroundBlue];
    
    self.titleLabel.textColor = [Theme wellWhite];
    
    [self.signUpButton setTitleColor:[Theme wellWhite] forState:UIControlStateNormal];
    self.signUpButton.backgroundColor = [Theme lightBlue];
    self.signUpButton.layer.cornerRadius = 3.0;
    
    [self.cancelButton setTitleColor:[Theme wellWhite] forState:UIControlStateNormal];
    self.cancelButton.backgroundColor = [Theme lightBlue];
    self.cancelButton.layer.cornerRadius = 3.0;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSignUp:(id)sender {
    
    if([self validateEmail:self.emailField.text]){
        
        if(self.usernameField.text && ![self.usernameField.text isEqualToString:@""]){
            
            if(self.passField.text && ![self.passField.text isEqualToString:@""]){
                
                PFUser *u = nil;
                
                if ([PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
                    u = [PFUser currentUser];
                } else {
                    u = [PFUser user];
                }
                
                u.username = self.usernameField.text;
                u.password = self.passField.text;
                u.email = self.emailField.text;
                
                [u signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if(!error){
                        [self dismissViewControllerAnimated:YES completion:nil];
                    } else {
                        NSLog(@"err signing up");
                        [[[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Sorry, an error occured while attempting to sign up." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                    }
                }];
                
            } else {
                [[[UIAlertView alloc] initWithTitle:@"No Password" message:@"Please enter a password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            }
            
        } else {
            [[[UIAlertView alloc] initWithTitle:@"No Username" message:@"Please enter a username." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
        
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Bad Email" message:@"Please enter a valid formed email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField==self.usernameField){
        [self.emailField becomeFirstResponder];
    } else if(textField==self.emailField){
        [self.passField becomeFirstResponder];
    } else if(textField==self.passField){
        [textField resignFirstResponder];
        [self onSignUp:nil];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}


@end
