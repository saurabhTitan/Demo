//
//  OTOLocationManager.h
//  InnovifyDemo
//
//  Created by Saurabh Vaza on 21/11/17.
//  Copyright © 2017 Saurabh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTOLocationManager : NSObject
+(OTOLocationManager*_Nullable)sharedManager;

#pragma mark -----------
#pragma mark Other Methods

- (void)requestLocationAccess;

// Tp start location tracking
- (void)startLocationTracking:(UIViewController *)aObjVC;

// To Stop location tracking
- (void)stopLocationTracking;
@end
