//
//  OTOGeneralSharedManager.m
//  1To1Rating
//
//  Created by Saurabh Vaza on 21/08/17.
//  Copyright © 2017 Ganadhakshya. All rights reserved.
//

#import "OTOGeneralSharedManager.h"
#import "DGActivityIndicatorView.h"

#import <UserNotifications/UserNotifications.h>


@implementation OTOGeneralSharedManager

static OTOGeneralSharedManager* sharedMyGeneral = nil;

+(OTOGeneralSharedManager*)sharedManager
{
    @synchronized([OTOGeneralSharedManager class])
    {
        if (!sharedMyGeneral)
            sharedMyGeneral = [[self alloc] init];
        
        return sharedMyGeneral;
    }
    
    return nil;
}

/*
 + (id)sharedManager {
 static Singleton *sharedMyManager = nil;
 static dispatch_once_t onceToken;
 dispatch_once(&onceToken, ^{
 sharedMyManager = [[self alloc] init];
 });
 return sharedMyManager;
 }
*/

#pragma mark -----------
#pragma mark Email Validation Method

- (BOOL)validateEmailWithString:(NSString*)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


#pragma mark -----------
#pragma mark Alert Methods

- (void)alertWithTitle:(NSString *)aStrTitle Message:(NSString *)aStrMessage controller:(UIViewController *)aVC{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:aStrTitle message:aStrMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        // Ok action example
    }];
//    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"Other" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
//        // Other action
//    }];
    [alert addAction:okAction];
//    [alert addAction:otherAction];
    [aVC presentViewController:alert animated:YES completion:nil];
}


- (void)alertWithTitle:(NSString *)aStrTitle Message:(NSString *)aStrMessage controller:(UIViewController *)aVC handler:(void (^ __nullable)(UIAlertAction *action))handler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:aStrTitle message:aStrMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        // Ok action example
        handler(action);
    }];
    //    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"Other" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
    //        // Other action
    //    }];
    [alert addAction:okAction];
    //    [alert addAction:otherAction];
    [aVC presentViewController:alert animated:YES completion:nil];
}


- (void)alertWithTwoOptionsTitle:(NSString *)aStrTitle Message:(NSString *)aStrMessage controller:(UIViewController *)aVC handler:(void (^ __nullable)(UIAlertAction *action))handler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:aStrTitle message:aStrMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        // Ok action example
        handler(action);
    }];

    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        // Other action
    }];
    [alert addAction:okAction];
    [alert addAction:otherAction];
    
    [aVC presentViewController:alert animated:YES completion:nil];
}



#pragma mark -----------
#pragma mark Check Internet Rechability

- (BOOL)checkIfInternetIsAvailable:(UIViewController *)aVC
{
    NSString *remoteHostName = @"http://pitchertech.com";
    Reachability *hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [hostReachability startNotifier];
    
//    Reachability *internetReachability = [Reachability reachabilityForInternetConnection];
//    [internetReachability startNotifier];
//    
//    Reachability *wifiReachability = [Reachability reachabilityForLocalWiFi];
//    [wifiReachability startNotifier];
    
    
    BOOL reachable = NO;
    NetworkStatus netStatus = [hostReachability currentReachabilityStatus];
    if(netStatus == ReachableViaWWAN || netStatus == ReachableViaWiFi)
    {
        reachable = YES;
    }
    else
    {
        reachable = NO;
        if (aVC) {
            [self alertWithTitle:kMsgTitle Message:kMsgInternet controller:aVC];
        }
    }
    return reachable;
}


#pragma mark -----------
#pragma mark JSON Objects

-(NSString*) jsonStringWithPrettyPrint:(BOOL) prettyPrint jsonObject:(id)aObj{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:aObj
                                                       options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}


