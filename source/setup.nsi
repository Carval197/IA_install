/*
1. 语言
2. 大文件
3. PRODUCT_NAME
4. PRODUCT_VERSION
5. 是否压缩
*/

; 该脚本使用 HM VNISEdit 脚本编辑器向导产生

; 安装程序初始定义常量
!define PRODUCT_NAME "Controller Application"
!define EXE_NAME "IA"
#!define PRODUCT_VERSION "1.24"
!define PRODUCT_VERSION "2.13"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\${PRODUCT_NAME}.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

;是否压缩
SetCompress force
;压缩格式
SetCompressor zlib
;显示安装细节
ShowInstDetails hide
;显示卸载细节
ShowUnInstDetails hide

; ------ MUI 现代界面定义 (1.67 版本以上兼容) ------
!include "MUI.nsh"

; MUI 预定义常量
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall.ico"

; 语言选择窗口常量设置
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"

; 欢迎页面
!insertmacro MUI_PAGE_WELCOME
; 安装目录选择页面
!insertmacro MUI_PAGE_DIRECTORY
; 安装过程页面
!insertmacro MUI_PAGE_INSTFILES
;安装后运行界面
;!define MUI_FINISHPAGE_RUN "$INSTDIR\${PRODUCT_NAME}.exe"
; 安装完成页面
!insertmacro MUI_PAGE_FINISH
; 卸载欢迎页面
!insertmacro MUI_UNPAGE_WELCOME
; 安装卸载过程页面
!insertmacro MUI_UNPAGE_INSTFILES
; 卸载完成页面
!insertmacro MUI_UNPAGE_FINISH

; 安装界面包含的语言设置
!insertmacro MUI_LANGUAGE "English"
;!insertmacro MUI_LANGUAGE "SimpChinese"

; 安装预释放文件
!insertmacro MUI_RESERVEFILE_LANGDLL
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI 现代界面定义结束 ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "Setup.exe"
InstallDir "$PROGRAMFILES\${PRODUCT_NAME}"
InstallDirRegKey HKLM "${PRODUCT_UNINST_KEY}" "UninstallString"


Section "MainSection" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite try
  File /r "..\files\*.*"  ;文件
SectionEnd

;创建快捷方式
Section -AdditionalIcons
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\${EXE_NAME}.exe"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\${EXE_NAME}.exe"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\${EXE_NAME}.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\${EXE_NAME}.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
SectionEnd

#-- 根据 NSIS 脚本编辑规则，所有 Function 区段必须放置在 Section 区段之后编写，以避免安装程序出现未可预知的问题。--#
;!include "x64.nsh"
;Function Is64
;${If} ${RunningX64}
;    MessageBox MB_OK "running on x64"
;${Else}
;    MessageBox MB_OK "running on x86"
;${EndIf}
;FunctionEnd

;!include "WinVer.nsh"
;Function WinVer
;	${If} ${AtLeastWin10}
;    MessageBox MB_OK "Least Win10"
;	${Endif}

;	${If} ${IsWin10}
;	  MessageBox MB_OK "Is Win10"
;	${Endif}

;	${If} ${AtLeastWinVista}
;	  MessageBox MB_OK "Least Vista"
;	${EndIf}

;	${If} ${IsWin2000}
;	${OrIf} ${IsWinXP}
;	  MessageBox MB_OK "Is 2000 or XP！"
;	${EndIf}

;	${If} ${AtMostWinXP}
;	  MessageBox MB_OK "Most XP"
;	${EndIf}
;FunctionEnd

!include "x64.nsh"
!include "WinVer.nsh"
Function InstallDriver
;  ${If} ${RunningX64}
;	    StrCpy $R0 "x64"
;	${Else}
;	    StrCpy $R0 "x86"
;	${EndIf}

;	${If} ${IsWin7}
;    StrCpy $R1 "W7"
;	${ElseIf} ${IsWin8}
;	  StrCpy $R1 "W8"
;	${Else}
;	  StrCpy $R1 "Other"
;	${EndIf}

;	${If} $R1 != "Other"
;	  StrCpy $R2 "$INSTDIR\Driver\$R1_$R0.exe"
;  	ExecWait "$R2"
;	${EndIf}

  StrCpy $R2 "$INSTDIR\Driver\NIVISA1700runtime.exe"
	ExecWait "$R2"
FunctionEnd

Function .onInit
  !insertmacro MUI_LANGDLL_DISPLAY
;  Call Is64
;  Call WinVer
;  Call InstallDriver
FunctionEnd

!include "x64.nsh"
!include "WinVer.nsh"

Function .onInstSuccess
	ExecWait "$INSTDIR\Microsoft\vc_redist.x86.exe /passive"
  Call InstallDriver
FunctionEnd

/******************************
 *  以下是安装程序的卸载部分  *
 ******************************/
;删除文件和快捷方式
Section Uninstall
	RMDir /r "$INSTDIR"
	
  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
	RMDir /r "$SMPROGRAMS\${PRODUCT_NAME}"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd

#-- 根据 NSIS 脚本编辑规则，所有 Function 区段必须放置在 Section 区段之后编写，以避免安装程序出现未可预知的问题。--#
/*
Function un.onInit
!insertmacro MUI_UNGETLANGUAGE
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "您确实要完全移除 $(^Name) ，及其所有的组件？" IDYES +2
  Abort
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) 已成功地从您的计算机移除。"
FunctionEnd
*/

