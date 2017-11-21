//
//  MainVCViewController.m
//  InnovifyDemo
//
//  Created by Saurabh Vaza on 21/11/17.
//  Copyright © 2017 Saurabh. All rights reserved.
//

#import "MainVCViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "OTOLocationManager.h"
#import "SQLiteManager.h"

@interface MainVCViewController ()<CLLocationManagerDelegate>
{
    NSTimeInterval lastTimeInterval;
}
@property (weak, nonatomic) IBOutlet UILabel *lblLocationInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnLocationStatus;

@end

@implementation MainVCViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%s",__FUNCTION__);
    
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"%s",__FUNCTION__);
    
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"%s",__FUNCTION__);
    
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
#pragma mark Button Click Methods

- (IBAction)btnLocationStatusClicked:(id)sender {
    _btnLocationStatus.selected = !_btnLocationStatus.selected;
    
    if (_btnLocationStatus.selected) {
        [_btnLocationStatus setBackgroundColor:[UIColor redColor]];
        [[OTOLocationManager sharedManager] startLocationTracking:self];
    }else{
        [_btnLocationStatus setBackgroundColor:[UIColor greenColor]];
        [[OTOLocationManager sharedManager] stopLocationTracking];
    }
}

#pragma mark -----------
#pragma mark Other Methods

- (void)insertLocationDetailIntoDB:(NSString *)aStrLatitude andLongitude:(NSString *)aStrLongitude speed:(NSString *)aStrSpeed{
    
    @try {
        NSMutableDictionary *aMutDictInfo = [NSMutableDictionary dictionary];
        [aMutDictInfo setObject:aStrLatitude forKey:@"lat"];
        [aMutDictInfo setObject:aStrLongitude forKey:@"long"];
        [aMutDictInfo setObject:aStrSpeed forKey:@"currentTimeInterval"];
        [aMutDictInfo setObject:@"60" forKey:@"nextTimeInterval"];
        NSString *aStrTime = [[OTOGeneralSharedManager sharedManager] getTodaysDateInString];
        
        [aMutDictInfo setObject:aStrTime forKey:@"time"];
        
        // To write info into database

        [[SQLiteManager singleton] save:aMutDictInfo into:@"LocationMaster"];
        
        NSString *aStrInfo = [NSString stringWithFormat:@"lat: %@ long: %@ currentTimeInterval : %@ nextTimeInterval : %@ time : %@" ,aStrLatitude,aStrLongitude,aStrSpeed,@"60", aStrTime];
        
        // To write info into local file
        [[OTOGeneralSharedManager sharedManager] writeToDocumentDirectory:aStrInfo];
        
    } @catch (NSException *exception) {
        NSLog(@"Class:: %s Exception :: %@",__func__,exception.description);
    } @finally {
        
    }
    
}

- (BOOL)checkDifferenceFor:(NSInteger)aIntDifference{
    
    NSDate *aDtLast = [NSDate dateWithTimeIntervalSince1970:lastTimeInterval];
    
    NSTimeInterval aInterval = [aDtLast timeIntervalSinceDate: [NSDate date]];//[date1 timeIntervalSince1970] - [date2 timeIntervalSince1970];
    
    long seconds = lroundf(aInterval); // Since modulo operator (%) below needs int or long

//    int ahour = seconds / 3600;
//    int aminute = (int)seconds % 3600 / 60;
    int aseconds = (int)seconds % 60;
    
    if (ABS(aseconds) > 30) {
        lastTimeInterval = [NSDate date].timeIntervalSince1970;
        return true;
    }
    
    return false;
}


#pragma mark -----------
#pragma mark CLLocationManager Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    @try {
        CLLocation *aObjNewLocation = [locations lastObject];
        
        NSString *aStrlatitude, *aStrlongitude, *aStrSpeed;
        
        aStrlatitude = [NSString stringWithFormat:@"%.2f",aObjNewLocation.coordinate.latitude];
        aStrlongitude = [NSString stringWithFormat:@"%.2f",aObjNewLocation.coordinate.longitude];
        
        double speed = aObjNewLocation.speed * 3.6; // 3.6 is to get km/hr
        
        aStrSpeed = [NSString stringWithFormat:@"%.2f",speed];

        NSLog(@"lat: %@ long: %@ speed : %@ " ,aStrlatitude,aStrlongitude,aStrSpeed);
        
        if (!lastTimeInterval) {
            lastTimeInterval = [NSDate date].timeIntervalSince1970;
            [self insertLocationDetailIntoDB:aStrlatitude andLongitude:aStrlongitude speed:aStrSpeed];
        }
        
        if (speed >= 80) { // Location should be captured after every 30 seconds interval, if speed >= 80
            if ([self checkDifferenceFor:30]) {
                [self insertLocationDetailIntoDB:aStrlatitude andLongitude:aStrlongitude speed:@"30"];
            }
        }else if (speed < 80 && speed >= 60) { // Location should be captured after every minute if speed < 80 and speed >= 60
            if ([self checkDifferenceFor:60]) {
                [self insertLocationDetailIntoDB:aStrlatitude andLongitude:aStrlongitude speed:@"60"];
            }
        }else if (speed < 60 && speed >= 30) { // Location should be captured after every 2 minutes if speed < 60 and speed >= 30
            if ([self checkDifferenceFor:120]) {
                [self insertLocationDetailIntoDB:aStrlatitude andLongitude:aStrlongitude speed:@"120"];
            }
        }else if (speed < 30) { // Location should be captured after every 5 minutes if speed < 30
            if ([self checkDifferenceFor:300]) {
                [self insertLocationDetailIntoDB:aStrlatitude andLongitude:aStrlongitude speed:@"300"];
            }
        }
        
        
    } @catch (NSException *exception) {
        NSLog(@"Class:: %s Exception :: %@",__func__,exception.description);
    } @finally {
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}

@end
