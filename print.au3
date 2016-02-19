Opt("WinTitleMatchMode", 2)

; Terminate script if no command-line arguments
If $CmdLine[0] = 0 Then Exit(1)

$FnToPrt = $CmdLine[1]

Const $EXIT_FAILED_TO_OPEN_PROCESS = 1
Const $EXIT_PRINT_WAIT_TIMEOUT = 2
Const $EXIT_PROCESS_CLOSE_TIMEOUT = 3

ShellExecute("AcroRd32.exe", "/h /p" & " """ & $FnToPrt & """", "", "", @SW_HIDE)
$Pid = ProcessWait("AcroRd32.exe", 30)
If $Pid = 0 Then
    Exit($EXIT_FAILED_TO_OPEN_PROCESS)
EndIf

$Timer = 0
Do
    Sleep(1000)
    $Timer += 1
    If WinExists("[CLASS:PrintUI_PrinterQueue]") = 0 Then
        If ProcessWaitClose($Pid, 30) <> 1 Then
            Exit($EXIT_PROCESS_CLOSE_TIMEOUT)
        EndIf
    EndIf
    If $Timer = 60 Then
        Exit($EXIT_PRINT_WAIT_TIMEOUT)
    EndIf
Until ProcessExists($PID) = 0
