//
//  AnimationStoreManager.m
//  testTab
//
//  Created by liuxiaoyu on 14-1-3.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "AnimationStoreManager.h"
#define ARC4RANDOM_MAX      0x100000000
@interface AnimationStoreManager()

@property (nonatomic, strong) NSMutableArray *stackArray;

@property (nonatomic, weak) UIView *targetView;

@end

@implementation AnimationStoreManager

+ (instancetype)sharedManager {
	static AnimationStoreManager *_storeManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_storeManager = [[AnimationStoreManager alloc] init];
	});
	return _storeManager;
}

- (NSMutableArray *)stackArray {
	if (!_stackArray) {
		_stackArray = [NSMutableArray array];
	}
	return _stackArray;
}

- (void)doAnimationWithTypeArray:(NSArray *)typeArray view:(UIView *)view{
	int count = typeArray.count>2? typeArray.count* 8:typeArray.count* 12;
	for (int i=0; i < count; i++) {
		UILabel *animationLabel = [[UILabel alloc] init];
        animationLabel.backgroundColor = [UIColor clearColor];
		animationLabel.text = typeArray[(i%typeArray.count)];
		[animationLabel sizeToFit];
		animationLabel.center = CGPointMake(view.frame.size.width/2, -100);
		int toPointX = arc4random()%320;
		UIBezierPath *movePath = [UIBezierPath bezierPath];
		[movePath moveToPoint:animationLabel.center];
		[movePath addLineToPoint:CGPointMake(toPointX, view.frame.size.height)];
		
		
		CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
		moveAnim.path = movePath.CGPath;
		moveAnim.removedOnCompletion = YES;
		
		double val = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 100.0f);
		NSLog(@"%lf",val/100);
		
		CAAnimationGroup *animGroup = [CAAnimationGroup animation];
		animGroup.animations = @[moveAnim];
		animGroup.duration = 2.5+val/100;
		animGroup.delegate = self;
		[animationLabel.layer addAnimation:animGroup forKey:nil];
		[view addSubview:animationLabel];
        
		NSDictionary *currentDictionary = @{@"currentAnim": animGroup.animations[0],@"currentLabel": animationLabel};
		[self.stackArray addObject:currentDictionary];
	}
	self.targetView = view;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
	CAAnimationGroup *animGroup = (CAAnimationGroup *)anim;
	CAKeyframeAnimation *keyAnim = animGroup.animations[0];

	if (flag == YES) {
		[self.stackArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
			if ([obj[@"currentAnim"] isEqual:keyAnim]) {
				[obj[@"currentLabel"] removeFromSuperview];
				*stop = YES;
			}
		}];
	}
}

@end
