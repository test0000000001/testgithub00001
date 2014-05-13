//
//  LLOldBindModel.m
//  VideoShare
//
//  Created by zengchao on 13-8-10.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "LLOldBindModel.h"
#import "UAModelDefines.h"
#import "LLDaoModelUser.h"
#import "LLDaoBase.h"
#import "JsonParseUtil.h"

@implementation BindCell
@synthesize type=_type;
@synthesize binded=_binded;
@synthesize opened=_opened;
@synthesize name=_name;
@synthesize snsid = _snsid;
- (id)init {
    if (self = [super init])
    {
    }
    return self;
}


NSString* _type;
NSString* _binded;
NSString* _opened;
NSString* _name;
NSString* _snsid;

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.type = [decoder decodeObjectForKey:@"type"];
        self.binded = [decoder decodeObjectForKey:@"binded"];
        self.opened = [decoder decodeObjectForKey:@"opened"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.snsid = [decoder decodeObjectForKey:@"snsid"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_type forKey:@"type"];
    [encoder encodeObject:_binded forKey:@"binded"];
    [encoder encodeObject:_opened forKey:@"opened"];
    [encoder encodeObject:_name forKey:@"name"];
    [encoder encodeObject:_snsid forKey:@"snsid"];
}
@end

@implementation LLOldBindModel
static NSMutableDictionary *bindedItemsDictionary=nil;

@synthesize bindedList=_bindedList;
- (id)init {
    if (self = [super init])
    {
        //        0  looklook
        //        1 新浪微博
        //        2 人人
        //        3 开心
        //        4 街旁
        //        5 qzone空间
        //        6 腾讯微博
        //        7 搜狐微博
        self.bindedList=[[NSMutableArray alloc]initWithCapacity:5];
        for (int i=0; i<5; i++) {
            BindCell* bindcell = [[BindCell alloc]init];
            bindcell.opened = @"1";
            bindcell.binded = @"0";
            
            if (i==0) {
                //                bindcell.opened = @"0";
                bindcell.name = @"新浪微博";
                bindcell.type= @"1";
            }
            else if (i==1) {
                //                bindcell.opened = @"0";
                bindcell.name = @"人人网";
                bindcell.type= @"2";
            }
            else if (i==2) {
                //                bindcell.opened = @"0";
                bindcell.name = @"腾讯微博";
                bindcell.type= @"6";
            }
            else if (i==3) {
                //                bindcell.opened = @"0";
                bindcell.name = @"开心";
                bindcell.type= @"3";
            }
            else if (i==4) {
                bindcell.opened = @"0";
                bindcell.name = @"街旁";
                bindcell.type= @"4";
            }
            
            [_bindedList addObject:bindcell];
        }
    }
    return self;
}


-(void)refreshFromLocalRecord:(LLDAOBase*)dao SnsType:(NSString*)snstype
{
    if([self isFileExist:@"bindedItemsData"]){
        NSMutableDictionary *bindedItemsDictionary  = [self defaultBindedItems];
        if(bindedItemsDictionary != nil && [bindedItemsDictionary count] > 0){
            NSEnumerator *enumerator = [bindedItemsDictionary keyEnumerator];
            id key;
            while ((key = [enumerator nextObject]))
            {
                BindCell* bindcell = [bindedItemsDictionary objectForKey:key];
                
                
                if( [key isEqualToString:@"1"])
                {
                    __block LLDaoModelUser *myllDaoModelUser = [[LLDaoModelUser alloc] init];
                    [dao searchAll:myllDaoModelUser callback:^(NSArray* array){
                        if([array count] >0){
                            myllDaoModelUser  = [array objectAtIndex:0];
                           
                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                            NSDictionary *Info = [defaults objectForKey:SinaAuthData];
                            if (Info && !STR_IS_NIL(snstype) && [snstype isEqualToString:@"1"]) {
                                myllDaoModelUser.isBindSina = @"1";
                                //持久化本地的token到数据库中
                                NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
                                [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
                                NSString *currentDateStr = [dateFormat stringFromDate:[Info objectForKey:SinaExpirationDateKey]];
                                NSMutableDictionary *sinaBindInfos =[[NSMutableDictionary alloc]initWithObjectsAndKeys:[Info objectForKey:SinaAccessTokenKey],SinaAccessTokenKey, currentDateStr, SinaExpirationDateKey,[Info objectForKey:SinaUserIDKey],SinaUserIDKey,@"", SinaThirdRemind_in,@"" ,THIRDPARTYNICKNAME,nil ];
                                myllDaoModelUser.bindSinaAuthInfo = [JsonParseUtil convertDicToJsonString:sinaBindInfos];;
                                
                                [dao updateInsertToDB:myllDaoModelUser callback:^(BOOL result) {
                                    JLog(@"update result:%d",result);
                                }];
                            }
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:SinaAuthData];
                        }
                    }];
                    
                    
                    
                }else if([key isEqualToString:@"6"]){
                    __block LLDaoModelUser *myllDaoModelUser = [[LLDaoModelUser alloc] init];
                    [dao searchAll:myllDaoModelUser callback:^(NSArray* array){
                        if([array count] >0){
                            //持久化本地的token到数据库中
                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                            NSDictionary *Info = [defaults objectForKey:TCAuthData];
                            if (Info && !STR_IS_NIL(snstype) && [snstype isEqualToString:@"6"]) {
                                myllDaoModelUser  = [array objectAtIndex:0];
                                myllDaoModelUser.isBindTC = @"1";
                                NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
                                [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
                                NSString *currentDateStr = [dateFormat stringFromDate:[Info objectForKey:TCExpirationDateKey]];
                                NSMutableDictionary *tcBindInfos = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[Info objectForKey:TCAccessTokenKey],TCAccessTokenKey, currentDateStr, TCExpirationDateKey,[Info objectForKey:TCUserIDKey],TCUserIDKey,@"", TCthirdremind_in,@"", TCopenkey,@"", TCRefresh_token,@"" ,THIRDPARTYNICKNAME, nil ];
                                myllDaoModelUser.bindTCAuthInfo =[JsonParseUtil convertDicToJsonString:tcBindInfos];
                                 
                                [dao updateInsertToDB:myllDaoModelUser callback:^(BOOL result) {
                                    JLog(@"update result:%d",result);
                                }];
                            }
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:TCAuthData];
                        }
                    }];
                    
                    
                }
                
                
            }
        }
    }
    
}

-(BOOL)isFileExist:(NSString*)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    return [[NSFileManager defaultManager] fileExistsAtPath: appFile];
}

-(NSMutableDictionary*)defaultBindedItems
{
    static dispatch_once_t bindedItemsDictionaryToken;
    dispatch_once(&bindedItemsDictionaryToken, ^{
        if (bindedItemsDictionary==nil) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
                bindedItemsDictionary=[NSKeyedUnarchiver unarchiveObjectWithFile:[self dataFilePath]];
            }else {
                bindedItemsDictionary=[NSMutableDictionary dictionaryWithCapacity:5];
            }
        }else{
            NSLog(@"bindedItemsDictionary != nil");
        }
    });
    return bindedItemsDictionary;
}

//static NSString *bindedItemsFilePath=@"/Documents/bindedItemsDictionary.dat";
-(NSString*)dataFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"bindedItemsData"];
}


@end
