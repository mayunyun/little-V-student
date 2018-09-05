
#import "XtomFunction.h"
#import "XTomRequest.h"
#import "XtomManager.h"
#import "XtomCashManager.h"
#import "Navbar.h"
#import "MLNavigationController.h"
#import "UINavViewController.h"

///////////////////////////////////////////////////////////////
//                     导航设置                               //
///////////////////////////////////////////////////////////////
#define TitleFont 20
#define TitleColor [UIColor whiteColor]

#define BackItemOffset UIEdgeInsetsMake(0, 5, 0, 0)
#define ItemLeftMargin 0
#define ItemWidth 48
#define ItemHeight 30
#define ItemTextFont 16
#define ItemTextNormalColot [UIColor whiteColor]
#define ItemTextSelectedColot [UIColor grayColor]
#define ItemTextSelectedColotDisabled [UIColor lightGrayColor]
///////////////////////////////////////////////////////////////
//                     界面相关                               //
///////////////////////////////////////////////////////////////
#define UINavigationBarButton_Color_Red 239/255.0
#define UINavigationBarButton_Color_Green 239/255.0
#define UINavigationBarButton_Color_Blue 239/255.0
#define UINavigationBarButton_Color_ALPHA 1
#define BB_Color_NavigationBar [UIColor colorWithRed:UINavigationBarButton_Color_Red green:UINavigationBarButton_Color_Green blue:UINavigationBarButton_Color_Blue alpha:UINavigationBarButton_Color_ALPHA]

#define UIViewBack_Color_Red 230/255.0
#define UIViewBack_Color_Green 230/255.0
#define UIViewBack_Color_Blue 230/255.0
#define UIViewBack_Color_Alpha 1.0
#define BB_Color_BackGround ([UIColor colorWithRed:UIViewBack_Color_Red green:UIViewBack_Color_Green blue:UIViewBack_Color_Blue alpha:UIViewBack_Color_Alpha])
#define BB_Back_Color_Here_Bar [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0f]

#define UIBorder_Color_Red 199/255.0
#define UIBorder_Color_Green 199/255.0
#define UIBorder_Color_Blue 199/255.0
#define UIBorder_Color_Alpha 1.0

#define BB_Blake [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1]
#define BB_BorderOne_Color [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1]
#define BB_TitleColor [UIColor colorWithRed:240/255.0 green:122/255.0 blue:22/255.0 alpha:1]
#define BB_RED_HERE [UIColor colorWithRed:238/255.0f green:86/255.0f blue:92/255.0f alpha:1.0f]
#define BB_shadow_color [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1.0f]
#define BB_Green_Color [UIColor colorWithRed:59/255.0 green:121/255.0 blue:178/255.0 alpha:1]
#define BB_Green11_Color [UIColor colorWithRed:0/255.0 green:210/255.0 blue:77/255.0 alpha:1]
#define BB_NewGreenlight_Color [UIColor colorWithRed:94/255.0 green:117/255.0 blue:143/255.0 alpha:1]
#define BB_NewGreen_Color [UIColor colorWithRed:52/255.0 green:77/255.0 blue:105/255.0 alpha:1]
#define BB_New_StyleColor [UIColor colorWithRed:58/255.0 green:198/255.0 blue:227/255.0 alpha:1]
//增周几个颜色值
#define BB_243_243_243_10 [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0f]
#define BB_230_232_227_10 [UIColor colorWithRed:230/255.0 green:232/255.0 blue:227/255.0 alpha:1.0f]
#define BB_124_198_38_10 [UIColor colorWithRed:124/255.0 green:198/255.0 blue:38/255.0 alpha:1.0f]

///////////////////////////////////////////////////////////////
//                     主要几种颜色变量                         //
///////////////////////////////////////////////////////////////
#define BB_Back_Color_Here [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0f]
#define BB_Red_Color [UIColor colorWithRed:236/255.0 green:88/255.0 blue:93/255.0 alpha:1]
#define ZH_Red_Color [UIColor colorWithRed:252/255.0 green:100/255.0 blue:124/255.0 alpha:1]


