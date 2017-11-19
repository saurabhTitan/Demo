//
//  OTOMainVC.m
//  1To1Rating
//
//  Created by Saurabh Vaza on 17/08/17.
//  Copyright © 2017 Saurabh. All rights reserved.
//

#import "OTOMainVC.h"
//#import <AccountKit/AccountKit.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface OTOMainVC ()
{
    
    __weak IBOutlet UIImageView *imgViewBg;
    __weak IBOutlet UIImageView *imgViewRating;
    
    __weak IBOutlet UIButton *btnLoginWithEmail;
    
    __weak IBOutlet UIButton *btnLoginWithFb;
    __weak IBOutlet UIButton *btnSignUp;
    __weak IBOutlet UILabel *lblCntTermsAndPolicy;
    
    NSString *strEmail, *strUserId;
    
}
@end

@implementation OTOMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    @try {
        [self setUpView];
        [self setUpBasic];
        
        [[OTOGeneralSharedManager sharedManager] isCurrentTimeIsBetween5AMto5PM];
        
        [[OTOGeneralSharedManager sharedManager] setUpLocalNotifications];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:kUDKeyUserData]) {
            [self setUpLoing:nil];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUDDeviceToken]) {
//        [[OTOGeneralSharedManager sharedManager] alertWithTitle:@"Token" Message:[[NSUserDefaults standardUserDefaults] objectForKey:kUDDeviceToken] controller:self];
//    }
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self isUserLoggedIn]) {
        // if the user is already logged in, go to the main screen
        [self proceedToMainScreen];
    }
    
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUDDeviceToken]) {
//        [[OTOGeneralSharedManager sharedManager] alertWithTitle:@"Token" Message:[[NSUserDefaults standardUserDefaults] objectForKey:kUDDeviceToken] controller:self];
//    }
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

- (void)setUpView{
    
    btnLoginWithFb.clipsToBounds = YES;
    btnLoginWithEmail.clipsToBounds = YES;
    
    btnLoginWithEmail.layer.cornerRadius = 5.0;
    btnLoginWithFb.layer.cornerRadius = 5.0;
    
    [btnLoginWithFb setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [btnLoginWithFb setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -15)];
    
    [btnLoginWithEmail setImageEdgeInsets:UIEdgeInsetsMake(0, -47, 0, 10)];
    [btnLoginWithEmail setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];

}

- (void)setUpBasic{
    [self proceedToMainScreen];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
    }
//    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    // Optional: Place the button in the center of your view.
//    loginButton.center = btnLoginWithFb.center;
//    loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
//    [self.view addSubview:loginButton];
}

#pragma mark -----------
#pragma mark User Define Titles

- (IBAction)btnLoginWithEmailClicked:(id)sender {
    
    
}

- (IBAction)btnLoginWithFBClicked:(id)sender {
//    NSString *inputState = [[NSUUID UUID] UUIDString];
//    UIViewController<AKFViewController> *viewController = [accountKit viewControllerForEmailLoginWithEmail:nil
//                                                                                                      state:inputState];
//    [self _prepareLoginViewController:viewController]; // see below
//    [self presentViewController:viewController animated:YES completion:NULL];
    
    id aObjFbManager = [[FBSDKLoginManager alloc] init];
    
    NSArray *aArrPermission = [NSArray arrayWithObjects:@"public_profile",@"email",@"user_friends", nil];
    
    [aObjFbManager logInWithReadPermissions:aArrPermission fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error == nil) {
            if (result.grantedPermissions != nil) {
                if ([result.grantedPermissions containsObject:@"email"]) {
                    [self getFBData];
//                    [aObjFbManager logOut];
                }
            }
        }
    }];
    
}
- (IBAction)btnSignUpClicked:(id)sender {
}

#pragma mark -----------
#pragma mark Other Methods

- (void)getFBData{
    if (FBSDKAccessToken.currentAccessToken != nil) {
        FBSDKGraphRequest *aObjRequest = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"id, name, first_name, last_name, email",@"fields",  nil]];
        
        [aObjRequest startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (error == nil) {
                NSLog(@"Result : %@",result);
             //   [self callWSToLoginWithFB];
                
                NSData *aDtUser = [NSKeyedArchiver archivedDataWithRootObject:result];
                [[NSUserDefaults standardUserDefaults] setObject:aDtUser forKey:kUDKeyUserData];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                if ([result objectForKey:@"email"]) {
                    strEmail = [result objectForKey:@"email"];
                }else{
                    strEmail = @"";
                }
                
                [self callWSToLoginWithFB];
            }
        }];
    }
}

- (BOOL) isUserLoggedIn{
       return NO;
}


- (void)proceedToMainScreen{
    

}


#pragma mark -----------
#pragma mark Webservice Methods

- (void)callWSToLoginWithFB{
    @try {
        [[OTOGeneralSharedManager sharedManager] startActivity:self.view];
        if ([[OTOGeneralSharedManager sharedManager] checkIfInternetIsAvailable:self]) {
            
            NSMutableDictionary *aMutDictParam = [NSMutableDictionary dictionary];
            
            [aMutDictParam setObject:strEmail forKey:@"email"];
            [aMutDictParam setObject:@"1" forKey:@"IsWithFB"];
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:kUDDeviceToken]) {
                [aMutDictParam setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kUDDeviceToken] forKey:@"device_id"];
            }else{
                [aMutDictParam setObject:kDeviceToken forKey:@"device_id"];
            }
            //        [aMutDictParam setObject:txtEmail.text forKey:@"de vice_id"];
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
        
        NSMutableDictionary *aMutDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSKeyedUnarchiver unarchiveObjectWithData:aDt],@"data", nil];
        aMutDictResponse = [NSMutableDictionary dictionaryWithDictionary:aMutDict];
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




@end
