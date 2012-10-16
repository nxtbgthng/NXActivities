//
//  NXTextInputCell.m
//  NXActivities
//
//  Created by Thomas Kollbach on 12.10.12.
//  Copyright (c) 2012 nxtbgthng. All rights reserved.
//

#import "NXReadLaterTextInputCell.h"

@implementation NXReadLaterTextInputCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _inputField = [[UITextField alloc] initWithFrame:self.contentView.bounds];
        _inputField.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_inputField];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // do nothing
}

- (void)layoutSubviews;
{
    [super layoutSubviews];
    
    self.inputField.frame = CGRectInset(self.contentView.bounds, 6, 10);
}

@end
