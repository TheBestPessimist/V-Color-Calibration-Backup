; The purpose of this autohotkey script is to lock the V whenever the user closes the "lid" (keyboard in this case)
; This implies that in "Power Options -> Chose what closing the lid does" is selected "Do nothing";
;
;
;
;
;
; ======================================================================================
; change "TBP-V" to whatever you get from running "hostname" in cmd, but keep the quotes
;
global hostname := "TBP-V"




;
;
;
;
; DO NOT CHANGE ANYTHING ELSE!!!!!!!!!
;
;
;
;
global GUID_LIDSWITCH_STATE_CHANGE := "ba3e0f4d-b817-4094-a2d1-d56379e6a0f3"
global newGUID:=""

; convert string to windows GUID then register for Power Notification Changes
if (A_ComputerName = hostname) {
    varSetCapacity(newGUID,16,0)
    dllCall("Rpcrt4\UuidFromString","Str",GUID_LIDSWITCH_STATE_CHANGE,"UInt",&newGUID)
    rhandle:=dllCall("RegisterPowerSettingNotification","UInt",a_scriptHwnd,"Str",strGet(&newGUID),"Int",0)
    onMessage(0x218,"WM_POWERBROADCAST")
}

WM_POWERBROADCAST(wparam, lparam)
{
  if (wparam = 0x8013) ;PBT_POWERSETTINGCHANGE
  {
    new_state := Numget(lparam+20, 0, "uchar")
    ;new_state = 0 = closed
    ;new_state = 1 = opened
    if(new_state = 0) {
        DllCall("LockWorkStation")
    }
  }
  return 1
}
