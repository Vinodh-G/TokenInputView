//
//  AddMembersViewController.m
//  TokenInputView
//
//  Created by Vinodh Swamy on 4/25/16.
//  Copyright © 2016 Vinodh Swamy. All rights reserved.
//

#import "VSAddMembersViewController.h"
#import "UserListViewController.h"
#import "VSTokenInputView.h"
#import "VSToken.h"

static CGFloat kMinInputViewHeight = 43;
static CGFloat kMaxInputViewHeight = 94;

static CGFloat kLeftPadding = 15;
static CGFloat kTopPadding = 10;
static CGFloat kRightPadding = 15;
static CGFloat kBottomPadding = 10;

static NSString *kEmailKey = @"Email";
static NSString *kNameKey = @"Name";

@interface VSAddMembersViewController () <InputViewDelegate>
@property (weak, nonatomic) IBOutlet VSTokenInputView *addedMembersInputView;
@property (weak, nonatomic) IBOutlet UIView *userListContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addedMemberViewHeight;

@property (nonatomic) UserListViewController *userListController;
@property (nonatomic) NSMutableArray *addedMembers;
@property (nonatomic) NSMutableDictionary *tokensCache;
@end

@implementation VSAddMembersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.addedMembersInputView.inPutViewDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureUserListViewController];
    [self checkAndUpdateDoneButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self layoutViewsBasedOnComposerHeight];
    [self.addedMembersInputView becomeFirstResponder];    
    [self.addedMembersInputView addTokens:[self.tokensCache allValues] needsLayout:YES];
    VSToken *token = self.tokensCache[self.selectedToken.uniqueId];
    [self.addedMembersInputView setSelectedToken:token highlight:YES];
}

- (NSMutableArray *)addedMembers
{
    if (!_addedMembers)
    {
        _addedMembers = [NSMutableArray array];
    }
    return _addedMembers;
}

- (NSDictionary *)tokensCache
{
    if (!_tokensCache)
    {
        _tokensCache = [NSMutableDictionary dictionary];
    }
    return _tokensCache;
}

#pragma mark -
#pragma mark Interface

- (void)configureAddMembersViewForMembers:(NSArray *)members
{
    [self addtokensForUsers:members];
}

#pragma mark -
#pragma mark Actions

- (void)doneButtonPressed:(id)sender
{
    if (self.addMembersBlock)
    {
        self.addMembersBlock(YES, self.addedMembers, nil);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Private

- (void)configureUserListViewController
{
    if (!self.userListController)
    {
        self.userListController = [UserListViewController userListController];
        [self addChildViewController:self.userListController];
        self.userListController.view.frame = self.userListContainerView.bounds;
        [self.userListContainerView addSubview:self.userListController.view];
        [self.userListController didMoveToParentViewController:self];
    }
    
    __weak VSAddMembersViewController *weakSelf = self;
    self.userListController.didScrollBlock = ^{
        [weakSelf.view endEditing:YES];
    };
}

- (void)layoutViewsBasedOnComposerHeight
{
    self.addedMemberViewHeight.constant = kMinInputViewHeight;
    self.addedMembersInputView.textContainerInset = UIEdgeInsetsMake(kTopPadding, kLeftPadding, kBottomPadding, kRightPadding);
}

- (void)searchUsersForText:(NSString *)searchText
{
    __weak VSAddMembersViewController *weakSelf = self;
    
    [self.userListController searchUserForUserName:searchText addedUsers:self.addedMembers withSelectedUserBlock:^(BOOL succes, NSDictionary *user, NSError *error) {
        if (succes)
        {

            [weakSelf addUser:user updateTokenView:YES];
        }
    } deselectedUserBlock:^(BOOL succes, NSDictionary *user, NSError *error) {
        if (succes)
        {
            [weakSelf removeUser:user];
        }
    }];
}

- (void)addUser:(NSDictionary *)user updateTokenView:(BOOL)update
{
    VSToken *token = self.tokensCache[user[kEmailKey]];
    if (!token)
    {
        token = [[VSToken alloc] init];
        token.name = user[kNameKey];
        token.uniqueId= user[kEmailKey];
        [self.tokensCache setValue:token forKey:token.uniqueId];
    }
    token.timeStamp = [NSDate date];
    
    [self.addedMembers addObject:user];
    [self.addedMembersInputView addToken:token needsLayout:update];
}

- (void)removeUser:(NSDictionary *)user
{
    VSToken *token = self.tokensCache[user[kEmailKey]];
    if (token)
    {
        [self.addedMembers removeObject:user];
        [self.tokensCache removeObjectForKey:token.uniqueId];
        [self.addedMembersInputView removeToken:token needsLayout:YES];
    }
}

- (NSDictionary *)userForToken:(VSToken *)token
{
    NSDictionary *userForToken = nil;
    for (NSDictionary *user in self.addedMembers)
    {
        if ([user[kEmailKey] isEqualToString:token.uniqueId])
        {
            userForToken = user;
            break;
        }
    }
    return userForToken;
}

- (void)checkAndUpdateDoneButton
{
    BOOL enable = [self.addedMembers count] ? YES : NO;
    [[[self navigationItem] rightBarButtonItem] setEnabled:enable];
}

- (void )addtokensForUsers:(NSArray *)users
{
    for (NSDictionary *user in users)
    {
        [self addUser:user updateTokenView:NO];
    }
}

#pragma mark -
#pragma mark InputViewDelegate

- (void)textDidChange:(NSString *)text
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if ([text length])
    {
        [self performSelector:@selector(searchUsersForText:) withObject:text afterDelay:0.3];
    }
    else
    {
        [self.userListController resetUserListScreen];
    }
}

- (void)didRemoveToken:(VSToken *)token
{
    NSDictionary *user = [self userForToken:token];
    if (user)
    {
        [self removeUser:user];
        [self.userListController resetUserListScreen];
    }
}


- (void)didUpdateSize:(CGSize)size
{
    CGFloat height = [self correctedHeight:size.height];
    [UIView animateWithDuration:0.2 animations:^{
       self.addedMemberViewHeight.constant = height;
        [self.view layoutIfNeeded];
    }];
}

- (CGFloat)correctedHeight:(CGFloat)height
{
    CGFloat correctedHeight = 0;
    if (height < kMinInputViewHeight)
        correctedHeight = kMinInputViewHeight;
    else if (height > kMaxInputViewHeight)
        correctedHeight = kMaxInputViewHeight;
    else
        correctedHeight = height;
    
    return correctedHeight;
}

@end
