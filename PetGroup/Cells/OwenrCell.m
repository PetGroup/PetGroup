//
//  OwenrCell.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-24.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "OwenrCell.h"

@interface OwenrCell ()
{
    UIButton *replyB;
    UIButton *reportB;
}
@property(nonatomic,retain)UIImageView* buttonIV;
@property(nonatomic,retain)UILabel* titleL;
@property(nonatomic,retain)UILabel* readL;
@property(nonatomic,retain)UILabel* replyL;
@property(nonatomic,retain)UIView* backV;
@property(nonatomic,retain)UIView* lineV;
@property(nonatomic,retain)EGOImageButton* headPhote;
@property(nonatomic,retain)UIButton* nameB;
@property(nonatomic,retain)UILabel* timeL;
@property(nonatomic,retain)UILabel* locationL;
@property (strong,nonatomic)DTAttributedTextContentView * textView;

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
+(CGFloat)heightForRowWithArticle:(AriticleContent*)article
{
    CGFloat origin = 10;
    CGSize size = [article.name sizeWithFont:[UIFont systemFontOfSize:18.0] constrainedToSize:CGSizeMake(300, 90) lineBreakMode:NSLineBreakByWordWrapping];
    origin += (size.height+10);
    origin += 79;
    NSNumber *high = [OwenrCell getRequiredHeightForTextView:article.content];
    origin += ([high floatValue]+50);
    return origin;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backV = [[UIView alloc]init];
        _backV.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [self.contentView addSubview:_backV];
        self.lineV = [[UIView alloc]init];
        _lineV.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_lineV];
        
        self.titleL = [[UILabel alloc]init];
        _titleL.backgroundColor = [UIColor clearColor];
        _titleL.numberOfLines = 0;
        _titleL.font = [UIFont systemFontOfSize:18.0];
        [self.contentView addSubview:_titleL];
        
        self.readL = [[UILabel alloc]init];
        _readL.font = [UIFont systemFontOfSize:14];
        _readL.textColor = [UIColor grayColor];
        _readL.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_readL];
        
        self.replyL = [[UILabel alloc]init];
        _replyL.backgroundColor = [UIColor clearColor];
        _replyL.font = [UIFont systemFontOfSize:14];
        _replyL.textColor = [UIColor grayColor];
        [self.contentView addSubview:_replyL];
        
        self.headPhote = [[EGOImageButton alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        [_headPhote addTarget:self action:@selector(PersonDetail) forControlEvents:UIControlEventTouchUpInside];
        _headPhote.placeholderImage = [UIImage imageNamed:@"headbg"];
        [self.contentView addSubview:_headPhote];
        
        self.textView = [[DTAttributedTextContentView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
        
        self.textView.shouldDrawImages = NO;
        self.textView.shouldDrawLinks = NO;
        self.textView.delegate = self;
        self.textView.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:self.textView];
        
        self.nameB = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nameB setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_nameB addTarget:self action:@selector(PersonDetail) forControlEvents:UIControlEventTouchUpInside];
        _nameB.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_nameB];
        
        self.timeL = [[UILabel alloc]initWithFrame:CGRectMake(70, 40, 100, 20)];
        _timeL.font = [UIFont systemFontOfSize:14];
        _timeL.textColor = [UIColor grayColor];
        [self.contentView addSubview:_timeL];
        
        self.locationL = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 140, 20)];
        _locationL.numberOfLines = 0;
        _locationL.text = @"楼主";
        _locationL.font = [UIFont systemFontOfSize:14];
        _locationL.textColor = [UIColor grayColor];
        [self.contentView addSubview:_locationL];
        
        self.buttonIV = [[UIImageView alloc]init];
        float diffH = [Common diffHeight:nil];
        if (diffH==0.0f) {
            self.buttonIV.image = [UIImage imageNamed:@"dibuanniu_bg"];
        }
        else
            self.buttonIV.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        
        _buttonIV.userInteractionEnabled = YES;
        [self.contentView addSubview:_buttonIV];
        
        replyB = [UIButton buttonWithType:UIButtonTypeCustom];
        replyB.frame = CGRectMake(220, 5.5, 85, 28);
        [replyB.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [replyB setTitle:@"回复" forState:UIControlStateNormal];
        [replyB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [replyB setBackgroundImage:[UIImage imageNamed:@"huifu_normal"] forState:UIControlStateNormal];
        [replyB setBackgroundImage:[UIImage imageNamed:@"huifu_click"] forState:UIControlStateHighlighted];
        [replyB addTarget:self action:@selector(replyAction) forControlEvents:UIControlEventTouchUpInside];
        [_buttonIV addSubview:replyB];
        reportB = [UIButton buttonWithType:UIButtonTypeCustom];
        reportB.frame = CGRectMake(10, 4.5, 100, 31);
        [reportB setTitle:@"举报本话题" forState:UIControlStateNormal];
        [reportB.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [reportB setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [reportB addTarget:self action:@selector(reportAction) forControlEvents:UIControlEventTouchUpInside];
        [_buttonIV addSubview:reportB];
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
    CGFloat origin = 10;
    CGSize size = [self.article.name sizeWithFont:[UIFont systemFontOfSize:18.0] constrainedToSize:CGSizeMake(300, 90) lineBreakMode:NSLineBreakByWordWrapping];
    _titleL.frame = CGRectMake(10, origin, 300, size.height);
    _titleL.text = self.article.name;
    origin += (size.height+10);
    _readL.frame = CGRectMake(170, origin, 70, 12);
    _readL.text = [NSString stringWithFormat:@"浏览:%@",self.article.clientCount];
    
    _replyL.frame = CGRectMake(250, origin, 70, 12);
    _replyL.text = [NSString stringWithFormat:@"回复:%@",self.article.replyCount];
    origin += 22;
    _backV.frame = CGRectMake(0, 0, 320, origin);
    
    _lineV.frame = CGRectMake(0, origin, 320, 1);
    
    origin += 10;
    _headPhote.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.article.headImage]];
    _headPhote.frame = CGRectMake(10, origin, 40, 40);
    
    CGSize nameSize = [self.article.userName sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(160, 20) lineBreakMode:NSLineBreakByWordWrapping];
    [_nameB setTitle:self.article.userName forState:UIControlStateNormal] ;
    _nameB.frame = CGRectMake(60, origin, nameSize.width, 20);
    
    _locationL.frame =CGRectMake(250, origin, 60, 20);
    _locationL.textAlignment = NSTextAlignmentRight;
    origin += 25;
    _timeL.text = self.article.ct;
    _timeL.frame = CGRectMake(60, origin, 240, 20);
    origin += 22;
    
    NSNumber *high = [OwenrCell getRequiredHeightForTextView:self.article.content];
    _textView.frame = CGRectMake(0, origin, 320, [high floatValue]);
    _textView.attributedString = self.article.content;
    
    origin += ([high floatValue] + 10);
    
    _buttonIV.frame = CGRectMake(0, origin, 320, 40);
}
-(void)replyAction
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(owenrCellPressReplyButton)]) {
        [self.delegate owenrCellPressReplyButton];
    }
}
-(void)reportAction
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(owenrCellPressReportButton)]) {
        [self.delegate owenrCellPressReportButton];
    }
}
-(void)PersonDetail
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(owenrCellPressNameButtonOrHeadButton)]) {
        [self.delegate owenrCellPressNameButtonOrHeadButton];
    }
}
#pragma mark -
#pragma mark - 哈哈哈

+(NSNumber *)getRequiredHeightForTextView:(NSAttributedString *)attributeStr
{
    DTAttributedTextContentView * atextView = [[DTAttributedTextContentView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    atextView.attributedString = attributeStr;
    atextView.shouldDrawImages = YES;
    atextView.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    atextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    CGSize gg = [atextView suggestedFrameSizeToFitEntireStringConstraintedToWidth:320];
    return [NSNumber numberWithFloat:gg.height];
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
        imageView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
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
        if (self.delegate&&[self.delegate respondsToSelector:@selector(owenrCellPressImageWithID:)]) {
            NSMutableString* imageID = [NSMutableString  stringWithFormat:@"%@",button.URL];
            [imageID deleteCharactersInRange:[imageID rangeOfString:BaseImageUrl]];
            [self.delegate owenrCellPressImageWithID:imageID];
        }
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
                    if (self.delegate&&[self.delegate respondsToSelector:@selector(owenrCellPressWithURL:)]) {
                        [self.delegate owenrCellPressWithURL:button.URL];
                    }
                    //				[self.textView scrollToAnchorNamed:fragment animated:NO];
                }
            }
        }
    }
}

@end
