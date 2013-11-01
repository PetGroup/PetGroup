//
//  OwenrCell.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-24.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "OwenrCell.h"
#import "EGOImageView.h"
@interface OwenrCell ()
{
    UIButton *replyB;
    UIButton *reportB;
}
@property(nonatomic,retain)EGOImageView* headPhote;
@property(nonatomic,retain)UILabel* nameL;
@property(nonatomic,retain)UILabel* timeL;
@property(nonatomic,retain)UILabel* contentL;
@property(nonatomic,retain)UILabel* locationL;
@end
@implementation OwenrCell
@synthesize mediaPlayers;
- (NSMutableSet *)mediaPlayers
{
	if (!mediaPlayers)
	{
		mediaPlayers = [[NSMutableSet alloc] init];
	}
	
	return mediaPlayers;
}
+(CGFloat)heightForRowWithArticle:(Article*)article
{
    return 100;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.headPhote = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        _headPhote.placeholderImage = [UIImage imageNamed:@"headbg"];
        [self.contentView addSubview:_headPhote];
        
        self.textView = [[DTAttributedTextContentView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
        
        self.textView.shouldDrawImages = NO;
        self.textView.shouldDrawLinks = NO;
        self.textView.delegate = self;
        self.textView.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:self.textView];
        
        self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 50, 12)];
        _nameL.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nameL];
        
        self.timeL = [[UILabel alloc]initWithFrame:CGRectMake(70, 40, 100, 12)];
        _timeL.font = [UIFont systemFontOfSize:14];
        _timeL.textColor = [UIColor grayColor];
        [self.contentView addSubview:_timeL];
        
        self.locationL = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 140, 20)];
        _locationL.numberOfLines = 0;
        _locationL.text = @"楼主";
        _locationL.font = [UIFont systemFontOfSize:14];
        _locationL.textColor = [UIColor grayColor];
        [self.contentView addSubview:_locationL];
        
        self.contentL = [[UILabel alloc]initWithFrame:CGRectMake(260, 10, 50, 12)];
        _contentL.font = [UIFont systemFontOfSize:14];
        _contentL.textColor = [UIColor grayColor];
        [self.contentView addSubview:_contentL];
        
        replyB = [UIButton buttonWithType:UIButtonTypeCustom];
        [replyB setTitle:@"回复" forState:UIControlStateNormal];
        [replyB setBackgroundImage:[UIImage imageNamed:@"huifu_normal"] forState:UIControlStateNormal];
        [replyB setBackgroundImage:[UIImage imageNamed:@"huifu_click"] forState:UIControlStateHighlighted];
        [replyB addTarget:self action:@selector(replyAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:replyB];
        reportB = [UIButton buttonWithType:UIButtonTypeCustom];
        [reportB setTitle:@"举报" forState:UIControlStateNormal];
        [reportB addTarget:self action:@selector(reportAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:reportB];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _headPhote.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.article.headImage]];
    _nameL.text = self.article.userName;
    _timeL.text = self.article.ct;
}
-(void)replyAction
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(owenrCellPressReplyButtonAtIndexPath:)]) {
        [self.delegate owenrCellPressReplyButtonAtIndexPath:self.indexPath];
    }
}
-(void)reportAction
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(owenrCellPressReportButtonAtIndexPath:)]) {
        [self.delegate owenrCellPressReportButtonAtIndexPath:self.indexPath];
    }
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
		DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
		imageView.delegate = self;
		
		// sets the image if there is one
		imageView.image = [(DTImageTextAttachment *)attachment image];
		
		// url for deferred loading
		imageView.url = attachment.contentURL;
		
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
			UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
			[button addGestureRecognizer:longPress];
			
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
        
    }
    else
    {
        NSURL *URL = button.URL;
        
        if ([[UIApplication sharedApplication] canOpenURL:[URL absoluteURL]])
        {
            [[UIApplication sharedApplication] openURL:[URL absoluteURL]];
        }
        else
        {
            if (![URL host] && ![URL path])
            {
                
                // possibly a local anchor link
                NSString *fragment = [URL fragment];
                
                if (fragment)
                {
                    //				[self.textView scrollToAnchorNamed:fragment animated:NO];
                }
            }
        }
    }
}

@end
