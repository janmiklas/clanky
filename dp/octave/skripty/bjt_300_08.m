addpath "../funkcie/"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% EDITOVAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mer_path1 = "../../merania/0513/";
mer_path2 = "BP_BUV48A_300V_8A_02/";
mer_filename_vc = "scope_31_1.csv";
mer_filename_ic = "scope_31_4.csv";
mer_filename_vg = "scope_31_2.csv";
mer_filename_ig = "scope_31_3.csv";

outfilename_off = "../../latex/obr/plots/bjt_300_08_off.tex"
outfilename_on = "../../latex/obr/plots/bjt_300_08_on.tex"


tab_off.tus=[ 84.5, 86, 86.11, 86.32];
tab_off.G=[ 7.27, 8/50, 8/300, .18/300];
tab_off.t=1e-6*tab_off.tus;

tab_on.tus=[153.6, 153.75, 153.79, 154, 154.6, 157.5];
%tab_on.G=[.2/300.8, 8.7/292, 10.7/290, 9.7/25, 9.7/12.2, 10/2];
tab_on.G=[.2/300.8, 8.7/300, 10.7/300, 9.7/25, 9.7/12.2, 10/2];
tab_on.t=1e-6*tab_on.tus;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bjt_sim_vseobec

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mer_300_08 = mer;
sim_off_300_08 = sim_off;
sim_on_300_08 = sim_on;
