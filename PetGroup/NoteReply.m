//
//  NoteReply.m
//  PetGroup
//
//  Created by Tolecen on 13-11-5.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "NoteReply.h"

@implementation NoteReply
- (id)initWithDictionnary:(NSDictionary*)info
{
    self = [super init];
    if (self) {
        self.replyID = [info objectForKey:@"id"];
        self.ParentID = [info objectForKey:@"pid"];
        self.noteID = [info objectForKey:@"noteId"];
        self.userID = [info objectForKey:@"userId"];
        NSArray *arr = [[info objectForKey:@"userIcon"] componentsSeparatedByString:@"_"];
        self.headImage = arr[0];
        self.userName = [info objectForKey:@"nickname"];
        self.ct = [Common DynamicCurrentTime:[Common getCurrentTime] AndMessageTime:[info objectForKey:@"ct"]];
        self.content = [NoteReply _attributedStringForSnippetUsingiOS6Attributes:NO String:[info objectForKey:@"content"]];
        self.state = [info objectForKey:@"state"];
    }
    return self;
}
+ (NSAttributedString *)_attributedStringForSnippetUsingiOS6Attributes:(BOOL)useiOS6Attributes String:(NSString *)contentStr
{
    NSData *data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithHTMLData:data documentAttributes:NULL];
	return attributedString;
}
@end