#define BB_White_Color [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]
#define BB_Border_Color [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1]
#define BB_lineColor [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1]
#define BB_Orange_Color [UIColor colorWithRed:251/255.0 green:84/255.0 blue:54/255.0 alpha:1]
#define BB_Blue_Color [UIColor colorWithRed:58/255.0 green:198/255.0 blue:227/255.0 alpha:1]
#define BB_Gray [UIColor colorWithRed:149/255.0 green:149/255.0 blue:149/255.0 alpha:1.0f]
#define BB_Graylight [UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1.0f]
#define BB_Graydark [UIColor colorWithRed:71/255.0 green:71/255.0 blue:71/255.0 alpha:1.0f]
#define ZH_Green [UIColor colorWithRed:24/255.0 green:178/255.0 blue:130/255.0 alpha:1.0f]
#define ZH_Nav_Green [UIColor colorWithRed:37/255.0 green:137/255.0 blue:137/255.0 alpha:1.0f]
#define ZH_Light_Green [UIColor colorWithRed:160/255.0 green:199/255.0 blue:199/255.0 alpha:1.0f]
#define ZH_Background [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0f]
#define ZH_Tabbar [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1.0f]

#define BB_COLOR_0_55_0_10 [UIColor colorWithRed:0/255.0 green:55/255.0 blue:0/255.0 alpha:1.0f]
#define BB_COLOR_149_149_149_10 [UIColor colorWithRed:149/255.0 green:149/255.0 blue:149/255.0 alpha:1.0f]
#define BB_COLOR_234_234_234_10 [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0f]
///////////////////////////////////////////////////////////////
//                     定义系统常量相关                         //
///////////////////////////////////////////////////////////////
#define CoLocation CLLocationCoordinate2DMake(36.678573, 117.121612)
#define UI_View_Hieght (kDevice_Is_iPhone5?504.0f:416.0f)//带navigationbar View 的高度
#define NOTIFICATION_OUT_NOTE @"outNote"
#define BB_XCONST_PAGE_SIZE  10
#define BB_TIME_CODE @"60"//验证码时长
#define BB_TIME_RECORD 90//录音时长
#define BB_Time_ACTIVE 0.5f //动画时长
#define BB_TabBar_Height 44//底栏的高度
#define BB_XCONST_IS_DRAGING @"isDrag" //是否正在拖动 0 没有 1 在拖
#define BB_XCONST_IS_PAY @"isPay" //是否已经支付 0 没有 1 支付

#define BB_XCONST_FONT_MAIN_SIZE 14.0f
#define BB_XCONST_FONT_CONTENT 16.0f
#define ConFont 20//标题内容的大小

#define BB_XCONST_TIME_FAMAT @"yy-MM-dd HH:mm +0800"
#define BB_XCONST_INTERVAL 0.8f//自动关闭弹出框 停留时间

#define BB_XCONST_KEFUTEL @"400-880-1234"
#define BB_UMENG_APPKEY @"5302f3de56240b3bd700a5e3"

#define BB_CASH_DOCUMENT @"baowencash"//缓存目录
#define BB_CASH_AVATAR @"avatar"//头像目录
#define BB_CASH_BLOG @"blog"//博文图片目录
#define BB_CASH_AUDIO @"audio"//语音目录
#define BB_CASH_VIDEO @"video"//视频目录
#define BB_CASH_TALK @"talk"//聊天记录缓存目录

#define BB_CASH_DATABASE @"chatDatabase.db"//缓存数据库名称
#define BB_DB_DISTRICT @"sys_cascade_district"//地区表

#define BB_NOTIFICATION_GET_MESSAGE @"getMessage"//获取消息的通知
#define BB_NOTIFICATION_SEND_MESSAGE @"sendMessage"//发送消息的通知
#define BB_NOTIFICATION_START_LOCATION @"startLocation"//打开位置的通知
#define BB_XCONST_LOCAL_MESSAGE @"localMessage"//系统推送消息
#define BB_NOTIFICATION_MeSSAGE @"messageNotice"//系统推送消息的通知
#define BB_BOTIFICATION_PAY @"paymoney" //支付消息
#define BB_NOTIFICATION_SELECT @"selectbar" //点击选项卡消息通知
#define BB_NOTIFICATION_Progress @"myProgress"//下载进度条的通知

