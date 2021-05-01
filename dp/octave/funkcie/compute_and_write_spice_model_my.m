function ret = compute_and_write_spice_model_my(tab_t, tab_G, str_outfilename)
	ret.abc = abc = tab2abc(tab_t, tab_G);
	ret.writestatus = write_spice_model_my(tab_t, abc, str_outfilename);
endfunction
