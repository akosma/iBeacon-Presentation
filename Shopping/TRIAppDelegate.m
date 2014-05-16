//
//  TRIAppDelegate.m
//  Shopping
//
//  Created by Adrian on 16/05/14.
//  Copyright (c) 2014 Trifork GmbH. All rights reserved.
//

#import "TRIAppDelegate.h"


@interface TRIAppDelegate () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) CLBeaconRegion *region;
@property (nonatomic) BOOL notificationSent;

@end


@implementation TRIAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Core location stuff
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    self.notificationSent = NO;
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"49EF247E-00B4-4693-A61C-A63C7BD34085"];
    self.region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                     identifier:@"com.trifork.Shopping"];
    self.region.notifyEntryStateOnDisplay = YES;
    
    if ([CLLocationManager isRangingAvailable])
    {
        [self.manager startMonitoringForRegion:self.region];
    }

    return YES;
}

#pragma mark - CLLocationManagerDelegate methods

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
        if (!self.notificationSent)
        {
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.fireDate = [NSDate date];
            notification.alertBody = @"Welcome to the Computer Shop!";
            notification.alertAction = @"Show";
            notification.soundName = UILocalNotificationDefaultSoundName;
            
            NSTimeZone* timezone = [NSTimeZone defaultTimeZone];
            notification.timeZone = timezone;
            
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            self.notificationSent = YES;
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
    
    NSPredicate *predicateRelevantBeacons = [NSPredicate predicateWithFormat:@"(self.accuracy > 0) AND ((self.proximity == %d) OR (self.proximity == %d))", CLProximityNear, CLProximityImmediate];
    NSArray *relevantsBeacons = [beacons filteredArrayUsingPredicate:predicateRelevantBeacons];
    NSPredicate *predicateClosest = [NSPredicate predicateWithFormat:@"(self.accuracy == %@.@min.accuracy) AND (self.rssi == %@.@max.rssi)", relevantsBeacons, relevantsBeacons];
    
    CLBeacon *closestBeacon = nil;
    NSArray *closestArray = [relevantsBeacons filteredArrayUsingPredicate:predicateClosest];
    
    //    NSLog(@"======= closest");
    //    for (CLBeacon *beacon in closestArray)
    //    {
    //        NSLog(@"beacon: minor = %@, rssi = %li, accuracy = %1.2f, proximity = %li",
    //              beacon.minor, beacon.rssi, beacon.accuracy, beacon.proximity);
    //    }
    
    if ([closestArray count] > 0)
    {
        closestBeacon = [closestArray objectAtIndex:0];
    }
    if (closestBeacon)
    {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:@"NEW_BEACONS"
                              object:self
                            userInfo:@{
                                       @"minor": closestBeacon.minor
                                       }];

    }
}

@end
