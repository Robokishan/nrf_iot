define get_object_file_name
$(OUTPUT_DIRECTORY)/$(strip $(1))/$(notdir $(2:%.c=%.o))
endef

# $1 target name
# $2 include paths container file
# $3 list of source files
define get_object_files
$(call ensure_exists_each,source file, $(3)) \
$(foreach src_file, $(3), \
  $(eval obj_file := $(call get_object_file_name, $(1), $(src_file))) \
  $(eval DEPENDENCIES += $(obj_file:.o=.d)) \
  $(call bind_obj_with_src, $(obj_file), $(src_file), $(2), $(1)) \
  $(obj_file))

endef