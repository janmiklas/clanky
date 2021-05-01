function ret = sorted_cells(data_cells, sorting_row)
	[a, i]=sort(sorting_row);
	ret = data_cells(i);
endfunction
