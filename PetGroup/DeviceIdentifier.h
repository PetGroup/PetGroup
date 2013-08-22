//
//  DeviceIdentifier.h
//  Wesync
//
//  Created by yongrong on 12-10-29.
//  Copyright (c) 2012年 sina weibo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DeviceIdentifier : NSObject
- (NSString *) macaddress;
/*
 * @method uniqueDeviceIdentifier
 * @description use this method when you need a unique identifier in one app.
 * It generates a hash from the MAC-address in combination with the bundle identifier
 * of your app.
 */

- (NSString *) uniqueDeviceIdentifier;

/*
 * @method uniqueGlobalDeviceIdentifier
 * @description use this method when you need a unique global identifier to track a device
 * with multiple apps. as example a advertising network will use this method to track the device
 * from different apps.
 * It generates a hash from the MAC-address only.
 */

- (NSString *) uniqueGlobalDeviceIdentifier;

@end
