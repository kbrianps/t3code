' T3 Code Fast Launcher (Single-Instance + Instant Launch)
Option Explicit

Dim WshShell, fso, electronPath, mainPath, desktopDir
Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

electronPath = "Z:\Workspaces\t3code\node_modules\.pnpm\electron@41.5.0\node_modules\electron\dist\electron.exe"
mainPath = "Z:\Workspaces\t3code\apps\desktop\dist-electron\main.cjs"
desktopDir = "Z:\Workspaces\t3code\apps\desktop"

' 1. Check if T3 Code window already exists - if so, focus it and exit
If WshShell.AppActivate("T3 Code") Then
    Wscript.Quit 0
End If

' 2. Verify files exist before launching to prevent any "file not found" errors
If Not fso.FileExists(electronPath) Then
    MsgBox "Electron executable not found at:" & vbCrLf & electronPath, vbCritical, "T3 Code Launcher Error"
    Wscript.Quit 1
End If

If Not fso.FileExists(mainPath) Then
    MsgBox "T3 Code build artifact not found at:" & vbCrLf & mainPath & vbCrLf & vbCrLf & "Please run 'pnpm run build:desktop' first.", vbExclamation, "T3 Code Not Built"
    Wscript.Quit 1
End If

' 3. Set working directory and launch Electron directly
WshShell.CurrentDirectory = desktopDir
WshShell.Run """" & electronPath & """ """ & mainPath & """", 1, False

Set WshShell = Nothing
Set fso = Nothing
