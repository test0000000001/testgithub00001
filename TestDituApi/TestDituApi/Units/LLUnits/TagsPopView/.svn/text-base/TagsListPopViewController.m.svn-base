//
//  TagsListPopViewController.m
//  VideoShare
//
//  Created by li jian on 13-6-27.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "TagsListPopViewController.h"
#import "MarkData.h"
#import "SelectMarkCell.h"



@implementation TagsListPopViewController

@synthesize tagsArray = _tagsArray;
@synthesize tagsCollectionView = _tagsCollectionView;
@synthesize highlightTagIDArray = _highlightTagIDArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.outerLeftMargin = 10.0f;
        self.innerMargin = 2.5f;
        self.cornerRadius = 5;
        self.closeButton.hidden = YES;
        [self initCollectionView];
    }
    return self;
}

- (void)initCollectionView
{
    [CmmobiAndUmengClick beginLogPageView:My_Album_Tag_Details_page]; //埋点
    self.tagsCollectionView = [[PSCollectionView alloc] initWithFrame:CGRectZero];
    self.tagsCollectionView.collectionViewDelegate = self;
    self.tagsCollectionView.collectionViewDataSource = self;
    self.tagsCollectionView.delegate = self;
    self.tagsCollectionView.backgroundColor = [UIColor clearColor];
    self.tagsCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tagsCollectionView.numColsPortrait = 4;//竖屏列数
    [self.contentView addSubview:self.tagsCollectionView];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(7, 25, 150, 21)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    label.text = @"选择标签:";
    [self.contentView addSubview:label];
    
    UIButton *shutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shutButton setFrame:CGRectMake(245, 5, 50, 50)];
    [shutButton setImage:[UIImage imageNamed:@"3_x11"] forState:UIControlStateNormal];
    [shutButton setImage:[UIImage imageNamed:@"3_x22"] forState:UIControlStateHighlighted];
    [shutButton setImage:[UIImage imageNamed:@"3_x22"] forState:UIControlStateSelected];
    [shutButton addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:shutButton];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[self.tagsCollectionView setFrame:self.contentView.bounds];
    CGRect rect = self.tagsCollectionView.frame;
    rect.origin.x -= 2;
    rect.origin.y = 70;
    rect.size.height -= 70;
    //rect.origin.x = 2;
    self.tagsCollectionView.frame = rect;
}

#pragma mark -
#pragma mark - PSCollectionViewDelegate and DataSource
- (NSUInteger)numberOfSectionsInCollectionView:(PSCollectionView *)collectionView
{
    return 1;
}

- (NSUInteger)collectionView:(PSCollectionView *)collectionView numberOfViewsInSection:(NSUInteger)section
{
    return [self.tagsArray count];
}

//- (UIView *)collectionView:(PSCollectionView *)collectionView sectionHeaderForSection:(NSUInteger)section
//{
//    UIView* sectionView=nil;
//    sectionView = self.collectionSectionView;
//    return sectionView;
//}

- (CGFloat)collectionView:(PSCollectionView *)collectionView heightForViewAtIndexPath:(NSIndexPath *)indexPath
{
    return 37.0f;
}

- (PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView viewAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *fCellIdentifier = @"SelectMarkCell";
    SelectMarkCell *cell = (SelectMarkCell *)[collectionView dequeueReusableViewWithIdentifier:fCellIdentifier];
    
    if (!cell) {
        cell = [[SelectMarkCell alloc] initWithFrame:CGRectMake(0, 0, 70, 28)reuseIdentifier:fCellIdentifier];
    }
    
    MarkCell *mark = [self.tagsArray objectAtIndex:indexPath.row];
    cell.markItemBtn.tag = indexPath.row;
    [cell.markItemBtn setTitle:mark.name forState:UIControlStateNormal];
    [cell.markItemBtn setTitle:mark.name forState:UIControlStateHighlighted];
    [cell.markItemBtn setTitle:mark.name forState:UIControlStateSelected];
    [cell.markItemBtn setTitleColor:HEXCOLOR(0x7F7F7F) forState:UIControlStateNormal];
    [cell.markItemBtn setTitleColor:HEXCOLOR(0x7F7F7F) forState:UIControlStateHighlighted];
    [cell.markItemBtn setTitleColor:HEXCOLOR(0x7F7F7F) forState:UIControlStateSelected];
    
    if (self.highlightTagIDArray && self.highlightTagIDArray.count > 0) {
        if ([self.highlightTagIDArray indexOfObject:mark.markId] != NSNotFound) {
            cell.markItemBtn.selected = YES;
        } else {
            cell.markItemBtn.selected = NO;
            cell.markItemBtn.userInteractionEnabled = NO;
        }
    }
    
    return cell;
}

#pragma mark -
#pragma mark - PSCollectionViewDelegate
- (void)collectionView:(PSCollectionView *)collectionView didSelectView:(PSCollectionViewCell *)view atIndexPath:(NSIndexPath *)indexPath
{
    SelectMarkCell *cell = (SelectMarkCell *)view;
    if (!cell.markItemBtn.selected) {
        return;
    }
    if (self.tagsArray.count > 0) {
        MarkCell *mark = [self.tagsArray objectAtIndex:indexPath.row];
        NSDictionary* uf = [NSDictionary dictionaryWithObjectsAndKeys:mark.markId ,@"tagID", mark.name, @"tagName",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:BROADCAST_TAGS_CHANGE object:self userInfo:uf];
    }
    [self removeFromSuperview];
}

-(void)customEventToViewController:(UITouch *)touch
{
    
}

- (void)btnPressed:(id)sender
{
    [CmmobiAndUmengClick endLogPageView:My_Album_Tag_Details_page]; //埋点
    [self removeFromSuperview];
}

-(IBAction)markItemBtnClicked:(id)sender{
    UIButton *markBtn = (UIButton*)sender;
    int rowIndex = markBtn.tag;
    if (markBtn.selected) {
        if (self.tagsArray.count > 0) {
            
            MarkCell *mark = [self.tagsArray objectAtIndex:rowIndex];
            NSDictionary* uf = [NSDictionary dictionaryWithObjectsAndKeys:mark.markId ,@"tagID", mark.name, @"tagName",nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:BROADCAST_TAGS_CHANGE object:self userInfo:uf];
        }
        [self removeFromSuperview];
    }
}

@end

























