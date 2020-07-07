UninstallSearch(RegSearchTarget)
{
    SetBatchLines -1  ; Makes searching occur at maximum speed.
    Gosub, RegSearch
    If !InStr(RegValue, RegSearchTarget)
        RegValue := ""
    return RegValue

    RegSearch:
    ContinueRegSearch := True
    Loop, Reg, HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall, KVR
    {
        Gosub, CheckThisRegItem
        if (ContinueRegSearch = false) ; It told us to stop.
            return
    }
    Loop, Reg, HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall, KVR
    {
        Gosub, CheckThisRegItem
        if (ContinueRegSearch = false) ; It told us to stop.
            return
    }
    Loop, Reg, HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall, KVR
    {
        Gosub, CheckThisRegItem
        if (ContinueRegSearch = false) ; It told us to stop.
            return
    }
    return

    CheckThisRegItem:
    if (A_LoopRegType = "KEY")  ; Remove these two lines if you want to check key names too.
        return
    RegRead, RegValue
    if ErrorLevel
        return
    IfInString, RegValue, %RegSearchTarget%
    {
        ContinueRegSearch := false
        ;MsgBox, 4, , The following match was found:`n%A_LoopRegKey%\%A_LoopRegSubKey%\%A_LoopRegName%`nValue = %RegValue%`n`nContinue?
        ;IfMsgBox, No
        ;    ContinueRegSearch := false  ; Tell our caller to stop searching.
        return
    }
    return
}
