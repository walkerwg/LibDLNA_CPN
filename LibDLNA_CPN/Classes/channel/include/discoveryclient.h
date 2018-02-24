
#pragma once

#ifdef __cplusplus
extern "C" {
#endif
    
#if 0 //lzz, 2013.11.22
    #if !defined(APPCFG_NEED_CLIENTDIS)
        #error "You Must define if use it APPCFG_NEED_CLIENTDIS!"
    #endif
#endif
    
	//******************************************************************************************
	////程序接口
	//******************************************************************************************
	//设置使用的版本号,目前支持版本号如下:
	//         ver=HSDIS_VER_1 旧的程序,M280,TVXT710使用
	//         ver=HSDIS_VER_2 新的程序,M1101,E170  TVXT770,K560系列
	int hs_discoveryclient_presetdisversion(int nver);
	//******************************************************************************************
	//设置显示ide设备名称
	int hs_discoveryclient_presetShowinfo(char* showinfo);
	//******************************************************************************************
	//int hs_discoveryclient_init();//服务初始化工作
	//******************************************************************************************
	int hs_discoveryclient_start();//启动服务,注意此函数使用之前,必须首先调用 discoveryclient_init
	//******************************************************************************************
	char *hs_discoveryclient_getDeviceList();//获取设备列表
	//******************************************************************************************
	int hs_discoveryclient_stop();//停止服务
	//******************************************************************************************
	//int hs_discoveryclient_uninit();//服务销毁工作
	//******************************************************************************************
    
	int hs_discoveryclient_getServerVerSvn(char *ip, char *version);//lzz, 2014.02.17, getting Server's Version and Svn information
	
	/*
     调用流程:
     1、配置
     设置使用的版本号:
     hs_discoveryclient_presetdisversion(nver);
     //设置显示的设备名称
     int hs_discoveryclient_presetShowinfo(char* showinfo);
     2、初始化
     hs_discoveryclient_init();
     3、启动
     hs_discoveryclient_start();
     4、工作
     hs_discoveryclient_getdevicelist();
     5、停止
     hs_discoveryclient_stop();
     6、退出
     hs_discoveryclient_uninit();
     */
    
#ifdef __cplusplus
}
#endif


