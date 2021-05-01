addpath "../funkcie/"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% EDITOVAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mer_path1 = "../../merania/0513/";
mer_path2 = "BP_BUV48A_150V_6A_02/";
mer_filename_vc = "scope_94_1.csv";
mer_filename_ic = "scope_94_4.csv";
mer_filename_vg = "scope_94_2.csv";
mer_filename_ig = "scope_94_3.csv";

outfilename_off = "plots/bjt_150_06_off.tex"
outfilename_on = "plots/bjt_150_06_on.tex"


%tab_off.tus=[ 83.7, 84.85, 86.12, 86.38, 86.53, 86.68];
%tab_off.G=[ 7.8, 10/2.3, 10/20, 10/146, 2.47/150, .2/150];
tab_off.tus=[84.85, 86.25, 86.38,  86.68];
tab_off.G=[7.8, 10/40.6, 10/146, .2/150];
tab_off.t=1e-6*tab_off.tus;

tab_on.tus=[153.6, 153.75, 153.79, 154, 154.6, 157.5];
%tab_on.G=[.2/300.8, 8.7/292, 10.7/290, 9.7/25, 9.7/12.2, 10/2];
tab_on.G=[.2/300.8, 8.7/300, 10.7/300, 9.7/25, 9.7/12.2, 10/2];
tab_on.t=1e-6*tab_on.tus;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bjt_sim_vseobec

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mer_150_06 = mer;
sim_off_150_06 = sim_off;
sim_on_150_06 = sim_on;
