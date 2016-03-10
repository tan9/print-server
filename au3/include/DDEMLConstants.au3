#include-once
; ------------------------------------------------------------------------------
;
; Version:        1.5.3
; AutoIt Version: 3.3.0.0
; Language:       English
; Author:         doudou
; Description:    Common constants for Microsoft DDEML
;                 (Dynamic Data Exchange Management Library).
; $Revision: 1.2 $
; $Date: 2010/04/17 04:53:40 $
;
; ------------------------------------------------------------------------------
Global Const $XST_NULL              = 0  ; quiescent states ;
Global Const $XST_INCOMPLETE        = 1
Global Const $XST_CONNECTED         = 2
Global Const $XST_INIT1             = 3  ; mid-initiation states ;
Global Const $XST_INIT2             = 4
Global Const $XST_REQSENT           = 5  ; active conversation states ;
Global Const $XST_DATARCVD          = 6
Global Const $XST_POKESENT          = 7
Global Const $XST_POKEACKRCVD       = 8
Global Const $XST_EXECSENT          = 9
Global Const $XST_EXECACKRCVD      = 10
Global Const $XST_ADVSENT          = 11
Global Const $XST_UNADVSENT        = 12
Global Const $XST_ADVACKRCVD       = 13
Global Const $XST_UNADVACKRCVD     = 14
Global Const $XST_ADVDATASENT      = 15
Global Const $XST_ADVDATAACKRCVD   = 16

; used in LOWORD(dwData1) of XTYP_ADVREQ callbacks... ;
Global Const $CADV_LATEACK         = 0xFFFF

;**** conversation status bits (fsStatus) ****;

Global Const $ST_CONNECTED            = 0x0001
Global Const $ST_ADVISE               = 0x0002
Global Const $ST_ISLOCAL              = 0x0004
Global Const $ST_BLOCKED              = 0x0008
Global Const $ST_CLIENT               = 0x0010
Global Const $ST_TERMINATED           = 0x0020
Global Const $ST_INLIST               = 0x0040
Global Const $ST_BLOCKNEXT            = 0x0080
Global Const $ST_ISSELF               = 0x0100

; DDE constants for wStatus field ;

Global Const $DDE_FACK                = 0x8000
Global Const $DDE_FBUSY               = 0x4000
Global Const $DDE_FDEFERUPD           = 0x4000
Global Const $DDE_FACKREQ             = 0x8000
Global Const $DDE_FRELEASE            = 0x2000
Global Const $DDE_FREQUESTED          = 0x1000
Global Const $DDE_FAPPSTATUS          = 0x00ff
Global Const $DDE_FNOTPROCESSED       = 0x0000

Global Const $DDE_FACKRESERVED        = BitNOT(BitOR($DDE_FACK, $DDE_FBUSY, $DDE_FAPPSTATUS))
Global Const $DDE_FADVRESERVED        = BitNOT(BitOR($DDE_FACKREQ, $DDE_FDEFERUPD))
Global Const $DDE_FDATRESERVED        = BitNOT(BitOR($DDE_FACKREQ, $DDE_FRELEASE, $DDE_FREQUESTED))
Global Const $DDE_FPOKRESERVED        = BitNOT($DDE_FRELEASE)

;**** message filter hook types ****;

Global Const $MSGF_DDEMGR             = 0x8001

Global Const $CP_WINANSI      = 1004
Global Const $CP_WINUNICODE   = 1200

;**** transaction types ****;

Global Const $XTYPF_NOBLOCK            = 0x0002  ; CBR_BLOCK will not work ;
Global Const $XTYPF_NODATA             = 0x0004  ; DDE_FDEFERUPD ;
Global Const $XTYPF_ACKREQ             = 0x0008  ; DDE_FACKREQ ;

Global Const $XCLASS_MASK              = 0xFC00
Global Const $XCLASS_BOOL              = 0x1000
Global Const $XCLASS_DATA              = 0x2000
Global Const $XCLASS_FLAGS             = 0x4000
Global Const $XCLASS_NOTIFICATION      = 0x8000

Global Const $XTYP_ERROR              = BitOR(0x0000, $XCLASS_NOTIFICATION, $XTYPF_NOBLOCK)
Global Const $XTYP_ADVDATA            = BitOR(0x0010, $XCLASS_FLAGS)
Global Const $XTYP_ADVREQ             = BitOR(0x0020, $XCLASS_DATA, $XTYPF_NOBLOCK)
Global Const $XTYP_ADVSTART           = BitOR(0x0030, $XCLASS_BOOL)
Global Const $XTYP_ADVSTOP            = BitOR(0x0040, $XCLASS_NOTIFICATION)
Global Const $XTYP_EXECUTE            = BitOR(0x0050, $XCLASS_FLAGS)
Global Const $XTYP_CONNECT            = BitOR(0x0060, $XCLASS_BOOL, $XTYPF_NOBLOCK)
Global Const $XTYP_CONNECT_CONFIRM    = BitOR(0x0070, $XCLASS_NOTIFICATION, $XTYPF_NOBLOCK)
Global Const $XTYP_XACT_COMPLETE      = BitOR(0x0080, $XCLASS_NOTIFICATION)
Global Const $XTYP_POKE               = BitOR(0x0090, $XCLASS_FLAGS)
Global Const $XTYP_REGISTER           = BitOR(0x00A0, $XCLASS_NOTIFICATION, $XTYPF_NOBLOCK)
Global Const $XTYP_REQUEST            = BitOR(0x00B0, $XCLASS_DATA)
Global Const $XTYP_DISCONNECT         = BitOR(0x00C0, $XCLASS_NOTIFICATION, $XTYPF_NOBLOCK)
Global Const $XTYP_UNREGISTER         = BitOR(0x00D0, $XCLASS_NOTIFICATION, $XTYPF_NOBLOCK)
Global Const $XTYP_WILDCONNECT        = BitOR(0x00E0, $XCLASS_DATA, $XTYPF_NOBLOCK)

