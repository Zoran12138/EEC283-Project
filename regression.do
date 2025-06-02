set PrefMain(tclBreakOnQuit) 0
quit -sim
if {[file exists "sim/work"]} {file delete -force "sim/work"}
file mkdir "sim/work"
vlib "sim/work"
vmap work "sim/work"

if {![file exists "sim/logs"]} {file mkdir "sim/logs"}
if {![file exists "reports/cov_bitflip_fullcov"]} {file mkdir "reports/cov_bitflip_fullcov"}
if {![file exists "reports/cov_all"]} {file mkdir "reports/cov_all"}
if {![file exists "reports/cov_mulcov"]} {file mkdir "reports/cov_mulcov"}
if {![file exists "reports/cov_bitflip"]} {file mkdir "reports/cov_bitflip"}
if {![file exists "reports/cov_deepcov"]} {file mkdir "reports/cov_deepcov"}

set COVER_OPTS "sbcefx"

vlog -work work -cover $COVER_OPTS rtl/regfile.sv tb/tb_regfile_bitflip_fullcov.sv -l sim/logs/cov_bitflip_fullcov_vlog.log
vsim -c -coverage -voptargs=+acc work.tb_regfile_bitflip_fullcov -do "run -all; quit -f" -l sim/logs/cov_bitflip_fullcov_vsim.log
vcover report -details -html -directory sim/work/tb_regfile_bitflip_fullcov.ucdb -output reports/cov_bitflip_fullcov/coverage_html -assert
vcover merge -format ucdb -directory sim/work/tb_regfile_bitflip_fullcov.ucdb -output reports/cov_bitflip_fullcov/tb_regfile_bitflip_fullcov.ucdb

vlog -work work -cover $COVER_OPTS rtl/regfile.sv tb/tb_regfile_all.sv -l sim/logs/cov_all_vlog.log
vsim -c -coverage -voptargs=+acc work.tb_regfile_all -do "run -all; quit -f" -l sim/logs/cov_all_vsim.log
vcover report -details -html -directory sim/work/tb_regfile_all.ucdb -output reports/cov_all/coverage_html -assert
vcover merge -format ucdb -directory sim/work/tb_regfile_all.ucdb -output reports/cov_all/tb_regfile_all.ucdb

vlog -work work -cover $COVER_OPTS rtl/regfile.sv tb/tb_regfile_mulcov.sv -l sim/logs/cov_mulcov_vlog.log
vsim -c -coverage -voptargs=+acc work.tb_regfile_mulcov -do "run -all; quit -f" -l sim/logs/cov_mulcov_vsim.log
vcover report -details -html -directory sim/work/tb_regfile_mulcov.ucdb -output reports/cov_mulcov/coverage_html -assert
vcover merge -format ucdb -directory sim/work/tb_regfile_mulcov.ucdb -output reports/cov_mulcov/tb_regfile_mulcov.ucdb

vlog -work work -cover $COVER_OPTS rtl/regfile.sv tb/tb_regfile_bitflip.sv -l sim/logs/cov_bitflip_vlog.log
vsim -c -coverage -voptargs=+acc work.tb_regfile_bitflip -do "run -all; quit -f" -l sim/logs/cov_bitflip_vsim.log
vcover report -details -html -directory sim/work/tb_regfile_bitflip.ucdb -output reports/cov_bitflip/coverage_html -assert
vcover merge -format ucdb -directory sim/work/tb_regfile_bitflip.ucdb -output reports/cov_bitflip/tb_regfile_bitflip.ucdb

vlog -work work -cover $COVER_OPTS rtl/regfile.sv tb/tb_regfile_deepcov1.sv -l sim/logs/cov_deepcov_vlog.log
vsim -c -coverage -voptargs=+acc work.tb_regfile_deepcov1 -do "run -all; quit -f" -l sim/logs/cov_deepcov_vsim.log
vcover report -details -html -directory sim/work/tb_regfile_deepcov1.ucdb -output reports/cov_deepcov/coverage_html -assert
vcover merge -format ucdb -directory sim/work/tb_regfile_deepcov1.ucdb -output reports/cov_deepcov/tb_regfile_deepcov1.ucdb

puts "=== Regression 完成！報告已儲存於 reports/**/coverage_html/index.html ==="
quit

