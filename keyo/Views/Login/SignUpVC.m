//
//  SignUpVC.m
//  keyo
//
//  Created by Derek Arner on 12/25/13.
//  Copyright (c) 2013 MakoWare. All rights reserved.
//

#import "SignUpVC.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSignUp:(id)sender {
    
    if([self.emailField.text isEqualToString:self.confirmEmail.text]){
    
        PFUser *u = [PFUser user];
    
        u.username = self.emailField.text;
        u.password = self.passField.text;
        u.email = self.emailField.text;
        
        [u signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(!error){
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                NSLog(@"err signing up");
            }
        }];
    } else {
        NSLog(@"emails dont match");
    }
}

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField==self.emailField){
        [self.confirmEmail becomeFirstResponder];
    } else if(textField==self.confirmEmail){
        [self.passField becomeFirstResponder];
    } else if(textField==self.passField){
        [textField resignFirstResponder];
        [self onSignUp:nil];
    }
    
    return YES;
}

@end
