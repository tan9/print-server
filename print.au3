#include <au3\include\DDEML.au3>
#include <au3\include\DDEMLClient.au3>

Opt("WinTitleMatchMode", 2)

Const $EXIT_MISSING_ARGUMENT = 1
Const $EXIT_FAILED_TO_OPEN_ADOBE_READER = 2
Const $EXIT_CANNOT_LOCATE_ACROBAT_DDE = 3
Const $EXIT_FAILED_TO_PRINT = 4


; Read pdf filepath from command line argument, terminate script if no command-line arguments
If $CmdLine[0] = 0 Then Exit($EXIT_MISSING_ARGUMENT)
$PdfFile = $CmdLine[1]


; Execute Adobe Reader
$Pid = ShellExecute("AcroRd32.exe", "/h", "", "", @SW_HIDE)
If $Pid = 0 Then
    ConsoleWrite('Can not open Adobe Reader process.' & @CRLF)
    Exit($EXIT_FAILED_TO_OPEN_ADOBE_READER)
EndIf

$Handle = WinWait("Reader", "", 10)
If $Handle = 0 Then
    ConsoleWrite('Adobe Reader window not show up within 10 seconds.' & @CRLF)
    Exit($EXIT_FAILED_TO_OPEN_ADOBE_READER)
EndIf


; Find out the Acrobat DDE Service
Sleep(500)

Local $aServiceName[19]

$aServiceName[0] = "AcroviewR20" ; Acrobat Reader DC 2020
$aServiceName[1] = "AcroviewR21"
$aServiceName[2] = "AcroviewR22"
$aServiceName[3] = "AcroviewR23"
$aServiceName[4] = "AcroviewR24"
$aServiceName[5] = "AcroviewR25"
$aServiceName[6] = "AcroviewR26"
$aServiceName[7] = "AcroviewR27"
$aServiceName[8] = "AcroviewR28"
$aServiceName[9] = "AcroviewR29"
$aServiceName[10] = "AcroviewR30"
$aServiceName[11] = "AcroviewR15" ; Acrobat Reader DC 2015
$aServiceName[12] = "AcroviewR11" ; Adobe Reader XI
$aServiceName[13] = "AcroviewR10" ; Adobe Reader X
$aServiceName[14] = "Acroview"    ; Acrobat Reader 9 and below
$aServiceName[15] = "AcroviewR16"
$aServiceName[16] = "AcroviewR17"
$aServiceName[17] = "AcroviewR18"
$aServiceName[18] = "AcroviewR19"

Global $szTopic = "Control"
Global $szService = ""

For $vServiceName In $aServiceName
    $res = _DDEMLClient_Execute($vServiceName, $szTopic, "[AppHide()]")
    If $res & "" = "0x00000000" Then ; Successfull call returns 0x00000000, while fails call is 0
        $szService = $vServiceName;
		ExitLoop
    EndIf
Next

If $szService = "" Then
    ConsoleWrite('Cannot locate Acrobat DDE Service.' & @CRLF)
    Exit($EXIT_CANNOT_LOCATE_ACROBAT_DDE)
EndIf


; Start to print
$szCommand = '[FilePrintSilent("' & $PdfFile & '")][AppExit()]'
$res = _DDEMLClient_Execute($szService, $szTopic, $szCommand)
If $res <> 0x00000001 Then
    ConsoleWrite('Something wrong when printing.' & @CRLF)
    Exit($EXIT_FAILED_TO_PRINT)
EndIf
