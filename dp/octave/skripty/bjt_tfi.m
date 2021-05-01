tab_i= [4 6 8 10]
tab_toffus = [1.23 1.52 1.82 2]



figure; close;
h_off = figure%("papersize", [.1 .1]);
set(h_off, "position", [0  0 350 200]);
plot(tab_i, tab_toffus, "k.");
%legend("boxoff");
grid;
xlim([0 12]);
ylim([0 3]);
%set(gca, "xtick", ceil(sim_on.tus*5)/5:.2:sim_on.tus(end));
%set(gca, "ytick", 0:5:50);
%set(gca, "xticklabel", "");
%set(gca, "yticklabel", "");
xlabel('$I_C (\un{A})$', 'interpreter', 'latex');
ylabel('$t_{off} (\un{\mu s})$', 'interpreter', 'latex');
%text(t_stop*1e6-.1, sim_on.gce(end)/2*5+2, '$g_{CE}$', 'interpreter', 'latex');
system("mkdir plots");
print('-depslatex', '-S350,200', "../../latex/obr/plots/bjt_tfi.tex"); 
