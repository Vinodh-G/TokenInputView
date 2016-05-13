//
//  UserTableCell.m
//  TokenInputView
//
//  Created by Vinodh Swamy on 4/25/16.
//  Copyright © 2016 Vinodh Swamy. All rights reserved.
//

#import "UserTableCell.h"

@interface UserTableCell ()

@end

@implementation UserTableCell

+(id)userTableCell
{
    UserTableCell *userCell = [[[NSBundle mainBundle] loadNibNamed:@"UserTableCell"
                                                                          owner:nil
                                                                        options:nil] lastObject];
    return userCell;
}

- (void)prepareForReuse {
    self.userNameLabel.text = @"";
//    self.userImageview.image = [UIImage imageNamed:@"dummy_profil_image"];
}

@end
