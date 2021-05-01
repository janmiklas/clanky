function ret = tab2sp_my(tab_t, tab_G, str_outfilename)
	ret.abc = abc = tab2abc(tab_t, tab_G);
	ret.write = write_spice_model_my(tab_t, abc, str_outfilename);
endfunction
