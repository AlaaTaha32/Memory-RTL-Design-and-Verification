vlog -sv Env.sv +cover -covercells
vsim -voptargs=+acc work.tb -cover
add wave -position insertpoint sim:/tb/memory_inst/*
add wave -position insertpoint sim:/tb/memory_inst/Memory
coverage save mem_coverage.ucdb -onexit
run 360
radix -binary -showbase
radix signal sim:/tb/memory_inst/Data_in unsigned -showbase
radix signal sim:/tb/memory_inst/Address unsigned -showbase
radix signal sim:/tb/memory_inst/Data_out unsigned -showbase
radix signal sim:/tb/memory_inst/Memory[0] unsigned -showbase
radix signal sim:/tb/memory_inst/Memory[1] unsigned -showbase
radix signal sim:/tb/memory_inst/Memory[2] unsigned -showbase
radix signal sim:/tb/memory_inst/Memory[3] unsigned -showbase
radix signal sim:/tb/memory_inst/Memory[4] unsigned -showbase
radix signal sim:/tb/memory_inst/Memory[5] unsigned -showbase
radix signal sim:/tb/memory_inst/Memory[6] unsigned -showbase
radix signal sim:/tb/memory_inst/Memory[7] unsigned -showbase
radix signal sim:/tb/memory_inst/Memory[8] unsigned -showbase
radix signal sim:/tb/memory_inst/Memory[9] unsigned -showbase
radix signal sim:/tb/memory_inst/Memory[10] unsigned -showbase
radix signal sim:/tb/memory_inst/Memory[11] unsigned -showbase
radix signal sim:/tb/memory_inst/Memory[12] unsigned -showbase
radix signal sim:/tb/memory_inst/Memory[13] unsigned -showbase
radix signal sim:/tb/memory_inst/Memory[14] unsigned -showbase
radix signal sim:/tb/memory_inst/Memory[15] unsigned -showbase