Opt("WinTitleMatchMode", 2)

; Terminate script if no command-line arguments
If $CmdLine[0] = 0 Then Exit (1)

$FnToPrt = $CmdLine[1]

ShellExecute("AcroRD32.exe", "/h /p" & " """ & $FnToPrt & """", "", "", @SW_HIDE )
$OK = ProcessWait("AcroRd32.exe", 20)
if $OK = 0 Then
    msgbox(0, "", "Coudn't start process")
    ;return 0
    exit (2)
endif

GLOBAL $PID = WinGetProcess ("Reader")
GLobal $handle = WinGethandle ("Reader")
$timer = 0
Do
    sleep(1000)
    $timer +=+1
    if Winexists('[CLASS:PrintUI_PrinterQueue]', "") = 0 then
        ;msgbox(0,"","Printing finished")
        WinClose($handle)
    endif
    if $timer = 60 then
        msgbox(0, "", "Timeout")
        ;return 0
        exitloop
    endif
 until ProcessExists($PID) = 0
