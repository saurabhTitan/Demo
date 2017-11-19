//
//  OTOSignInVC.m
//  1To1Rating
//
//  Created by Saurabh Vaza on 19/08/17.
//  Copyright © 2017 Saurabh. All rights reserved.
//

#import "OTOSignInVC.h"

//#import "OTOGeneralSharedManager.h"

@interface OTOSignInVC ()
{
    __weak IBOutlet UILabel *lblSignIn;
    
    __weak IBOutlet UITextField *txtEmail;
    __weak IBOutlet UITextField *txtPassword;
    __weak IBOutlet UIButton *btnForgotPassword;
    __weak IBOutlet UIButton *btnSignIn;
    __weak IBOutlet UIButton *btnCreateNew;
}
@end

@implementation OTOSignInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -----------
#pragma mark 

- (IBAction)btnForgotPasswordClicked:(id)sender {
}
- (IBAction)btnSignInClicked:(id)sender {
    
    if ([txtEmail.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
        [[OTOGeneralSharedManager sharedManager] alertWithTitle:kMsgTitle Message:kMsgEmailRequired controller:self];
    }
    else if (![[OTOGeneralSharedManager sharedManager] validateEmailWithString:txtEmail.text]) {
        [[OTOGeneralSharedManager sharedManager] alertWithTitle:kMsgTitle Message:kMsgValidEmail controller:self];
    }
    else if ([txtPassword.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
        [[OTOGeneralSharedManager sharedManager] alertWithTitle:kMsgTitle Message:kMsgPasswordRequired controller:self];
    }
    else{
        [self callWSToLogin];
    }
    
}
- (IBAction)btnCreateNewClicked:(id)sender {
}

#pragma mark -----------
#pragma mark Webservice Methods

- (void)callWSToLogin{
    @try {
        [[OTOGeneralSharedManager sharedManager] startActivity:self.view];
        if ([[OTOGeneralSharedManager sharedManager] checkIfInternetIsAvailable:self]) {
            
            NSMutableDictionary *aMutDictParam = [NSMutableDictionary dictionary];
            
            [aMutDictParam setObject:txtEmail.text forKey:@"email"];
            [aMutDictParam setObject:txtPassword.text forKey:@"password"];
            //        [aMutDictParam setObject:txtEmail.text forKey:@"de vice_id"];
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:kUDDeviceToken]) {
                [aMutDictParam setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kUDDeviceToken] forKey:@"device_id"];
            }else{
                [aMutDictParam setObject:kDeviceToken forKey:@"device_id"];
            }
            
            [aMutDictParam setObject:@"iphone" forKey:@"device_type"];

            
            [[OTOSharedWebService sharedManager] apiCallWithUrl:kAPIPathLogin method:kMethodPost parameter:aMutDictParam completionHandler:^(NSURLResponse * _Nullable response, id  _Nullable responseObject, NSError * _Nullable error) {
                
                @try {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[OTOGeneralSharedManager sharedManager] stopActivity:self.view];
                    });
                    
                    if (error) {
                        [[OTOGeneralSharedManager sharedManager] alertWithTitle:kMsgTitle Message:kMsgGeneral controller:self];
                    } else {
                        NSMutableDictionary *aMutDictResponse = responseObject;
                        
                        if (aMutDictResponse && [[aMutDictResponse objectForKey:@"success"] boolValue] == TRUE) {
                            [[NSUserDefaults standardUserDefaults] setObject:txtEmail.text forKey:kUDKeyUserName];
                            [[NSUserDefaults standardUserDefaults] setObject:txtPassword.text forKey:kUDKeyPassword];
                            
                            NSData *aDt = [NSKeyedArchiver archivedDataWithRootObject:[aMutDictResponse objectForKey:@"data"]];
                            [[NSUserDefaults standardUserDefaults] setObject:aDt forKey:kUDKeyUserData];
                            [[NSUserDefaults standardUserDefaults] setObject:[[aMutDictResponse objectForKey:@"data"] objectForKey:@"user_id"] forKey:kUDKeyUserId];
                            
                            if ([[aMutDictResponse objectForKey:@"data"] objectForKey:@"username"] && [[[aMutDictResponse objectForKey:@"data"] objectForKey:@"username"] length] > 0){
                                [[NSUserDefaults standardUserDefaults] setObject:[[aMutDictResponse objectForKey:@"data"] objectForKey:@"username"] forKey:kUDUserName];
                            }
                            
                            NSString *aStrUserName = [[aMutDictResponse objectForKey:@"data"] objectForKey:@"invitee_user_name"];

                            if (aStrUserName && ![aStrUserName isKindOfClass:[NSNull class]] && aStrUserName != NULL && [aStrUserName length] > 0) {
                                [[NSUserDefaults standardUserDefaults] setObject:[[aMutDictResponse objectForKey:@"data"] objectForKey:@"invitee_user_name"] forKey:kUDInviteUserName];
                            }
                           
                            
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            [self setUpLoing:aMutDictResponse];
                            
                        }else{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[OTOGeneralSharedManager sharedManager] alertWithTitle:kMsgTitle Message:[aMutDictResponse objectForKey:@"msg"] controller:self];
                            });
                        }
                    }
                } @catch (NSException *exception) {
                    NSLog(@"Class:: %s Exception :: %@",__func__,exception.description);
                } @finally {
                    
                }
                
            }];
        }else{
            [[OTOGeneralSharedManager sharedManager] stopActivity:self.view];
        }
    } @catch (NSException *exception) {
        NSLog(@"%s : %@",__FUNCTION__,exception.description);
    } @finally {
        
    }
}