#define BB_XCONST_ISAUTO_LOGIN @"isAutoLogin"//userDefaults 关于自动登录的名称
#define BB_XCONST_LOCAL_PASSWORD @"localPWD"//本地密码的名称
#define BB_XCONST_LOCAL_LOGINNAME @"loginname" //记住登录名
#define BB_XCONST_LOCAL_ID @"localID"//登陆的id
#define BB_XCONST_LOCAL_TELNUMBER @"localTelNumber"//本机手机号
#define BB_XCONST_LAST_VERSION @"lastversion"//本地版本号
#define BB_XCONST_NO_UPDATE @"versionupdate"//是否更新 1为不更新 0更新
#define GDownLoad @"gdownload"//2G 3G 下载开关 1 可下载 0 不可下载
#define HouDownLoad @"houdownload"// 后台下载开关 1 可下载 0 不可下载
#define MyClock @"myclock"// 闹钟开关 1 开启 0 关闭

///////////////////////////////////////////////////////////////
//                          逻辑相关                          //
///////////////////////////////////////////////////////////////
//#define REQUEST_MAINLINK_INIT @"http://192.168.0.146:8008/group1/hm_PHP/index.php/webservice/"


//修改必改
//#define REQUEST_MAINLINK_INIT_IMAGE @"http://192.168.2.146:8008/group2/hm_XYGG/"
//#define REQUEST_MAINLINK_INIT @"http://192.168.2.146:8008/group2/hm_XYGG/index.php/webservice/"


#define REQUEST_MAINLINK_INIT_IMAGE @"http://121.40.110.29/"
#define REQUEST_MAINLINK_INIT @"http://121.40.249.75:8080/hclz/"
//public static final String SYS_ROOT = "http://121.40.110.29:80/"; // 开发使用地址
//	public static final String SYS_ROOT = "http://app.xiaoyuanguagua.com/";	//开发之前的
//	public static final String SYS_ROOT = "http://app.schooltime.ren/";   // 正式发布的地址

//http://115.29.208.238:81
//http://app.xiaoyuanguagua.com
//http://121.40.110.29




#define REQUEST_CHAT_INIT @"192.168.0.146"//聊天初始化
#define REQUEST_CHAT_PORT @"5222"//聊天端口初始化
#define REQUEST_MAINLINK [XtomFunction getRootPath]//服务器根地址
#define REQUEST_HOST [XtomFunction getChatPath]//聊天服务器根地址
#define REQUEST_MONEY @"58.56.89.218:8008"//首次调用初始化的接口 根据项目自己配置
#define REQUEST_INVITE_ADD @"invite_add"//邀请加入群或社团接口
#define REQUEST_FRIEND_ADD @"friend_add"//好友添加接口
#define REQUEST_SYSTEM_INIT @"index/init"//系统初始化
#define REQUEST_LOGIN_LINK @"client_login"//登陆接口
#define REQUEST_REGISTER_GET_CODE @"code_get"//申请验证码接口
#define REQUEST_REGISTER_VERIFY_CODE @"code_verify"//验证验证码
#define REQUEST_USERNAME_SAVE @"username_save"//修改用户名
#define REQUEST_GOODS_SAVEOPERATE @"goods_saveoperate"//保存商品操作接口

#define REQUEST_GET_MOBILE_LIST @"mobile_list"//邀请通讯录号码安装软件接口
#define REQUEST_REGISTER_LINK @"client_add"//注册接口
#define REQUEST_FINDPWD_VERIFY_USER @"client_verify"//找回密码 验证用户
#define REQUEST_FINDPWD_RESETPWD @"password_reset"//找回密码 重设密码
#define REQUEST_SAVE_POSITION @"position_save"//保存位置
#define REQUEST_UPLOAD_FILE @"file_upload"//上传文件
#define REQUEST_SAVE_DEVICE @"device_save"//硬件注册
#define REQUEST_LOGIN_OUT @"client_loginout"//退出登录
#define REQUEST_SAVE_PASSWORD @"password_save"//修改密码
#define REQUEST_SAVE_CLIENT @"client_save"//保存个人资料
#define REQUEST_GET_CLIENT @"client_get"//获取个人资料
#define REQUEST_COLLEGE_LIST @"college_list"//获取学校、专业、班级类别列表接口
#define REQUEST_OTHERTYPE_LIST @"othertype_list"//获取其他类别列表接口
#define REQUEST_FOOD_LIST    @"food_list"
#define REQUEST_All_city_list  @"all_city_list"
#define REQUEST_SHOW_GOODS @"show_goods"//获取商品详情

