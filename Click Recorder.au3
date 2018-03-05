#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         Samuel Pua

 Script Function:
	To have autoclicker functionality with manual editable strokes.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>

#include <Timers.au3>

HotKeySet("+q", "reset") ; shift q resets
HotKeySet("+w", "addLeft") ; add left click
HotKeySet("+e", "addRight") ; add right click
HotKeySet("+r", "addNo") ; add no click

HotKeySet("+{ENTER}", "addEnter") ; add enter

HotKeySet("+a", "showSteps") ; show steps
HotKeySet("+s", "runAll") ; run script
HotKeySet("~", "closeProgram") ; Exit
HotKeySet("?", "helpMe") ; Help

HotKeySet("{+}", "plusTimes") ; Add 1 more run iteration
HotKeySet("-", "minusTimes") ; Reduce 1 run iteration
HotKeySet("=", "setTimes") ; Set times
HotKeySet("|", "changeDelay") ; Change delay

HotKeySet("+l", "fileLoad") ; fileload
HotKeySet("+f", "fileSave") ; filesave

;;;;;;;;;;;;;;;;;;; Start ;;;;;;;;;;;;;;;;;;;
Global $mouseFile="mousestrokes.txt"

Global $current=0
Global $memoryX[1000]
Global $memoryy[1000]
Global $delays[1000]
Global $clicks[1000] ; 0 left, 1 right, 2 no
Global $lastTime=0
Global $startTime
Global $runTimes=1

Global $instructions

$instructions = ""
$instructions = $instructions & "Shift Q: Reset Instructions"&@CRLF
$instructions = $instructions & "Shift W: Add new left click"&@CRLF
$instructions = $instructions & "Shift E: Add new right click"&@CRLF
$instructions = $instructions & "Shift R: Add delay"&@CRLF
$instructions = $instructions & "Shift Enter: Add enter key"&@CRLF
$instructions = $instructions & "|: Manually change delay"&@CRLF&@CRLF

$instructions = $instructions & "+: Increase number of runs"&@CRLF
$instructions = $instructions & "-: Reduce number of runs"&@CRLF
$instructions = $instructions & "=: Set number of runs"&@CRLF&@CRLF

$instructions = $instructions & "Shift A: Show Steps"&@CRLF
$instructions = $instructions & "Shift S: Run clicks"&@CRLF&@CRLF

$instructions = $instructions & "Shift L: Load File from "&$mouseFile&@CRLF
$instructions = $instructions & "Shift F: Save File to "&$mouseFile&@CRLF&@CRLF

$instructions = $instructions & "~: Exit Program"&@CRLF
$instructions = $instructions & "?: Help"

MsgBox(0,"Instructions", $instructions)

Func reset()
   $current=0
   $lastTime=0
   $runTimes=1
   Msgbox(0,"Reset", "All keys reset")
EndFunc

Func addLeft()
   $memoryX[$current]=mousegetpos(0)
   $memoryY[$current]=mousegetpos(1)
   $clicks[$current]=0 ; left click
   if $current=0 Then
	  $startTime=_Timer_Init()
	  $delays[$current]=0
   Else
	  $delays[$current] = _Timer_Diff($startTime)-$lastTime
	  $lastTime = _Timer_Diff($startTime)
   EndIf
   $current=$current+1
EndFunc

Func addRight()
   $memoryX[$current]=mousegetpos(0)
   $memoryY[$current]=mousegetpos(1)
   $clicks[$current]=1 ; right click
   if $current=0 Then
	  $startTime=_Timer_Init()
	  $delays[$current]=0
   Else
	  $delays[$current] = _Timer_Diff($startTime)-$lastTime
	  $lastTime = _Timer_Diff($startTime)
   EndIf
   $current=$current+1
EndFunc

Func addNo()
   $memoryX[$current]=mousegetpos(0)
   $memoryY[$current]=mousegetpos(1)
   $clicks[$current]=2 ; no click
   if $current=0 Then
	  $startTime=_Timer_Init()
	  $delays[$current]=0
   Else
	  $delays[$current] = _Timer_Diff($startTime)-$lastTime
	  $lastTime = _Timer_Diff($startTime)
   EndIf
   $current=$current+1
EndFunc

Func addEnter()
   $memoryX[$current]=mousegetpos(0)
   $memoryY[$current]=mousegetpos(1)
   $clicks[$current]=3 ; Enter
   if $current=0 Then
	  $startTime=_Timer_Init()
	  $delays[$current]=0
   Else
	  $delays[$current] = _Timer_Diff($startTime)-$lastTime
	  $lastTime = _Timer_Diff($startTime)
   EndIf
   $current=$current+1
EndFunc

