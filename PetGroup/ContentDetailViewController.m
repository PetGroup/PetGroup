//
//  ContentDetailViewController.m
//  PetGroup
//
//  Created by Tolecen on 13-11-28.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "ContentDetailViewController.h"

@interface ContentDetailViewController ()

@end

@implementation ContentDetailViewController
@synthesize mediaPlayers;
- (NSMutableSet *)mediaPlayers
{
	if (!mediaPlayers)
	{
		mediaPlayers = [[NSMutableSet alloc] init];
	}
	
	return mediaPlayers;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.typeName = @"宠物介绍";
        self.needDismiss = NO;
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    float diffH = [Common diffHeight:self];
    
    
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
    [backButton setBackgroundImage:diffH==0.0f?[UIImage imageNamed:@"back2.png"]:[UIImage imageNamed:@"backnew.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2+diffH, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [titleLabel setText:self.typeName];
    [self.view addSubview:titleLabel];
    
    if (self.contentType==contentTypeTextView) {
        _textView = [[DTAttributedTextView alloc] initWithFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-44-diffH)];
        _textView.shouldDrawImages = NO;
        _textView.shouldDrawLinks = NO;
        _textView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        _textView.textDelegate = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [_textView addGestureRecognizer:tap];
        _textView.contentInset = UIEdgeInsetsMake(10, 10, 54, 10);
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.view addSubview:_textView];
        [self getArticleByID:self.articleID];
    }
    else
    {
        theWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-44-diffH)];
        theWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        theWebView.delegate = self;
        [theWebView loadRequest:[NSURLRequest requestWithURL:self.addressURL]];
        [self.view addSubview:theWebView];
        

    }
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.delegate = self;
    hud.labelText = @"正在加载...";
    [hud show:YES];


	// Do any additional setup after loading the view.
}
-(void)getArticleByID:(NSString *)theID
{
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:theID forKey:@"id"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:params forKey:@"params"];
    [body setObject:@"getExperById" forKey:@"method"];
    [body setObject:@"service.uri.pet_exper" forKey:@"service"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        _textView.attributedString = [self _attributedStringForSnippetUsingiOS6Attributes:NO String:[responseObject objectForKey:@"info"]];
        [hud hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
    }];

}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [hud show:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [hud hide:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [hud hide:YES];
    [webView stopLoading];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网页加载失败" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"重新加载", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [theWebView reload];
    }
}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
    if (_textView) {
        if (![self respondsToSelector:@selector(topLayoutGuide)])
        {
            return;
        }
        
        // this also compiles with iOS 6 SDK, but will work with later SDKs too
        CGFloat topInset = [[self valueForKeyPath:@"topLayoutGuide.length"] floatValue];
        CGFloat bottomInset = [[self valueForKeyPath:@"bottomLayoutGuide.length"] floatValue];
        
        UIEdgeInsets outerInsets = UIEdgeInsetsMake(topInset, 0, bottomInset, 0);
        UIEdgeInsets innerInsets = outerInsets;
        innerInsets.left += 10;
        innerInsets.right += 10;
        innerInsets.top += 10;
        innerInsets.bottom += 10;
        
        CGPoint innerScrollOffset = CGPointMake(-innerInsets.left, -innerInsets.top);
        
        _textView.contentInset = innerInsets;
        _textView.contentOffset = innerScrollOffset;
        _textView.scrollIndicatorInsets = outerInsets;

    }
	
	
}

