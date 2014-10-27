//
//  TRIAppDelegate.m
//  Shopping
//
//  Created by Adrian on 16/05/14.
//  Copyright (c) 2014 akosma. All rights reserved.
//

@import CoreLocation;

#import "TRIAppDelegate.h"
#import "TRINotifications.h"


static NSString *LAST_NOFIFICATION_SENT = @"LAST_NOFIFICATION_SENT";
static NSString *SHOPPING_UUID = @"49EF247E-00B4-4693-A61C-A63C7BD34085";


@interface TRIAppDelegate () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) CLBeaconRegion *region;
@property (nonatomic) NSDate *lastNotification;

@end


@implementation TRIAppDelegate

-           (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Core location stuff
    if ([CLLocationManager isRangingAvailable])
    {
        self.manager = [[CLLocationManager alloc] init];
        self.manager.delegate = self;
        [self.manager requestAlwaysAuthorization];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.lastNotification = [defaults objectForKey:LAST_NOFIFICATION_SENT];
    if (self.lastNotification == nil)
    {
        NSDate *past = [NSDate distantPast];
        self.lastNotification = past;
        [defaults setObject:past
                     forKey:LAST_NOFIFICATION_SENT];
        [defaults synchronize];
    }
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    UIApplication *app = [UIApplication sharedApplication];
    app.applicationIconBadgeNumber = 0;
    [app cancelAllLocalNotifications];
}

#pragma mark - CLLocationManagerDelegate methods

-      (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways)
    {
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:SHOPPING_UUID];
        self.region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                         identifier:@"com.trifork.Shopping"];
        self.region.notifyEntryStateOnDisplay = YES;
        
        if ([CLLocationManager isRangingAvailable])
        {
            [self.manager startMonitoringForRegion:self.region];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region
{
    [self.manager requestStateForRegion:self.region];
}

-(void)locationManager:(CLLocationManager *)manager
     didDetermineState:(CLRegionState)state
             forRegion:(CLRegion *)region
{
    if (state == CLRegionStateInside)
    {
        // Do not display more than one notification every 10 minutes
        NSDate *now = [NSDate date];
        NSTimeInterval interval = [now timeIntervalSinceDate:self.lastNotification];
        UIApplication *app = [UIApplication sharedApplication];
        if (interval > 600 && app.applicationState == UIApplicationStateBackground)
        {
                // If the app is in the background, show a local notification
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                notification.fireDate = [NSDate date];
                notification.alertBody = @"Welcome to the Computer Shop!";
                notification.alertAction = @"Show";
                notification.soundName = UILocalNotificationDefaultSoundName;
                
                NSTimeZone* timezone = [NSTimeZone defaultTimeZone];
                notification.timeZone = timezone;
            
                app.applicationIconBadgeNumber = 1;
                [app scheduleLocalNotification:notification];
                self.lastNotification = now;
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:now
                             forKey:LAST_NOFIFICATION_SENT];
                [defaults synchronize];
        }
        [self.manager startRangingBeaconsInRegion:self.region];
    }
    else
    {
        //Stop Ranging here
        [self.manager stopRangingBeaconsInRegion:self.region];
    }
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region
{
    //    NSLog(@"======= new ranging");
    //    for (CLBeacon *beacon in beacons)
    //    {
    //        NSLog(@"beacon: minor = %@, rssi = %li, accuracy = %1.2f, proximity = %li",
    //              beacon.minor, beacon.rssi, beacon.accuracy, beacon.proximity);
    //    }
    
    NSString *pred1 = @"(self.accuracy > 0) AND ((self.proximity == %d) OR (self.proximity == %d))";
    NSPredicate *predicateRelevantBeacons = [NSPredicate predicateWithFormat:pred1, CLProximityNear, CLProximityImmediate];
    NSArray *relevantsBeacons = [beacons filteredArrayUsingPredicate:predicateRelevantBeacons];

    NSString *pred2 = @"(self.accuracy == %@.@min.accuracy) AND (self.rssi == %@.@max.rssi)";
    NSPredicate *predicateClosest = [NSPredicate predicateWithFormat:pred2, relevantsBeacons, relevantsBeacons];
    NSArray *closestArray = [relevantsBeacons filteredArrayUsingPredicate:predicateClosest];
    CLBeacon *closestBeacon = [closestArray firstObject];
    
    if (closestBeacon)
    {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:CLOSEST_BEACON_FOUND
                              object:self
                            userInfo:@{
                                       @"minor": closestBeacon.minor
                                       }];

    }
}

@end
