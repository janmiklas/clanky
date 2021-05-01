addpath "../funkcie/"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% EDITOVAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mer_path1 = "../../merania/0513/";
mer_path2 = "BP_BUV48A_300V_4A_02/";
mer_filename_vc = "scope_55_1.csv";
mer_filename_ic = "scope_55_4.csv";
mer_filename_vg = "scope_55_2.csv";
mer_filename_ig = "scope_55_3.csv";

outfilename_off = "../../latex/obr/plots/bjt_300_04_off.tex"
outfilename_on = "../../latex/obr/plots/bjt_300_04_on.tex"


tab_off.tus=[39.95, 41.035, 41.09, 41.18];
tab_off.G=[4.44, 4/50, 4/300, .2/300];
tab_off.t=1e-6*tab_off.tus;

tab_on.tus=[153.6, 153.75, 153.79, 154, 154.6, 157.5];
%tab_on.G=[.2/300.8, 8.7/292, 10.7/290, 9.7/25, 9.7/12.2, 10/2];
tab_on.G=[.2/300.8, 8.7/300, 10.7/300, 9.7/25, 9.7/12.2, 10/2];
tab_on.t=1e-6*tab_on.tus;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bjt_sim_vseobec

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mer_300_04 = mer;
sim_off_300_04 = sim_off;
sim_on_300_04 = sim_on;
