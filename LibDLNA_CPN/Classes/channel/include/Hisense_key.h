//
//  HisenseKey.h
//  cyrm
//
//  Created by brent on 14-5-21.
//  Copyright (c) 2014年 HIsense. All rights reserved.
//
#ifndef _HISENSE_KEY_DEFINE_H_
#define _HISENSE_KEY_DEFINE_H_

// 多屏互动//
const char* const GET_RADIOTV_INFO          = "GET_RADIOTV_INFO$ABABABABABAB#IOS";      // 获取机顶盒信息 GET_RADIOTV_INFO$__12位MAC__#HX8T-S
const char* const PULL_FROM_RADIOTV         = "PULL_FROM_RADIOTV$PULL_FROM_RADIOTV";    // 拉送
const char* const PUSH_TO_RADIOTV           = "PUSH_TO_RADIOTV$PUSH_TO_RADIOTV";        // 推屏
const char* const PARAMS_SUBSCRIBER         = "params_subscriber";                      // 登录
const char* const PARAMS_PULL               = "params_pull$";                           //

///////////////'START_VOICE_CONTROL' 'CLOSE_VOICE_CONTROL'
const char* const START_INPUT_METHOD        = "START_INPUT_METHOD";                     // 开启输入法
const char* const GET_TV_CONTENT            = "GET_TV_CONTENT";                         // 获取电视端内容
const char* const SEND_EDIT_CONTENT         = "SEND_EDIT_CONTENT";                      // 传输输入内容
const char* const CLOSE_INPUT_METHOD        = "CLOSE_INPUT_METHOD";                     // 关闭输入法
const char* const TICK_INPUT_METHOD         = "TICK_INPUT_METHOD";                      // 心跳
const char* const COMMIT_INPUT_METHOD       = "COMMIT_INPUT_METHOD";                    // 确认跳转键

const char* const ITEM_SEP_STR              = "\r\n#";
const char* const DEVICE_KEY_MUTE           = "KEY_MUTE";
const char* const DEVICE_KEY_HOME           = "KEY_HOME";
const char* const DEVICE_KEY_CHANNELUP      = "KEY_CHANNELUP";
const char* const DEVICE_KEY_CHANNELDOWN    = "KEY_CHANNELDOWN";
const char* const DEVICE_KEY_VOLUMEDOWN     = "KEY_VOLUMEDOWN";
const char* const DEVICE_KEY_VOLUMEUP       = "KEY_VOLUMEUP";

const char* const DEVICE_KEY_0              = "KEY_0";
const char* const DEVICE_KEY_1              = "KEY_1";
const char* const DEVICE_KEY_2              = "KEY_2";
const char* const DEVICE_KEY_3              = "KEY_3";
const char* const DEVICE_KEY_4              = "KEY_4";
const char* const DEVICE_KEY_5              = "KEY_5";
const char* const DEVICE_KEY_6              = "KEY_6";
const char* const DEVICE_KEY_7              = "KEY_7";
const char* const DEVICE_KEY_8              = "KEY_8";
const char* const DEVICE_KEY_9              = "KEY_9";

const char* const DEVICE_KEY_RED            = "KEY_RED";
const char* const DEVICE_KEY_GREEN          = "KEY_GREEN";
const char* const DEVICE_KEY_YELLOW         = "KEY_YELLOW";
const char* const DEVICE_KEY_BLUE           = "KEY_BLUE";

const char* const DEVICE_KEY_RETURNS        = "KEY_RETURNS";
const char* const DEVICE_KEY_MENU           = "KEY_MENU";
const char* const DEVICE_KEY_DOWN           = "KEY_DOWN";
const char* const DEVICE_KEY_LEFT           = "KEY_LEFT";
const char* const DEVICE_KEY_RIGHT          = "KEY_RIGHT";
const char* const DEVICE_KEY_UP             = "KEY_UP";
const char* const DEVICE_KEY_OK             = "KEY_OK";
const char* const DEVICE_KEY_3DS            = "KEY_3DS";
const char* const DEVICE_KEY_TVS            = "KEY_TVS";
const char* const DEVICE_KEY_SOURCES        = "KEY_SOURCES";

const char* const DEVICE_KEY_INFO           = "KEY_INFO";
const char* const DEVICE_KEY_ALTERNATES     = "KEY_ALTERNATES";

