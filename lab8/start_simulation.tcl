set dir_zadatak "./project"

if {[file exists $dir_zadatak] == 0} {
	create_project project $dir_zadatak -part xc7s100fgga676-2
	set_property target_language VHDL [current_project]
	add_files -norecurse {{./kcpsm6.vhd} {./program.vhd} {./movavg4.vhd}}

	update_compile_order -fileset sources_1

	set_property SOURCE_SET sources_1 [get_filesets sim_1]
	add_files -fileset sim_1 -norecurse {./system_testbench.vhd}
	update_compile_order -fileset sim_1

	set_property -name {xsim.simulate.runtime} -value {100us} -objects [get_filesets sim_1]
	set_param synth.elaboration.rodinMoreOptions {rt::set_parameter ignoreVhdlAssertStmts false}
	update_ip_catalog
} else {
	open_project $dir_zadatak/project.xpr
}

launch_simulation
