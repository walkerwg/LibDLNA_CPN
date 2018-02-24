#ifndef _CUPNP_EXT_H
#define _CUPNP_EXT_H
/**
 * @file
 * @ingroup highlevelapi
 * Upnp device struct api
 */

/**
 * The state of the device.
 */
typedef enum{
	/**Online*/
	UPNP_DEVADD = 0,
	/**Update*/
	UPNP_DEVUPDATE =1,
	/**Invalid*/
	UPNP_DEVINVALID =2,
	/**Byebye*/
	UPNP_DEVREMOVE =3,
	/**For get all, same as online.*/
	UPNP_DEVGETALL =4,
}UPNPDevState;

/**
 * The icon struct.
 */
typedef struct _CgUpnpDeviceIcon {
	char* fullurl;          /** URL of the icon. */
	char* mimeType;     /** Mime type of the icon. */
	int width;          /** Horizontal dimension of icon in pixels.  */
	int height;         /** Vertical dimension of icon in pixels.  */
	int depth;          /** Number of color bits per pixel.  */	
	char* url;
} CgUpnpDeviceIcon;

/**
* The date struct of the device.
*/
typedef struct {							/*same as CgUpnpDeviceType*/
	char *friendlyName;	
	char *udn;
	char *uri;
	char *deviceType;
	char *modelnumber;
	char *ModelName;
	char *modeldescription;
	char *manufacturer;
	CgUpnpDeviceIcon **icons;				/*N is the number of icons, icon[N] is NULL*/
	char *modelSerialNum;
	char *manufacturerUrl;
}UpnpDevType;

#endif