const char* const DEVICE_KEY_RIGHTMOUSEKEYS = "KEY_RIGHTMOUSEKEYS";
const char* const DEVICE_KEY_LEFTMOUSEKEYS  = "KEY_LEFTMOUSEKEYS";
const char* const DEVICE_KEY_RESTS          = "KEY_RESTS";
const char* const DEVICE_KEY_POWER          = "KEY_POWER";
const char* const DEVICE_KEY_STOP           = "KEY_STOP";
const char* const DEVICE_KEY_EXIT           = "KEY_EXIT";
const char* const DEVICE_KEY_PLAY           = "KEY_PLAY";
const char* const DEVICE_KEY_SEARCH         = "KEY_SEARCH";
const char* const DEVICE_KEY_MIDDLEMOUSEKEYS= "KEY_MIDDLEMOUSEKEYS";
const char* const DEVICE_KEY_ZOOM           = "KEY_ZOOM";
const char* const DEVICE_KEY_NEXT           = "KEY_NEXT";
const char* const DEVICE_KEY_BACKS          = "KEY_BACKS";
const char* const DEVICE_KEY_FORWARDS       = "KEY_FORWARDS";
const char* const DEVICE_KEY_PREVIOUS       = "KEY_PREVIOUS";

const char* const DEVICE_KEY_MOUSEDOWN      = "KEY_MOUSEDOWN";
const char* const DEVICE_KEY_MOUSEUP        = "KEY_MOUSEUP";
const char* const DEVICE_KEY_ZOOMIN         = "KEY_ZOOMIN";
const char* const DEVICE_KEY_ZOOMOUT        = "KEY_ZOOMOUT";
const char* const DEVICE_KEY_SETTING        = "KEY_SETTING";
const char* const DEVICE_KEY_PAUSE          = "KEY_PAUSE";
const char* const DEVICE_KEY_RECORD         = "KEY_RECORD";
const char* const DEVICE_KEY_CHANNELDOT     = "KEY_CHANNELDOT";
const char* const DEVICE_KEY_CHANNELLINE    = "KEY_CHANNELLINE";

const char* const DEVICE_KEY_AUP            = "KEY_AUP";//A
const char* const DEVICE_KEY_BUP            = "KEY_BUP";//B
const char* const DEVICE_KEY_CUP            = "KEY_CUP";//..
const char* const DEVICE_KEY_DUP            = "KEY_DUP";
const char* const DEVICE_KEY_EUP            = "KEY_EUP";
const char* const DEVICE_KEY_FUP            = "KEY_FUP";
const char* const DEVICE_KEY_GUP            = "KEY_GUP";
const char* const DEVICE_KEY_HUP            = "KEY_HUP";
const char* const DEVICE_KEY_IUP            = "KEY_IUP";
const char* const DEVICE_KEY_JUP            = "KEY_JUP";
const char* const DEVICE_KEY_KUP            = "KEY_KUP";
const char* const DEVICE_KEY_LUP            = "KEY_LUP";
const char* const DEVICE_KEY_MUP            = "KEY_MUP";
const char* const DEVICE_KEY_NUP            = "KEY_NUP";
const char* const DEVICE_KEY_OUP            = "KEY_OUP";
const char* const DEVICE_KEY_PUP            = "KEY_PUP";
const char* const DEVICE_KEY_QUP            = "KEY_QUP";
const char* const DEVICE_KEY_RUP            = "KEY_RUP";
const char* const DEVICE_KEY_SUP            = "KEY_SUP";
const char* const DEVICE_KEY_TUP            = "KEY_TUP";
const char* const DEVICE_KEY_UUP            = "KEY_UUP";
const char* const DEVICE_KEY_VUP            = "KEY_VUP";
const char* const DEVICE_KEY_WUP            = "KEY_WUP";
const char* const DEVICE_KEY_XUP            = "KEY_XUP";
const char* const DEVICE_KEY_YUP            = "KEY_YUP";
const char* const DEVICE_KEY_ZUP            = "KEY_ZUP";//z

const char* const DEVICE_KEY_0UP            = "KEY_0UP";//)
const char* const DEVICE_KEY_1UP            = "KEY_1UP";//!
const char* const DEVICE_KEY_2UP            = "KEY_2UP";//@
const char* const DEVICE_KEY_3UP            = "KEY_3UP";//#
const char* const DEVICE_KEY_4UP            = "KEY_4UP";//$
const char* const DEVICE_KEY_5UP            = "KEY_5UP";//%
const char* const DEVICE_KEY_6UP            = "KEY_6UP";//^
const char* const DEVICE_KEY_7UP            = "KEY_7UP";//&
const char* const DEVICE_KEY_8UP            = "KEY_8UP";//*
const char* const DEVICE_KEY_9UP            = "KEY_9UP";//(

