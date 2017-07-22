#
# Copyright (C) 2007-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=mt7601uap
PKG_VERSION:=0.2.2
PKG_RELEASE:=1
PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/tanaka1892/mt7601u-ap.git
PKG_SOURCE_VERSION:=ff9dda5fc276dd3f8f040c8c1d7b876551a7e9b5
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz
PKG_BUILD_PARALLEL:=1
PKG_MAINTAINER:=lioliy <lioliy@my.com>
PKG_LICENSE:=GPLv2

include $(INCLUDE_DIR)/package.mk

MAKE_OPTS:= \
	ARCH="$(LINUX_KARCH)" \
	CROSS_COMPILE="$(KERNEL_CROSS)" \
	KSRC="$(LINUX_DIR)" \
	KVER="$(LINUX_VERSION)" \
	M="$(PKG_BUILD_DIR)" \

define KernelPackage/$(PKG_NAME)
	SUBMENU:=Wireless Drivers
	TITLE:=Driver for mt7601uap wireless adapters
	FILES:=$(PKG_BUILD_DIR)/mt7601uap.$(LINUX_KMOD_SUFFIX)
	DEPENDS:=+wireless-tools +kmod-mac80211 @USB_SUPPORT
	AUTOLOAD:=$(call AutoProbe,mt7601uap)
endef

define KernelPackage/$(PKG_NAME)/description
  This package contains a rewritten driver for usb wireless adapters based on the mediatek mt7601uap chip by ulli-kroll
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) $(MAKE_OPTS)
endef

define KernelPackage/mt7601uap/install
	$(INSTALL_DIR) $(1)/lib/modules/$(LINUX_VERSION)
endef

$(eval $(call KernelPackage,$(PKG_NAME)))
