onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib My_ROM_opt

do {wave.do}

view wave
view structure
view signals

do {My_ROM.udo}

run -all

quit -force
