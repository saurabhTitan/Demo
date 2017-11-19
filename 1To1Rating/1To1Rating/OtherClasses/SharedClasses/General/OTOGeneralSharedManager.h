//
//  OTOGeneralSharedManager.h
//  1To1Rating
//
//  Created by Saurabh Vaza on 21/08/17.
//  Copyright © 2017 Saurabh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OTOGeneralSharedManager : NSObject

+(OTOGeneralSharedManager*)sharedManager;


#pragma mark -----------
#pragma mark Email Validation Method

- (BOOL)validateEmailWithString:(NSString*)checkString;

#pragma mark -----------
#pragma mark Alert Methods

- (void)alertWithTitle:(NSString *)aStrTitle Message:(NSString *)aStrMessage controller:(UIViewController *)aVC;

- (void)alertWithTitle:(NSString *)aStrTitle Message:(NSString *)aStrMessage controller:(UIViewController *)aVC handler:(void (^ __nullable)(UIAlertAction *action))handler;

- (void)alertWithTwoOptionsTitle:(NSString *_Nullable)aStrTitle Message:(NSString *_Nullable)aStrMessage controller:(UIViewController *_Nullable)aVC handler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler;

#pragma mark -----------
#pragma mark Check Internet Rechability

- (BOOL)checkIfInternetIsAvailable:(UIViewController *)aVC;

#pragma mark -----------
#pragma mark JSON Objects

-(NSString*) jsonStringWithPrettyPrint:(BOOL) prettyPrint jsonObject:(id)aObj;

- (NSData *) jsonDataForDictionary:(id)aObjDict;

#pragma mark -----------
#pragma mark Color from hex string

// Assumes input like "#00FF00" (#RRGGBB).
- (UIColor *)colorFromHexString:(NSString *)hexString;


#pragma mark -----------
#pragma mark Activity Indicator Methods

- (void)startActivity:(UIView *)aView;
- (void)stopActivity:(UIView *)aView;


#pragma mark -----------
#pragma mark

- (NSString *)getStringFromDict:(NSMutableDictionary *)aMutDict;

#pragma mark -----------
#pragma mark Get Current Time

- (NSString *)getCurrentTime;
- (NSString *)getCurrentHour;
- (NSString *)getCurrentMin;
- (BOOL)isCurrentTimeIsBetween5AMto5PM;

#pragma mark -----------
#pragma mark Get Label Height

- (CGFloat)getLabelHeight:(UILabel*)label;

#pragma mark -----------
#pragma mark Local Notification Methods

- (void)setUpLocalNotifications;
- (void)removeLocalNotificationFor6;

#pragma mark -----------
#pragma mark Get Today's Date

- (NSString *_Nullable)getTodaysDateInString;


@end
