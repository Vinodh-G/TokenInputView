# TokenInputView

The `TokenInputView` class implements the behavior for a scrollable, multiline text `(Tokens)` seperated by `','`. The class supports the display of text using custom style information and also supports text editing. You typically use a TokenInputView to display multiple lines text, such as when displaying the body of a large list of emails adresses or list of user names.

`TokenInputView` is a subclass of UITextView

Usage
========

`TokenInputView` can be used from storyboards/ xibs or even programatically creating instance using `[[TokenInputView alloc] init]`
The sample in this repo shows the usage of `TokenInputView` from storyboards.



Once TokenInputView is created, set the inPutViewDelegate of `TokenInputView` to ViewController or View who ever is resposible for handing adding and removing tokens.

Interface
========

 Adds the provided token to the TokenInputView, and updates the View text needsLayout is true
`- (void)addToken:(VSToken *)token needsLayout:(BOOL)needsLayout`

 Removes the provided token from the TokenInputView, and updates the View text needsLayout is true
`- (void)removeToken:(VSToken *)token needsLayout:(BOOL)needsLayout`


 Adds the the array of tokens to the TokenInputView, and updates the View text needsLayout is true
`- (void)addTokens:(NSArray *)tokens needsLayout:(BOOL)needsLayout`

Highlights the provided token to the TokenInputView, and mark the provided token as selected 
`- (void)setSelectedToken:(VSToken *)token highlight:(BOOL)highlight`

Updates the text in the TokenInputView based on the tokens added to it.
`- (void)updateTextForTokens;`

The below code snippit shows adding the removeing tokens from `TokenInputView`
`
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
`


![solarized vim](http://i.imgur.com/JgDnF1N.png)
![solarized vim](http://i.imgur.com/l3U0bsq.png)
![solarized vim](http://i.imgur.com/jtWx5gs.png)
