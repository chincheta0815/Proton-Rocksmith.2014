# parameters:
#   $(1): lowercase package name
#   $(2): uppercase package name
#   $(3): 32/64 build type
#   $(4): CROSS/<empty>, cross compile
#
define create-rules-make-pwasio
$(call create-rules-common,$(1),$(2),$(3),$(4))

$$(OBJ)/.$(1)-configure$(3):
	@echo ":: configuring $(3)bit $(1)..." >&2
	cd "$$($(3)_OBJ$(3))" && env $$($(2)_ENV$(3)) \
	rsync --filter=:C --exclude '*~' --exclude .git --info=name -Oarx --delete "$$($(2)_SRC)/" "$$($(2)_OBJ$(3))" $(--quiet?)

	touch $$@

$$(OBJ)/.$(1)-build$(3):
	@echo ":: building $(3)bit $(1)..." >&2
	+cd "$$($(2)_OBJ$(3))" && env $$($(2)_ENV$(3)) \
	PREFIX="$$($(2)_OBJ$(3))" \
	WINEBUILD_EXTRA_INCLUDEDIR="-I$$(WINE_SRC)/include \
		-I$$(WINE_SRC)/include/wine \
		-I$$(WINE_DST$(3))/include/wine \
		-I$$(WINE_DST$(3))/include/wine/windows \
		$$($(2)_EXTRA_INCFLAGS$(3))" \
	WINEBUILD_EXTRA_LIBDIR="-L$$(WINE_LIBDIR$(3)) \
		$$($(2)_EXTRA_LIBDIR$(3))" \
	$$(MAKE) $(3)
	$(call install-strip,$$($(2)_OBJ$(3))/build-$(3)/$(1).dll,$$(DST_DIR)/lib$(subst 32,,$(3))/wine/$(if $(subst 64,,$(3)),i386,x86_64)-windows)
	$(call install-strip,$$($(2)_OBJ$(3))/build-$(3)/$(1).so,$$(DST_DIR)/lib$(subst 32,,$(3))/wine/$(if $(subst 64,,$(3)),i386,x86_64)-unix)

	touch $$@

endef

rules-make-pwasio = $(call create-rules-make-pwasio,$(1),$(call toupper,$(1)),$(2),$(3))
