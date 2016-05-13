//
//  UserTableCell.h
//  TokenInputView
//
//  Created by Vinodh Swamy on 4/25/16.
//  Copyright © 2016 Vinodh Swamy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCUser;

@interface UserTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageview;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

+(id)userTableCell;

@end
