# parameters:
#   $(1): lowercase package name
#   $(2): uppercase package name
#   $(3): build target arch
#   $(4): build target os
#
define create-rules-make-pwasio
$(call create-rules-common,$(1),$(2),$(3),$(4))
ifneq ($(findstring $(3)-$(4),$(ARCHS)),)

$$(OBJ)/.$(1)-$(3)-configure:
	@echo ":: configuring $(1)-$(3)..." >&2

	cd "$$($(2)_$(3)_OBJ)" && env $$($(2)_$(3)_ENV) \
	rsync --filter=:C --exclude '*~' --exclude .git --info=name -Oarx --delete "$$($(2)_SRC)/" "$$($(2)_$(3)_OBJ)" $(--quiet?)

	touch $$@

$$(OBJ)/.$(1)-i386-build:
	@echo ":: building $(1)-$(3)..." >&2
	+cd "$$($(2)_$(3)_OBJ)" && env $$($(2)_$(3)_ENV) \
	PREFIX="$$($(2)_$(3)_OBJ)" \
	WINEBUILD=$$(WINE_$$(HOST_ARCH)_OBJ)/tools/winebuild/winebuild \
	WINEBUILD_EXTRA_INCLUDEDIR="-I$$(WINE_SRC)/include \
		-I$$(WINE_SRC)/include/wine \
		-I$$(WINE_$(3)_DST)/include/wine \
		-I$$(WINE_$(3)_DST)/include/wine/windows" \
	WINEBUILD_EXTRA_LIBDIR="-L$$(DST_LIBDIR$(3))/$$(WINE_$(3)_LIBDIR)" \
	WINECC=$$(WINE_$$(HOST_ARCH)_OBJ)/tools/winegcc/winegcc \
	$$(MAKE) 32
	$(call install-strip,$$($(2)_$(3)_OBJ)/build32/$(1).dll,$$(DST_DIR)/lib/wine/$(3)-windows)
	$(call install-strip,$$($(2)_$(3)_OBJ)/build32/$(1).so,$$(DST_DIR)/lib/wine/$(3)-unix)

	touch $$@

$$(OBJ)/.$(1)-x86_64-build:
	@echo ":: building $(1)-$(3)..." >&2
	+cd "$$($(2)_$(3)_OBJ)" && env $$($(2)_$(3)_ENV) \
	PREFIX="$$($(2)_$(3)_OBJ)" \
	WINEBUILD=$$(WINE_$$(HOST_ARCH)_OBJ)/tools/winebuild/winebuild \
	WINEBUILD_EXTRA_INCLUDEDIR="-I$$(WINE_SRC)/include \
		-I$$(WINE_SRC)/include/wine \
		-I$$(WINE_$(3)_DST)/include/wine \
		-I$$(WINE_$(3)_DST)/include/wine/windows" \
	WINEBUILD_EXTRA_LIBDIR="-L$$(DST_LIBDIR$(3))/$$(WINE_$(3)_LIBDIR)" \
	WINECC=$$(WINE_$$(HOST_ARCH)_OBJ)/tools/winegcc/winegcc \
	$$(MAKE) 64
	$(call install-strip,$$($(2)_$(3)_OBJ)/build64/$(1).dll,$$(DST_DIR)/lib/wine/$(3)-windows)
	$(call install-strip,$$($(2)_$(3)_OBJ)/build64/$(1).so,$$(DST_DIR)/lib/wine/$(3)-unix)

	touch $$@



endif
endef

rules-make-pwasio = $(call create-rules-make-pwasio,$(1),$(call toupper,$(1)),$(2),$(3))
