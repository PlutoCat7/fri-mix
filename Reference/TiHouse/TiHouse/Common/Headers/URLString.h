
//
//  URLString.h
//  TiHouse
//
//  Created by 吴俊明 on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#ifndef URLString_h
#define URLString_h

///获取日程列表(分页，根据房屋id=78，用户uid，过滤类型,start=0,limit=10,scheduletype=完成状态，0未完成1已完成,timetype=时间状态 1=过去 2=未来)
#define URL_Schedule_ByHouseidUid @"api/inter/schedule/pageByHouseidUid"
///删除日程(scheduleid,uid=36)
#define URL_Delete_Schedule @"api/inter/schedule/remove"
///获取日程列表(所有，根据房屋id，用户uid)
#define URL_Get_All_Schedule @"api/inter/schedule/listByHouseidUid"
///获取日程子列表(所有，按月，根据房屋id，用户uid)
#define URL_Schedule_List_By_Date @"api/inter/schedulesub/listMonthByHousidUid"
/// 编辑日程(完成状态)


//------亲友-----
///获取亲友列表
#define URL_Get_RelFri_List @"/api/inter/houseperson/listByHouseid"
///编辑亲友(昵称)
#define URL_Edit_RelFri_NickName @"/api/inter/houseperson/editNickname"
///7 删除亲友
#define URL_Delect_RelFri @"/api/inter/house/remove"
#define URL_Edit_Finish_Schedule @"api/inter/schedule/editScheduletype"
///编辑亲友(头像)
#define URL_Edit_Fri_Head @"api/inter/houseperson/editUrlhead"
///编辑亲友(权限)
#define URL_Edit_Fri_Auth @"api/inter/houseperson/editAuthority"
///4 编辑亲友(关系)
#define URL_Edit_TypeRelation @"api/inter/houseperson/editTypeRelation"


#endif /* URLString_h */
