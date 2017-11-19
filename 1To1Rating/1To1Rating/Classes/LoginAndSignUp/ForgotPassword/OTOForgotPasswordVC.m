//
//  OTOForgotPassword.m
//  1To1Rating
//
//  Created by Saurabh Vaza on 19/08/17.
//  Copyright © 2017 Saurabh. All rights reserved.
//

#import "OTOForgotPasswordVC.h"

@interface OTOForgotPasswordVC ()
{
    
    __weak IBOutlet UILabel *lblForgotPassword;
    __weak IBOutlet UITextField *txtEmail;
    __weak IBOutlet UIButton *btnSend;
    __weak IBOutlet UIButton *btnLogin;
}
@end

@implementation OTOForgotPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpView];
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
- (IBAction)btnSendClicked:(id)sender {
    
    if ([txtEmail.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
        [[OTOGeneralSharedManager sharedManager] alertWithTitle:kMsgTitle Message:kMsgEmailRequired controller:self];
    }
    else if (![[OTOGeneralSharedManager sharedManager] validateEmailWithString:txtEmail.text]) {
        [[OTOGeneralSharedManager sharedManager] alertWithTitle:kMsgTitle Message:kMsgValidEmail controller:self];
    }
    else{
        [self callWSToForgotPassword];
    }

    
}
- (IBAction)btnLoginClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -----------
#pragma mark Basic Methods

- (void)setUpView{
    
    btnSend.clipsToBounds = YES;
    
    btnSend.layer.cornerRadius = 5.0;
    
    [btnSend setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [btnSend setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -15)];

}

- (void)setUpBasic{
    
}


#pragma mark -----------
#pragma mark Webservice Methods

- (void)callWSToForgotPassword{
    @try {
        [[OTOGeneralSharedManager sharedManager] startActivity:self.view];
        if ([[OTOGeneralSharedManager sharedManager] checkIfInternetIsAvailable:self]) {
            
            NSMutableDictionary *aMutDictParam = [NSMutableDictionary dictionary];
            
            [aMutDictParam setObject:txtEmail.text forKey:@"email"];
            
            [[OTOSharedWebService sharedManager] apiCallWithUrl:kAPIPathForgotPass method:kMethodPost parameter:aMutDictParam completionHandler:^(NSURLResponse * _Nullable response, id  _Nullable responseObject, NSError * _Nullable error) {
                @try {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[OTOGeneralSharedManager sharedManager] stopActivity:self.view];
                    });
                    
                    if (error) {
                        [[OTOGeneralSharedManager sharedManager] alertWithTitle:kMsgTitle Message:kMsgGeneral controller:self];
                    } else {
                        NSMutableDictionary *aMutDictResponse = responseObject;
                        
                        if (aMutDictResponse &&  [[aMutDictResponse objectForKey:@"success"] boolValue] == TRUE) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [[OTOGeneralSharedManager sharedManager] alertWithTitle:kMsgTitle Message:[aMutDictResponse objectForKey:@"msg"] controller:self handler:^(UIAlertAction *action) {
                                        [self.navigationController popViewControllerAnimated:YES];
                                    }];
                                });
                            });
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


@end
