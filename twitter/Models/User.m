//
//  User.m
//  twitter
//
//  Created by César Francisco Barraza on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if(self)
    {
        // set basic data
        self.ID = dictionary[@"id_str"];
        self.name = dictionary[@"name"];
        self.handle = dictionary[@"screen_name"];
        self.tweetsCount = [dictionary[@"statuses_count"] intValue];
        self.followingCount = [dictionary[@"friends_count"] intValue];
        self.followersCount = [dictionary[@"followers_count"] intValue];
        
        // set URLs
        self.profileImageURL = [NSURL URLWithString:dictionary[@"profile_image_url_https"]];
        self.backgroundImageURL = [NSURL URLWithString:dictionary[@"profile_background_image_url_https"]];
    }
    
    return self;
}

@end