#define REQUEST_BILL_ADD    @"bill_add"
#define REQUEST_BILL_LIST   @"bill_list"
#define REQUEST_JUDGE_FLAG_GET @"judge_flag_get"
#define REQUEST_JUDGE_FLAG_GET @"judge_flag_get"
#define REQUEST_JUDGE_LIST    @"judge_list"
#define REQUEST_TRADE_SAVE    @"trade_save"
#define REQUEST_SHARE_ROOT    @"http://58.56.89.218:8008/group2/hm_SCMS/"
#define REQUEST_TRADE_CONFIRM    @"trade_confirm"
#define REQUEST_TRADE_LIST    @"trade_list"
#define REQUEST_SHARE_SUCC_CALLBACK   @"share_succ_callback"
#define REQUEST_FOOD_GET    @"food_get"
#define REQUEST_BUSINESS_GET    @"business_get"
#define REQUEST_LOCAL_PAY_SAVE    @"local_pay_save"//
#define REQUEST_TRADE_GET    @"trade_get"
#define REQUEST_COUPON_GET    @"coupon_get"
#define REQUEST_NEW_NOTICE_GET    @"new_notice_get"
#define REQUEST_JUDGE_ADD    @"judge_add"
#define REQUEST_GROUP_ADD @"group_add"//群组增加接口

#define REQUEST_ABOUT_SAVE1 @ "about_save" //修改关于组织信息接口
#define REQUEST_RSS_REMOVE @ "rss_remove" //取消订阅
#define REQUEST_RSS_ADD @ "rss_add" //订阅

#define REQUEST_RSS_VERIFY @ "rss_verify" //订阅
#define REQUEST_ABOUT_SAVE1 @ "about_save" //修改关于组织信息接口
#define REQUEST_NAME_SAVE1 @"name_save"//修改社团或群组名称信息接口
#define REQUEST_ABOUT_ADD @"about_add"//添加关于组织信息接口
#define REQUEST_SAVE_BLOG @"blog_add"//保存帖子
#define REQUEST_GET_BLOG_LIST @"blog_list"//获取帖子列表  这个接口只返回一张图片需要修改 gai
#define REQUEST_SAVE_OPERATE @"blog_saveoperate"//保存帖子操作接口
#define KjuBao @"blog_report" //举报
#define kshiGuangList @"pub_account_list" //时光号列表
#define KshiGuangGuanZhu   @"pub_fans_add" //关注时光号
#define KongdezhiGuanZhu   @"fans_add" //个人关注
#define KshiGuangQuxiao @"pub_fans_remove" //取消关注时光号
#define KongdezhiQuxiao @"fans_remove" //取消个人关注
#define REQUEST_GET_BLOG_DATAIL @"blog_get"//获取帖子详情
#define REQUEST_SAVE_ADVICE @"advice_add"//意见反馈
#define REQUEST_GET_IMG_LIST @"img_list"//获取相册
#define REQUEST_BILL_SAVEOPERATE @"bill_saveoperate"//保存帖子操作接口
#define REQUEST_LIST_MODULE_AD @"list_module_ad"//获取分类幻灯片列表接口



#define REQUEST_IMG_FOOD_LIST @"img_food_list"//获取呱呱购图片列表
#define REQUEST_ABOUT_GET @"about_get"//获取组织关于详情信息接口
#define REQUEST_OPERATE_BROADCAST @"broadcast_saveoperate"//广播操作
#define REQUEST_BROADCAST_LIST @"broadcast_list"//广播列表
#define REQUEST_GET_NOTICE_LIST @"notice_list"//通知列表
#define REQUEST_OPERATE_NOTiCE @"notice_saveoperate"//通知操作
#define REQUEST_GET_APPS_LIST @"apps_list"//应用推荐列表
#define REQUEST_SERVICE_GET @"service_get"//联系客服

#define REQUEST_SAVE_FRIEND @"friend_add"//保存好友
#define REQUEST_SAVEOPERATE @"request_saveoperate"//请求操作接口




#define REQUEST_CLIENT_SAVEOPERATOR @"client_saveoperate"//成员操作接口

#define REQUEST_REMOVE_FRIEND @"friend_remove"//移除好友
#define REQUEST_SAVE_MSG @"msg_add"//保存私信接口
#define REQUEST_GET_MSG_LIST @"msg_list"//获取私信消息列表

