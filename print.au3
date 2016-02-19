Opt("WinTitleMatchMode", 2)

; Terminate script if no command-line arguments
If $CmdLine[0] = 0 Then Exit (1)

$FnToPrt = $CmdLine[1]

ShellExecute("AcroRd32.exe", "/h /p" & " """ & $FnToPrt & """", "", "", @SW_HIDE )
$OK = ProcessWait("AcroRd32.exe", 20)
If $OK = 0 Then
    Exit (2)
EndIf

Global $PID = WinGetProcess ("Reader")
Global $Handle = WinGetHandle ("Reader")
$Timer = 0
Do
    Sleep (1000)
    $Timer += 1
    If WinExists('[CLASS:PrintUI_PrinterQueue]', "") = 0 Then
        WinClose($Handle)
    EndIf
    If $Timer = 60 Then
        ExitLoop
    EndIf
Until ProcessExists ($PID) = 0