- (NSData *) jsonDataForDictionary:(id)aObjDict{
    NSError *error;
    NSData *aDtJson = [NSJSONSerialization dataWithJSONObject:aObjDict
                                                       options:(NSJSONWritingOptions)    (/* DISABLES CODE */ (YES) ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (!aDtJson) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
    } else {
        return aDtJson = [[NSData alloc] init];
    }
    
    return aDtJson;
}

#pragma mark -----------
#pragma mark Color from hex string

// Assumes input like "#00FF00" (#RRGGBB).
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

#pragma mark -----------
#pragma mark Activity Indicator Methods

- (void)startActivity:(UIView *)aView{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[self colorFromHexString:kColorActivity] size:20.0f];
    activityIndicatorView.tag = 87654;
    activityIndicatorView.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    activityIndicatorView.center = aView.center;
    [aView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
}

- (void)stopActivity:(UIView *)aView{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    DGActivityIndicatorView *activityIndicatorView = (DGActivityIndicatorView *)[aView viewWithTag:87654];
    [activityIndicatorView stopAnimating];
    [activityIndicatorView removeFromSuperview];
}


#pragma mark -----------
#pragma mark 

- (NSString *)getStringFromDict:(NSMutableDictionary *)aMutDict{
    NSString *aStrResult = @"";
    NSArray *aArrKeys = [aMutDict allKeys];
    
    for (int aIntCnt = 0; aIntCnt < aArrKeys.count; aIntCnt++) {
        NSString *aStrValue = [aMutDict objectForKey:[aArrKeys objectAtIndex:aIntCnt]];
        aStrResult = [aStrResult stringByAppendingString:[NSString stringWithFormat:@"%@=%@",[aArrKeys objectAtIndex:aIntCnt],aStrValue]];
        
        if (aIntCnt != aMutDict.count - 1) {
            aStrResult = [aStrResult stringByAppendingString:@"&"];
        }
    }
    
    return aStrResult;
}

#pragma mark -----------
#pragma mark Get Current Time

- (NSString *)getCurrentTime{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"%H:%M:%S"];
    NSString *aStrTime = [formatter stringFromDate:date];
    return aStrTime;
}

- (NSString *)getCurrentHour{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    NSString *aStrTime = [formatter stringFromDate:date];
    return aStrTime;
}


- (NSString *)getCurrentMin{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    NSString *aStrTime = [formatter stringFromDate:date];
    return aStrTime;
}


- (BOOL)isCurrentTimeIsBetween5AMto5PM{
    BOOL aBoolResult = NO;
    
    NSString *aStrCurrentHr = [self getCurrentHour];
//    NSString *aStrCurrentMin = [self getCurrentMin];
    
    NSString *aStrMinHr = @"5";
    NSString *aStrMaxHr = @"16";
    
//    NSString *aStrMaxMin = @"59";
    
//    NSLog(@"aStrCurrentHr : %@ , aStrCurrentMin : %@",aStrCurrentHr,aStrCurrentMin);
    
    if ([aStrCurrentHr intValue] >= [aStrMinHr intValue] && [aStrCurrentHr intValue] <= [aStrMaxHr intValue]) {
        aBoolResult = YES;
    }
    
    return aBoolResult;
}


#pragma mark -----------
#pragma mark Get Label Height

- (CGFloat)getLabelHeight:(UILabel*)label
{
    CGSize constraint = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}


#pragma mark -----------
#pragma mark Get Today's Date

- (NSString *_Nullable)getTodaysDateInString{
    NSString *aStrResult;
    
    NSDateFormatter *aDtFrmt = [[NSDateFormatter alloc] init];
    [aDtFrmt setDateFormat:@"dd/MM/yyyy-HH:mm:ss a"]; //yyyy-MM-dd
    
    aStrResult = [aDtFrmt stringFromDate:[NSDate date]];
    
    return aStrResult;
}

#pragma mark -----------
#pragma mark Document Directory Writing Methods

- (void)writeToDocumentDirectory:(NSString *_Nonnull)aStrInfo{
    //  Following Code will creat Directory in DocumentsDirectory
    
    NSString *aStrDocDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *aStrDirName = [aStrDocDir stringByAppendingPathComponent:@"MyDir"];
    
    BOOL aBoolIsDir;
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if(![fm fileExistsAtPath:aStrDirName isDirectory:&aBoolIsDir])
    {
        if([fm createDirectoryAtPath:aStrDirName withIntermediateDirectories:YES attributes:nil error:nil])
            NSLog(@"Directory Created");
        else
            NSLog(@"Directory Creation Failed");
    }
    else{
        NSLog(@"Directory Already Exist");
    }
    
    NSString *aStrFileName = [aStrDirName stringByAppendingPathComponent:@"Location.txt"];
    NSError *error;

    if (![fm fileExistsAtPath:aStrFileName]) { // if file is not exist, create it.
        NSString *helloStr = @"Localization Recording";
        [helloStr writeToFile:aStrFileName atomically:YES encoding:NSUTF8StringEncoding error:&error];
    }
    
    if ([fm isWritableFileAtPath:aStrFileName]) {
        NSLog(@"Writable");
        aStrInfo = [aStrInfo stringByAppendingString:@"\r\n"];
//        [aStrInfo writeToFile:aStrFileName atomically:YES encoding:NSUTF8StringEncoding error:&error];
        
        NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:aStrFileName];
        [fileHandler seekToEndOfFile];
        [fileHandler writeData:[aStrInfo dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandler closeFile];
        
    }else {
        NSLog(@"Not Writable");
    }
    
    [self addSkipBackupAttributeToItemAtURL:[NSURL URLWithString:aStrDirName]];

}


- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL{
    
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                    
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    
    if(!success){
        
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    
    return success;
}


@end
