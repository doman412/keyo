//
//  LoginVC.m
//  keyo
//
//  Created by Derek Arner on 12/25/13.
//  Copyright (c) 2013 MakoWare. All rights reserved.
//

#import "LoginVC.h"
#import "Theme.h"


@interface LoginVC ()

@end

@implementation LoginVC

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
    [self.loginButton setTitleColor:[Theme wellWhite] forState:UIControlStateNormal];
    
    self.signUpButton.backgroundColor = [Theme lightBlue];
    self.signUpButton.layer.cornerRadius = 3.0;
    
    self.loginButton.backgroundColor = [Theme lightBlue];
    self.loginButton.layer.cornerRadius = 3.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSignUp:(id)sender {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpVC"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)onLogin:(id)sender {
    [PFUser logInWithUsernameInBackground:self.emailField.text password:self.passField.text target:self selector:@selector(onLoginReturn:error:)];
}

- (IBAction)onGuest:(id)sender {
    [PFAnonymousUtils logInWithTarget:self selector:@selector(onLoginReturn:error:)];
}

- (void)onLoginReturn:(PFUser *)user error:(NSError *)error
{
    if(error){
        NSLog(@"onLoginReturn: %li, err(%@)",(long)error.code, error);
        UIAlertView *a;
        switch(error.code){
            case 101:
                a = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Wrong username or password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                break;
            case 100:
                [[[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"There was an issue connecting. Please make sure you have an internet connection established." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                break;
        }
        [a show];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    NSLog(@"textFieldShouldReturn (%p)",textField);
    if(textField == self.emailField){
        [self.passField becomeFirstResponder];
    } else if(textField == self.passField){
        [textField resignFirstResponder];
        [self onLogin:nil];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

@end
