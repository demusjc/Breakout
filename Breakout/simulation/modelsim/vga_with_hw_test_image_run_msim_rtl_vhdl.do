transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/demusjc/Downloads/vga_test/vga_test/db {C:/Users/demusjc/Downloads/vga_test/vga_test/db/altpll0_altpll.v}
vcom -93 -work work {C:/Users/demusjc/Downloads/vga_test/vga_test/vga_controller.vhd}
vcom -93 -work work {C:/Users/demusjc/Downloads/vga_test/vga_test/hw_image_generator.vhd}
vcom -93 -work work {C:/Users/demusjc/Downloads/vga_test/vga_test/altpll0.vhd}

