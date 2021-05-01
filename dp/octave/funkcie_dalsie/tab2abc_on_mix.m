function abc = tab2abc_on_mix(tab_t, tab_G)
	switch numel(tab_t)
		case(3)
			abc = tab2abc_on_mix_2(tab_t, tab_G);
		case(4)
			abc = tab2abc_on_mix_3(tab_t, tab_G);
		case(5)
			abc = tab2abc_on_mix_4(tab_t, tab_G);
		case(6)
			abc = tab2abc_on_mix_5(tab_t, tab_G);
		case(7)
			abc = tab2abc_on_mix_6(tab_t, tab_G);
		otherwise
			error("malo alebo vela bodov v tabulke. mozne je od 3 do 7");
	endswitch
endfunction
