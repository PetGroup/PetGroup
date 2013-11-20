//
//  UncaughtExceptionHandler.h
//  PaoPaoArProThird
//
//  Created by hapame on 12-10-10.
//
//
#import <UIKit/UIKit.h>
//#import <Foundation/Foundation.h>

@interface UncaughtExceptionHandler : NSObject
{
    BOOL dismissed;
}
@end
void InstallUncaughtExceptionHandler();