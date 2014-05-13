//
//  UAModel.m
//  VideoShare
//
//  Created by qin on 13-5-29.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "UAModel.h"
#import "OpenUDID.h"
#import <sys/socket.h> // Per msqr
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>

#import <ifaddrs.h>
#import <arpa/inet.h>

#import "UIDeviceHardware.h"
#import "GetNetworkInfoModel.h"

@implementation UAModel

@synthesize aPP_PositionModel = _aPP_PositionModel;

@synthesize devicetoken = _devicetoken;
@synthesize mobiletype = _mobiletype;
@synthesize openUDID = _openUDID;
@synthesize mac = _mac;
@synthesize resolution = _resolution;
@synthesize basestationinfo = _basestationinfo;
@synthesize internetway = _internetway;
@synthesize systemversionid =_systemversionid;
@synthesize sdk_imei = _sdk_imei;
@synthesize channel_number = _channel_number;
@synthesize siteid = _siteid;
@synthesize cdr = _cdr;
@synthesize gps = _gps;
@synthesize clientversion = _clientversion;
@synthesize uaData = _uaData;
@synthesize loginUserInfoData = _loginUserInfoData;

static UAModel* singleton = nil;

+(UAModel *)defaultUAModel{
    static dispatch_once_t defaultUAModelonceToken;
    dispatch_once(&defaultUAModelonceToken, ^{
        if(singleton == nil){
            singleton=[[UAModel alloc] init];
//            if([[NSFileManager defaultManager] fileExistsAtPath:[UAModel dataFilePath]]){
////                singleton=[NSKeyedUnarchiver unarchiveObjectWithFile: [UAModel dataFilePath] ];
//            }
//            else{
//                
//            }
        }
    });
    return singleton;
}

-(id)init
{
    if(self = [super init]){
        self.mobiletype = @"1";
        self.sdk_imei = @"";
        self.channel_number = @"looklook";
        self.basestationinfo = @"";
        
        self.gps = @"";
        self.clientversion = @"";
        self.siteid = @"";
        self.cdr = @"";
        UIDeviceHardware *d = [[UIDeviceHardware alloc] init];
        self.devicetype  = [d platform];
        self.devicetype =[self.devicetype stringByReplacingOccurrencesOfString:@"," withString:@"-"];
        self.devicetype =[NSString stringWithFormat:@"%@_ios_%@",self.devicetype, [[UIDevice currentDevice] systemVersion]];
        
         self.systemversionid = [NSString stringWithFormat:@"%@_ios_%@",self.devicetype, [[UIDevice currentDevice] systemVersion]];
        
        
        
        int deviceHeight = [[UIScreen mainScreen] bounds].size.height;
        int deviceWidth = [[UIScreen mainScreen] bounds].size.width;
        self.resolution = [[[NSString stringWithFormat:@"%d", deviceWidth] stringByAppendingString :@"x"] stringByAppendingString:[NSString stringWithFormat:@"%d", deviceHeight]];

        self.internetway = [self getCurrentNetworkType];
        
        self.aPP_PositionModel=[[APP_PositionModel alloc]init];
        self.uaData = [[UAData alloc] init];
        self.loginUserInfoData = [[LoginUserInfoData alloc] init];
        
        
        self.devicetoken = [[NSUserDefaults standardUserDefaults] objectForKey:@"devicetoken"];
        if(self.devicetoken == nil){
            self.devicetoken = @"";
        }
        
        self.mac = [[NSUserDefaults standardUserDefaults] objectForKey:@"mac"];
        if(self.mac == nil){
            self.mac = [self macaddress];
        }
        
        self.openUDID = [[NSUserDefaults standardUserDefaults] objectForKey:@"openUDID"];
        if(self.openUDID == nil){
            self.openUDID = [OpenUDID value];
        }
        
        self.uaData.equipmentid = [[NSUserDefaults standardUserDefaults] objectForKey:@"equipmentid"];
        if(self.uaData.equipmentid == nil){
            self.uaData.equipmentid = @"";
        }
    }
    return self;
}

+(NSString*)dataFilePath{
//    return @"";
    return [NSString stringWithFormat:@"%@/Documents/UAModel",NSHomeDirectory()];
}

#pragma mark MAC
// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to mlamb.
- (NSString *) macaddress
{
	int                    mib[6];
	size_t                len;
	char                *buf;
	unsigned char        *ptr;
	struct if_msghdr    *ifm;
	struct sockaddr_dl    *sdl;
	
	mib[0] = CTL_NET;
	mib[1] = AF_ROUTE;
	mib[2] = 0;
	mib[3] = AF_LINK;
	mib[4] = NET_RT_IFLIST;
	
	if ((mib[5] = if_nametoindex("en0")) == 0) {
		printf("Error: if_nametoindex error/n");
		return NULL;
	}
	
	if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
		printf("Error: sysctl, take 1/n");
		return NULL;
	}
	
	if ((buf = malloc(len)) == NULL) {
		printf("Could not allocate memory. error!/n");
		return NULL;
	}
	
	if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
		printf("Error: sysctl, take 2");
		return NULL;
	}
	
	ifm = (struct if_msghdr *)buf;
	sdl = (struct sockaddr_dl *)(ifm + 1);
	ptr = (unsigned char *)LLADDR(sdl);
	// NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
	NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
	free(buf);
	return [outstring uppercaseString];
	
}

