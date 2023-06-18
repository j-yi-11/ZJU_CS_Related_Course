onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib ROM_opt

do {wave.do}

view wave
view structure
view signals

do {ROM.udo}

run -all

quit -force
