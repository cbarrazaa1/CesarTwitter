//
//  ComposeViewController.m
//  twitter
//
//  Created by César Francisco Barraza on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UITextView *composeTextfield;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.composeTextfield becomeFirstResponder];
    
    /* TODO
    // load UI
    [self.profilePicture setImageWithURL:self.url];
    self.nameLabel.text = self.name;
    self.handleLabel.text = self.handle;
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tweetClick:(id)sender {
    [[APIManager shared] composeTweetWith:self.composeTextfield.text
                         completion:^(Tweet* tweet, NSError* error)
                         {
                             if(error == nil)
                             {
                                 [self.delegate didTweet:tweet];
                                 [self dismissViewControllerAnimated:YES completion:nil];
                             }
                             else
                             {
                                 NSLog(@"Error at 'tweetClick::completion': %@", error.localizedDescription);
                             }
                         }
     ];
}

- (IBAction)closeClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
