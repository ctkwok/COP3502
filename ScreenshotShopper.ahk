/*
Requires List.ahk - Holds List of Web titles that is in Order Review
List2.ahk - Holds list of web titles that give order confirmation
RetailerList.ahk - holds list of Retailer names found in web title

Two Important functions from AHK : ScreenCapture, GetURL, varize (remove illegal char)
*/

;For GetURL Function
;test comment
;more test


ModernBrowsers := "ApplicationFrameWindow,Chrome_WidgetWin_0,Chrome_WidgetWin_1,Maxthon3Cls_MainFrm,MozillaWindowClass,Slimjet_WidgetWin_1"
LegacyBrowsers := "IEFrame,OperaWindowClass"

pathDir = C:\Users\c\Desktop\Program
FileRead, keyListOfWebName, %pathDir%\OrderReview.ahk
StringReplace,keyListOfWebName,keyListOfWebName,`r`n,,A ;Remove Enter from OrderReview.ahk

FileRead, keyListOfWebNameSecond, %pathDir%\OrderConfirmation.ahk
StringReplace,keyListOfWebNameSecond,keyListOfWebNameSecond,`r`n,,A ;Remove Enter from OrderConfirmation.ahk

FileRead, retailerName, %pathDir%\RetailerList.ahk
StringReplace,retailerName,retailerName,`r`n,,A ;Remove Enter from RetailerList.ahk

FileRead, bufferPage, %pathDir%\BufferPage.ahk
StringReplace,bufferPage,bufferPage,`r`n,,A ;Remove Enter from RetailerList.ahk

SetTitleMatchMode,3 ;Match exact cast

WinGetTitle, OutputVar, A
StringCaseSense, On ;Case Sensitive

nameBrowsers := "Google Chrome,Mozilla Firefox"

TrayTip, ScreenshotShopper, Startup,6 ;Make a bubble box for user information

Run, SSAdditionalHotkey.ahk, %pathDir% ;Run hotkey additional ahk

