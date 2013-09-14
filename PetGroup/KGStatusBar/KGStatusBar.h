//
//  KGStatusBar.h
//
//  Created by Kevin Gibbon on 2/27/13.
//  Copyright 2013 Kevin Gibbon. All rights reserved.
//  @kevingibbon
//

//Modified by Tolecen on 9/14/2013

#import <UIKit/UIKit.h>

@interface KGStatusBar : UIView

+(void)showStatusBarWithoutAutoHide:(NSString *)status;
+ (void)showWithStatus:(NSString*)status;
+ (void)showErrorWithStatus:(NSString*)status;
+ (void)showSuccessWithStatus:(NSString*)status;
+ (void)dismiss;

@end
