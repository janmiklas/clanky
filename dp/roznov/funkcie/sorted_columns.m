function ret = sorted_columns(data_columns, sorting_row)
	[a, i]=sort(sorting_row);
	ret = data_columns(:,i);
endfunction