const char* const DEVICE_KEY_BACKSPACE      = "KEY_BACKSPACE";//key Backspace
const char* const DEVICE_KEY_ENTER          = "KEY_ENTER";//key Enter
const char* const DEVICE_KEY_SPACE          = "KEY_SPACE";//Key Space

const char* const DEVICE_KEY_GRAVE          = "KEY_GRAVE";      //`
const char* const DEVICE_KEY_MINUS          = "KEY_MINUS";      //-
const char* const DEVICE_KEY_EQUAL          = "KEY_EQUAL";      //=
const char* const DEVICE_KEY_COMMA          = "KEY_COMMA";      //,
const char* const DEVICE_KEY_DOT            = "KEY_DOT";        //.
const char* const DEVICE_KEY_SLASH          = "KEY_SLASH";      //'/'
const char* const DEVICE_KEY_LEFTBRACE      = "KEY_LEFTBRACE";  //[
const char* const DEVICE_KEY_RIGHTBRACE     = "KEY_RIGHTBRACE"; //]
const char* const DEVICE_KEY_BACKSLASH      = "KEY_BACKSLASH";  //
const char* const DEVICE_KEY_SEMICOLON      = "KEY_SEMICOLON";  //;
const char* const DEVICE_KEY_APOSTROPHE     = "KEY_APOSTROPHE"; //'

const char* const KEY_GRAVEUP               = "KEY_GRAVEUP";//~
const char* const KEY_MINUSUP               = "KEY_MINUSUP";//_
const char* const KEY_EQUALUP               = "KEY_EQUALUP";//+
const char* const KEY_COMMAUP               = "KEY_COMMAUP";//<
const char* const KEY_DOTUP                 = "KEY_DOTUP";//>
const char* const KEY_SLASHUP               = "KEY_SLASHUP";//?
const char* const KEY_LEFTBRACEUP           = "KEY_LEFTBRACEUP";//{
const char* const KEY_RIGHTBRACEUP          = "KEY_RIGHTBRACEUP";//}
const char* const KEY_BACKSLASHUP           = "KEY_BACKSLASHUP";//|
const char* const KEY_SEMICOLONUP           = "KEY_SEMICOLONUP";//:
const char* const KEY_APOSTROPHEUP          = "KEY_APOSTROPHEUP";//"

const char* const DEVICE_KEY_TYPESCROLLHORIZONTALLYRIGHT   = "KEY_TYPESCROLLHORIZONTALLYRIGHT";
const char* const DEVICE_KEY_TYPESCROLLHORIZONTALLYLEFT    = "KEY_TYPESCROLLHORIZONTALLYLEFT";
const char* const DEVICE_KEY_TYPESCROLLVERTICALLYUP        = "KEY_TYPESCROLLVERTICALLYUP";//鼠标垂直上滚scroll
const char* const DEVICE_KEY_TYPESCROLLVERTICALLYDOWN      = "KEY_TYPESCROLLVERTICALLYDOWN";

const char* const DEVICE_KEYCODE_ZOOMIN = "KEY_ZOOMIN";
const char* const DEVICE_KEYCODE_ZOOMOUT= "KEY_ZOOMOUT";

const char* const DEVICE_KEYCODE_MOUSEDOWN = "KEY_UDDLEFTMOUSEKEYS";
const char* const DEVICE_KEYCODE_MOUSEUP = "KEY_UDULEFTMOUSEKEYS";