- (NSAttributedString *)_attributedStringForSnippetUsingiOS6Attributes:(BOOL)useiOS6Attributes String:(NSString *)contentStr
{
    NSString * regExStr = @"\\[([a-zA-Z0-9\\u4e00-\\u9fa5]+?)\\]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regExStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    
    NSString *facefilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"emotionImageThird.plist"];
    NSDictionary *m_pEmojiDic = [[NSDictionary alloc] initWithContentsOfFile:facefilePath];
    
    //    __block NSMutableArray  * keyArray = [NSMutableArray array];
    __block NSMutableArray  * rangeArray = [NSMutableArray array];
    __block NSMutableArray  * lengthArray = [NSMutableArray array];
    __block NSMutableArray  * replacementArray = [NSMutableArray array];
    [regex enumerateMatchesInString:contentStr options:0 range:NSMakeRange(0, [contentStr length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSString * resultStr = [contentStr substringWithRange:[result rangeAtIndex:1]];
        NSLog(@"images = %@",resultStr);
        NSLog(@"range = %d,%d",[result rangeAtIndex:1].location,[result rangeAtIndex:1].length);
        //        [keyArray addObject:resultStr];
        [rangeArray addObject:[NSNumber numberWithInt:([result rangeAtIndex:1].location-1)]];
        [lengthArray addObject:[NSNumber numberWithInt:([result rangeAtIndex:1].length+2)]];
        if (m_pEmojiDic[resultStr]) {
            [replacementArray addObject:[NSString stringWithFormat:@"<img src=\"%@\" width=\"18\" height=\"18\" />",m_pEmojiDic[resultStr]]];
        }
        else
            [replacementArray addObject:resultStr];
        //       [timeTimes addObject:[tmp substringWithRange:[result rangeAtIndex:1]]];
    }];
    NSMutableString * uu = [[NSMutableString alloc] initWithString:contentStr];
    int lengthC = uu.length;
    for (int i = 0; i<rangeArray.count;i++) {
        int d = uu.length - lengthC;
        [uu replaceCharactersInRange:NSMakeRange([rangeArray[i] integerValue]+d, [lengthArray[i] integerValue]) withString:replacementArray[i]];
    }
    NSData *data = [uu dataUsingEncoding:NSUTF8StringEncoding];
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithHTMLData:data documentAttributes:NULL];
	return attributedString;
}
#pragma mark Custom Views on Text

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttributedString:(NSAttributedString *)string frame:(CGRect)frame
{
	NSDictionary *attributes = [string attributesAtIndex:0 effectiveRange:NULL];
	
	NSURL *URL = [attributes objectForKey:DTLinkAttribute];
	NSString *identifier = [attributes objectForKey:DTGUIDAttribute];
	
	
	DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
	button.URL = URL;
	button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
	button.GUID = identifier;
	
	// get image with normal link text
	UIImage *normalImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDefault];
	[button setImage:normalImage forState:UIControlStateNormal];
	
	// get image for highlighted link text
	UIImage *highlightImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDrawLinksHighlighted];
	[button setImage:highlightImage forState:UIControlStateHighlighted];
	
	// use normal push action for opening URL
	[button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
	
	// demonstrate combination with long press
	UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
	[button addGestureRecognizer:longPress];
	
	return button;
}

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
	if ([attachment isKindOfClass:[DTVideoTextAttachment class]])
	{
		NSURL *url = (id)attachment.contentURL;
		
		// we could customize the view that shows before playback starts
		UIView *grayView = [[UIView alloc] initWithFrame:frame];
		grayView.backgroundColor = [DTColor blackColor];
		
		// find a player for this URL if we already got one
		MPMoviePlayerController *player = nil;
		for (player in self.mediaPlayers)
		{
			if ([player.contentURL isEqual:url])
			{
				break;
			}
		}
		
		if (!player)
		{
			player = [[MPMoviePlayerController alloc] initWithContentURL:url];
			[self.mediaPlayers addObject:player];
		}
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_4_2
		NSString *airplayAttr = [attachment.attributes objectForKey:@"x-webkit-airplay"];
		if ([airplayAttr isEqualToString:@"allow"])
		{
			if ([player respondsToSelector:@selector(setAllowsAirPlay:)])
			{
				player.allowsAirPlay = YES;
			}
		}
#endif
		
		NSString *controlsAttr = [attachment.attributes objectForKey:@"controls"];
		if (controlsAttr)
		{
			player.controlStyle = MPMovieControlStyleEmbedded;
		}
		else
		{
			player.controlStyle = MPMovieControlStyleNone;
		}
		
		NSString *loopAttr = [attachment.attributes objectForKey:@"loop"];
		if (loopAttr)
		{
			player.repeatMode = MPMovieRepeatModeOne;
		}
		else
		{
			player.repeatMode = MPMovieRepeatModeNone;
		}
		
		NSString *autoplayAttr = [attachment.attributes objectForKey:@"autoplay"];
		if (autoplayAttr)
		{
			player.shouldAutoplay = YES;
		}
		else
		{
			player.shouldAutoplay = NO;
		}
		
		[player prepareToPlay];
		
		player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		player.view.frame = grayView.bounds;
		[grayView addSubview:player.view];
		
		return grayView;
        //        return nil;
	}
	else if ([attachment isKindOfClass:[DTImageTextAttachment class]])
	{
		// if the attachment has a hyperlinkURL then this is currently ignored
		EGOImageButton *imageView = [[EGOImageButton alloc] initWithFrame:frame];
        if (frame.size.width<50) {
            imageView.backgroundColor = [UIColor clearColor];
        }
        else
        {
            imageView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        }
        //		imageView.delegate = self;
		
		// sets the image if there is one
        //		imageView.image = [(DTImageTextAttachment *)attachment image];
		
		// url for deferred loading
		imageView.imageURL = attachment.contentURL;
		
		// if there is a hyperlink then add a link button on top of this image
		if (attachment.hyperLinkURL)
		{
			// NOTE: this is a hack, you probably want to use your own image view and touch handling
			// also, this treats an image with a hyperlink by itself because we don't have the GUID of the link parts
			imageView.userInteractionEnabled = YES;
			
			DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:imageView.bounds];
            button.tag = ButtonTypeImage;
			button.URL = attachment.hyperLinkURL;
			button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
			button.GUID = attachment.hyperLinkGUID;
			
			// use normal push action for opening URL
			[button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
			
			// demonstrate combination with long press
            //			UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
            //			[button addGestureRecognizer:longPress];
			
			[imageView addSubview:button];
		}
		
		return imageView;
	}
	else if ([attachment isKindOfClass:[DTIframeTextAttachment class]])
	{
		DTWebVideoView *videoView = [[DTWebVideoView alloc] initWithFrame:frame];
		videoView.attachment = attachment;
		
		return videoView;
	}
	else if ([attachment isKindOfClass:[DTObjectTextAttachment class]])
	{
		// somecolorparameter has a HTML color
		NSString *colorName = [attachment.attributes objectForKey:@"somecolorparameter"];
		UIColor *someColor = DTColorCreateWithHTMLName(colorName);
		
		UIView *someView = [[UIView alloc] initWithFrame:frame];
		someView.backgroundColor = someColor;
		someView.layer.borderWidth = 1;
		someView.layer.borderColor = [UIColor blackColor].CGColor;
		
		someView.accessibilityLabel = colorName;
		someView.isAccessibilityElement = YES;
		
		return someView;
	}
	
	return nil;
}