-(NSString *)getCurrentNetworkType{
    NSString *networkType = @"";
    if([GetNetworkInfoModel getNetworkType] == NETWORK_NOT_AVAILABLE){
        networkType = @"";
    }else if([GetNetworkInfoModel getNetworkType] == NETWORK_WIFI){
        networkType = @"WIFI";
    }else if([GetNetworkInfoModel getNetworkType] == NETWORK_3G){
        networkType = @"3G";
    }else if([GetNetworkInfoModel getNetworkType] == NETWORK_2G){
        networkType = @"GPRS";
    }else if([GetNetworkInfoModel getNetworkType] == NETWORK_OTHER){
        networkType = @"其他";
    }
    return networkType;
}

-(void)save{
    [[NSUserDefaults standardUserDefaults] setValue:self.devicetoken forKey:@"devicetoken"];
    [[NSUserDefaults standardUserDefaults] setValue:self.openUDID forKey:@"openUDID"];
    [[NSUserDefaults standardUserDefaults] setValue:self.mac forKey:@"mac"];
    if([APP_USERID length]> 0){
        [[NSUserDefaults standardUserDefaults] setValue:APP_USERID forKey:@"loginguserid"]; //当前登录的用户id
    }
    [[NSUserDefaults standardUserDefaults] setValue:_uaData.equipmentid forKey:@"equipmentid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"loginuserid"]);
}

-(void)UserFirstLogin
{
    if([APP_USERID length] > 0){
        [[NSUserDefaults standardUserDefaults] setValue:APP_USERID forKey:APP_USERID]; //当前登录的用户id
    }
}

-(NSString*)getFirstLoginUserId{
    return [[NSUserDefaults standardUserDefaults] objectForKey:APP_USERID];
}

-(void)removeCurrentLoginUserid
{
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"loginguserid"]; //当前登录的用户id
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginuserid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"loginguserid"]);
}



//单例销毁
-(void)attemptDealloc
{
    singleton = nil;
}

// 更新官方用户
- (void)updateOfficialUsersWithJsonStr:(NSString *)JsonStr
{
    
    NSString *gotJson = nil;
    
    __block LLDaoModelUser *modelUser = [[LLDaoModelUser alloc] init];
    [[LLDAOBase shardLLDAOBase] searchWhere:modelUser String:[NSString stringWithFormat:@"userid =\'%@\'",APP_USERID] orderBy:0 asc:0 offset:0 count:1 callback:^(NSArray *result) {
        modelUser = [result lastObject];
    }];
    
    if (JsonStr) {
        modelUser.officialUsersJsonStr = JsonStr;
        [[LLDAOBase shardLLDAOBase] updateToDB:modelUser callback:^(BOOL result) {
            
        }];
        gotJson = JsonStr;
    }
    else {
        gotJson =  modelUser.officialUsersJsonStr;
    }
    // insert

    
    // update to login user data
    OfficialUsersData *usersData = [[OfficialUsersData alloc] init];
    [usersData setResponseModelFromDic:[gotJson JSONValue]];
    
    self.loginUserInfoData.officialUsers = usersData;
}

// 判断是否官方用户
- (BOOL)isOfficialForUserID:(NSString *)userID;
{
    
    NSInteger founded = NSNotFound;
    OfficialUsersData *officialUsersData = self.loginUserInfoData.officialUsers;
    for (OfficialUser *oneUser in officialUsersData.userids) {
        if ([oneUser.userid isEqualToString:userID]) {
            founded = 1;
            break;
        }
    }
    
    return !(founded == NSNotFound);
}

-(NSString*)longitude
{
    NSString* resuslt = @"";
    if (!STR_IS_NIL(_gps)) {
        NSArray *gpsArray = [_gps componentsSeparatedByString:@","];
        if(gpsArray.count > 1)
        {
            resuslt = [gpsArray objectAtIndex:1];//分享经度，可能为空
        }
    }
    return resuslt;
}

-(NSString*)latitude
{
    NSString* resuslt = @"";
    if (!STR_IS_NIL(_gps)) {
        NSArray *gpsArray = [_gps componentsSeparatedByString:@","];
        if(gpsArray.count > 1)
        {
            resuslt = [gpsArray objectAtIndex:0];//分享纬度可能为空
        }
    }
    return resuslt;
}
@end