#define REQUEST_ASK_ADD @"ask_add"//添加提问
#define REQUEST_ASK_LIST @"ask_list"//提问列表
#define REQUEST_ASK_GET @"ask_get"//提问详情

#define REQUEST_REPLY_ADD @"reply_add"//评论添加
#define REQUEST_REPLY_LIST @"reply_list"//评论列表
#define REQUEST_REPLY_REMOVE @"reply_remove"//评论删除

#define REQUEST_LIST_SUBMODULE_GOODS @"list_submodule_goods"//评论列表
#define REQUEST_LIST_COMMENT @"list_comment"//评论列表

#define REQUEST_GOODS_LIST @"goods_list"//评论列表

#define REQUEST_CART_BUY @"cart_buy"//放入购物车
#define REQUEST_CART_OPERATE @"cart_operate"//购物车操作
#define REQUEST_CART_LIST @"cart_list"//购物车列表
#define REQUEST_CLIENT_ACCOUNTPAY @"client_accountpay"//余额购买

///////////////////////////////////////////////////////////////
//                          业务相关                          //
///////////////////////////////////////////////////////////////
#define REQUEST_TYPE_LIST @"type_list"//章节类别列表
#define REQUEST_ASKTYPE_LIST @"asktype_list"//问答类别列表
#define REQUEST_OTHERTYPE_LIST @"othertype_list"//其他类别列表
#define kgetXue @"school_change_apply" //修改学校
#define kGetGunagGao @"home_ad_list"//获取首页广告

#define REQUEST_LIST_SUB_MODULE @"list_sub_module"


#define REQUEST_APPLY_ADD @"apply_add"//社区报名接口
#define REQUEST_IMG_SAVEOPERATE @"img_saveoperate"//图片操作

#define REQUEST_EXAM_INIT @"exam_init"//题目初始化
#define REQUEST_EXAM_GET @"exam_get"//题目详情
#define REQUEST_EXAM_SAVE @"exam_save"//成绩保存
#define REQUEST_TEST_LIST @"test_list"//趣味测试列表
#define REQUEST_ADMIN_VERIFY @"admin_verify"//验证是否为管理员

#define REQUEST_GROUP_ID_GET @"group_id_get"//获取群组id接口

#define REQUEST_CHAPTER_LIST @"chapter_list"//章节列表
#define REQUEST_CHAPTER_GET @"chapter_get"//章节详情
#define REQUEST_FAVORITE_LIST @"favorite_list"//收藏列表
#define REQUEST_VIDEO_LIST @"video_list"//课时列表
#define REQUEST_VIDEO_BUY @"video_buy"//购买课时
#define REQUEST_CHAPTER_SAVE @"chapter_saveoperate"//章节操作
#define REQUEST_VIDEO_SAVE @"video_saveoperate"//课时操作
#define REQUEST_STUDY_LIST @"study_list"//企业学习列表
#define REQUEST_PERCENT_GET @"percent_get"//企业学习进度

#define REQUEST_REQUEST_ADD @ "request_add"//申请加入群或社团接口
#define REQUEST_REQUEST_LIST1 @ "request_list"//获取加入请求列表

#define REQUEST_FRIEND_REMOVE @"friend_remove"//员工列表



#define REQUEST_COMPANY_GET @"company_get"//企业详情
#define REQUEST_DEPT_LIST @"dept_list"//部门列表
#define REQUEST_CLIENT_REMOVE @"client_remove"//移除员工
#define REQUEST_CLIENT_LIST @"client_list"//员工列表
#define REQUEST_SERVICE_GET @"service_get"//联系客服
#define REQUEST_GROUP_LIST @"group_list"//组织列表
#define REQUEST_GROUPCHAT_ADD @"groupchat_add"//邀请加入讨论组
#define REQUEST_COMPANYCHAT_ADD @"companychat_add"//加入公司群聊
#define REQUEST_MEMO_SAVE @"memo_save"//我的好友修改备注

#define REQUEST_GROUP_ADD @"group_add"//添加讨论组
#define REQUEST_GROUP_LIST @"group_list"//讨论组列表
#define REQUEST_GROUP_GET @"group_get"//讨论组详情
#define REQUEST_GROUP_REMOVE @"group_remove"//自己主动退出（或由管理员踢出）群组