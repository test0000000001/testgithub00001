//
//  ClusterDetailModalPanel.m
//  VideoShare
//
//  Created by dongsheng xu on 12-12-18.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//

#import "ClusterDetailModalPanel.h"
#import "ClusterDetailCell.h"
#import "ArAnnotation.h"
#import "ImageCacheManager.h"
#import "Tools.h"
#import "AppDelegate.h"
#import "UserLocationAnnotation.h"
#import "SpaceCollectionViewCell.h"
#import "DiaryDetailsViewController.h"

#define CELL_ITEM_HEIGHT 83

@implementation ClusterDetailModalPanel
@synthesize mapStyle=_mapStyle;
@synthesize clusterDetailTableView=_clusterDetailTableView;
@synthesize clusterChildAnnotationList=_clusterChildAnnotationList;
@synthesize mycollectionNC =_mycollectionNC;

- (id)initWithFrame:(CGRect)frame itemCount:(int)itemCount
{
    self = [super initWithFrame:frame];
    if (self) {
        self.outerLeftMargin = 10.0f;
        self.innerMargin = 5.0f;
        self.cornerRadius = 5;
        self.diaryArray = [NSMutableArray new];
        
        //int maxItemCount = (frame.size.height - self.outerLeftMargin*2 - 46)/CELL_ITEM_HEIGHT;
        //int maxItemCount = (frame.size.height - self.outerLeftMargin*2)/CELL_ITEM_HEIGHT;
        int maxItemCount = 4;
        int itemsCount = itemCount > maxItemCount ? maxItemCount:itemCount;
        self.outerTopMargin = (frame.size.height - itemsCount*CELL_ITEM_HEIGHT -self.innerMargin*2)/2;
        
        self.clusterDetailTableView = [[UITableView alloc]initWithFrame:CGRectZero];
        self.clusterDetailTableView.backgroundColor = [UIColor clearColor];
        self.clusterDetailTableView.delegate=self;
        self.clusterDetailTableView.dataSource=self;
        self.clusterDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //self.clusterDetailTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        
        [self.contentView addSubview:self.clusterDetailTableView];
        [self.contentView sendSubviewToBack:self.clusterDetailTableView];
        
    }
    return self;
}

-(void)refreshClusterDetailTableView:(NSMutableArray*)newClusterChildAnnotationList{
    [self.clusterChildAnnotationList removeAllObjects];
    [self.clusterChildAnnotationList addObjectsFromArray:newClusterChildAnnotationList];
    [self.clusterDetailTableView reloadData];
}

- (void)layoutSubviews {
	[super layoutSubviews];  
	[self.clusterDetailTableView setFrame:self.contentView.bounds];
}

