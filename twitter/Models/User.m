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
        
        // set profile image URL
        self.profileImageURL = [NSURL URLWithString:dictionary[@"profile_image_url"]];
    }
    
    return self;
}

@end
