#include-once
; ------------------------------------------------------------------------------
;
; Version:        1.5
; AutoIt Version: 3.3.0.0
; Language:       English
; Author:         doudou
; Description:    Functions for DDEML servers.
; Requirements:   DDEML
; $Revision: 1.1.1.1 $
; $Date: 2010/04/07 20:58:50 $
;
; ------------------------------------------------------------------------------

;===============================================================================
; Function Name:   _DdeNameService
; Description:     The DdeNameService function registers or unregisters the
;                  service names a dynamic data exchange (DDE) server supports.
;                  This function causes the system to send $XTYP_REGISTER or
;                  $XTYP_UNREGISTER transactions to other running Dynamic Data
;                  Exchange Management Library (DDEML) client applications.
;                  
;                  A server application should call this function to register
;                  each service name that it supports and to unregister names it
;                  previously registered but no longer supports. A server should
;                  also call this function to unregister its service names just
;                  before terminating.

;
; Parameter(s):    $hszName - Handle to the string that specifies the service
;                             name the server is registering or unregistering.
;                             An application that is unregistering all of its
;                             service names should set this parameter to 0.
;                  $afCmd - Specifies the service name flags. This parameter can
;                           be one of the following flags:
;                           $DNS_REGISTER   Registers the error code service
;                                           name.
;                           $DNS_UNREGISTER Unregisters the error code service
;                                           name. If the $hszName parameter is
;                                           0, all service names registered by
;                                           the server will be unregistered.
;                           $DNS_FILTERON   Turns on service name initiation
;                                           filtering. The filter prevents a
;                                           server from receiving $XTYP_CONNECT
;                                           transactions for service names it
;                                           has not registered. This is the default
;                                           setting for this filter.
;                                           If a server application does not
;                                           register any service names, the
;                                           application cannot receive
;                                           $XTYP_WILDCONNECT transactions.
;                           $DNS_FILTEROFF  Turns off service name initiation
;                                           filtering. If this flag is
;                                           specified, the server receives an
;                                           $XTYP_CONNECT transaction whenever
;                                           another DDE application calls the
;                                           _DdeConnect function, regardless of
;                                           the service name.
;
; Requirement(s):  External:   user32.dll (it's already in system32).
;
; Return Value(s): If the funcion succeeds, it returns a nonzero value. That
;                  value is not a true HDDEDATA value, merely a Boolean indicator
;                  of success. The function is typed HDDEDATA to allow for possible
;                  future expansion of the function and a more sophisticated
;                  return value. 
;                  If the function fails, the return value is 0.
;
; Author(s):       doudou
;===============================================================================
Func _DdeNameService($hszName, $afCmd)
    If Not _DdeIsInitialized() Then
        ConsoleWrite("DDEML not initialized")
        SetError($DMLERR_DLL_NOT_INITIALIZED)
        Return False
    EndIf
    Local $res = DllCall("user32.dll", $_DDEML_HANDLETYPE, "DdeNameService", "dword", $_DDEML_idInst, $_DDEML_HANDLETYPE, $hszName, $_DDEML_HANDLETYPE, 0, "uint", $afCmd)
    If $res[0] Then Return True
    
    SetError(_DdeGetLastError())
    Return False
EndFunc

;===============================================================================
; Function Name:   _DdePostAdvise
; Description:     The _DdePostAdvise function causes the system to send an
;                  $XTYP_ADVREQ transaction to the calling (server) application's
;                  dynamic data exchange (DDE) callback function for each client
;                  with an active advise loop on the specified topic and item.
;                  A server application should call this function whenever the
;                  data associated with the topic name or item name pair changes.
;
; Parameter(s):    $hszTopic - Handle to a string that specifies the topic name.
;                              To send notifications for all topics with active
;                              advise loops, an application can set this parameter
;                              to 0.
;                  $hszItem - Handle to a string that specifies the item name.
;                             To send notifications for all items with active
;                             advise loops, an application can set this parameter
;                             to 0.
;
; Requirement(s):  External:   user32.dll (it's already in system32).
;
; Return Value(s): If the function succeeds, the return value is True.
;                  If the function fails, the return value is False.
;
; Author(s):       doudou
;===============================================================================
Func _DdePostAdvise($hszTopic = 0, $hszItem = 0)
    Local $res = DllCall("user32.dll", "int", "DdePostAdvise", "dword", $_DDEML_idInst, $_DDEML_HANDLETYPE, $hszTopic, $_DDEML_HANDLETYPE, $hszItem)
    If $res[0] Then Return True
    
    SetError(_DdeGetLastError())
    Return False
EndFunc

;===============================================================================
; Function Name:   _DdeEnableCallback
; Description:     The _DdeEnableCallback function enables or disables transactions
;                  for a specific conversation or for all conversations currently
;                  established by the calling application.
;                  After disabling transactions for a conversation, the operating
;                  system places the transactions for that conversation in a
;                  transaction queue associated with the application. The application
;                  should reenable the conversation as soon as possible to avoid
;                  losing queued transactions.

;
; Parameter(s):    $wCmd - Specifies the function code. This parameter can be
;                          one of the following values: 
;                          $EC_ENABLEALL    Enables all transactions for the
;                                           specified conversation. 
;                          $EC_ENABLEONE    Enables one transaction for the
;                                           specified conversation. 
;                          $EC_DISABLE      Disables all blockable transactions
;                                           for the specified conversation.
;                          A server application can disable the following transactions:
;                          
;                              $XTYP_ADVSTART
;                              $XTYP_ADVSTOP
;                              $XTYP_EXECUTE
;                              $XTYP_POKE
;                              $XTYP_REQUEST
;                          
;                          A client application can disable the following transactions:
;                          
;                              $XTYP_ADVDATA
;                              $XTYP_XACT_COMPLETE
;                           
;                          $EC_QUERYWAITING Determines whether any transactions
;                                           are in the queue for the specified
;                                           conversation. 
;                  $hConv - Handle to the conversation to enable or disable.
;                           If this parameter is 0, the function affects all
;                           conversations.
;
; Requirement(s):  External:   user32.dll (it's already in system32).
;
; Return Value(s): If the function succeeds, the return value is True.
;                  If the function fails, the return value is False.
;
; Author(s):       doudou
;===============================================================================
Func _DdeEnableCallback($wCmd = $EC_ENABLEALL, $hConv = 0)
    Local $res = DllCall("user32.dll", "int", "DdeEnableCallback", "dword", $_DDEML_idInst, $_DDEML_HANDLETYPE, $hConv, "uint", $wCmd)
    If $res[0] Then Return True
    
    SetError(_DdeGetLastError())
    Return False
EndFunc

Func _DdeImpersonateClient($hConv)
    Local $res = DllCall("user32.dll", "int", "DdeImpersonateClient", $_DDEML_HANDLETYPE, $hConv)
    If $res[0] Then Return True
    
    SetError(_DdeGetLastError())
    Return False
EndFunc