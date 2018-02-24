#ifndef _UPNP_SERVER_H_
#define _UPNP_SERVER_H_

#ifdef __cplusplus
extern "C"
{
#endif
    
#include "upnp_common.h"

/**
 * @file
 * @ingroup highlevelapi
 * Upnp server module provides a high level interface to access media server
 */


/** Media types that can be given as argument to acceptMediaTypes in UAVMS_AddLocalObject.*/
#define CD_ACCEPT_AUDIO 1
#define CD_ACCEPT_VIDEO 2
#define CD_ACCEPT_IMAGE 4
#define CD_ACCEPT_TEXT 8
#define CD_ACCEPT_ALL_MEDIA 0x07
#define CD_ACCEPT_ALL (0)

#define CD_ROOT_CONTAINERID "0"

//添加共享时的错误值
#define CD_NO_ERR  		                   0	//无错误
#define CD_ERR_UNKNOWN_TYPE        1	//不被允许或者未知的文件格式
#define CD_ERR_NO_MEMORY              2	//内存不足
#define CD_ERR_INVALID_PATH          3		//想要加入的共享路径不存在
#define CD_ERR_PATH_NOTEXITED      4	//想要共享的文件或者目录不存在
#define CD_ERR_ACCESS_FAILED         5	//文件或者目录访问失败
#define CD_ERR_NET_FAILED               6	//网络错误，无法共享-无法取到本地ip地址
#define CD_ERR_SHARE_AGAIN               7	//已经共享,不允许重复共享

#define CD_ERR_COMMON                   -1	//



#define UAVMS_MAX_CD_OBJECT_ID_SIZE 255
#define UAVMS_MAX_DLNA_PARAMETER_LEN 128



/**
 * Start media server.<br/>
 * The stack must be shutdown with UPNP_Finish or UPNP_DmsStop.
 *
 * @param createUniqueUDNs TRUE of unique UDN is to be created, otherwise FALSE.
 * @return 0 if successful, otherwise a error code.
 */
int UPNP_DmsStart(BOOL createUniqueUDN);


/**
 * Stop media server.<br/>
 * If quit stack, should call UPNP_Finish. If stop media server, should call UPNP_DmsStop.
 *
 * @return 0 if successful, otherwise a error code.
 */
int UPNP_DmsStop(void);


/**
 * Rename the friendname of media server.<br/>
 *
 * @param friendlyname Must be ASCII.
 * @return 0 if successful, otherwise a error code.
 */
int UPNP_DmsRename(const char *friendlyname);


/**
	 * Adds files and directories from the local file 
	 * system to the local ContentDirectory DB.
	 * The files and directories (or links to them) should be physically located
	 * in the file system.<br/>
	 * @param filename		[IN] The name of the file or directory in the local file system 
	 *						from which items are to be added to the DB.
	 *						If filename is NULL, the behavior is undetermined.
	 * @param acceptMediaType	[IN] The media types that are accepted to be added to this container.
	 * 					Possible acceptMediaTypes are : CD_ACCEPT_AUDIO,
	 * 					CD_ACCEPT_VIDEO, CD_ACCEPT_IMAGE and CD_ACCEPT_ALL.
	 * 				    This can be ORred as an input parameter.
	 * @param containerId		[IN] The local CD containerId of into which the files are to be added.	
	 * if is "0", add to root ,if null,  add to root the path
	 * @param recursive		[IN] If true, the filename has to be a directory. All files
	 *						in the directory are added to the CD DB and the directory 
	 *						is scanned recursively adding all media items 
	 *						in all subdirectories.
	 *						If false, only the file system item indicated by filename 
	 *						is added to the contNode.
	 * @param keepDirStructure	[IN] If true, the directory structure in the local file system is copied to
	 *						CD DB when adding containers and items recursively. If false, items and 
	 *						containers are added directly under containerId container node.
	 * @param addedId [OUT] The added item ID as string to the CD database object which refers to the added
	 *						container or item.
	 * @return 0 if successful, otherwise a system wide error code.
 */
int UAVMS_AddLocalObject(const char* filename, 
			int acceptMediaTypes, 
			const char* containerId,
			BOOL recursive,
			BOOL keepDirStructure,
			const char addedId[UAVMS_MAX_CD_OBJECT_ID_SIZE]);
    
int IOS_AddLocalObject(const char* filename,
                           int acceptMediaTypes,
                           const char* containerId,
                           BOOL recursive,
                           BOOL keepDirStructure,
                       const char addedId[UAVMS_MAX_CD_OBJECT_ID_SIZE]);


/**
	 * Adds file from the local file system to the local ContentDirectory DB.
	 * The files  should be physically located in the file system.<br/>
	 * @param filename		[IN] The name of the file or directory in the local file system 
	 *						from which items are to be added to the DB.
	 *						If filename is NULL, the behavior is undetermined.
	 * @param acceptMediaType	[IN] The media types that are accepted to be added to this container.
	 * 					Possible acceptMediaTypes are : CD_ACCEPT_AUDIO,
	 * 					CD_ACCEPT_VIDEO, CD_ACCEPT_IMAGE and CD_ACCEPT_ALL.
	 * 				    This can be ORred as an input parameter.
	 * @param containerId		[IN] The local CD containerId of into which the files are to be added.	
	 * if is "0", add to root ,if null,  add to root the path
        * @param title      [IN] title
        * @param thumbnail      [IN] thumbnail
        * @param artist      [IN] artist
        * @param date      [IN] date
        * @param duration      [IN] duration
        * @param size      [IN] size
        * @param resolution      [IN] resolution       
	 * @param addedId [OUT] The added item ID as string to the CD database object which refers to the added
	 *						container or item.        
	 * @return 0 if successful, otherwise a system wide error code.
 */
int UAVMS_AddLocalFileDetail(const char* filename, 
			int acceptMediaTypes, 
			const char* containerId,
			char* title,
            char* thumbnail,
            char* artist,
            char* date,
            char* duration,
            char* size,
            char* resolution,
			const char addedId[UAVMS_MAX_CD_OBJECT_ID_SIZE]);


/**
	 * Adds files and directories from the local file 
	 * system to the local ContentDirectory DB.
	 * The files and directories (or links to them) should be physically located
	 * in the file system.<br/>
	 * @param filename		[IN] The name of the file or directory in the local file system 
	 *						from which items are to be added to the DB.
	 *						If filename is NULL, the behavior is undetermined.
	 * @param acceptMediaType	[IN] The media types that are accepted to be added to this container.
	 * 					Possible acceptMediaTypes are : CD_ACCEPT_AUDIO,
	 * 					CD_ACCEPT_VIDEO, CD_ACCEPT_IMAGE and CD_ACCEPT_ALL.
	 * 				    This can be ORred as an input parameter.
	 * @param containerId		[IN] The local CD containerId of into which the files are to be added.	
	 * if is "0", add to root ,if null,  add to root the path
	 * @param recursive		[IN] If true, the filename has to be a directory. All files
	 *						in the directory are added to the CD DB and the directory 
	 *						is scanned recursively adding all media items 
	 *						in all subdirectories.
	 *						If false, only the file system item indicated by filename 
	 *						is added to the contNode.
	 * @param keepDirStructure	[IN] If true, the directory structure in the local file system is copied to
	 *						CD DB when adding containers and items recursively. If false, items and 
	 *						containers are added directly under containerId container node.
	 * @param addedId [OUT] The added item ID as string to the CD database object which refers to the added
	 *						container or item.
	 * @return 0 if successful, otherwise a system wide error code.
 */
int UAVMS_AddPushSharedFile(const char* filename, 
                                    int acceptMediaTypes, 
                                    const char* containerId,
                                    int recursive,
                                    int keepDirStructure,
                                    const char addedId[UAVMS_MAX_CD_OBJECT_ID_SIZE]);


/**
 * Removes added object(s) from the local ContentDirectory DB.<br/>
 *
 * @param filename		[IN] The ID of the container or item 
 *							that should be removed from the ContentDirectory DB.
 * @return 0 if successful, otherwise a system wide error code.
 */
int UAVMS_RemoveLocalObject(const char* objectId);


int UAVMS_RemoveLocalObjectNoPath(const char* objectId);

/**
 * Adds a customer specific MIME type to the list of predefined
 * mime types.<br/>
 *
 * @param fileExtension  [IN] The file extension of the MIME type.
 * @param contentType  [IN] the MIME type.
 * @return 0 if adding was successful otherwise a system wide error.
 */
int UAVDEV_AddCustomerMimeType(const char *fileExtension, const char *mimeType);


void DLNA_set_default_path(char *dir);

/**
 * Get dms http port.<br/>
 *
 * @return port otherwise -1.
 */
int UPNP_DmsGetPort(void);    
    
#ifdef __cplusplus
}
#endif

#endif
