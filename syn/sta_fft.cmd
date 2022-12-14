read_liberty /mnt/volume_sky130/skywater-pdk/libraries/sky130_fd_sc_hd/latest/timing/sky130_fd_sc_hd__tt_025C_1v80.lib
read_verilog FFT_gl.v
link_design FFT

create_clock -name clk -period 50 {mclk}
set_input_delay -clock clk 0 {per_addr per_din per_en per_we puc_rst }
set_output_delay -clock clk 0 {per_dout}
report_checks
report_power
exit