- (BOOL)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView shouldDrawBackgroundForTextBlock:(DTTextBlock *)textBlock frame:(CGRect)frame context:(CGContextRef)context forLayoutFrame:(DTCoreTextLayoutFrame *)layoutFrame
{
	UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(frame,1,1) cornerRadius:10];
    
	CGColorRef color = [textBlock.backgroundColor CGColor];
	if (color)
	{
		CGContextSetFillColorWithColor(context, color);
		CGContextAddPath(context, [roundedRect CGPath]);
		CGContextFillPath(context);
		
		CGContextAddPath(context, [roundedRect CGPath]);
		CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
		CGContextStrokePath(context);
		return NO;
	}
	
	return YES; // draw standard background
}
- (void)linkPushed:(DTLinkButton *)button
{
    if (button.tag==ButtonTypeImage) {

        NSArray *imageArray = [[NSString stringWithFormat:@"%@",button.URL] componentsSeparatedByString:@"/pet-file-server/get/"];
        NSString * imageID;
        if (imageArray.count>0) {
            imageID = imageArray[1];
        }
        else
            imageID = [NSString stringWithFormat:@"%@",button.URL];
        PhotoViewController* photoVC = [[PhotoViewController alloc]initWithSmallImages:nil images:@[imageID] indext:0];
        [self presentViewController:photoVC animated:NO completion:nil];
        
    }
    else
    {
        NSURL *URL = button.URL;
        
        if ([[UIApplication sharedApplication] canOpenURL:[URL absoluteURL]])
        {
            WebViewViewController* webVC = [[WebViewViewController alloc]init];
            webVC.addressURL = URL;
            [self presentViewController:webVC animated:YES completion:^{
                
            }];

        }
        else
        {
            if (![URL host] && ![URL path])
            {
                
                // possibly a local anchor link
                NSString *fragment = [URL fragment];
                
                if (fragment)
                {

                }
            }
        }
    }
}
- (void)linkLongPressed:(UILongPressGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateBegan)
	{

	}
}

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateRecognized)
	{
		CGPoint location = [gesture locationInView:_textView];
		NSUInteger tappedIndex = [_textView closestCursorIndexToPoint:location];
		
		NSString *plainText = [_textView.attributedString string];
		NSString *tappedChar = [plainText substringWithRange:NSMakeRange(tappedIndex, 1)];
		
		__block NSRange wordRange = NSMakeRange(0, 0);
		
		[plainText enumerateSubstringsInRange:NSMakeRange(0, [plainText length]) options:NSStringEnumerationByWords usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
			if (NSLocationInRange(tappedIndex, enclosingRange))
			{
				*stop = YES;
				wordRange = substringRange;
			}
		}];
		
		NSString *word = [plainText substringWithRange:wordRange];
		NSLog(@"%d: '%@' word: '%@'", tappedIndex, tappedChar, word);
	}
}
-(void)backButton
{
    if (self.needDismiss) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        return;
    }
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