Func showSteps()
   Local $printer=""
   For $i = 0 to $current-1
	  $printer=$printer&"Delay: "&$delays[$i]&"ms"&@CRLF

	  if $clicks[$i]=0 Then
		 $printer=$printer&"Left Click: "
	  ElseIf $clicks[$i]=1 Then
		 $printer=$printer&"Right Click: "
	  ElseIf $clicks[$i]=2 Then
		 $printer=$printer&"No Click: "
	  ElseIf $clicks[$i]=3 Then
		 $printer=$printer&"Enter Key: "
	  EndIf

	  $printer=$printer&$memoryX[$i]&", "&$memoryY[$i]&@CRLF&@CRLF
   Next
   MsgBox(0,"Show Steps Recorded",$printer)
EndFunc

Func changeDelay()
   for $i = 0 to $current-1
	  $response=InputBox("Manually change timer for step"&$i+1,"Current delay: "&$delays[$i]&"ms")
	  if $response<>"" Then
		 $delays[$i]=$response
	  endif
   Next
EndFunc

Func runAll()
   sleep(1000)
   for $runrun = 1 to $runTimes
	  for $i = 0 to $current-1
		 Sleep($delays[$i])
		 if $clicks[$i]=0 then ; if left
			MouseClick("left", $memoryX[$i], $memoryY[$i],1,0)
		 ElseIf $clicks[$i]=1 then ; if right
			MouseClick("right", $memoryX[$i], $memoryY[$i],1,0)
		 ElseIf $clicks[$i]=2 Then
			MouseMove( $memoryX[$i], $memoryY[$i]); if nothing so do nothing
		 ElseIf $clicks[$i]=3 Then
			Send("{ENTER}")
		 endif
	  Next
   Next
EndFunc

Func closeProgram()
   MsgBox(0,"Exit","Exiting program...")
   Exit(0)
EndFunc

Func helpMe()
   MsgBox(0,"Instructions", $instructions)
EndFunc

Func plusTimes()
   $runTimes=$runTimes+1
   MsgBox(0, "Number of runs", "Current number of runs is: "&$runTimes)
EndFunc

Func minusTimes()
   $runTimes=$runTimes-1
   MsgBox(0, "Number of runs", "Current number of runs is: "&$runTimes)
EndFunc

Func setTimes()
   $runTimes=InputBox("Please key in desired run times", "Current loop count set: "&$runTimes)
   MsgBox(0, "Number of runs", "Current number of runs is: "&$runTimes)
EndFunc

Func fileLoad()
   Local $hFileOpen = FileOpen($mouseFile, $FO_READ)
   If $hFileOpen = -1 Then
      MsgBox($MB_SYSTEMMODAL, "", "An error occurred when reading the file.")
      Return False
   EndIf

   FileClose($hFileOpen)

   $tempLine="Start"
   $lineCount=0
   $done=0
   $current=0
   While $done = 0
	  $lineCount=$lineCount+1
	  $temp=FileREadLine($mouseFile,$lineCount)
	  if @error<>0 Then
		 $done=1
	  EndIf

	  ;Do actual work
	  if $done=0 Then
		 if (StringLen($temp)>=7) and (StringMid($temp,1,1)<>"#")  then
			$commands=StringSplit($temp," ")
			if $commands[1]="L" Then
			   $clicks[$current]=0
			ElseIf $commands[1]="R" Then
			   $clicks[$current]=1
			ElseIf $commands[1]="N" Then
			   $clicks[$current]=2
			ElseIf $commands[1]="E" Then
			   $clicks[$current]=3
			endif

			$memoryX[$current]=$commands[2]*1
			$memoryY[$current]=$commands[3]*1
			$delays[$current]=$commands[4]*1

			$current=$current+1
		 EndIf
	  EndIf
   WEnd

   MsgBox(0,"File Load", $mouseFile&" loaded successfully!")

EndFunc

Func fileSave()
   Local $hFileOpen = FileOpen($mouseFile, $FO_OVERWRITE)
   If $hFileOpen = -1 Then
      MsgBox($MB_SYSTEMMODAL, "", "An error occurred when reading the file.")
      Return False
   EndIf

   for $i = 0 to $current-1
	  $line=""
   	  If $clicks[$i]=0 Then
		 $line="L "
	  ElseIf $clicks[$i]=1 Then
		 $line="R "
	  ElseIf $clicks[$i]=2 Then
		 $line="N "
	  ElseIf $clicks[$i]=3 Then
		 $line="E "
	  EndIf

	  $line=$line&$memoryX[$i]&" " & $memoryY[$i] & " " & $delays[$i]
	  FileWriteLine ( $hFileOpen, $line )
   Next

   FileClose($hFileOpen)
   MsgBox(0,"File Save", $mouseFile&" saved successfully!")
EndFunc

While 1
	  Sleep(100)
WEnd