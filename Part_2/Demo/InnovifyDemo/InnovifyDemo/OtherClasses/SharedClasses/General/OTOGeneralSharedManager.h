//
//  OTOGeneralSharedManager.h
//  1To1Rating
//
//  Created by Saurabh Vaza on 21/08/17.
//  Copyright © 2017 Ganadhakshya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OTOGeneralSharedManager : NSObject

+(OTOGeneralSharedManager*_Nullable)sharedManager;


#pragma mark -----------
#pragma mark Email Validation Method

- (BOOL)validateEmailWithString:(NSString*_Nonnull)checkString;

#pragma mark -----------
#pragma mark Alert Methods

- (void)alertWithTitle:(NSString *_Nonnull)aStrTitle Message:(NSString *_Nonnull)aStrMessage controller:(UIViewController *_Nonnull)aVC;

- (void)alertWithTitle:(NSString *_Nonnull)aStrTitle Message:(NSString *_Nonnull)aStrMessage controller:(UIViewController *_Nonnull)aVC handler:(void (^ __nullable)(UIAlertAction * _Nonnull action))handler;

- (void)alertWithTwoOptionsTitle:(NSString *_Nullable)aStrTitle Message:(NSString *_Nullable)aStrMessage controller:(UIViewController *_Nullable)aVC handler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler;

#pragma mark -----------
#pragma mark Check Internet Rechability

- (BOOL)checkIfInternetIsAvailable:(UIViewController *_Nullable)aVC;

#pragma mark -----------
#pragma mark JSON Objects

-(NSString*_Nullable) jsonStringWithPrettyPrint:(BOOL) prettyPrint jsonObject:(id _Nullable )aObj;

- (NSData *_Nonnull) jsonDataForDictionary:(id _Nonnull )aObjDict;

#pragma mark -----------
#pragma mark Color from hex string

// Assumes input like "#00FF00" (#RRGGBB).
- (UIColor *_Nonnull)colorFromHexString:(NSString *_Nonnull)hexString;


#pragma mark -----------
#pragma mark Activity Indicator Methods

- (void)startActivity:(UIView *_Nonnull)aView;
- (void)stopActivity:(UIView *_Nonnull)aView;


#pragma mark -----------
#pragma mark

- (NSString *_Nonnull)getStringFromDict:(NSMutableDictionary *_Nonnull)aMutDict;

#pragma mark -----------
#pragma mark Get Current Time

- (NSString *_Nullable)getCurrentTime;
- (NSString *_Nullable)getCurrentHour;
- (NSString *_Nonnull)getCurrentMin;
- (BOOL)isCurrentTimeIsBetween5AMto5PM;

#pragma mark -----------
#pragma mark Get Label Height

- (CGFloat)getLabelHeight:(UILabel*_Nonnull)label;

#pragma mark -----------
#pragma mark Get Today's Date

- (NSString *_Nullable)getTodaysDateInString;

#pragma mark -----------
#pragma mark Document Directory Writing Methods

- (void)writeToDocumentDirectory:(NSString *_Nonnull)aStrInfo;

@end
