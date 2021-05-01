addpath "../funkcie/"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% EDITOVAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mer_path1 = "../../merania/0517/";
mer_path2 = "G50N60HS_300V_40A/";
mer_filename_vc = "scope_11_1.csv";
mer_filename_ic = "scope_11_4.csv";
mer_filename_vg = "scope_11_2.csv";
mer_filename_ig = "scope_11_3.csv";

outfilename_off = "../../latex/obr/plots/igbt_300_40_1_off.tex";
outfilename_on = "../../latex/obr/plots/igbt_300_40_1_on.tex";

tab_off.tus=[ 195, 195.15, 195.21 , 195.24, 195.4, 195.7];
tab_off.G=[ 40.8/4.5, 40.8/14.14, 39/259, 2.8/340, 0.8/300,0.35/300];
tab_off.t=1e-6*tab_off.tus;

tab_on.tus=[208.02, 208.14, 208.2, 208.35];
tab_on.G = [0.002, 0.28, 3.7,  12];
tab_on.t = 1e-6*tab_on.tus;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



igbt_sim_vseobec

mer_igbt_300_40 = mer;
sim_on_igbt_300_40 = sim_on;
sim_off_igbt_300_40 = sim_off;
