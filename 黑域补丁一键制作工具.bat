@echo off
TITLE ���򲹶�һ���������� by iceWindr
color 3f
set batDir=%~dp0
set adb="%batDir%\adb\adb.exe"
set work="%batDir%\work"
if exist %work% ( 
rd /s/q %work%
)
md "%batDir%\work"
echo.
ECHO. =====================================================================
echo.
echo  �㼴��ʹ�ú��򲹶�һ����������
echo.
echo  ��ϵ���ߣ��ᰲ����http://www.coolapk.com/��@iceWindr
echo.
echo  Ϊ�����������·����Ŀ¼�����������ļ��ո�����������޸�
echo.
echo  ȷ�����������ȷ��װpython������3.5.x�汾����jdk1.8�������������...
echo.
ECHO. =====================================================================
pause >nul
CLS
echo.
ECHO  ================== ��ѡ�� ==================
echo.
echo  1. ��odex�Ż��汾��services.jarӦ����1M����
echo.
echo  2. odex�Ż��汾��Ŀǰ��֧��64λϵͳ��
echo.
ECHO  ============================================
set "select="
echo.
set /p select=��ѡ��:
echo.
CLS
if /i '%select%'=='1' goto deodex
if /i '%select%'=='2' goto odex

:deodex
ECHO. ===============================================================
echo.
echo  �뽫�ֻ���USB���Դ򿪲����ӵ���
echo.
echo  ��������USB����Ȩ�ޣ��������ֻ��˵���ʾ����Ȩ�������������...
echo.
ECHO. ===============================================================
pause >nul
CLS
ECHO. =============================================================
echo.
echo  �Ƿ񿴼�����������ʾ��
echo.
echo.
echo       List of devices attached
echo       * daemon not running. starting it now on port 5037 *
echo       * daemon started successfully *
echo       d6fb078b        device
echo.
echo.
echo  �������������ʾ��˵���ֻ�����������������밴���������...
echo.
echo  ������رմ˴��ڣ���������Ƿ���ȷ��װ���ֻ��Ƿ���ȷ����
echo.
ECHO. =============================================================
echo.
%adb% devices
pause >nul
CLS
echo.
echo  ������ȡsystem/framework/services.jar��PC...
echo.
%adb% pull /system/framework/services.jar "%batDir%\work"
echo.
echo  ���ڽ� apk ת�� smali
echo.
java -Xms1g -jar baksmali-2.2b4.jar d %batDir%\Brevent.apk -o %work%\apk
echo  ���ڽ� services ת�� smali
echo.
java -Xms1g -jar baksmali-2.2b4.jar d %work%\services.jar -o %work%\services
echo  ���ڴ򲹶�
echo.
python patch.py -a %work%\apk -s %work%\services
echo.
echo  ���������������� services
echo.
java -Xms1g -jar smali-2.2b4.jar a -o classes.dex %work%\services
jar -cvf services.jar classes.dex
md "%work%\new"
move services.jar %work%\new
del classes.dex
CLS
echo.
ECHO. ======================================================
echo.
echo  �����ɹ������ɵ�services.jar��\work\new\services.jar
echo.
echo  �Ƿ��������뵽�ֻ������������ʼ����
echo.
echo  �ò�����ROOTȨ�ޣ���ϵͳδROOT���ֶ��رմ˴��ڣ�
echo.
ECHO. ======================================================
pause >nul
CLS
echo.
echo  ���ڵ���services.jar���ֻ�...
echo.
echo  ��ǰ����������ROOTȨ�ޣ������ֻ�����Ȩ
echo.
%adb% push "%work%\new\services.jar" /sdcard/services.jar
%adb% shell su -c "mount -o rw,remount /system"
%adb% shell su -c "cp -rf /sdcard/services.jar /system/framework/services.jar"
%adb% shell rm /system/framework/oat/arm64/services.odex
echo.
goto Done

:odex
ECHO. ===============================================================
echo.
echo  �뽫�ֻ���USB���Դ򿪲����ӵ���
echo.
echo  ��������USB����Ȩ�ޣ��������ֻ��˵���ʾ����Ȩ�������������...
echo.
ECHO. ===============================================================
pause >nul
CLS
ECHO. =============================================================
echo.
echo  �Ƿ񿴼�����������ʾ��
echo.
echo.
echo       List of devices attached
echo       * daemon not running. starting it now on port 5037 *
echo       * daemon started successfully *
echo       d6fb078b        device
echo.
echo.
echo  �������������ʾ��˵���ֻ�����������������밴���������...
echo.
echo  ������رմ˴��ڣ���������Ƿ���ȷ��װ���ֻ��Ƿ���ȷ����
echo.
ECHO. =============================================================
echo.
%adb% devices
pause >nul
CLS
echo.
echo  ������ȡsystem/framework��PC...
echo.
%adb% pull /system/framework "%batDir%\work"
echo.
ECHO  ========== ��ѡ�����Android�汾 ==========
echo.
echo  1. Android 5.0 - Android 5.1
echo.
echo  2. Android 6.0 - Android 7.1
echo.
ECHO  ===========================================
set "select="
echo.
set /p select=��ѡ��:
echo.
CLS
if /i '%select%'=='1' goto L
if /i '%select%'=='2' goto N

