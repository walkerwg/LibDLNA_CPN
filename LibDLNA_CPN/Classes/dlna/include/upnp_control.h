#ifndef _UPNP_CONTROL_H_
#define _UPNP_CONTROL_H_

#ifdef __cplusplus
extern "C"
{
#endif
    
#include "upnp_common.h"
#include "upnp_ext.h"

/**
 * @file
 * @ingroup highlevelapi
 * Upnp control module provides a high level interface to access media control point
 */

typedef struct {
	char *CurrentTransportState;	
	char *CurrentTransportStatus;
	char *CurrentSpeed;
}TransportInfopara;


/**
 * position info for controlpoint to handle.
 */
typedef struct PositionInfo_s {
	/** The current track number. */
	uint32_t Track;
	/** The current track duration .eg:"00:01:02" */
	const char* TrackDuration;
	/** The current relative time position in format "hh:mm:ss". */
	const char* RelTime;
	/** The current absolute time position in format "hh:mm:ss". */
	const char* AbsTime; 
	/** The current relative byte position. */
	const char* RelCount;
	/** The current absolute byte position. */
	const char* AbsCount;
} UAVMR_PositionInfo;


/**
 * Prototype of the customer specific device callbacks.<br/>
 * It carries data and state about one device.<br/>
 * @param device Data of device.
 * @param state State of device.
 */
typedef void (*UPNPDevListener)(UpnpDevType *device, UPNPDevState state);

/**
 * Start media control point.<br/>
 * The stack must be shutdown with UPNP_Finish or UPNP_DmcStop.
 *
 * @param enable_server TRUE of media server will be controled, otherwise FALSE.
 * @param enable_render TRUE of media renderer will be controled, otherwise FALSE.
 * @param cb The callback function for data and state about device.
 * @param ms  interval for sending out search messages in ms. If 0 - no periodic messages. If -1, use default
 * @return 0 if successful, otherwise a error code.
 */
int UPNP_DmcStart(BOOL enable_server, BOOL enable_render, UPNPDevListener cb);
int UPNP_DmcStart_IT(BOOL enable_server, BOOL enable_render, UPNPDevListener cb, long ms);

/**
 * Stop media control point.<br/>
 * If quit stack, should call UPNP_Finish. If stop media control point, should call UPNP_DmcStop.
 *
 * @return 0 if successful, otherwise a error code.
 */
int UPNP_DmcStop(void);


/**
 * Refresh devices list.<br/>
 * It will be clear the current list and send search msg to network.
 *
 * @return 0 if successful, otherwise a error code.
 */
int UPNP_DmcResearch(void);

/**
 * Judge device type.<br/>
 *
 * @param device_type device type string.
 * @return 1 if is media server, 2 if is media render, 0 if else.
 */
int UPNP_DmcDeviceType(char* device_type);

/**
 * Get the current all devices.<br/>
 *
 * @param server TRUE of media server will be get, otherwise FALSE.
 * @param render TRUE of media renderer will be get, otherwise FALSE.
 * @param cb The callback function for data and state about device. The state is UPNP_DEVGETALL.
 * @return 0 if successful, otherwise a error code.
 */
int UPNP_DmcGetDevices(BOOL server, BOOL render, UPNPDevListener cb);



/**
 * The playing state of the renderer.
 */
typedef enum UAV_PlayState_e {
	/** Not applicable */
	UAV_PLAY_NA,
	/** Playing */
	UAV_PLAY_PLAYING,
	/** Paused */
	UAV_PLAY_PAUSED,
	/** Stopped */
	UAV_PLAY_STOPPED,
	/** Seeking */
	UAV_PLAY_SEEKING,
} UAV_PlayState;

/**
 * Get the current render's state.
 * @param renderer [IN] render's udn 
 */
UAV_PlayState UAV_GetPlayState(const char* renderer);

/**
 * Plays mediaItem on the selected server/renderer pair.<br/>
 * mediaItem has to be an item fetched from server Browse or Search results.<br/>
 * If a play is already ongoing, the old play is stopped and the new started.<br/>
 * Returns 0 if operations were successful, otherwise a system error.
 * @param server_udn [IN] server's udn 
 * @param renderer_udn [IN] render's udn
 * @param url [IN] item's url
 * @param objectId [IN] item's objectId ,such as "0/1"
 * @return 0 if successful, otherwise a system wide error code.
 */

int UAV_Play(const char* server_udn, const char* renderer_udn, 
			 const char* url,const char* objectId);

/**
 * Plays mediaItem on the local device/renderer pair.<br/>
 * mediaItem has to be an item fetched from local filesystem  eg mnt/sdcard.<br/>
 * If a play is already ongoing, the old play is stopped and the new started.<br/>
 * Returns 0 if operations were successful, otherwise a system error.
 * @param renderer_udn [IN] render's udn
 * @param uri [IN] item's uri
 * @return 0 if successful, otherwise a system wide error code.
 */
int UAV_Play_LocalRes(const char* renderer_udn, 
			 const char* uri );
    

/**
* Stops playing the last play action.
* @param renderer [IN] render's udn 
* @return 0 if successful, otherwise a system wide error code.
*/
int UAV_Stop(const char* renderer);

/**
* Pauses playing the last play action.
* @param renderer [IN] render's udn 
* @return 0 if successful, otherwise a system wide error code.
*/
int UAV_Pause(const char* renderer);

/**
* Performs seek.
* 
* @param renderer [IN] render's udn 
* @param unit			[IN] Seek unit string as defined in UPnP AVTransport DCP.
* @param target		[IN] Seek target string as defined in UPnP AVTransport DCP.
* @return 0 if successful, otherwise a system wide error code.
*/
int UAV_Seek(const char* renderer,const char* unit, const char* target);

/**
 * The callback function prototype for asynchronous events from the renderer to
 * the client.
 *
 * The renderer callback can be used to get state updates from a renderer,
 * for example, changes in the play state.
 *
 * The client shall set the callback with UAV_SetRendererEventCallback.
 *
 * NOTE: "TransportState" variable of the MediaRenderer AV
 * service is delivered. The variable can have the values:
 * "PLAYING", "STOPPED", "TRANSITIONING", "PAUSED_PLAYBACK","PAUSED_RECORDING",
 * "RECORDING", "NO_MEDIA_PRESENT".
 * "Mute" and "Volume" variable of the MediaRenderer RC service is also delivered.
 *
 * @param renderer [IN] The renderer which caused the event.
 * @param variableName [IN] The variable name of the event.
 * @param value [IN] The value of the evented variable. Can be NULL.
 * @param additionalInfo [IN] Additional information regarding the event. Can be NULL.
 *
 * @return 0 if successful, otherwise a system wide error code.
 *
 *
 */
typedef int  (*UAV_RendererEventCallback) (char* renderer, const char *variableName,
											const char* value, const char* additionalInfo);

/**
 * Sets the renderer callback.
 *
 *
 * After setting the callback with a valid callback function, the
 * renderer state changes are delivered to the callback.
 * Internally the system registers to the renderer via UPnP event notifications.
 *
 * This function shall be called AFTER the first UAV_Play is called for a particular
 * renderer.
 *
 * @param renderer [IN] The renderer device to which the client registers.
 * @param callback [IN] The callback to which the events are to be delivered.
 * 						If NULL, unregisters from the renderer and events are no
 * 						more delivered to the client.
 *
 * @return 0 if successful, otherwise a system wide error code.
 */
int UAV_SetRendererEventCallback(const char *renderer, UAV_RendererEventCallback callback);

/**
 * Performs RC GetMute on renderer's "Master" volume channel.
 * Play has to be issued before using this function.
 * @param renderer [IN] render's udn 
 * @return Current Mute setting.
 */
BOOL UAV_GetMute(const char* renderer);

/**
 * Performs RC SetMute on renderer's "Master" volume channel.
 * Play has to be issued before using this function.
 * @param renderer [IN] render's udn 
 * @param DesiredMute [IN] a boolen value of mute seted by controlpoint 
 */
void UAV_SetMute(const char* renderer,BOOL DesiredMute);

/**
 * Performs RC GetVolume on renderer's "Master" volume channel.
 * Play has to be issued before using this function.
 * @param renderer [IN] render's udn 
 * @return Current Volume setting.
 */
uint16_t UAV_GetVolume(const char* renderer);

/**
 * Performs RC SetVolume on renderer's "Master" volume channel.
 * Play has to be issued before using this function.
 * @param renderer [IN] render's udn 
 * @param DesiredVolume [IN] a uint16_t value of mute seted by controlpoint 
 */
void UAV_SetVolume(const char* renderer, uint16_t DesiredVolume);

/** API for CP to get position info
* @param udn [IN] render's udn
* @param positionInfo [IN] UAVMR_PositionInfo param that will be filled by send action to render
* @return 0 if successful, otherwise a system wide error code.
*/
int UPNP_GetPositionInfo(const char* renderer, UAVMR_PositionInfo* positionInfo);

/** 
 * Control point side API  
 * By calling this API, the controlpoint could send any user-defined command to render.
 */
int UAV_Send_TransparentControlInfo(const char* renderer, 
									const char* OpClass, 
									const char* OpType, 
									const char* OpPara);

int UAV_SetRendererTPEventCallback (UAV_RendererEventCallback callback);

/** browse shared resource<br/>
* @param udn [IN] server's udn
* @param objectId [IN] resource id to browse "0" is root
* @param start [IN] item start index
* @param count [IN] item number  want to get
* @return browse result, is xml format.
*/
char *UPNP_BrowseServerContent(const char* udn, const char *objectId, const char *start, const char *count);



/** browse shared resource<br/>
* @param udn [IN] server's udn
* @param objectId [IN] resource id to browse "0" is root
* @param start [IN] item start index
* @param count [IN] item number want to get
* @param totalCount [IN] total item that can get
* @param returnedCount [IN] item number returned
* @return browse result, is xml format.
*/
char *UPNP_BrowseServerContentPart(const char* udn, const char *objectId, const char *start, 
                                                 const char *count, char * totalCount, char * returnedCount);

/**
 * Get the item 's MetaData. The caller shall not try to change any content of this pointer. 
 * @param udn [IN] server's udn
 * @param objectId [IN] item's id
 * @return item's metadata 
 */
char *UPNP_BrowseMetadata(const char* udn, const char *objectId);


/**
*Get the DMS UpdateID
*Used for ping if the DMS is living..
*/
int UPNP_GetSystemUpdateID(const char* udn );

    
#ifdef __APPLE__
    
    typedef struct _iosMedia{
        long long size;
        char* title;
        char* mime;
        char* duration;
        
    }iosMedia;
    
    typedef enum _IOSCMD{
        
        OPEN_STREAM = 0,
        READ_STREAM,
        CLOSE_STREAM,
        GET_MEDIAINFO
        
    }IOSCMD;
    
    typedef struct _IOSCMDPara{
        char* uri;
        long long offset;
        long long size;
        char* buf;
        iosMedia* info;
        
        
    }IOSCMDPara;
    
    typedef int (*IOSReadCB)(IOSCMD cmd, IOSCMDPara* param);
    
    
    IOSReadCB IOS_getListener();
    
    int IOS_Play_LocalRes(const char* renderer_udn,
                          const char* uri, IOSReadCB cb);
    
#endif
    
#ifdef __cplusplus
}
#endif
        
#endif
