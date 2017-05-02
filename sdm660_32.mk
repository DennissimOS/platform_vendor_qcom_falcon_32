TARGET_USES_AOSP := true
TARGET_USES_QCOM_BSP := false

ifeq ($(TARGET_USES_AOSP),true)
  TARGET_ENABLE_QC_AV_ENHANCEMENTS := false
  TARGET_USES_QTIC := false
else
  DEVICE_PACKAGE_OVERLAYS := device/qcom/sdm660_32/overlay
  TARGET_ENABLE_QC_AV_ENHANCEMENTS := true
  TARGET_USES_QTIC := true
endif

TARGET_KERNEL_VERSION := 4.4
BOARD_FRP_PARTITION_NAME := frp
BOARD_HAVE_QCOM_FM := false
TARGET_USES_NQ_NFC := false

ifeq ($(TARGET_USES_NQ_NFC),true)
# Flag to enable and support NQ3XX chipsets
NQ3XX_PRESENT := true
endif

#QTIC flag
-include $(QCPATH)/common/config/qtic-config.mk

# Video codec configuration files
MEDIA_XML_TARGET := system/vendor/etc
MEDIA_XML_TARGET_VENDOR := vendor/etc
MEDIA_XML_TARGET_SYSTEM := etc
ifeq ($(TARGET_ENABLE_QC_AV_ENHANCEMENTS), true)
PRODUCT_COPY_FILES += device/qcom/sdm660_32/media_profiles.xml:$(MEDIA_XML_TARGET)/media_profiles.xml \
                                          device/qcom/sdm660_32/media_profiles.xml:$(MEDIA_XML_TARGET_VENDOR)/media_profiles.xml \
                                          device/qcom/sdm660_32/media_profiles.xml:$(MEDIA_XML_TARGET_SYSTEM)/media_profiles.xml

PRODUCT_COPY_FILES += device/qcom/sdm660_32/media_codecs.xml:$(MEDIA_XML_TARGET)/media_codecs.xml \
                                          device/qcom/sdm660_32/media_codecs.xml:$(MEDIA_XML_TARGET_VENDOR)/media_codecs.xml \
                                          device/qcom/sdm660_32/media_codecs.xml:$(MEDIA_XML_TARGET_SYSTEM)/media_codecs.xml

PRODUCT_COPY_FILES += device/qcom/sdm660_32/media_codecs_performance.xml:$(MEDIA_XML_TARGET)/media_codecs_performance.xml \
                                          device/qcom/sdm660_32/media_codecs_performance.xml:$(MEDIA_XML_TARGET_VENDOR)/media_codecs_performance.xml \
                                          device/qcom/sdm660_32/media_codecs_performance.xml:$(MEDIA_XML_TARGET_SYSTEM)/media_codecs_performance.xml
endif #TARGET_ENABLE_QC_AV_ENHANCEMENTS

PRODUCT_COPY_FILES += device/qcom/sdm660_32/whitelistedapps.xml:system/vendor/etc/whitelistedapps.xml \
                      device/qcom/sdm660_32/gamedwhitelist.xml:system/vendor/etc/gamedwhitelist.xml \
                      device/qcom/sdm660_32/appboosts.xml:system/vendor/etc/appboosts.xml

$(call inherit-product, device/qcom/common/common.mk)

PRODUCT_NAME := sdm660_32
PRODUCT_DEVICE := sdm660_32
PRODUCT_BRAND := Android
PRODUCT_MODEL := sdm660 for arm64

# default is nosdcard, S/W button enabled in resource
PRODUCT_CHARACTERISTICS := nosdcard

# When can normal compile this module,  need module owner enable below commands
# font rendering engine feature switch
-include $(QCPATH)/common/config/rendering-engine.mk
ifneq (,$(strip $(wildcard $(PRODUCT_RENDERING_ENGINE_REVLIB))))
    MULTI_LANG_ENGINE := REVERIE
#    MULTI_LANG_ZAWGYI := REVERIE
endif

# Enable features in video HAL that can compile only on this platform
TARGET_USES_MEDIA_EXTENSIONS := false

# WLAN chipset
WLAN_CHIPSET := qca_cld3

#Android EGL implementation
PRODUCT_PACKAGES += libGLES_android
#PRODUCT_BOOT_JARS += tcmiface
#PRODUCT_BOOT_JARS += telephony-ext

PRODUCT_PACKAGES += telephony-ext

