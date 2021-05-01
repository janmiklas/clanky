addpath "../funkcie/"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% EDITOVAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mer_path1 = "../../merania/0513/";
mer_path2 = "BP_BUV48A_300V_6A_02/";
mer_filename_vc = "scope_43_1.csv";
mer_filename_ic = "scope_43_4.csv";
mer_filename_vg = "scope_43_2.csv";
mer_filename_ig = "scope_43_3.csv";

outfilename_off = "../../latex/obr/plots/bjt_300_06_off.tex"
outfilename_on = "../../latex/obr/plots/bjt_300_06_on.tex"


tab_off.tus=[60.35, 61.66, 61.73, 61.87];	% 1. ked ib prejde nulou, 2. ked vce prejde 50V, 3. zlom (g=Il/Vd), 4. koniec - ked ib zas prejde nulou
tab_off.G=[6, 6/50, 6/300, .4/300];
tab_off.t=1e-6*tab_off.tus;

tab_on.tus=[153.6, 153.75, 153.79, 154, 154.6, 157.5];
%tab_on.G=[.2/300.8, 8.7/292, 10.7/290, 9.7/25, 9.7/12.2, 10/2];
tab_on.G=[.2/300.8, 8.7/300, 10.7/300, 9.7/25, 9.7/12.2, 10/2];
tab_on.t=1e-6*tab_on.tus;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bjt_sim_vseobec

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mer_300_06 = mer;
sim_off_300_06 = sim_off;
sim_on_300_06 = sim_on;
