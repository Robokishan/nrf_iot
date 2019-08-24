$(eval uniq_objs :=)
$(foreach _,$(ALLOBJS),$(if $(filter $_,${uniq_objs}),,$(eval uniq_objs += $_)))
FILE_COUNTER = 1
ifndef ECHO
T := $(shell $(MAKE) $(MAKECMDGOALS) --no-print-directory \
      -nrRf $(firstword $(MAKEFILE_LIST)) \
      ECHO="COUNTTHIS" | grep -c "COUNTTHIS")
N := x
C = $(words $(uniq_objs))$(eval N := x $(N))
ECHO = python2 echo_process.py --stepno=$(FILE_COUNTER) --nsteps=$(C) \
	   $(eval FILE_COUNTER=$(shell echo $$(($(FILE_COUNTER)+1))))
endif