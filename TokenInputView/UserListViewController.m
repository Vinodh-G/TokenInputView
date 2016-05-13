//
//  UserListViewController.m
//  TokenInputView
//
//  Created by Vinodh Swamy on 4/25/16.
//  Copyright © 2016 Vinodh Swamy. All rights reserved.
//

#import "UserListViewController.h"
#import "UserTableCell.h"

static CGFloat const kStandardAnimationTime = 0.2f;

static const NSString *kNameKey = @"Name";

@interface UserListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *usersTableView;
@property (weak, nonatomic) IBOutlet UIView *noResultsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noResultsTopConstraint;

@property (nonatomic, copy) SelectedUserCompletionBlock selectedUserBlock;
@property (nonatomic, copy) DeselectedUsersCompletionBlock deSelectedUserBlock;
@property (nonatomic) NSArray *userList;
@property (nonatomic) NSString *currentUserSearchTag;
@property (nonatomic) NSArray *addedUsers;

@property (nonatomic) NSArray *dummyUsers;
@end


@implementation UserListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showNoRecordsView:NO];
    
    self.dummyUsers = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UsersList" ofType:@"plist"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

#pragma mark -
#pragma mark Interface

+ (id)userListController
{
    UserListViewController *userListController = [[UserListViewController alloc] initWithNibName:NSStringFromClass([UserListViewController class]) bundle:nil];
    return userListController;
}

- (void)searchUserForUserName:(NSString *)userName withCompletionBlock:(SelectedUserCompletionBlock)block
{
    self.selectedUserBlock = block;
    self.currentUserSearchTag = [userName stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] ;
    [self searchUsersForText:self.currentUserSearchTag];
}

- (void)searchUserForUserName:(NSString *)userName
                addedUsers:(NSArray *)addedUsers
        withSelectedUserBlock:(SelectedUserCompletionBlock)selectedUserBlock
          deselectedUserBlock:(DeselectedUsersCompletionBlock)deselectedUserblock
{
    self.selectedUserBlock = selectedUserBlock;
    self.deSelectedUserBlock = deselectedUserblock;
    self.addedUsers = addedUsers;
    self.currentUserSearchTag = [userName stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] ;
    [self searchUsersForText:self.currentUserSearchTag];
}

- (void)resetUserListScreen
{
    self.currentUserSearchTag = nil;
    self.userList = nil;
    [self reloadAllSections];
}

#pragma mark -
#pragma mark UITableViewDatasource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger noOfRows = 0;
    noOfRows = [self.userList count];
    return noOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCellId"];
    if (!cell)
    {
        cell = [UserTableCell userTableCell];
    }
    
    NSDictionary *user = self.userList[indexPath.row];
    [self configureCell:cell ForUser:user];
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *user = self.userList[indexPath.row];    
    if (self.selectedUserBlock)
    {
        self.selectedUserBlock(YES, user, nil);
    }
    [self.usersTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.didScrollBlock)
    {
        self.didScrollBlock();
    }
}

#pragma mark -
#pragma mark Private
- (void)searchUsersForText:(NSString *)searchText
{
    NSString *predicateString = [NSString stringWithFormat:@"Name contains[c] '%@'", searchText];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    NSArray *users =[self.dummyUsers filteredArrayUsingPredicate:predicate];
    
    self.userList = users;
    [self reloadAllSections];
}

- (void)reloadAllSections
{
    [self.usersTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self showNoRecordsView:NO];
}

- (void)showNoRecordsView:(BOOL)show
{
    if (show && self.noResultsView.hidden && [self.currentUserSearchTag length])
    {
        self.noResultsView.hidden = NO;
        [UIView animateWithDuration:kStandardAnimationTime animations:^{
            self.noResultsView.alpha = 1.0;
        }];
    }
    else if (!show && !self.noResultsView.hidden)
    {
        [UIView animateWithDuration:kStandardAnimationTime animations:^{
            self.noResultsView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            self.noResultsView.hidden = YES;
        }];
    }
}

- (void)configureCell:(UserTableCell *)cell ForUser:(NSDictionary *)user
{
    cell.userNameLabel.text = user[kNameKey];
    
    cell.accessoryType = [self isUserAlreadySelected:user] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

- (BOOL)isUserAlreadySelected:(NSDictionary *)user
{
    BOOL isSelected = NO;
    isSelected = [self.addedUsers containsObject:user];
    return isSelected;
}

#pragma mark -
#pragma mark Keyboard Notifications

- (void)keyboardDidShow:(NSNotification *)notification
{
    CGSize keyBoardSize = [[[notification userInfo]
                            objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue].size;
    
    CGFloat originX = (self.noResultsView.bounds.size.height - keyBoardSize.height) / 2;
    self.noResultsTopConstraint.constant = originX;
}
@end
