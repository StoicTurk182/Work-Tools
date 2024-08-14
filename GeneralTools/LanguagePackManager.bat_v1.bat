@echo off
setlocal

:: Function to check if the script is running with elevated privileges
:CheckAdmin
    openfiles >nul 2>&1
    if '%errorlevel%' == '0' goto Admin
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -ArgumentList '%*' -Verb RunAs"
    exit /b

:Admin
    echo Running with administrative privileges...
    goto Main

:Main
    cls
    echo *** Language Pack Manager ***
    echo 1. Install/Uninstall English
    echo 2. Install/Uninstall French
    echo 3. Install/Uninstall German
    echo 4. Install/Uninstall Spanish
    echo 5. Install/Uninstall Italian
    echo 6. Install/Uninstall Portuguese (Brazil)
    echo 7. Install/Uninstall Russian
    echo 8. Install/Uninstall Arabic
    echo 9. Install/Uninstall Hindi
    echo 10. Install/Uninstall Chinese (Simplified)
    echo 11. Install/Uninstall Korean
    echo 12. Install/Uninstall Japanese
    echo 13. Install/Uninstall Chinese (Traditional)
    echo 14. Exit
    echo.
    set /p choice=Choose an option:

    if '%choice%'=='1' goto HandleEnglish
    if '%choice%'=='2' goto HandleFrench
    if '%choice%'=='3' goto HandleGerman
    if '%choice%'=='4' goto HandleSpanish
    if '%choice%'=='5' goto HandleItalian
    if '%choice%'=='6' goto HandlePortuguese
    if '%choice%'=='7' goto HandleRussian
    if '%choice%'=='8' goto HandleArabic
    if '%choice%'=='9' goto HandleHindi
    if '%choice%'=='10' goto HandleChineseSimplified
    if '%choice%'=='11' goto HandleKorean
    if '%choice%'=='12' goto HandleJapanese
    if '%choice%'=='13' goto HandleChineseTraditional
    if '%choice%'=='14' exit /b

:HandleLanguage
    echo Choose action:
    echo 1. Install
    echo 2. Uninstall
    echo 3. Back to main menu
    echo.
    set /p action=Choose an action:

    if '%action%'=='1' goto Install
    if '%action%'=='2' goto Uninstall
    if '%action%'=='3' goto Main

:Install
    dism /Online /Add-Capability /CapabilityName:Language.Basic~~~%langCode%~0.0.1.0
    dism /Online /Add-Capability /CapabilityName:Language.Fonts.%fontsCode%~~~%langCode%~0.0.1.0
    dism /Online /Add-Capability /CapabilityName:Language.Handwriting~~~%langCode%~0.0.1.0
    dism /Online /Add-Capability /CapabilityName:Language.OCR~~~%langCode%~0.0.1.0
    dism /Online /Add-Capability /CapabilityName:Language.Speech~~~%langCode%~0.0.1.0
    dism /Online /Add-Capability /CapabilityName:Language.TextToSpeech~~~%langCode%~0.0.1.0
    echo Installation complete.
    pause
    goto Main

:Uninstall
    dism /Online /Remove-Capability /CapabilityName:Language.Basic~~~%langCode%~0.0.1.0
    dism /Online /Remove-Capability /CapabilityName:Language.Fonts.%fontsCode%~~~%langCode%~0.0.1.0
    dism /Online /Remove-Capability /CapabilityName:Language.Handwriting~~~%langCode%~0.0.1.0
    dism /Online /Remove-Capability /CapabilityName:Language.OCR~~~%langCode%~0.0.1.0
    dism /Online /Remove-Capability /CapabilityName:Language.Speech~~~%langCode%~0.0.1.0
    dism /Online /Remove-Capability /CapabilityName:Language.TextToSpeech~~~%langCode%~0.0.1.0
    echo Uninstallation complete.
    pause
    goto Main

:HandleEnglish
    set langCode=en-US
    set fontsCode=Engl
    goto HandleLanguage

:HandleFrench
    set langCode=fr-FR
    set fontsCode=Frnc
    goto HandleLanguage

:HandleGerman
    set langCode=de-DE
    set fontsCode=Germ
    goto HandleLanguage

:HandleSpanish
    set langCode=es-ES
    set fontsCode=Span
    goto HandleLanguage

:HandleItalian
    set langCode=it-IT
    set fontsCode=Ital
    goto HandleLanguage

:HandlePortuguese
    set langCode=pt-BR
    set fontsCode=Port
    goto HandleLanguage

:HandleRussian
    set langCode=ru-RU
    set fontsCode=Russ
    goto HandleLanguage

:HandleArabic
    set langCode=ar-SA
    set fontsCode=Aran
    goto HandleLanguage

:HandleHindi
    set langCode=hi-IN
    set fontsCode=Hind
    goto HandleLanguage

:HandleChineseSimplified
    set langCode=zh-CN
    set fontsCode=Chin
	
	
    goto HandleLanguage

:HandleKorean
    set langCode=ko-KR
    set fontsCode=Kore
    goto HandleLanguage

:HandleJapanese
    set langCode=ja-JP
    set fontsCode=Japa
    goto HandleLanguage

:HandleChineseTraditional
    set langCode=zh-TW
    set fontsCode=Chin
    goto HandleLanguage