ifneq ($(strip $(QCPATH)),)
#PRODUCT_BOOT_JARS += WfdCommon
#Android oem shutdown hook
PRODUCT_BOOT_JARS += oem-services
endif

ifeq ($(strip $(BOARD_HAVE_QCOM_FM)),true)
PRODUCT_BOOT_JARS += qcom.fmradio
endif #BOARD_HAVE_QCOM_FM

# add vendor manifest file
PRODUCT_COPY_FILES += \
    device/qcom/sdm660_32/vintf.xml:$(TARGET_COPY_OUT_VENDOR)/manifest.xml

# Audio configuration file
-include $(TOPDIR)hardware/qcom/audio/configs/sdm660/sdm660.mk

# Sensor HAL conf file
PRODUCT_COPY_FILES += \
    device/qcom/sdm660_32/sensors/hals.conf:system/etc/sensors/hals.conf

# WLAN host driver
ifneq ($(WLAN_CHIPSET),)
PRODUCT_PACKAGES += $(WLAN_CHIPSET)_wlan.ko
endif

# WLAN driver configuration file
PRODUCT_COPY_FILES += \
    device/qcom/sdm660_32/WCNSS_qcom_cfg.ini:system/etc/wifi/WCNSS_qcom_cfg.ini \
    device/qcom/sdm660_32/wifi_concurrency_cfg.txt:system/etc/wifi/wifi_concurrency_cfg.txt

PRODUCT_PACKAGES += \
    wpa_supplicant_overlay.conf \
    p2p_supplicant_overlay.conf

#ANT+ stack
PRODUCT_PACKAGES += \
    AntHalService \
    libantradio \
    antradio_app \
    libvolumelistener

# Gralloc
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.mapper@2.0-impl

# HW Composer
PRODUCT_PACKAGES += \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.composer@2.1-service

# Sensor features
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:system/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:system/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:system/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.sensor.ambient_temperature.xml:system/etc/permissions/android.hardware.sensor.ambient_temperature.xml \
    frameworks/native/data/etc/android.hardware.sensor.relative_humidity.xml:system/etc/permissions/android.hardware.sensor.relative_humidity.xml \
    frameworks/native/data/etc/android.hardware.sensor.hifi_sensors.xml:system/etc/permissions/android.hardware.sensor.hifi_sensors.xml

# FBE support
PRODUCT_COPY_FILES += \
    device/qcom/sdm660_32/init.qti.qseecomd.sh:system/bin/init.qti.qseecomd.sh

# MSM IRQ Balancer configuration file
PRODUCT_COPY_FILES += device/qcom/sdm660_32/msm_irqbalance.conf:system/vendor/etc/msm_irqbalance.conf

# dm-verity configuration
PRODUCT_SUPPORTS_VERITY := true
PRODUCT_SYSTEM_VERITY_PARTITION := /dev/block/bootdevice/by-name/system

#for android_filesystem_config.h
PRODUCT_PACKAGES += \
    fs_config_files

# Add the overlay path
#PRODUCT_PACKAGE_OVERLAYS := $(QCPATH)/qrdplus/Extension/res \
#       $(QCPATH)/qrdplus/globalization/multi-language/res-overlay \
#      $(PRODUCT_PACKAGE_OVERLAYS)

# Enable logdumpd service only for non-perf bootimage
ifeq ($(findstring perf,$(KERNEL_DEFCONFIG)),)
    ifeq ($(TARGET_BUILD_VARIANT),user)
        PRODUCT_DEFAULT_PROPERTY_OVERRIDES+= \
            ro.logdumpd.enabled=0
    else
        PRODUCT_DEFAULT_PROPERTY_OVERRIDES+= \
            ro.logdumpd.enabled=1
    endif
else
    PRODUCT_DEFAULT_PROPERTY_OVERRIDES+= \
        ro.logdumpd.enabled=0
endif

#A/B related packages
PRODUCT_PACKAGES += update_engine \
                    update_engine_client \
                    update_verifier \
                    bootctrl.sdm660 \
                    brillo_update_payload
#Boot control HAL test app
PRODUCT_PACKAGES_DEBUG += bootctl

#FEATURE_OPENGLES_EXTENSION_PACK support string config file
PRODUCT_COPY_FILES += \
        frameworks/native/data/etc/android.hardware.opengles.aep.xml:system/etc/permissions/android.hardware.opengles.aep.xml
