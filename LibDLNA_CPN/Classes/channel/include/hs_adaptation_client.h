/*
this file export api for hisense sip;
auther:yangfuxing hisense 
*/


#ifndef _HS_TRANSMIT_CHANNEL_H_
#define _HS_TRANSMIT_CHANNEL_H_

/* 
												��Ϣ��ʽ
												
******************************************************************************************************************************************************
|						 |	�����	  |						   |	�����	|									   |	�����	|					 |
|��Ϣ���ͣ����ҵ����̬��|<HS_SIP_TAG>|�豸���ͣ�����ض��豸��|<HS_SIP_TAG>|��Ϣ���ԣ�������������Ϣ����������Ϣ��|<HS_SIP_TAG>|��Ϣ���ݣ���Ϣʵ�壩|
|						 |			  |				 		   |			|									   |			|					 |
******************************************************************************************************************************************************
**************************************************************************************************
|	�����	  |						   |	�����	|			   |   �����     |              |
|<HS_SIP_TAG> |  �ź�Դ���ͣ����⣩    |<HS_SIP_TAG>|   ����ģʽ   |<HS_SIP_TAG>  |  ��������    |
|			  |				 		   |			|	  ����     |              |	   ����      |
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
	MSG_TYPE_ERR = 0,		//�������
	MSG_TYPE_KEY,			//��������
	MSG_TYPE_INPUT,			//���뷨����
	MSG_TYPE_VOICE,			//��������
	MSG_TYPE_EPG,			//EPG����
	MSG_TYPE_HEA,			//�ҵ����(household electrical appliances) ����
	MSG_TYPE_IMAGEPLAYER,			//ͼƬ����������
	MSG_TYPE_FUSIONVIDEO,//��Ƶ�ں�����
	MSG_TYPE_COUNT,			//��������
	} msg_type_t;			//��Ϣ����
	
typedef enum household_electrical_appliances_type{
	GOODS_ERR = -1,					//�������
	BLACK_GOODS_STB,				//�����У�ý�����ģ�0
	BLACK_GOODS_DVD,				//DVD��ý�����ģ�1
	BLACK_GOODS_TV,					//���ӻ�2
	WHITE_GOODS_WASHER,				//ϴ�»�
	WHITE_GOODS_FRIDGE,				//�����
	WHITE_GOODS_AIR_CONDITIONING,	//�յ�
	WHILE_GOODS_WATER_HEATER,		//��ˮ��
	GOODS_HEAT_CONTROLER,			//ů��������
	GOODS_COUNT,					//�豸��������
	} msg_goods_t;					//�豸����
	
typedef enum msg_head{
	MSG_HEAD_ERR = 0,		//�������
	MSG_HEAD_CMD,			//��Ϣ����
	MSG_HEAD_CONTENT,		//��Ϣ����
	MSG_HEAD_COUNT,			//��Ϣͷ����
	} msg_head_t;

typedef enum msg_source{
	MSG_SOURCE_ERR = -1,	//�������
	MSG_SOURCE_HDMI = 2,	//HDMI
	MSG_SOURCE_AV = 5,		//AV iN
	MSG_SOURCE_MC = 10,		//Media Center
	MSG_SOURCE_COUNT,	    //�ź�Դ��������
	} msg_source_t;			//�ź�Դ����
	
typedef enum msg_keymode{
	MSG_KEYMODE_ERR = -1,		//�������
	MSG_KEYMODE_SINGLE = 0,	    //����
	MSG_KEYMODE_CONTINUE_START,	//��������ʼ
	MSG_KEYMODE_CONTINUE_STOP,	//����������
	MSG_KEYMODE_COUNT,	    	//����ģʽ����
	} msg_keymode_t;			//����ģʽ

typedef enum msg_keytype{
	MSG_KEYTYPE_ERR = -1,		//�������
	MSG_KEYTYPE_BASE = 0,	    //��������
	MSG_KEYTYPE_ASSIST,			//��������
	MSG_KEYTYPE_COUNT,	    	//������������
	} msg_keytype_t;			//��������
	
typedef char* msg_body_t;//��Ϣ���ݣ���ֵ�ַ�����
	
typedef struct msg_info{
	msg_type_t type;			//��Ϣ����, enum
	msg_goods_t goods;			//�豸����, enum
	msg_head_t head;			//��Ϣ����, enum
	msg_body_t body;			//��Ϣ���� char*
	msg_source_t sourcetype;    //�ź�Դ���ͣ�ý�����ģ�, enum
	msg_keymode_t keymode;		//����ģʽ��ý�����ģ�, enum
	msg_keytype_t keytype;		//�������ͣ�ý�����ģ�, enum
	} msg_info_t;
	

typedef void (* callback_msg_func)(char *svrinfo,int reserved);
int register_message_callback(callback_msg_func on_msg_func);//���ÿͻ��˽�����Ϣ�ص�

typedef void (* callback_channel_Exception) (char *exceptinfo,int errnum);//������Ϣ && �����
int register_channelException_callback(callback_channel_Exception on_msg_func);//����ͨ���쳣�Ͽ�֪ͨ�ص�

int client_connect(char *svrip, short port);//���ӷ����
int send_keystr(int deviceid,int sourceid,char *keystr,int key_mode,int msg_type,int reserved);//������Ϣ
int client_disconnect();//�Ͽ�����

#endif