Loop
{
    FileDelete %pathDir%\new.txt
    Sleep 100
    orderReviewURL := 0 ;Confirms previous window was a order review
    orderConfirmed := 0 ;URL or tab name confirmed
    checkPreOrder := 0 ;if not order confirmation then set to 0
    Loopout := 0 
    knownRetailer := 0
    listOfKeyText := ""
    preURL := ""
    postURL := ""
    getURL := ""
    updatedTab := ""

    if Outputvar not contains %nameBrowsers% ;Not a browser, get new Tab Name when diff Act. window
    {
     WinWaitNotActive, %OutputVar% ;Wait until new Active window   
     WinGetTitle, OutputVar, A
      continue
    }

    if OutputVar not in %keyListOfWebName%  ;Non Tab Name Retailer
        {
        IfWinActive, %OutputVar%
        
            {   
                getURL := GetActiveBrowserURL()

                if getURL in %keyListOfWebName% ;getURL of retailer
                {
                    orderReviewURL := 2 ;2 = by URL, 1 by Tab Name
                }
                
                if (orderReviewURL = 0)
                {
                    if OutputVar contains %retailerName% ;Detect if navigating through a new tab with same tab name
                    {
                        getUpdatedURL := GetActiveBrowserURL()
                        WinGetTitle, updatedTab, A

                        if (getURL = getUpdatedURL) && (OutputVar = updatedTab)
                        {
                            while (getURL = getUpdatedURL) && (OutputVar = updatedTab)
                            {

                                getUpdatedURL := GetActiveBrowserURL()
                                WinGetTitle, updatedTab, A
                                Sleep 10
                            
                            }
                        continue
                        }
                    
                    }
                     WinWaitNotActive, %OutputVar% ;Wait until new Active window
                    WinGetTitle, OutputVar, A
                }
                
            }else
            {
                WinGetTitle, OutputVar, A ;Get new Tab Title if different from previous active window
            }
        }
        
      if OutputVar in %keyListOfWebName%
      {
      orderReviewURL = 1
      }
              
     while (orderReviewURL > 0) ;Active window is a in list 1= Tab name , 2 = URL address
        {
            FormatTime, theTime,, M.d.yy HH.mm.ss ;get the time in variable theTime
            tempScreenshot := CaptureScreen(1,0,0) ;Screenshot current page in clipboard
            
            WinGetTitle, OutputVar, A
            webTitle := OutputVar ;webTitle has current active window tab title
            
            preURL := GetActiveBrowserURL() ;Get Current URL
            postURL := GetActiveBrowserURL()
            
            
            if(orderReviewURL = 1)
            {
              if OutputVar not in %keyListOfWebName%
                  {
                  orderReviewURL = 0
                  break
                  }
            }
              
            if(orderReviewURL = 2)
            {
              if preURL not in %keyListOfWebName% ;getURL of retailer
                  {
                  orderReviewURL = 0
                  break
                  }
            }

            sleep 2500
            
            if(orderReviewURL = 1)
            {
            WinGetTitle, OutputVar, A
              if OutputVar not in %keyListOfWebName%
                  {
                  orderReviewURL = 0
                  break
                  }
            }
            
            
              
            if(orderReviewURL = 2)
            
            {
            preURL := GetActiveBrowserURL() ;Get Current URL
              if preURL not in %keyListOfWebName% ;getURL of retailer
                  {
                  orderReviewURL = 0
                  break
                  }
            }
            
            GetOrderText(pathDir)
            sleep 100
            
            if OutputVar in %retailerName%
            {
                strUnknownRetail := unknownRetailerName(OutputVar,pathdir)
                ;Msgbox % strUnknownRetail[1] " " strUnknownRetail[2]
                getRetailerName := strUnknownRetail[2]
                knownRetailer := 1
                tempRetailName = %OutputVar%*||*%getRetailerName%
                ;tempRetailName := OutputVar + "*||*" + getRetailerName
                ;Msgbox % tempRetailName
                listOfKeyText := GetKeyText(tempRetailName, pathDir)
                sleep 100
            
            }else
            {
                getRetailerName := StrSplit(OutputVar,A_Space) ;the variable has all the words of web title delimitted by a space
                    Loop % getRetailerName.MaxIndex() ;Get the string that has a keyword listed in retailerlist For Filename 
                    {
                    currentRetailString := getRetailerName[A_index]
                    sleep 10
                    
                        if currentRetailString contains %retailerName%
                        {
                            getRetailerName := varize(currentRetailString)
                            listOfKeyText := GetKeyText(getRetailerName, pathDir)
                            ;Msgbox % listOfKeyText[1] "and" listOfKeyText[2] " " listOfKeyText[3] " " listOfKeyText[4]
                            knownRetailer := 1
                            sleep 100
                            break
                        }
                        
                        if (getRetailerName.MaxIndex() = A_index)
                        {
                           ; listUnkRetail := unknownRetailerName(webTitle,pathDir)
                           ; if (webTitle =
                            getRetailerName = Unknown Retailer
                            unknownRetailer := 1
                            break
                        }

                        ;Msgbox,% getRetailerName[A_index]
                    }
             }
                



              FormatTime, tempTime,, M.d.yy HH.mm.ss ;prevent screenshot confirmation page
              tempSavePictureLocation = %A_desktop%\Program\Paint\%tempTime% %getRetailerName% Order Review Backup.png
              CaptureScreen(1,0,tempSavePictureLocation)

                
              TrayTip, Detected Order Review, %getRetailerName%,6 ;Make a bubble box for user information
            
                Loop {

                        if (Mod(A_index, 5) = 1)
                        {
                            FileDelete, %savePictureLocation%
                            FormatTime, theTime,, M.d.yy HH.mm.ss ;Get New time
                            timeOrderReview := theTime
                            savePictureLocation = %A_desktop%\Program\Paint\%theTime% %getRetailerName% Order Review.png
                            CaptureScreen(1,0,savePictureLocation) ;Get New screenshot
                            Sleep, 900
                        }
                        
                        checkPreOrder := 1 ;Used for later to check if order is placed
                        
                        WinGetTitle, OutputVar, A ;Check if the active window changed
                        
                        if (orderReviewURL = 2)
                        {
                            postURL := GetActiveBrowserURL() ;Check if URL changed

                        }
                        if OutputVar in %bufferPage%
                        {
                            ;Msgbox 243
                            webTitle := OutputVar
                            
                        }
                        
                        if (OutputVar != webTitle)
                        {
                            Loopout := 1
                            break
                            
                        }
                        
                        if (postURL != preURL)
                        {
                            Loopout := 1
                            break
                            
                        }

                        
                        Sleep, 100
                    }
                    
             ;WinGetTitle, OutputVar, A
             ;postURL := GetActiveBrowserURL()
             
             if OutputVar in %keyListOfWebNameSecond%
             {
             orderConfirmed := 1
             }
             if postURL in %keyListOfWebNameSecond%
             {
             orderConfirmed := 1
             }
               ;msgbox Point 268

             
              if(knownRetailer > 0) && (orderConfirmed > 0)

                {
                    ;msgbox Point 274
                    FileRead , page , %pathDir%\new.txt
                                ;msgbox % listOfKeyText[1] "`r`n" listOfKeyText[2] "`r`n" listOfKeyText[3] "`r`n" listOfKeyText[4] "`r`n" listOfKeyText[5] "`r`n" listOfKeyText[6]
                    stringSearchOT1 := InStr(page, listOfKeyText[2],true)
                    if(stringSearchOT1 != 0 && listOfKeyText[2] != "")
                    
                    {
                        stringSearchOT2 := InStr(page, "$",,stringSearchOT1)
                        stringSearchOT3 := InStr(page, ".",,stringSearchOT2)
                        
                        OT1 := SubStr(page,stringSearchOT2+1,stringSearchOT3-stringSearchOT2-1)
                        OT2 := SubStr(page,stringSearchOT3,3)
                        ;Msgbox % OT1
                    }
                    
                    gcOccurence := delimKeyText(getRetailerName,pathDir,"*||*[GCOcc]") ;for Occurences other than 1
                     gcEnd := delimKeyText(getRetailerName,pathDir,"*||*[GCEnd]") ;If multiple giftcards, sum all of them 
                     gcStart := delimKeyText(getRetailerName,pathDir,"*||*[GCStart]")
                     
                     if(gcEnd[2] != "")
                    gcStringStop := InStr(page, gcEnd[2],true)
                    
                    if(gcStart[2] != "")
                    gcStringStart := InStr(page, gcStart[2],true)
                    else
                    gcStringStart := 1
                    
                    if(gcOccurence[2] != "")
                    stringSearchGC1 := InStr(page, listOfKeyText[3],true,gcStringStart,gcOccurence[2])
                    else
                    stringSearchGC1 := InStr(page, listOfKeyText[3],true,gcStringStart)    
                    
                  
                    if(stringSearchGC1 != 0 && listOfKeyText[3] != "")
                    {
                        if (gcStringStop > 0)
                            {
                                while (stringSearchGC2 < gcStringStop)
                                    {
                                    stringSearchGC2 := InStr(page, "$",,stringSearchGC1,A_index)
                                    if (stringSearchGC2 > gcStringStop)
                                    break
                                    stringSearchGC3 := InStr(page, ".",,stringSearchGC2)
                        
                                    tempGC1 := SubStr(page,stringSearchGC2+1,stringSearchGC3-stringSearchGC2-1)
                                    tempGC2 := SubStr(page,stringSearchGC3,3)
 
                                    GC1 += tempGC1
                                    GC2 += tempGC2

                                    
                                    }
                                    ;MsgBox % GC1 + GC2
                            }else
                            {
                                stringSearchGC2 := InStr(page, "$",,stringSearchGC1)
                                stringSearchGC3 := InStr(page, ".",,stringSearchGC2)
                                
                                GC1 := SubStr(page,stringSearchGC2+1,stringSearchGC3-stringSearchGC2-1)
                                GC2 := SubStr(page,stringSearchGC3,3)
                            }

                    }
                    
                    

                    stringSearchItem1 := InStr(page, listOfKeyText[4],true)
                    
                    if(stringSearchItem1 != 0 && listOfKeyText[4] != "")
                    {
                        stringSearchItem2 := InStr(page, "$",,stringSearchItem1)
                        stringSearchItem3 := InStr(page, ".",,stringSearchItem2)
                        
                        Item1 := SubStr(page,stringSearchItem2+1,stringSearchItem3-stringSearchItem2-1)
                        Item2 := SubStr(page,stringSearchItem3,3)
                        ;Msgbox % OT1 OT2
                        
                    }else 
                    
                    {
                        stringSearchItem1 := InStr(page, listOfKeyText[5],true)
                    
                    
                        if(stringSearchItem1 != 0 && listOfKeyText[5] != "")
                        {
                            stringSearchItem2 := InStr(page, "$",,stringSearchItem1)
                            stringSearchItem3 := InStr(page, ".",,stringSearchItem2)
                            
                            Item1 := SubStr(page,stringSearchItem2+1,stringSearchItem3-stringSearchItem2-1)
                            Item2 := SubStr(page,stringSearchItem3,3)
                        }
                    }
                    if(listOfKeyText[6] != "")
                    {
                        description := getDescText(pathDir,listOfKeyText[6])
                        ;msgbox % listOfKeyText[6]
                    }
                            ;MsgBox,,, % stringSearchOT1 " " stringSearchOT2 " " stringSearchOT3 " " OT1 " " OT2 "`r" stringSearchGC1 " " stringSearchGC2 " " stringSearchGC3 " " GC1 " " GC2 "`r" stringSearchItem1 " " stringSearchItem2 " " stringSearchItem3 " " Item1 " " Item2,5
               }
               
               
             if (orderConfirmed = 1 && checkPreOrder > 0)
             ;Check if page is order confirmation && Order review previously && New URL
                 {
                    sleep 1000
                    FormatTime, theTime,, M.d.yy HH.mm.ss ;Get New time
                    savePictureLocation = %A_desktop%\Program\Paint\%theTime% %getRetailerName% Confirmation.png
                    CaptureScreen(1,0,savePictureLocation) ;Save Image (Order confirmation)
                    TrayTip, ScreenShot, %getRetailerName%,6
                    

                    Sleep 100
                    
                    if(knownRetailer > 0)
                    {
                        ;Write to Excel
                        FilePath = %A_Desktop%/asdf.xlsx
                        xlDown := -4121
                        objExcel := ComObjCreate("Excel.Application")           ; create a handle to a new excel application
                        objWorkBook := objExcel.Workbooks.Open(FilePath)    ; opens the existing excel table
                        objExcel.Visible := False                                ; make excel visible (optional)

                        RegExMatch(objExcel.Worksheets(1).Range("a1")           ; find the row number of the first blank cell in column A
                            .End(xlDown).Offset(1, 0).Address(), "\d+$", Row)
                        listToExcel := {1:getRetailerName, 2:theTime, 3:OT1+OT2, 4:GC1+GC2, 5:Item1+Item2, 6:description}

                        Loop, 6
                            objExcel.Worksheets(1).Cells(Row, A_Index).Value := listToExcel[A_Index]
                        objWorkBook.Save
                        objExcel.Quit
                        objExcel := ""
                    }
                    
                    if (theTime = timeOrderReview)
                    FileDelete, %savePictureLocation%
                    else
                    FileDelete, %tempSavePictureLocation%

                    Sleep 100
                   
             
                }else
                {
                    WinGetTitle, OutputVar, A ;Get the new active window
                    FileDelete, %savePictureLocation%
                    FileDelete, %tempSavePictureLocation%
                   
             
                }
                sleep 100
                
                WinGetTitle, OutputVar, A

        }
     

}



;Capture screen stuff

/* CaptureScreen(aRect, bCursor, sFileTo, nQuality)
1) If the optional parameter bCursor is True, captures the cursor too.
2) If the optional parameter sFileTo is 0, set the image to Clipboard.
   If it is omitted or "", saves to screen.bmp in the script folder,
   otherwise to sFileTo which can be BMP/JPG/PNG/GIF/TIF.
3) The optional parameter nQuality is applicable only when sFileTo is JPG. Set it to the desired quality level of the resulting JPG, an integer between 0 - 100.
4) If aRect is 0/1/2/3, captures the entire desktop/active window/active client area/active monitor.
5) aRect can be comma delimited sequence of coordinates, e.g., "Left, Top, Right, Bottom" or "Left, Top, Right, Bottom, Width_Zoomed, Height_Zoomed".
   In this case, only that portion of the rectangle will be captured. Additionally, in the latter case, zoomed to the new width/height, Width_Zoomed/Height_Zoomed.

Example:
CaptureScreen(0)
CaptureScreen(1)
CaptureScreen(2)
CaptureScreen(3)
CaptureScreen("100, 100, 200, 200")
CaptureScreen("100, 100, 200, 200, 400, 400")   ; Zoomed
*/

/* Convert(sFileFr, sFileTo, nQuality)
Convert("C:\image.bmp", "C:\image.jpg")
Convert("C:\image.bmp", "C:\image.jpg", 95)
Convert(0, "C:\clip.png")   ; Save the bitmap in the clipboard to sFileTo if sFileFr is "" or 0.
*/


CaptureScreen(aRect = 0, bCursor = False, sFile = "", nQuality = "")
{
	If !aRect
	{
		SysGet, nL, 76  ; virtual screen left & top
		SysGet, nT, 77
		SysGet, nW, 78	; virtual screen width and height
		SysGet, nH, 79
	}
	Else If aRect = 1
		WinGetPos, nL, nT, nW, nH, A
	Else If aRect = 2
	{
		WinGet, hWnd, ID, A
		VarSetCapacity(rt, 16, 0)
		DllCall("GetClientRect" , "ptr", hWnd, "ptr", &rt)
		DllCall("ClientToScreen", "ptr", hWnd, "ptr", &rt)
		nL := NumGet(rt, 0, "int")
		nT := NumGet(rt, 4, "int")
		nW := NumGet(rt, 8)
		nH := NumGet(rt,12)
	}
	Else If aRect = 3
	{
		VarSetCapacity(mi, 40, 0)
		DllCall("GetCursorPos", "int64P", pt), NumPut(40,mi,0,"uint")
		DllCall("GetMonitorInfo", "ptr", DllCall("MonitorFromPoint", "int64", pt, "Uint", 2, "ptr"), "ptr", &mi)
		nL := NumGet(mi, 4, "int")
		nT := NumGet(mi, 8, "int")
		nW := NumGet(mi,12, "int") - nL
		nH := NumGet(mi,16, "int") - nT
	}
	Else
	{
		StringSplit, rt, aRect, `,, %A_Space%%A_Tab%
		nL := rt1	; convert the Left,top, right, bottom into left, top, width, height
		nT := rt2
		nW := rt3 - rt1
		nH := rt4 - rt2
		znW := rt5
		znH := rt6
	}

	mDC := DllCall("CreateCompatibleDC", "ptr", 0, "ptr")
	hBM := CreateDIBSection(mDC, nW, nH)
	oBM := DllCall("SelectObject", "ptr", mDC, "ptr", hBM, "ptr")
	hDC := DllCall("GetDC", "ptr", 0, "ptr")
	DllCall("BitBlt", "ptr", mDC, "int", 0, "int", 0, "int", nW, "int", nH, "ptr", hDC, "int", nL, "int", nT, "Uint", 0x40CC0020)
	DllCall("ReleaseDC", "ptr", 0, "ptr", hDC)
	If bCursor
		CaptureCursor(mDC, nL, nT)
	DllCall("SelectObject", "ptr", mDC, "ptr", oBM)
	DllCall("DeleteDC", "ptr", mDC)
	If znW && znH
		hBM := Zoomer(hBM, nW, nH, znW, znH)
	If sFile = 0
		SetClipboardData(hBM)
	Else Convert(hBM, sFile, nQuality), DllCall("DeleteObject", "ptr", hBM)
}

CaptureCursor(hDC, nL, nT)
{
	VarSetCapacity(mi, 32, 0), Numput(16+A_PtrSize, mi, 0, "uint")
	DllCall("GetCursorInfo", "ptr", &mi)
	bShow   := NumGet(mi, 4, "uint")
	hCursor := NumGet(mi, 8)
	xCursor := NumGet(mi,8+A_PtrSize, "int")
	yCursor := NumGet(mi,12+A_PtrSize, "int")

	DllCall("GetIconInfo", "ptr", hCursor, "ptr", &mi)
	xHotspot := NumGet(mi, 4, "uint")
	yHotspot := NumGet(mi, 8, "uint")
	hBMMask  := NumGet(mi,8+A_PtrSize)
	hBMColor := NumGet(mi,16+A_PtrSize)

	If bShow
		DllCall("DrawIcon", "ptr", hDC, "int", xCursor - xHotspot - nL, "int", yCursor - yHotspot - nT, "ptr", hCursor)
	If hBMMask
		DllCall("DeleteObject", "ptr", hBMMask)
	If hBMColor
		DllCall("DeleteObject", "ptr", hBMColor)
}

Zoomer(hBM, nW, nH, znW, znH)
{
	mDC1 := DllCall("CreateCompatibleDC", "ptr", 0, "ptr")
	mDC2 := DllCall("CreateCompatibleDC", "ptr", 0, "ptr")
	zhBM := CreateDIBSection(mDC2, znW, znH)
	oBM1 := DllCall("SelectObject", "ptr", mDC1, "ptr",  hBM, "ptr")
	oBM2 := DllCall("SelectObject", "ptr", mDC2, "ptr", zhBM, "ptr")
	DllCall("SetStretchBltMode", "ptr", mDC2, "int", 4)
	DllCall("StretchBlt", "ptr", mDC2, "int", 0, "int", 0, "int", znW, "int", znH, "ptr", mDC1, "int", 0, "int", 0, "int", nW, "int", nH, "Uint", 0x00CC0020)
	DllCall("SelectObject", "ptr", mDC1, "ptr", oBM1)
	DllCall("SelectObject", "ptr", mDC2, "ptr", oBM2)
	DllCall("DeleteDC", "ptr", mDC1)
	DllCall("DeleteDC", "ptr", mDC2)
	DllCall("DeleteObject", "ptr", hBM)
	Return zhBM
}

Convert(sFileFr = "", sFileTo = "", nQuality = "")
{
	If (sFileTo = "")
		sFileTo := A_ScriptDir . "\screen.bmp"
	SplitPath, sFileTo, , sDirTo, sExtTo, sNameTo
	
	If Not hGdiPlus := DllCall("LoadLibrary", "str", "gdiplus.dll", "ptr")
		Return	sFileFr+0 ? SaveHBITMAPToFile(sFileFr, sDirTo (sDirTo = "" ? "" : "\") sNameTo ".bmp") : ""
	VarSetCapacity(si, 16, 0), si := Chr(1)
	DllCall("gdiplus\GdiplusStartup", "UintP", pToken, "ptr", &si, "ptr", 0)

	If !sFileFr
	{
		DllCall("OpenClipboard", "ptr", 0)
		If	(DllCall("IsClipboardFormatAvailable", "Uint", 2) && (hBM:=DllCall("GetClipboardData", "Uint", 2, "ptr")))
			DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "ptr", hBM, "ptr", 0, "ptr*", pImage)
		DllCall("CloseClipboard")
	}
	Else If	sFileFr Is Integer
		DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "ptr", sFileFr, "ptr", 0, "ptr*", pImage)
	Else	DllCall("gdiplus\GdipLoadImageFromFile", "wstr", sFileFr, "ptr*", pImage)
	DllCall("gdiplus\GdipGetImageEncodersSize", "UintP", nCount, "UintP", nSize)
	VarSetCapacity(ci,nSize,0)
	DllCall("gdiplus\GdipGetImageEncoders", "Uint", nCount, "Uint", nSize, "ptr", &ci)
	struct_size := 48+7*A_PtrSize, offset := 32 + 3*A_PtrSize, pCodec := &ci - struct_size
	Loop, %	nCount
		If InStr(StrGet(Numget(offset + (pCodec+=struct_size)), "utf-16") , "." . sExtTo)
			break

	If (InStr(".JPG.JPEG.JPE.JFIF", "." . sExtTo) && nQuality<>"" && pImage && pCodec < &ci + nSize)
	{
		DllCall("gdiplus\GdipGetEncoderParameterListSize", "ptr", pImage, "ptr", pCodec, "UintP", nCount)
		VarSetCapacity(pi,nCount,0), struct_size := 24 + A_PtrSize
		DllCall("gdiplus\GdipGetEncoderParameterList", "ptr", pImage, "ptr", pCodec, "Uint", nCount, "ptr", &pi)
		Loop, %	NumGet(pi,0,"uint")
			If (NumGet(pi,struct_size*(A_Index-1)+16+A_PtrSize,"uint")=1 && NumGet(pi,struct_size*(A_Index-1)+20+A_PtrSize,"uint")=6)
			{
				pParam := &pi+struct_size*(A_Index-1)
				NumPut(nQuality,NumGet(NumPut(4,NumPut(1,pParam+0,"uint")+16+A_PtrSize,"uint")),"uint")
				Break
			}
	}

	If pImage
		pCodec < &ci + nSize	? DllCall("gdiplus\GdipSaveImageToFile", "ptr", pImage, "wstr", sFileTo, "ptr", pCodec, "ptr", pParam) : DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", "ptr", pImage, "ptr*", hBitmap, "Uint", 0) . SetClipboardData(hBitmap), DllCall("gdiplus\GdipDisposeImage", "ptr", pImage)

	DllCall("gdiplus\GdiplusShutdown" , "Uint", pToken)
	DllCall("FreeLibrary", "ptr", hGdiPlus)
}


CreateDIBSection(hDC, nW, nH, bpp = 32, ByRef pBits = "")
{
	VarSetCapacity(bi, 40, 0)
	NumPut(40, bi, "uint")
	NumPut(nW, bi, 4, "int")
	NumPut(nH, bi, 8, "int")
	NumPut(bpp, NumPut(1, bi, 12, "UShort"), 0, "Ushort")
	Return DllCall("gdi32\CreateDIBSection", "ptr", hDC, "ptr", &bi, "Uint", 0, "UintP", pBits, "ptr", 0, "Uint", 0, "ptr")
}

SaveHBITMAPToFile(hBitmap, sFile)
{
	VarSetCapacity(oi,104,0)
	DllCall("GetObject", "ptr", hBitmap, "int", 64+5*A_PtrSize, "ptr", &oi)
	fObj := FileOpen(sFile, "w")
	fObj.WriteShort(0x4D42)
	fObj.WriteInt(54+NumGet(oi,36+2*A_PtrSize,"uint"))
	fObj.WriteInt64(54<<32)
	fObj.RawWrite(&oi + 16 + 2*A_PtrSize, 40)
	fObj.RawWrite(NumGet(oi, 16+A_PtrSize), NumGet(oi,36+2*A_PtrSize,"uint"))
	fObj.Close()
}

SetClipboardData(hBitmap)
{
	VarSetCapacity(oi,104,0)
	DllCall("GetObject", "ptr", hBitmap, "int", 64+5*A_PtrSize, "ptr", &oi)
	sz := NumGet(oi,36+2*A_PtrSize,"uint")
	hDIB :=	DllCall("GlobalAlloc", "Uint", 2, "Uptr", 40+sz, "ptr")
	pDIB := DllCall("GlobalLock", "ptr", hDIB, "ptr")
	DllCall("RtlMoveMemory", "ptr", pDIB, "ptr", &oi + 16 + 2*A_PtrSize, "Uptr", 40)
	DllCall("RtlMoveMemory", "ptr", pDIB+40, "ptr", NumGet(oi, 16+A_PtrSize), "Uptr", sz)
	DllCall("GlobalUnlock", "ptr", hDIB)
	DllCall("DeleteObject", "ptr", hBitmap)
	DllCall("OpenClipboard", "ptr", 0)
	DllCall("EmptyClipboard")
	DllCall("SetClipboardData", "Uint", 8, "ptr", hDIB)
	DllCall("CloseClipboard")
}

; AutoHotkey Version: AutoHotkey 1.1
; Language:           English
; Platform:           Win7 SP1 / Win8.1 / Win10
; Author:             Antonio Bueno <user atnbueno of Google's popular e-mail service>
; Short description:  Gets the URL of the current (active) browser tab for most modern browsers
; Last Mod:           2016-05-19

; GET BROWSER URL
; "GetBrowserURL_DDE" adapted from DDE code by Sean, (AHK_L version by maraskan_user)
; Found at http://autohotkey.com/board/topic/17633-/?p=434518


GetActiveBrowserURL() {
	global ModernBrowsers, LegacyBrowsers
	WinGetClass, sClass, A
	If sClass In % ModernBrowsers
		Return GetBrowserURL_ACC(sClass)
	Else If sClass In % LegacyBrowsers
		Return GetBrowserURL_DDE(sClass) ; empty string if DDE not supported (or not a browser)
	Else
		Return ""
}

GetBrowserURL_DDE(sClass) {
	WinGet, sServer, ProcessName, % "ahk_class " sClass
	StringTrimRight, sServer, sServer, 4
	iCodePage := A_IsUnicode ? 0x04B0 : 0x03EC ; 0x04B0 = CP_WINUNICODE, 0x03EC = CP_WINANSI
	DllCall("DdeInitialize", "UPtrP", idInst, "Uint", 0, "Uint", 0, "Uint", 0)
	hServer := DllCall("DdeCreateStringHandle", "UPtr", idInst, "Str", sServer, "int", iCodePage)
	hTopic := DllCall("DdeCreateStringHandle", "UPtr", idInst, "Str", "WWW_GetWindowInfo", "int", iCodePage)
	hItem := DllCall("DdeCreateStringHandle", "UPtr", idInst, "Str", "0xFFFFFFFF", "int", iCodePage)
	hConv := DllCall("DdeConnect", "UPtr", idInst, "UPtr", hServer, "UPtr", hTopic, "Uint", 0)
	hData := DllCall("DdeClientTransaction", "Uint", 0, "Uint", 0, "UPtr", hConv, "UPtr", hItem, "UInt", 1, "Uint", 0x20B0, "Uint", 10000, "UPtrP", nResult) ; 0x20B0 = XTYP_REQUEST, 10000 = 10s timeout
	sData := DllCall("DdeAccessData", "Uint", hData, "Uint", 0, "Str")
	DllCall("DdeFreeStringHandle", "UPtr", idInst, "UPtr", hServer)
	DllCall("DdeFreeStringHandle", "UPtr", idInst, "UPtr", hTopic)
	DllCall("DdeFreeStringHandle", "UPtr", idInst, "UPtr", hItem)
	DllCall("DdeUnaccessData", "UPtr", hData)
	DllCall("DdeFreeDataHandle", "UPtr", hData)
	DllCall("DdeDisconnect", "UPtr", hConv)
	DllCall("DdeUninitialize", "UPtr", idInst)
	csvWindowInfo := StrGet(&sData, "CP0")
	StringSplit, sWindowInfo, csvWindowInfo, `" ;"; comment to avoid a syntax highlighting issue in autohotkey.com/boards
	Return sWindowInfo2
}

GetBrowserURL_ACC(sClass) {
	global nWindow, accAddressBar
	If (nWindow != WinExist("ahk_class " sClass)) ; reuses accAddressBar if it's the same window
	{
		nWindow := WinExist("ahk_class " sClass)
		accAddressBar := GetAddressBar(Acc_ObjectFromWindow(nWindow))
	}
	Try sURL := accAddressBar.accValue(0)
	If (sURL == "") {
		WinGet, nWindows, List, % "ahk_class " sClass ; In case of a nested browser window as in the old CoolNovo (TO DO: check if still needed)
		If (nWindows > 1) {
			accAddressBar := GetAddressBar(Acc_ObjectFromWindow(nWindows2))
			Try sURL := accAddressBar.accValue(0)
		}
	}
	If ((sURL != "") and (SubStr(sURL, 1, 4) != "http")) ; Modern browsers omit "http://"
		sURL := "http://" sURL
	If (sURL == "")
		nWindow := -1 ; Don't remember the window if there is no URL
	Return sURL
}

; "GetAddressBar" based in code by uname
; Found at http://autohotkey.com/board/topic/103178-/?p=637687

GetAddressBar(accObj) {
	Try If ((accObj.accRole(0) == 42) and IsURL(accObj.accValue(0)))
		Return accObj
	Try If ((accObj.accRole(0) == 42) and IsURL("http://" accObj.accValue(0))) ; Modern browsers omit "http://"
		Return accObj
	For nChild, accChild in Acc_Children(accObj)
		If IsObject(accAddressBar := GetAddressBar(accChild))
			Return accAddressBar
}

IsURL(sURL) {
	Return RegExMatch(sURL, "^(?<Protocol>https?|ftp)://(?<Domain>(?:[\w-]+\.)+\w\w+)(?::(?<Port>\d+))?/?(?<Path>(?:[^:/?# ]*/?)+)(?:\?(?<Query>[^#]+)?)?(?:\#(?<Hash>.+)?)?$")
}

; The code below is part of the Acc.ahk Standard Library by Sean (updated by jethrow)
; Found at http://autohotkey.com/board/topic/77303-/?p=491516

Acc_Init()
{
	static h
	If Not h
		h:=DllCall("LoadLibrary","Str","oleacc","Ptr")
}
Acc_ObjectFromWindow(hWnd, idObject = 0)
{
	Acc_Init()
	If DllCall("oleacc\AccessibleObjectFromWindow", "Ptr", hWnd, "UInt", idObject&=0xFFFFFFFF, "Ptr", -VarSetCapacity(IID,16)+NumPut(idObject==0xFFFFFFF0?0x46000000000000C0:0x719B3800AA000C81,NumPut(idObject==0xFFFFFFF0?0x0000000000020400:0x11CF3C3D618736E0,IID,"Int64"),"Int64"), "Ptr*", pacc)=0
	Return ComObjEnwrap(9,pacc,1)
}
Acc_Query(Acc) {
	Try Return ComObj(9, ComObjQuery(Acc,"{618736e0-3c3d-11cf-810c-00aa00389b71}"), 1)
}
Acc_Children(Acc) {
    ComObjError(false)
	If ComObjType(Acc,"Name") != "IAccessible"
		ErrorLevel := "Invalid IAccessible Object"
	Else {
		Acc_Init(), cChildren:=Acc.accChildCount, Children:=[]
		If DllCall("oleacc\AccessibleChildren", "Ptr",ComObjValue(Acc), "Int",0, "Int",cChildren, "Ptr",VarSetCapacity(varChildren,cChildren*(8+2*A_PtrSize),0)*0+&varChildren, "Int*",cChildren)=0 {
			Loop %cChildren%
				i:=(A_Index-1)*(A_PtrSize*2+8)+8, child:=NumGet(varChildren,i), Children.Insert(NumGet(varChildren,i-8)=9?Acc_Query(child):child), NumGet(varChildren,i-8)=9?ObjRelease(child):
			Return Children.MaxIndex()?Children:
		} Else
			ErrorLevel := "AccessibleChildren DllCall Failed"
	}
}


/*
Remove Illegal characters
https://autohotkey.com/board/topic/9430-remove-illegal-chars-from-a-string/
by: Veovis
*/


varize(var)
{
   stringreplace,var,var,%A_space%,_,a

   chars = <>:;'"/|\(){}=-+!`%^&*~
   loop, parse, chars,
      stringreplace,var,var,%A_loopfield%,,a
      
   return var
}

getKeyText(getRetailerName,pathDir)
{
    RetailerName := getRetailerName
    
    txt := pathDir "\ListOfKeyText.ahk" ;[1]Retailer, [2]Order total:, [3]Gift Card:, [4]Items (, [5]Items, [6]way to detect description (double for double text)
    FileRead, Contents, %txt%
    
    Loop, Parse, Contents, `r`n
    {
        if A_loopfield contains %RetailerName%
            {

            listOfKeyText := StrSplit(A_loopfield,",")
            ;Msgbox % listOfKeyText[1] "and" listOfKeyText[2]

            return listOfKeyText
            }


    }
}

delimKeyText(getRetailerName,pathDir,delim)
{
    RetailerName := getRetailerName
    
    txt := pathDir "\ListOfKeyText.ahk" ;
    FileRead, Contents, %txt%
    
    Loop, Parse, Contents, `r`n
    {
        if A_loopfield contains %RetailerName%
            {
            listOfKeyText := StrSplit(A_loopfield,delim)

            return listOfKeyText
            }


    }
}

unknownRetailerName(getWebTitle,pathDir) ;Wrap *||* to replace the retailername
{
    WebTitle := getWebTitle
    
    txt1 := pathDir "\ListOfKeyText.ahk" ;[1]Webtitle"*||*" [2]Replace Retailer
    FileRead, Contents, %txt1%
    
    Loop, Parse, Contents, `r`n
    {
        if A_loopfield contains %WebTitle%
            {
            listOfUnknownRetail := StrSplit(A_loopfield,"*||*")
            return listOfUnknownRetail
            }


    }
}


getDescText(pathDir,desctype)

{
    txt := pathDir "\new.txt"
    FileRead, Contents, %txt%

    amtMatches := 0
    
    Loop, Parse, Contents, `r`n
    {
    

        if(A_loopfield != "")
        {
            if (desctype = "Double")
            {
                if (A_loopfield = prevLine) 
                    {
                    if (amtMatches > 0)
                    {
                       descString .= "`n"
                    }
                    ;string := %A_loopfield%
                    descString .= A_loopfield
                    ;Msgbox % descString
                    amtMatches++
                    }
                    
             }
             
             if (desctype = "someDouble")
             {
                if A_loopfield contains %prevLine%
                {
                if (amtMatches > 0)
                    {
                    descString .= "`n"
                    }
                    ;string := %A_loopfield%
                    descString .= prevLine
                    ;Msgbox % descString
                    ;Msgbox % A_loopfield
                    amtMatches++
                    
                    }
             }
    prevLine := A_loopfield
    }


    }
    return descString

}


GetOrderText(pathDir)
{
    
    WinGetPos,,,Xmax,Ymax,A ; get active window size
    Ycenter := Ymax/2

    Send, {ALTDOWN}
    ControlClick, x10 y%Ycenter%, A   ;this is the safest point, I think
    Send, {ALTUP}
    
    send , ^a
    sleep , 125
    send , ^c
    sleep , 125
    FileDelete %pathDir%\new.txt
    sleep , 10
    fileappend , %clipboard%, %pathDir%\new.txt

    WinGetPos,,,Xmax,Ymax,A ; get active window size
    Ycenter := Ymax/2

    Send, {ALTDOWN}
    ControlClick, x10 y%Ycenter%, A   ;this is the safest point, I think
    Send, {ALTUP}
    return
}


