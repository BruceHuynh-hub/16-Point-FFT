export DESIGN_NAME = FFT
export PLATFORM    = sky130hd

#export VERILOG_INCLUDE_DIRS = /OpenROAD-flow-scripts/flow/mydesign/FFT/Design/rtl

export VERILOG_FILES = /OpenROAD-flow-scripts/flow/mydesign/FFT/Design/butterfly/butterfly.v  \
	/OpenROAD-flow-scripts/flow/mydesign/FFT/Design/butterfly/twiddle.v  \
	/OpenROAD-flow-scripts/flow/mydesign/FFT/Design/butterfly/FFT.v  \
	/OpenROAD-flow-scripts/flow/mydesign/FFT/Design/butterfly/signed_multiplier.v \


#	/OpenROAD-flow-scripts/flow/mydesign/FFT/Design/software/mmreg/mmreg.v \
	/OpenROAD-flow-scripts/flow/mydesign/FFT/Design/software/mmreg/toplevel.v\


export SDC_FILE      = /OpenROAD-flow-scripts/flow/mydesign/FFT/Design/config/constraint.sdc

# These values must be multiples of placement site
export DIE_AREA    =  0    0  1100  1100
export CORE_AREA   =  10  10  1100  1100
