//
//  VSAddMembersViewController.h
//  TokenInputView
//
//  Created by Vinodh Swamy on 4/25/16.
//  Copyright © 2016 Vinodh Swamy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VSToken;

typedef void (^AddMembersCompletionBlock)(BOOL succes, NSArray *members, NSError *error);

@interface VSAddMembersViewController : UIViewController

@property (nonatomic, copy) AddMembersCompletionBlock addMembersBlock;
@property (nonatomic) VSToken *selectedToken;

- (void)configureAddMembersViewForMembers:(NSArray *)members;
@end