- (void)setUpLoing:(NSMutableDictionary *)aMutDictResponse{
    
    if (!aMutDictResponse) {
        NSData *aDt = [[NSUserDefaults standardUserDefaults] objectForKey:kUDKeyUserData];
        
        aMutDictResponse = [NSMutableDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:aDt]];
    }
    
    [self callWSToSetDeviceToken];
}


- (void)callWSToSetDeviceToken{
    @try {
        if ([[OTOGeneralSharedManager sharedManager] checkIfInternetIsAvailable:self]) {
            
            NSMutableDictionary *aMutDictParam = [NSMutableDictionary dictionary];
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:kUDKeyUserId]) {
                [aMutDictParam setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kUDKeyUserId] forKey:@"user_id"];
            }else{
                [aMutDictParam setObject:@"11" forKey:@"user_id"];
            }
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:kUDDeviceToken]) {
                [aMutDictParam setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kUDDeviceToken] forKey:@"device_id"];
            }else{
                [aMutDictParam setObject:kDeviceToken forKey:@"device_id"];
            }
            
            [aMutDictParam setObject:@"iphone" forKey:@"device_type"];
            
            [[OTOSharedWebService sharedManager] apiCallWithUrl:kAPIPathDeviceToken method:kMethodPost parameter:aMutDictParam completionHandler:^(NSURLResponse * _Nullable response, id  _Nullable responseObject, NSError * _Nullable error) {
                
                @try {
                    if (error) {
                        [[OTOGeneralSharedManager sharedManager] alertWithTitle:kMsgTitle Message:kMsgGeneral controller:self];
                    } else {
                        NSMutableDictionary *aMutDictResponse = responseObject;
                        
                        if (aMutDictResponse && [[aMutDictResponse objectForKey:@"success"] boolValue] == TRUE) {
//                            if ([[NSUserDefaults standardUserDefaults] objectForKey:kUDDeviceToken]) {
//                                [[OTOGeneralSharedManager sharedManager] alertWithTitle:@"Token" Message:[[NSUserDefaults standardUserDefaults] objectForKey:kUDDeviceToken] controller:self];
//                            }
                        }else{
                            
                        }
                    }
                } @catch (NSException *exception) {
                    NSLog(@"Class:: %s Exception :: %@",__func__,exception.description);
                } @finally {
                    
                }
                
            }];
        }else{
        }
    } @catch (NSException *exception) {
        NSLog(@"%s : %@",__FUNCTION__,exception.description);
    } @finally {
        
    }
}

#pragma mark -----------
#pragma mark UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
