//
//  ClusterDetailModalPanel.h
//  VideoShare
//
//  Created by dongsheng xu on 12-12-18.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//

#import "UAModalPanel.h"
#import "Global.h"

@interface ClusterDetailModalPanel : UAModalPanel<UITableViewDelegate, UITableViewDataSource, UAModalPanelDelegate>{
    UITableView* _clusterDetailTableView;
    NSMutableArray* _clusterChildAnnotationList;
}
@property(nonatomic,assign)MAP_STYLE mapStyle;
@property(nonatomic,retain)UITableView* clusterDetailTableView;
@property(nonatomic,retain)NSMutableArray* clusterChildAnnotationList;
@property (nonatomic, strong) UINavigationController *mycollectionNC;

@property(nonatomic,retain)NSMutableArray* diaryArray; //传日记数组到详情页

- (id)initWithFrame:(CGRect)frame itemCount:(int)itemCount;

//根据最新的clusterChildAnnotationList刷新tableView
-(void)refreshClusterDetailTableView:(NSMutableArray*)newClusterChildAnnotationList;

@end
