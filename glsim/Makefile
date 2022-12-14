# SYSDIR = ../software/sandbox
# SYSDIR = ../software/uart
# SYSDIR = ../software/timer
# SYSDIR = ../software/mmreg
SYSDIR = ../software/butterfly

TARGET = $(SYSDIR)/app.elf

PMEM_SIZE = 8192

all:
	@echo "libcmd           Prepare library command file"
	@echo "iver             Simulate with iVerilog"
	@echo "clean            Cleanup"

libcmd:
	ls /mnt/volume_sky130/skywater-pdk/libraries/sky130_fd_sc_hd/latest/cells | awk '{print "+libdir+/mnt/volume_sky130/skywater-pdk/libraries/sky130_fd_sc_hd/latest/cells/" $$0;}' >lib.cmd
	ls /mnt/volume_sky130/skywater-pdk/libraries/sky130_fd_sc_hd/latest/cells | awk '{print "+incdir+/mnt/volume_sky130/skywater-pdk/libraries/sky130_fd_sc_hd/latest/cells/" $$0;}' >>lib.cmd


iver:
	msp430-elf-objcopy -O ihex $(TARGET) pmem.ihex
	./ihex2mem.tcl -ihex pmem.ihex -out pmem.mem -mem_size $(PMEM_SIZE)
	iverilog -DFUNCTIONAL -c lib.cmd ../syn/toplevel_gl.v -I ../rtl -y . -DSEED=1 -DGATELEVEL topleveltb.v

clean:
	rm -rf a.out *~ *vcd pmem.ihex pmem.mem lib.cmd
