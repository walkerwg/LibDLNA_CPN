/*
this file export api for hisense sip;
auther:yangfuxing hisense 
*/


#ifndef _HS_TRANSMIT_CHANNEL_H_
#define _HS_TRANSMIT_CHANNEL_H_

/* 
												消息格式
												
******************************************************************************************************************************************************
|						 |	间隔符	  |						   |	间隔符	|									   |	间隔符	|					 |
|消息类型（针对业务形态）|<HS_SIP_TAG>|设备类型（针对特定设备）|<HS_SIP_TAG>|消息属性（区分是命令消息还是数据消息）|<HS_SIP_TAG>|消息内容（消息实体）|
|						 |			  |				 		   |			|									   |			|					 |
******************************************************************************************************************************************************
**************************************************************************************************
|	间隔符	  |						   |	间隔符	|			   |   间隔符     |              |
|<HS_SIP_TAG> |  信号源类型（红外）    |<HS_SIP_TAG>|   按键模式   |<HS_SIP_TAG>  |  按键类型    |
|			  |				 		   |			|	  红外     |              |	   红外      |
**************************************************************************************************
*/
typedef enum msg_tag{
	MSG_TAG_TYPE = 0,
	MSG_TAG_GOODS,
	MSG_TAG_HEAD,
	MSG_TAG_BODY,
	MSG_TAG_SOURCE,
	MSG_TAG_KEYMODE,
	MSG_TAG_KEYTYPE,
	} msg_tag_t;

typedef enum msg_type{
	MSG_TYPE_ERR = 0,		//错误代码
	MSG_TYPE_KEY,			//按键类型
	MSG_TYPE_INPUT,			//输入法类型
	MSG_TYPE_VOICE,			//语音类型
	MSG_TYPE_EPG,			//EPG类型
	MSG_TYPE_HEA,			//家电控制(household electrical appliances) 类型
	MSG_TYPE_IMAGEPLAYER,			//图片播放器类型
	MSG_TYPE_FUSIONVIDEO,//视频融合类型
	MSG_TYPE_COUNT,			//类型数量
	} msg_type_t;			//消息类型
	
typedef enum household_electrical_appliances_type{
	GOODS_ERR = -1,					//错误代码
	BLACK_GOODS_STB,				//机顶盒（媒体中心）0
	BLACK_GOODS_DVD,				//DVD（媒体中心）1
	BLACK_GOODS_TV,					//电视机2
	WHITE_GOODS_WASHER,				//洗衣机
	WHITE_GOODS_FRIDGE,				//电冰箱
	WHITE_GOODS_AIR_CONDITIONING,	//空调
	WHILE_GOODS_WATER_HEATER,		//热水器
	GOODS_HEAT_CONTROLER,			//暖气控制器
	GOODS_COUNT,					//设备类型数量
	} msg_goods_t;					//设备类型
	
typedef enum msg_head{
	MSG_HEAD_ERR = 0,		//错误代码
	MSG_HEAD_CMD,			//消息命令
	MSG_HEAD_CONTENT,		//消息内容
	MSG_HEAD_COUNT,			//消息头数量
	} msg_head_t;

typedef enum msg_source{
	MSG_SOURCE_ERR = -1,	//错误代码
	MSG_SOURCE_HDMI = 2,	//HDMI
	MSG_SOURCE_AV = 5,		//AV iN
	MSG_SOURCE_MC = 10,		//Media Center
	MSG_SOURCE_COUNT,	    //信号源类型数量
	} msg_source_t;			//信号源类型
	
typedef enum msg_keymode{
	MSG_KEYMODE_ERR = -1,		//错误代码
	MSG_KEYMODE_SINGLE = 0,	    //单键
	MSG_KEYMODE_CONTINUE_START,	//连续键开始
	MSG_KEYMODE_CONTINUE_STOP,	//连续键结束
	MSG_KEYMODE_COUNT,	    	//按键模式数量
	} msg_keymode_t;			//按键模式

typedef enum msg_keytype{
	MSG_KEYTYPE_ERR = -1,		//错误代码
	MSG_KEYTYPE_BASE = 0,	    //基础按键
	MSG_KEYTYPE_ASSIST,			//辅助按键
	MSG_KEYTYPE_COUNT,	    	//按键类型数量
	} msg_keytype_t;			//按键类型
	
typedef char* msg_body_t;//消息内容（键值字符串）
	
typedef struct msg_info{
	msg_type_t type;			//消息类型, enum
	msg_goods_t goods;			//设备类型, enum
	msg_head_t head;			//消息属性, enum
	msg_body_t body;			//消息内容 char*
	msg_source_t sourcetype;    //信号源类型（媒体中心）, enum
	msg_keymode_t keymode;		//按键模式（媒体中心）, enum
	msg_keytype_t keytype;		//按键类型（媒体中心）, enum
	} msg_info_t;
	

typedef void (* callback_msg_func)(char *svrinfo,int reserved);
int register_message_callback(callback_msg_func on_msg_func);//设置客户端接收信息回调

typedef void (* callback_channel_Exception) (char *exceptinfo,int errnum);//错误信息 && 错误号
int register_channelException_callback(callback_channel_Exception on_msg_func);//设置通道异常断开通知回调

int client_connect(char *svrip, short port);//连接服务端
int send_keystr(int deviceid,int sourceid,char *keystr,int key_mode,int msg_type,int reserved);//传输信息
int client_disconnect();//断开连接

#endif