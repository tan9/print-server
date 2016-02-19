#include <au3\include\DDEML.au3>
#include <au3\include\DDEMLClient.au3>

Opt("WinTitleMatchMode", 2)

Const $EXIT_MISSING_ARGUMENT = 1
Const $EXIT_FAILED_TO_OPEN_ADOBE_READER = 2
Const $EXIT_FAILED_TO_PRINT = 3

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

Sleep(500)

$szService = "AcroviewR15"
$szTopic = "Control"
$szCommand = '[FilePrintSilent("' & $PdfFile & '")][AppExit()]'
$res = _DDEMLClient_Execute($szService, $szTopic, $szCommand)
If $res <> 0x00000001 Then
    ConsoleWrite('Something wrong when printing.' & @CRLF)
    Exit($EXIT_FAILED_TO_PRINT)
EndIf