:L
java -Xms1g -jar oat2dex.jar boot %work%\framework\arm64\boot.oat
java -Xms1g -jar oat2dex.jar %work%\framework\arm64\services.odex %work%\framework\arm64\dex
java -Xms1g -jar baksmali-2.2b4.jar d %work%\framework\arm64\services.dex -o %work%\services
CLS
echo.
echo  ���ڽ� apk ת�� smali
echo.
java -Xms1g -jar baksmali-2.2b4.jar d %batDir%\Brevent.apk -o %work%\apk
echo.
echo  ���ڴ򲹶�
echo.
python patch.py -a %work%\apk -s %work%\services
echo.
echo  ���������������� services
echo.
java -Xms1g -jar smali-2.2b4.jar a -o classes.dex %work%\services
jar -cvf services.jar classes.dex
md "%work%\new"
move services.jar %work%\new
del classes.dex
echo.
ECHO. ======================================================
echo.
echo  �����ɹ������ɵ�services.jar��\work\new\services.jar
echo.
echo  �Ƿ��������뵽�ֻ������������ʼ����
echo.
echo  �ò�����ROOTȨ�ޣ���ϵͳδROOT���ֶ��رմ˴��ڣ�
echo.
ECHO. ======================================================
pause >nul
CLS
echo.
echo  ���ڵ���services.jar���ֻ�...
echo.
echo  ��ǰ����������ROOTȨ�ޣ������ֻ�����Ȩ
echo.
%adb% push "%work%\new\services.jar" /sdcard/services.jar
%adb% shell su -c "mount -o rw,remount /system"
%adb% shell su -c "cp -rf /sdcard/services.jar /system/framework/services.jar"
echo.
goto Done

:N
java -Xms1g -jar baksmali-2.2b4.jar x -d %work%\framework\arm64 %work%\framework\oat\arm64\services.odex -o %work%\services
CLS
echo.
echo  ���ڽ� apk ת�� smali
echo.
java -Xms1g -jar baksmali-2.2b4.jar d %batDir%\Brevent.apk -o %work%\apk
echo.
echo  ���ڴ򲹶�
echo.
python patch.py -a %work%\apk -s %work%\services
echo.
echo  ���������������� services
echo.
java -Xms1g -jar smali-2.2b4.jar a -o classes.dex %work%\services
jar -cvf services.jar classes.dex
md "%work%\new"
move services.jar %work%\new
del classes.dex
echo.
ECHO. ======================================================
echo.
echo  �����ɹ������ɵ�services.jar��\work\new\services.jar
echo.
echo  �Ƿ��������뵽�ֻ������������ʼ����
echo.
echo  �ò�����ROOTȨ�ޣ���ϵͳδROOT���ֶ��رմ˴��ڣ�
echo.
ECHO. ======================================================
pause >nul
CLS
echo.
echo  ���ڵ���services.jar���ֻ�...
echo.
echo  ��ǰ����������ROOTȨ�ޣ������ֻ�����Ȩ
echo.
%adb% push "%work%\new\services.jar" /sdcard/services.jar
%adb% shell su -c "mount -o rw,remount /system"
%adb% shell su -c "cp -rf /sdcard/services.jar /system/framework/services.jar"
%adb% shell rm /system/framework/oat/arm64/services.odex
echo.
goto Done

:Done
echo.
ECHO. ======================================================
echo.
echo  ����ɹ����Ƿ�������װ����APP��
echo.
echo  ���������ʼ��װ���������ֶ��رմ˴���
echo.
ECHO. ======================================================
pause >nul
CLS
echo.
echo  ���ڰ�װ����APP...
echo.
%adb% install %batDir%/Brevent.apk
echo.
ECHO. ======================================================
echo.
echo  ��װ�ɹ������ֶ������ֻ�ʹ������Ч
echo.
echo  ��������رմ˴���
echo.
ECHO. ======================================================
pause >nul