Global Const $XTYP_MASK                = 0x00F0
Global Const $XTYP_SHIFT               = 4  ; shift to turn XTYP_ into an index ;

;**** Timeout constants ****;

Global Const $TIMEOUT_ASYNC           = 0xFFFFFFFF

;**** Transaction ID constants ****;

Global Const $QID_SYNC                = 0xFFFFFFFF

;***** public strings used in DDE *****;
Global Const $SZDDESYS_TOPIC         = "System"
Global Const $SZDDESYS_ITEM_TOPICS   = "Topics"
Global Const $SZDDESYS_ITEM_SYSITEMS = "SysItems"
Global Const $SZDDESYS_ITEM_RTNMSG   = "ReturnMessage"
Global Const $SZDDESYS_ITEM_STATUS   = "Status"
Global Const $SZDDESYS_ITEM_FORMATS  = "Formats"
Global Const $SZDDESYS_ITEM_HELP     = "Help"
Global Const $SZDDE_ITEM_ITEMLIST    = "TopicItemList"

Global Const $CBR_BLOCK = 0xffffffff

; Callback filter flags for use with standard apps.

Global Const $CBF_FAIL_SELFCONNECTIONS     = 0x00001000
Global Const $CBF_FAIL_CONNECTIONS         = 0x00002000
Global Const $CBF_FAIL_ADVISES             = 0x00004000
Global Const $CBF_FAIL_EXECUTES            = 0x00008000
Global Const $CBF_FAIL_POKES               = 0x00010000
Global Const $CBF_FAIL_REQUESTS            = 0x00020000
Global Const $CBF_FAIL_ALLSVRXACTIONS      = 0x0003f000

Global Const $CBF_SKIP_CONNECT_CONFIRMS    = 0x00040000
Global Const $CBF_SKIP_REGISTRATIONS       = 0x00080000
Global Const $CBF_SKIP_UNREGISTRATIONS     = 0x00100000
Global Const $CBF_SKIP_DISCONNECTS         = 0x00200000
Global Const $CBF_SKIP_ALLNOTIFICATIONS    = 0x003c0000

; Application command flags

Global Const $APPCMD_CLIENTONLY            = 0x00000010
Global Const $APPCMD_FILTERINITS           = 0x00000020
Global Const $APPCMD_MASK                  = 0x00000FF0

; Application classification flags

Global Const $APPCLASS_STANDARD            = 0x00000000
Global Const $APPCLASS_MASK                = 0x0000000F

Global Const $EC_ENABLEALL            = 0
Global Const $EC_ENABLEONE            = $ST_BLOCKNEXT
Global Const $EC_DISABLE              = $ST_BLOCKED
Global Const $EC_QUERYWAITING         = 2

Global Const $DNS_REGISTER        = 0x0001
Global Const $DNS_UNREGISTER      = 0x0002
Global Const $DNS_FILTERON        = 0x0004
Global Const $DNS_FILTEROFF       = 0x0008

Global Const $HDATA_APPOWNED          = 0x0001

Global Const $DMLERR_NO_ERROR                    = 0       ; must be 0 ;

Global Const $DMLERR_FIRST                       = 0x4000

Global Const $DMLERR_ADVACKTIMEOUT               = 0x4000
Global Const $DMLERR_BUSY                        = 0x4001
Global Const $DMLERR_DATAACKTIMEOUT              = 0x4002
Global Const $DMLERR_DLL_NOT_INITIALIZED         = 0x4003
Global Const $DMLERR_DLL_USAGE                   = 0x4004
Global Const $DMLERR_EXECACKTIMEOUT              = 0x4005
Global Const $DMLERR_INVALIDPARAMETER            = 0x4006
Global Const $DMLERR_LOW_MEMORY                  = 0x4007
Global Const $DMLERR_MEMORY_ERROR                = 0x4008
Global Const $DMLERR_NOTPROCESSED                = 0x4009
Global Const $DMLERR_NO_CONV_ESTABLISHED         = 0x400a
Global Const $DMLERR_POKEACKTIMEOUT              = 0x400b
Global Const $DMLERR_POSTMSG_FAILED              = 0x400c
Global Const $DMLERR_REENTRANCY                  = 0x400d
Global Const $DMLERR_SERVER_DIED                 = 0x400e
Global Const $DMLERR_SYS_ERROR                   = 0x400f
Global Const $DMLERR_UNADVACKTIMEOUT             = 0x4010
Global Const $DMLERR_UNFOUND_QUEUE_ID            = 0x4011

Global Const $DMLERR_LAST                        = 0x4011

Global Const $CF_CUSTOM = 0x0201

Global Const $_DDEML_HANDLETYPE = "ptr"
Global Const $_DDEML_HANDLETYPE_CHECK = "IsPtr"
Global Const $_DDEML_typdef_DdeCallback = "uint;uint;ptr;ptr;ptr;ptr;dword;dword"
Global Const $_DDEML_typdef_CONVCONTEXT = "UINT cb;UINT wFlags;UINT wCountryID;int iCodePage;DWORD dwLangID;DWORD dwSecurity;byte[128] qos"
Global Const $_DDEML_typdef_CONVINFO = "DWORD cb;DWORD hUser;INT hConvPartner;INT hszSvcPartner;INT hszServiceReq;INT hszTopic;INT hszItem;UINT wFmt;UINT wType;UINT wStatus;UINT wConvst;UINT wLastError;HCONVLIST hConvList;" & $_DDEML_typdef_CONVCONTEXT & ";HWND hwnd;HWND hwndPartner"
