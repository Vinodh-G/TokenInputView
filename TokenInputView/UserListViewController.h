//
//  UserListViewController.h
//  TokenInputView
//
//  Created by Vinodh Swamy on 4/25/16.
//  Copyright © 2016 Vinodh Swamy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCUser;

typedef void (^SelectedUserCompletionBlock)(BOOL succes, NSDictionary *user, NSError *error);
typedef void (^DeselectedUsersCompletionBlock)(BOOL succes, NSDictionary *user, NSError *error);
typedef void (^DidScrollBlock)();
@interface UserListViewController : UIViewController
@property (nonatomic, copy) DidScrollBlock didScrollBlock;

+ (id)userListController;
- (void)searchUserForUserName:(NSString *)userName
          withCompletionBlock:(SelectedUserCompletionBlock)block;

- (void)searchUserForUserName:(NSString *)userName
                   addedUsers:(NSArray *)addedUsers
        withSelectedUserBlock:(SelectedUserCompletionBlock)selectedUserBlock
          deselectedUserBlock:(DeselectedUsersCompletionBlock)deselectedUserblock;

- (void)resetUserListScreen;
@end
