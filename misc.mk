check_defined = \
	$(strip $(foreach 1,$1, \
		$(call __check_defined,$1,$(strip $(value 2)),$(3))))
__check_defined = \
	$(if $(value $1),, \
	  $(error $(3) $1$(if $2, ($2))))

define dump
$(eval CONTENT_TO_DUMP := $(1)) \
"$(MAKE)" -s -f "$(PROJ_DIR)/templates/dump.mk" VARIABLE=CONTENT_TO_DUMP
endef
export CONTENT_TO_DUMP