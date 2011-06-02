//
//  FTLocationServices.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 04/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@class FTLocationServices;


@protocol FTLocationServicesDelegate <NSObject>

@optional

- (void)locationService:(FTLocationServices *)service locationChangedToCLLocation:(CLLocationCoordinate2D)location;

- (void)locationService:(FTLocationServices *)service locationChangedToLocationInPoint:(CGPoint)location;

- (void)locationService:(FTLocationServices *)service failedWithError:(NSError *)error;

@end


@interface FTLocationServices : NSObject <CLLocationManagerDelegate> {
    
	CLLocation *currentLocation;
	
	CLLocationCoordinate2D currentLocationCoordinates;
	
	double currentAltitude;
	
	double currentSpeed;
	
	double currentDirection;
	
	CLLocationManager *locationManager;
	
	id <FTLocationServicesDelegate> delegate;
	
}

@property (nonatomic, readonly) CLLocation *currentLocation;

@property (nonatomic, readonly) CLLocationCoordinate2D currentLocationCoordinates;

@property (nonatomic, readonly) double currentAltitude;

@property (nonatomic, readonly) double currentSpeed;

@property (nonatomic, readonly) double currentDirection;

@property (nonatomic, readonly) CLLocationManager *locationManager;

@property (nonatomic, assign) id <FTLocationServicesDelegate> delegate;


- (void)startUpdatingLocation;

- (void)stopUpdatingLocation;

- (CGFloat)currentDistanceToCoordinates:(CLLocationCoordinate2D)coordinates;

- (CGFloat)currentDistanceToPointCoordinates:(CGPoint)coordinates;


@end
