onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib ROM_B_opt

do {wave.do}

view wave
view structure
view signals

do {ROM_B.udo}

run -all

quit -force