-(void)updateMapCellByDiaryStyle:(DiaryData*)diaryData mapCell:(ClusterDetailCell *)mapCell{
    CELL_DISPLAY_STYLE diaryStyle  = [Tools getCollentionDiaryDisplayStyle:diaryData];
    mapCell.videoImageView.image = [UIImage imageNamed:@"3_tankuang_moren"];
    mapCell.videoImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoDiaryDetailPage:)];
    [mapCell.videoImageView addGestureRecognizer:imageSingleTap];
    mapCell.textContentView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoDiaryDetailPage:)];
    [mapCell.textContentView addGestureRecognizer:singleTap];
    if(!STR_IS_NIL(diaryData.d_nickname)){
         mapCell.nicknameLabel.text = diaryData.d_nickname;
    }else{
         mapCell.nicknameLabel.text = @"";
    }
    if([APP_SEX isEqualToString:@"2"]){//性别保密
        mapCell.sexView.hidden = YES;
    }else{
        if ([@"1" isEqualToString:diaryData.d_sex]) {
            mapCell.sexView.image = [UIImage imageNamed:@"3_ar_nv"];
        }else if([@"0" isEqualToString:diaryData.d_sex]){
            mapCell.sexView.image = [UIImage imageNamed:@"3_ar_nan"];
        }else{
            mapCell.sexView.image = [UIImage imageNamed:@""];
        }
    }
    if(!STR_IS_NIL(diaryData.d_diarytimemilli)){
          mapCell.videoUploadTime.text = [Tools dateFormat:DIARY_CREATE_TIME_DEFAULT_FORMAT timeMilli:[NSNumber numberWithDouble:[diaryData.d_diarytimemilli doubleValue]]];
    }else{
         mapCell.videoUploadTime.text = @"";
    }
    mapCell.contentLabel.text = @"";
    mapCell.bofangImageView.hidden = YES;
    switch (diaryStyle) {
        case VIDEO_NO_AUXILIARY_ATTACH:   //只有主附件，没有辅附件
        {
            NSString *videoCoverUrl = [Tools parseVideoCover:diaryData];
            if (videoCoverUrl) {
                [ImageCacheManager setImageToImage:videoCoverUrl imageView:mapCell.videoImageView];
            }
            mapCell.contentLabel.text = [Tools parseTextDescByAttachLevel:diaryData attachLevel:0];
            mapCell.bofangImageView.hidden = NO;
            break;
        }
        case VIDEO_HAS_ONE_AUXILIARY_VOICE_ATTACH://有：主附件，语音辅附件
        {
            NSString *videoCoverUrl = [Tools parseVideoCover:diaryData];
            if (videoCoverUrl) {
                [ImageCacheManager setImageToImage:videoCoverUrl imageView:mapCell.videoImageView];
            }
            mapCell.bofangImageView.hidden = NO;
            break;
        }
        case VIDEO_HAS_ONE_AUXILIARY_WORDS_ATTACH: //有：主附件，文字辅附件
        {
            NSString *videoCoverUrl = [Tools parseVideoCover:diaryData];
            if (videoCoverUrl) {
                [ImageCacheManager setImageToImage:videoCoverUrl imageView:mapCell.videoImageView];
            }
            mapCell.contentLabel.text = [Tools parseTextDescByAttachLevel:diaryData attachLevel:0];
            mapCell.bofangImageView.hidden = NO;
            break;
        }
        case VIDEO_HAS_TWO_AUXILIARY_ATTACH://有：主附件，语音辅附件，文字辅附件
        {
            NSString *videoCoverUrl = [Tools parseVideoCover:diaryData];
            if (videoCoverUrl) {
                [ImageCacheManager setImageToImage:videoCoverUrl imageView:mapCell.videoImageView];
            }
            mapCell.contentLabel.text = [Tools parseTextDescByAttachLevel:diaryData attachLevel:0];
            mapCell.bofangImageView.hidden = NO;
            break;
        }
        case AUDIO_NO_AUXILIARY_ATTACH://只有主附件，没有辅附件
        {
            mapCell.videoImageView.image = [UIImage imageNamed:@"3_tankuang_luyin"];
            break;
        }
        case AUDIO_NO_MAIN_ATTACH://无主附件，有两个辅附件
        {
            mapCell.videoImageView.image = [UIImage imageNamed:@"3_tankuang_luyin"];
            mapCell.contentLabel.text = [Tools parseTextDescByAttachLevel:diaryData attachLevel:0];
            break;
        }
        case AUDIO_HAS_ONE_AUXILIARY_WORDS_ATTACH://有：主附件，文字辅附件
        {
            mapCell.videoImageView.image = [UIImage imageNamed:@"3_tankuang_luyin"];
            mapCell.contentLabel.text = [Tools parseTextDescByAttachLevel:diaryData attachLevel:0];
            break;
        }
        case AUDIO_HAS_TWO_AUXILIARY_ATTACH://有：主附件，语音辅附件，文字辅附件
            
        {
            mapCell.videoImageView.image = [UIImage imageNamed:@"3_tankuang_luyin"];
            mapCell.contentLabel.text = [Tools parseTextDescByAttachLevel:diaryData attachLevel:0];
            break;
        }
            
        case IMAGE_NO_AUXILIARY_ATTACH://只有主附件，没有辅附件
        {
            NSString *imageurl = [Tools parseImageUrlByAttachLevel:diaryData attachLevel:1];
            if (imageurl) {
                [ImageCacheManager setImageToImage:imageurl imageView:mapCell.videoImageView];
            }
            break;
        }
            
        case IMAGE_HAS_ONE_AUXILIARY_VOICE_ATTACH://有：主附件，语音辅附件
        {
            NSString *imageurl = [Tools parseImageUrlByAttachLevel:diaryData attachLevel:1];
            if (imageurl) {
                [ImageCacheManager setImageToImage:imageurl imageView:mapCell.videoImageView];
            }
            break;
        }
            
        case IMAGE_HAS_ONE_AUXILIARY_WORDS_ATTACH://有：主附件，文字辅附件
        {
            NSString *imageurl = [Tools parseImageUrlByAttachLevel:diaryData attachLevel:1];
            if (imageurl) {
                [ImageCacheManager setImageToImage:imageurl imageView:mapCell.videoImageView];
            }
            mapCell.contentLabel.text = [Tools parseTextDescByAttachLevel:diaryData attachLevel:0];
            break;
        }
            
        case IMAGE_HAS_TWO_AUXILIARY_ATTACH://有：主附件，语音辅附件，文字辅附件
            
        {
            NSString *imageurl = [Tools parseImageUrlByAttachLevel:diaryData attachLevel:1];
            if (imageurl) {
                [ImageCacheManager setImageToImage:imageurl imageView:mapCell.videoImageView];
            }
            mapCell.contentLabel.text = [Tools parseTextDescByAttachLevel:diaryData attachLevel:0];
            break;
        }
            
        case AUXILIARY_ATTACH_WORDS: //只有文字
        {
            mapCell.videoImageView.image = [UIImage imageNamed:@"3_tankuang_nothing"];
            mapCell.contentLabel.text = [Tools parseTextDescByAttachLevel:diaryData attachLevel:0];
            break;
        }
            
        case AUXILIARY_ATTACH_VOICE: //只有语音
        {
            mapCell.videoImageView.image = [UIImage imageNamed:@"3_tankuang_nothing"];
            break;
        }
            
        case AUXILIARY_ATTACH_WORDS_AND_VOICE:
        {
            mapCell.videoImageView.image = [UIImage imageNamed:@"3_tankuang_nothing"];
            mapCell.contentLabel.text = [Tools parseTextDescByAttachLevel:diaryData attachLevel:0];
            break;
        }
            
        default:
            break;
    }
    
}

