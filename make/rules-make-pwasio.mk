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
	@echo ":: building $(1)-i386..." >&2
	+cd "$$($(2)_i386_OBJ)" && env $$($(2)_i386_ENV) \
	PREFIX="$$($(2)_i386_OBJ)" \
	WINEBUILD=$$(WINE_$$(HOST_ARCH)_OBJ)/tools/winebuild/winebuild \
	WINEBUILD_EXTRA_INCLUDEDIR="-I$$(WINE_SRC)/include \
		-I$$(WINE_SRC)/include/wine \
		-I$$(WINE_i386_DST)/include/wine \
		-I$$(WINE_i386_DST)/include/wine/windows" \
	WINEBUILD_EXTRA_LIBDIR="-L$$(WINE_i386_LIBDIR)" \
	WINECC=$$(WINE_$$(HOST_ARCH)_OBJ)/tools/winegcc/winegcc \
	$$(MAKE) 32
	$(call install-strip,$$($(2)_i386_OBJ)/build32/$(1).dll,$$(DST_DIR)/lib/wine/i386-windows)
	$(call install-strip,$$($(2)_i386_OBJ)/build32/$(1).so,$$(DST_DIR)/lib/wine/i386-unix)

	touch $$@

$$(OBJ)/.$(1)-x86_64-build:
	@echo ":: building $(1)-x86_64..." >&2
	+cd "$$($(2)_x86_64_OBJ)" && env $$($(2)_x86_64_ENV) \
	PREFIX="$$($(2)_x86_64_OBJ)" \
	WINEBUILD=$$(WINE_$$(HOST_ARCH)_OBJ)/tools/winebuild/winebuild \
	WINEBUILD_EXTRA_INCLUDEDIR="-I$$(WINE_SRC)/include \
		-I$$(WINE_SRC)/include/wine \
		-I$$(WINE_x86_64_DST)/include/wine \
		-I$$(WINE_x86_64_DST)/include/wine/windows" \
	WINEBUILD_EXTRA_LIBDIR="-L$$(WINE_x84_64_LIBDIR)" \
	WINECC=$$(WINE_$$(HOST_ARCH)_OBJ)/tools/winegcc/winegcc \
	$$(MAKE) 64
	$(call install-strip,$$($(2)_x86_64_OBJ)/build64/$(1).dll,$$(DST_DIR)/lib/wine/x86_64-windows)
	$(call install-strip,$$($(2)_x86_64_OBJ)/build64/$(1).so,$$(DST_DIR)/lib/wine/x86_64-unix)

	touch $$@



endif
endef

rules-make-pwasio = $(call create-rules-make-pwasio,$(1),$(call toupper,$(1)),$(2),$(3))
