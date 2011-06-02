//
//  FTLocationServices.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 04/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTLocationServices.h"


@implementation FTLocationServices

@synthesize currentLocation;
@synthesize currentLocationCoordinates;
@synthesize currentAltitude;
@synthesize currentSpeed;
@synthesize currentDirection;
@synthesize locationManager;
@synthesize delegate;


#pragma mark Initialization

- (void)doInit {
	locationManager = [[CLLocationManager alloc] init];
	[locationManager setDelegate:self];
	[locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
}

- (id)init {
	self = [super init];
	if (self) {
		[self doInit];
	}
	return self;
}

#pragma mark Location service delegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	[currentLocation release];
	currentLocation = newLocation;
	[currentLocation retain];
	
	currentLocationCoordinates = currentLocation.coordinate;
	currentAltitude = currentLocation.altitude;
	currentDirection = currentLocation.course;
	currentSpeed = currentLocation.speed;
	
	if ([delegate respondsToSelector:@selector(locationService:locationChangedToCLLocation:)]) {
		[delegate locationService:self locationChangedToCLLocation:newLocation.coordinate];
	}
	if ([delegate respondsToSelector:@selector(locationService:locationChangedToLocationInPoint:)]) {
		[delegate locationService:self locationChangedToLocationInPoint:CGPointMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude)];
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	if ([delegate respondsToSelector:@selector(locationService:failedWithError:)]) {
		[delegate locationService:self failedWithError:error];
	}
}

#pragma mark Settings

- (void)startUpdatingLocation {
	[locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation {
	[locationManager stopUpdatingLocation];
}

#pragma mark Distance translations

- (CGFloat)currentDistanceToCoordinates:(CLLocationCoordinate2D)coordinates {
	return 0.0f;
}

- (CGFloat)currentDistanceToPointCoordinates:(CGPoint)coordinates {
	return 0.0f;
}

#pragma mark Memory management

- (void)dealloc {
	[currentLocation release];
	[locationManager release];
	[super dealloc];
}


@end
