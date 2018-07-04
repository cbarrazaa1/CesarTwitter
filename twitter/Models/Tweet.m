//
//  Tweet.m
//  twitter
//
//  Created by César Francisco Barraza on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "Tweet.h"
#import "NSDate+DateTools.h"

@implementation Tweet
- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    
    if(self)
    {
        // check if this is a retweet
        NSDictionary* originalTweet = dictionary[@"retweeted_status"];
        if(originalTweet != nil)
        {
            self.retweetedByUser = [[User alloc] initWithDictionary:dictionary[@"user"]];
            dictionary = originalTweet;
        }
        
        // set basic properties
        self.ID = dictionary[@"id_str"];
        self.text = dictionary[@"text"];
        
        // set bools (convert from nsnumber to actual bool)
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        
        // format the date
        NSString* originalDate = dictionary[@"created_at"];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        
        // configure the format that we are using right now
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
        
        // convert string to date
        NSDate* date = [formatter dateFromString:originalDate];
        
        // get possible date formats
        NSString* shortDate = date.shortTimeAgoSinceNow;
        char timeCharacter = [shortDate characterAtIndex:(shortDate.length - 1)];
        
        // only use short date if we're talking about seconds, minutes, hours or days
        if(timeCharacter == 's' || timeCharacter == 'm' || timeCharacter == 'h' || timeCharacter == 'd')
        {
            self.creationDate = shortDate;
        }
        else
        {
            // configure output format
            formatter.dateStyle = NSDateFormatterShortStyle;
            formatter.timeStyle = NSDateFormatterNoStyle;
            self.creationDate = [formatter stringFromDate:date];
        }
    }
    
    return self;
}

+ (NSMutableArray*)tweetsWithArray:(NSArray*)dictionaries  {
    NSMutableArray* res = [[NSMutableArray alloc] init];
    
    for(NSDictionary* dictionary in dictionaries)
    {
        [res addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    
    return res;
}
@end
