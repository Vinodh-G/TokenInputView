//
//  TokenInputView.h
//  TokenInputView
//
//  Created by Vinodh Swamy on 4/25/16.
//  Copyright © 2016 Vinodh Swamy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VSToken;

@protocol InputViewDelegate <NSObject>
@optional
- (void)textDidChange:(NSString *)text;
- (void)didRemoveToken:(VSToken *)token;
- (void)didUpdateSize:(CGSize)size;
- (void)didSelectToken:(VSToken *)token;
@end

@interface VSTokenInputView : UITextView

@property (nonatomic, weak) id <InputViewDelegate> inPutViewDelegate;

/*
 Adds the provided token to the TokenInputView, and updates the View text needsLayout is true
 */
- (void)addToken:(VSToken *)token needsLayout:(BOOL)needsLayout;

/*
 Removes the provided token from the TokenInputView, and updates the View text needsLayout is true
 */
- (void)removeToken:(VSToken *)token needsLayout:(BOOL)needsLayout;

/*
 Adds the the array of tokens to the TokenInputView, and updates the View text needsLayout is true
 */
- (void)addTokens:(NSArray *)tokens needsLayout:(BOOL)needsLayout;

/*
 Highlights the provided token to the TokenInputView, and mark the provided token as selected 
 */
- (void)setSelectedToken:(VSToken *)token highlight:(BOOL)highlight;

/*
 Updates the text in the TokenInputView based on the tokens added to it.
 */
- (void)updateTextForTokens;
@end
