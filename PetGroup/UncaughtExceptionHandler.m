//
//  UncaughtExceptionHandler.m
//  PaoPaoArProThird
//
//  Created by hapame on 12-10-10.
//
//

#import "UncaughtExceptionHandler.h"

#include <libkern/OSAtomic.h>

#include <execinfo.h>

NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";

NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";

NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

volatile int32_t UncaughtExceptionCount = 0;

const int32_t UncaughtExceptionMaximum = 10;

const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;

const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;

@implementation UncaughtExceptionHandler

+ (NSArray *)backtrace

{
    
    void* callstack[128];
    
    int frames = backtrace(callstack, 128);
    
    char **strs = backtrace_symbols(callstack, frames);
    
    int i;
    
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    
    for (
         
         i = UncaughtExceptionHandlerSkipAddressCount;
         
         i < UncaughtExceptionHandlerSkipAddressCount +
         
         UncaughtExceptionHandlerReportAddressCount;
         
         i++)
        
    {
        
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
        
    }
    
    free(strs);
    
    return backtrace;
    
}

- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex

{
    
    //if (anIndex == 0)
        
    {
        
        dismissed = YES;
        
    }
    
}

- (void)handleException:(NSException *)exception

{
    
    UIAlertView *alert =
    
    [[[UIAlertView alloc]
      
      initWithTitle:NSLocalizedString(@"程序运行错误", nil)
      
      message:[NSString stringWithFormat:NSLocalizedString(
                                                           
                                                           @"很抱歉！程序运行错误，您可以选择尝试继续，或退出再重新启动程序.\n"
                                                           
                                                           @"%@\n%@", nil),
               
               [exception reason],
               
               [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]]
      
      delegate:self
      
      cancelButtonTitle:NSLocalizedString(@"退出", nil)
      
      otherButtonTitles:NSLocalizedString(@"继续", nil), nil]
     
     autorelease];
    
    [alert show];
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    
    while (!dismissed)
        
    {
        
        for (NSString *mode in (NSArray *)allModes)
            
        {
            
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
            
        }
        
    }
    
    CFRelease(allModes);
    
    NSSetUncaughtExceptionHandler(NULL);
    
    signal(SIGABRT, SIG_DFL);
    
    signal(SIGILL, SIG_DFL);
    
    signal(SIGSEGV, SIG_DFL);
    
    signal(SIGFPE, SIG_DFL);
    
    signal(SIGBUS, SIG_DFL);
    
    signal(SIGPIPE, SIG_DFL);
    
    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName])
        
    {
        
        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
        
    }
    
    else
        
    {
        
        [exception raise];
        
    }
    
}

@end

NSString* getAppInfo()

{
    
    NSString *appInfo = [NSString stringWithFormat:@"App : %@ %@(%@)\nDevice : %@\nOS Version : %@ %@\nUDID : %@\n",
                         
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                         
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                         
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                         
                         [UIDevice currentDevice].model,
                         
                         [UIDevice currentDevice].systemName,
                         
                         [UIDevice currentDevice].systemVersion,
                         
                         @"ssssss"];
    
    NSLog(@"Crash!!!! %@", appInfo);
    
    return appInfo;
    
}

void MySignalHandler(int signal)

{
    
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    
    if (exceptionCount > UncaughtExceptionMaximum)
        
    {
        
        return;
        
    }
    
    NSMutableDictionary *userInfo =
    
    [NSMutableDictionary
     
     dictionaryWithObject:[NSNumber numberWithInt:signal]
     
     forKey:UncaughtExceptionHandlerSignalKey];
    
    NSArray *callStack = [UncaughtExceptionHandler backtrace];
    
    [userInfo
     
     setObject:callStack
     
     forKey:UncaughtExceptionHandlerAddressesKey];	
    
    [[[[UncaughtExceptionHandler alloc] init] autorelease]
     
     performSelectorOnMainThread:@selector(handleException:)
     
     withObject:
     
     [NSException
      
      exceptionWithName:UncaughtExceptionHandlerSignalExceptionName
      
      reason:
      
      [NSString stringWithFormat:
       
       NSLocalizedString(@"Signal %d was raised.\n"
                         
                         @"%@", nil),
       
       signal, getAppInfo()]
      
      userInfo:
      
      [NSDictionary
       
       dictionaryWithObject:[NSNumber numberWithInt:signal]
       
       forKey:UncaughtExceptionHandlerSignalKey]]
     
     waitUntilDone:YES];
    
}

void InstallUncaughtExceptionHandler()

{
    
    signal(SIGABRT, MySignalHandler);
    
    signal(SIGILL, MySignalHandler);
    
    signal(SIGSEGV, MySignalHandler);
    
    signal(SIGFPE, MySignalHandler);
    
    signal(SIGBUS, MySignalHandler);
    
    signal(SIGPIPE, MySignalHandler);
    
}