#pragma mark - 
#pragma mark UITableView Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = 0;
    if (tableView == _clusterDetailTableView) {
        count = [_clusterChildAnnotationList count];
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return CELL_ITEM_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==_clusterDetailTableView) {
        static NSString *FirstLevelCell = @"FirstLevelCell" ;
        ClusterDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
        cell.backgroundColor = [UIColor clearColor];
        if (cell == nil )
        {
            cell = [[ClusterDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstLevelCell size:CGSizeMake(self.frame.size.width, CELL_ITEM_HEIGHT)];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        cell.showsReorderControl = NO;
        ArAnnotation* annotation = nil;
        id <MKAnnotation> ann = [_clusterChildAnnotationList objectAtIndex:indexPath.row];
        if([ann isKindOfClass:[ArAnnotation class]]){
             annotation = (ArAnnotation*) ann;
            DiaryData *diaryData = annotation.diaryData;
            cell.textContentView.tag = annotation.index;
            cell.videoImageView.tag = annotation.index;
            [self updateMapCellByDiaryStyle:diaryData mapCell:cell];
            UIView* lastview = [cell viewWithTag:222];
            if (lastview) {
                    [lastview removeFromSuperview];
            }
            UIView * view = [Tools getRichText:UN_NIL(cell.contentLabel.text):153:2];
            view.tag = 222;
            view.frame = view.bounds;
            [cell addSubview:view];

            return cell;
        }
    }
    UITableViewCell *cellDefault = [tableView dequeueReusableCellWithIdentifier:@"default"];
    if (cellDefault == nil) {
        cellDefault = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
    return cellDefault;
}

#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *tableSelection = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:tableSelection animated:YES]; 
    ArAnnotation* annotation = [_clusterChildAnnotationList objectAtIndex:indexPath.row];
    [self gotoDiaryDetailPageByCurClickIndex:annotation.index];
}

-(void)gotoDiaryDetailPage:(UITapGestureRecognizer *)sender{
    int curClickIndex = sender.view.tag;
    [self gotoDiaryDetailPageByCurClickIndex:curClickIndex];
}

- (void)gotoDiaryDetailPageByCurClickIndex:(int)curClickIndex
{
    [CmmobiAndUmengClick event:NEAR_ENTRY_BOMB_BOX_BUTTON]; //埋点
    NSMutableArray *uuidArray = [[NSMutableArray alloc] init];
    for (DiaryData *ddata in self.diaryArray) {
        [uuidArray addObject:ddata.d_diaryuuid];
    }
    DiaryDetailsViewController *diaryDetailsViewController = [[DiaryDetailsViewController alloc]initWithWhoYouAre:PREVIOUS_PAGE_IS_OTHERS_DIARY_PAGE diaries:uuidArray position:curClickIndex];
    [self.mycollectionNC pushViewController:diaryDetailsViewController animated:YES];
}

- (void)didCloseModalPanel:(UAModalPanel *)modalPanel
{


}

@end
