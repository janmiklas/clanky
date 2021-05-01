addpath "../funkcie/"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% EDITOVAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mer_path1 = "../../merania/0513/";
mer_path2 = "BP_BUV48A_300V_10A_02/";
mer_filename_vc = "scope_16_1.csv";
mer_filename_ic = "scope_16_4.csv";
mer_filename_vg = "scope_16_2.csv";
mer_filename_ig = "scope_16_3.csv";

outfilename_off = "../../latex/obr/plots/bjt_300_10_off.tex"
outfilename_on = "../../latex/obr/plots/bjt_300_10_on.tex"


tab_off.tus=[ 109.4, 111, 111.16, 111.4];
tab_off.G=[ 7.8, 10/50, 10/300, .1/300];
tab_off.t=1e-6*tab_off.tus;

tab_on.tus=[153.55,  153.8, 154, 154.1, 154.9, 155, 157.3];
tab_on.G=[.2/300, 0.04, .4, .56, 1, 1.1, 10/2];
tab_on.t=1e-6*tab_on.tus;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numsteps = 1000
bjt_sim_vseobec

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mer_300_10 = mer;
sim_off_300_10 = sim_off;
sim_on_300_10 = sim_on;
