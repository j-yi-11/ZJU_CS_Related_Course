onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+ROM_D -L xpm -L dist_mem_gen_v8_0_13 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.ROM_D xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {ROM_D.udo}

run -all

endsim

quit -force