/*
 //特殊案件布局
 {".", "Lit_."},
 {",", "Lit_,"},
 {"@", "Lit_@"},
 {"~", "Lit_~"},
 {"!", "Lit_!"},
 {"?", "Lit_?"},
 {"^", "Lit_^"},
 {"*", "Lit_*"},
 {"-", "Lit_-"},
 {"<--", "Lit_<--"},
 {"_", "Lit__"},
 {";", "Lit_;"},
 {":", "Lit_:"},
 {"'", "Lit_'"},
 {"&", "Lit_&"},
 {"#", "Lit_#"},
 {"+", "Lit_+"},
 {"=", "Lit_="},
 {"?", "Lit_?"},
 {"ü", "Lit_ü"},
 {"£", "Lit_£"},
 {"¥", "Lit_¥"},
 {"¢", "Lit_¢"},
 {"(", "Lit_("},
 {")", "Lit_)"},
 {"[", "Lit_["},
 {"]", "Lit_]"},
 {"{", "Lit_{"},
 {"}", "Lit_}"},
 {"<", "Lit_<"},
 {">", "Lit_>"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"|", "Lit_|"},
 {"§", "Lit_§"},
 {"%", "Lit_%"},
 {"\"", "Lit_\""},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"°", "Lit_°"},
 {"¤", "Lit_¤"},
 //德语字母
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"ü", "Lit_ü"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"ü", "Lit_ü"},
 //意大利字母
 {"à", "Lit_à"},
 {"è", "Lit_è"},
 {"ì", "Lit_ì"},
 {"ò", "Lit_ò"},
 {"ù", "Lit_ù"},
 {"é", "Lit_é"},
 {"à", "Lit_à"},
 {"è", "Lit_è"},
 {"ì", "Lit_ì"},
 {"ò", "Lit_ò"},
 {"ù", "Lit_ù"},
 {"é", "Lit_é"},
 //葡萄牙字母
 {"?", "Lit_?"},
 {"á", "Lit_á"},
 {"a", "Lit_a"},
 {"?", "Lit_?"},
 {"à", "Lit_à"},
 {"é", "Lit_é"},
 {"ê", "Lit_ê"},
 {"í", "Lit_í"},
 {"ó", "Lit_ó"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"ú", "Lit_ú"},
 {"?", "Lit_?"},
 {"á", "Lit_á"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"à", "Lit_à"},
 {"é", "Lit_é"},
 {"ê", "Lit_ê"},
 {"í", "Lit_í"},
 {"ó", "Lit_ó"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"ú", "Lit_ú"},
 //西班牙字母
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"á", "Lit_á"},
 {"é", "Lit_é"},
 {"í", "Lit_í"},
 {"ó", "Lit_ó"},
 {"ú", "Lit_ú"},
 {"ü", "Lit_ü"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"á", "Lit_á"},
 {"é", "Lit_é"},
 {"í", "Lit_í"},
 {"ó", "Lit_ó"},
 {"ú", "Lit_ú"},
 {"ü", "Lit_ü"},
 //法语字母
 {"à", "Lit_à"},
 {"a", "Lit_a"},
 {"è", "Lit_è"},
 {"é", "Lit_é"},
 {"ê", "Lit_ê"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"ù", "Lit_ù"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 //俄语字母
 {"й", "Lit_й"},
 {"ц", "Lit_ц"},
 {"у", "Lit_у"},
 {"к", "Lit_к"},
 {"ё", "Lit_ё"},
 {"е", "Lit_е"},
 {"н", "Lit_н"},
 {"г", "Lit_г"},
 {"ш", "Lit_ш"},
 {"щ", "Lit_щ"},
 {"з", "Lit_з"},
 {"х", "Lit_х"},
 {"ъ", "Lit_ъ"},
 {"ф", "Lit_ф"},
 {"ы", "Lit_ы"},
 {"в", "Lit_в"},
 {"а", "Lit_а"},
 {"п", "Lit_п"},
 {"р", "Lit_р"},
 {"о", "Lit_о"},
 {"л", "Lit_л"},
 {"д", "Lit_д"},
 {"ж", "Lit_ж"},
 {"э", "Lit_э"},
 {"я", "Lit_я"},
 {"ч", "Lit_ч"},
 {"с", "Lit_с"},
 {"м", "Lit_м"},
 {"м", "Lit_м"},
 {"т", "Lit_т"},
 {"ь", "Lit_ь"},
 {"б", "Lit_б"},
 {"ю", "Lit_ю"},
 
 {"Й", "Lit_Й"},
 {"Ц", "Lit_Ц"},
 {"У", "Lit_У"},
 {"К", "Lit_К"},
 {"Ё", "Lit_Ё"},
 {"Е", "Lit_Е"},
 {"Н", "Lit_Н"},
 {"Г", "Lit_Г"},
 {"ш", "Lit_ш"},
 {"щ", "Lit_щ"},
 {"З", "Lit_З"},
 {"Х", "Lit_Х"},
 {"Ъ", "Lit_Ъ"},
 {"Ф", "Lit_Ф"},
 {"Ы", "Lit_Ы"},
 {"В", "Lit_В"},
 {"А", "Lit_А"},
 {"П", "Lit_П"},
 {"Р", "Lit_Р"},
 {"О", "Lit_О"},
 {"Л", "Lit_Л"},
 {"Д", "Lit_Д"},
 {"Ж", "Lit_Ж"},
 {"Э", "Lit_Э"},
 {"Я", "Lit_Я"},
 {"Ч", "Lit_Ч"},
 {"С", "Lit_С"},
 {"М", "Lit_М"},
 {"И", "Lit_И"},
 {"Т", "Lit_Т"},
 {"Ь", "Lit_Ь"},
 {"Б", "Lit_Б"},
 {"Ю", "Lit_Ю"},
 //捷克语字母
 {"á", "Lit_á"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"é", "Lit_é"},
 {"ě", "Lit_ě"},
 {"í", "Lit_í"},
 {"ň", "Lit_ň"},
 {"ó", "Lit_ó"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"ú", "Lit_ú"},
 {"?", "Lit_?"},
 {"y", "Lit_y"},
 {"?", "Lit_?"},
 {"á", "Lit_á"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"é", "Lit_é"},
 {"ě", "Lit_ě"},
 {"?", "Lit_?"},
 {"ó", "Lit_ó"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"ú", "Lit_ú"},
 {"?", "Lit_?"},
 {"Y", "Lit_Y"},
 {"?", "Lit_?"},
 //希腊字母
 {"α", "Lit_α"},
 {"β", "Lit_β"},
 {"γ", "Lit_γ"},
 {"δ", "Lit_δ"},
 {"ε", "Lit_ε"},
 {"ζ", "Lit_ζ"},
 {"η", "Lit_η"},
 {"θ", "Lit_θ"},
 {"ι", "Lit_ι"},
 {"κ", "Lit_κ"},
 {"λ", "Lit_λ"},
 {"μ", "Lit_μ"},
 {"ν", "Lit_ν"},
 {"ξ", "Lit_ξ"},
 {"ο", "Lit_ο"},
 {"π", "Lit_π"},
 {"ρ", "Lit_ρ"},
 {"σ", "Lit_σ"},
 {"τ", "Lit_τ"},
 {"υ", "Lit_υ"},
 {"φ", "Lit_φ"},
 {"χ", "Lit_χ"},
 {"ψ", "Lit_ψ"},
 {"ω", "Lit_ω"},
 
 
 {"Α", "Lit_Α"},
 {"Β", "Lit_Β"},
 {"Γ", "Lit_Γ"},
 {"Δ", "Lit_Δ"},
 {"Ε", "Lit_Ε"},
 {"Ζ", "Lit_Ζ"},
 {"Η", "Lit_Η"},
 {"Θ", "Lit_Θ"},
 {"Ι", "Lit_Ι"},
 {"Κ", "Lit_Κ"},
 {"∧", "Lit_∧"},
 {"Μ", "Lit_Μ"},
 {"Ν", "Lit_Ν"},
 {"Ξ", "Lit_Ξ"},
 {"Ο", "Lit_Ο"},
 {"∏", "Lit_∏"},
 {"Ρ", "Lit_Ρ"},
 {"∑", "Lit_∑"},
 {"Τ", "Lit_Τ"},
 {"Υ", "Lit_Υ"},
 {"Φ", "Lit_Φ"},
 {"Χ", "Lit_Χ"},
 {"Ψ", "Lit_Ψ"},
 {"Ω", "Lit_Ω"},
 //匈牙利语
 {"á", "Lit_á"},
 {"é", "Lit_é"},
 {"í", "Lit_í"},
 {"ó", "Lit_ó"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"ú", "Lit_ú"},
 {"ü", "Lit_ü"},
 {"?", "Lit_?"},
 {"á", "Lit_á"},
 {"é", "Lit_é"},
 {"í", "Lit_í"},
 {"ó", "Lit_ó"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"ú", "Lit_ú"},
 {"ü", "Lit_ü"},
 {"?", "Lit_?"},
 //保加利亚语
 {"а", "Lit_а"},
 {"б", "Lit_б"},
 {"в", "Lit_в"},
 {"г", "Lit_г"},
 {"д", "Lit_д"},
 {"е", "Lit_е"},
 {"ж", "Lit_ж"},
 {"з", "Lit_з"},
 {"и", "Lit_и"},
 {"й", "Lit_й"},
 {"к", "Lit_к"},
 {"л", "Lit_л"},
 {"м", "Lit_м"},
 {"н", "Lit_н"},
 {"о", "Lit_о"},
 {"п", "Lit_п"},
 {"р", "Lit_р"},
 {"с", "Lit_с"},
 {"т", "Lit_т"},
 {"у", "Lit_у"},
 {"ф", "Lit_ф"},
 {"х", "Lit_х"},
 {"ц", "Lit_ц"},
 {"ч", "Lit_ч"},
 {"ш", "Lit_ш"},
 {"щ", "Lit_щ"},
 {"ъ", "Lit_ъ"},
 {"ь", "Lit_ь"},
 {"ю", "Lit_ю"},
 {"я", "Lit_я"},
 {"А", "Lit_А"},
 {"Б", "Lit_Б"},
 {"В", "Lit_В"},
 {"Г", "Lit_Г"},
 {"Д", "Lit_Д"},
 {"Е", "Lit_Е"},
 {"Ж", "Lit_Ж"},
 {"З", "Lit_З"},
 {"И", "Lit_И"},
 {"Й", "Lit_Й"},
 {"К", "Lit_К"},
 {"Л", "Lit_Л"},
 {"М", "Lit_М"},
 {"Н", "Lit_Н"},
 {"О", "Lit_О"},
 {"П", "Lit_П"},
 {"Р", "Lit_Р"},
 {"С", "Lit_С"},
 {"Т", "Lit_Т"},
 {"У", "Lit_У"},
 {"Ф", "Lit_Ф"},
 {"Х", "Lit_Х"},
 {"Ц", "Lit_Ц"},
 {"Ч", "Lit_Ч"},
 {"Ш", "Lit_Ш"},
 {"Щ", "Lit_Щ"},
 {"ъ", "Lit_ъ"},
 {"ь", "Lit_ь"},
 {"Ю", "Lit_Ю"},
 {"Я", "Lit_Я"},
 //罗马尼亚语
 {"?", "Lit_?"},
 {"a", "Lit_a"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 //瑞典语
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 //挪威语--->同瑞典语
 //芬兰语--->	同瑞典语
 //丹麦语
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 
 
 {"/", "Lit_/"},
 {"\\", "Lit_\\"},
 
 
 {"LEFT", "cur_left"},
 {"UP", "cur_up"},
 {"DOWN", "cur_down"},
 {"RIGHT", "cur_right"},
 {"BACKSPACE", "backspace"},
 {"SPACE", "space"},
 {"ENTER", "enter"},
 //{"ü", "Lit_ü"},
 //{"|", "Lit_|"},
 //{"?", "Lit_?"},
 //{"?", "Lit_?"},
 //{"?", "Lit_?"},
 //{"è", "Lit_è"},
 //{"?", "Lit_?"},
 //{"ì", "Lit_ì"},
 //{"?", "Lit_?"},
 //{"?", "Lit_?"},
 //{"ò", "Lit_ò"},
 //{"?", "Lit_?"},
 //{"?", "Lit_?"},
 //{"ù", "Lit_ù"},
 //{"?", "Lit_?"}
 
 //新加特殊符号  20130619 by   llh
 {"^", "Lit_^"},
 {"£", "Lit_£"},
 {"§", "Lit_§"},
 //保加利亚语字符--->与word不一致
 {"?", "Lit_?"},
 {"á", "Lit_á"},
 {"a", "Lit_a"},
 {"?", "Lit_?"},
 {"à", "Lit_à"},
 {"é", "Lit_é"},
 {"ê", "Lit_ê"},
 {"í", "Lit_í"},
 {"ó", "Lit_ó"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"ú", "Lit_ú"},
 {"?", "Lit_?"},
 {"á", "Lit_á"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"à", "Lit_à"},
 {"é", "Lit_é"},
 {"ê", "Lit_ê"},
 {"í", "Lit_í"},
 {"ó", "Lit_ó"},
 {"?", "Lit_?"},
 {"?", "Lit_?"},
 {"ú", "Lit_ú"},
 
 //20130709新加 几个特殊字符和俄语
 
 {"№", "Lit_№"},
 
 {"~", "Lit_~"},
 {"_", "Lit__"},
 {"&", "Lit_&"},
 {"{", "Lit_{"},
 {"}", "Lit_}"},
 {"<", "Lit_<"},
 {">", "Lit_>"},
 {"|", "Lit_|"},
 
 };
 
 */


#endif