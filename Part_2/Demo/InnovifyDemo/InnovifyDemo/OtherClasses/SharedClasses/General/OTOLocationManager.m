//
//  OTOLocationManager.m
//  InnovifyDemo
//
//  Created by Saurabh Vaza on 21/11/17.
//  Copyright © 2017 Saurabh. All rights reserved.
//

#import "OTOLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@implementation OTOLocationManager

static OTOLocationManager* sharedMyLocation = nil;
static CLLocationManager  *objLocationMngr = nil;

+(OTOLocationManager*)sharedManager
{
    @synchronized([OTOLocationManager class])
    {
        if (!sharedMyLocation)
            sharedMyLocation = [[self alloc] init];
        objLocationMngr = [[CLLocationManager alloc] init];
        
        objLocationMngr.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        
        
        return sharedMyLocation;
    }
    
    return nil;
}

#pragma mark -----------
#pragma mark Other Methods

- (void)requestLocationAccess{
    [objLocationMngr requestWhenInUseAuthorization];
}

// Tp start location tracking
- (void)startLocationTracking:(UIViewController *)aObjVC{
    objLocationMngr.delegate = aObjVC;
    [objLocationMngr startUpdatingLocation];
}

// To Stop location tracking
- (void)stopLocationTracking{
    objLocationMngr.delegate = nil;
    [objLocationMngr stopUpdatingLocation];
}

@end
