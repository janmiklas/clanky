%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 300V
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
plot(mer_300_10.tus, [mer_300_10.vc/10, mer_300_10.ic*2.5, mer_300_10.ic./mer_300_10.vc*2.5]);
xlim([153.4 154.9]);
title("BJT 300V 10A");
legend("uc", "ic", "gce");
grid;
set(gca, "xtick", ceil(mer_300_10.tus*5)/5:.2:mer_300_10.tus(end));
set(gca, "ytick", 0:5:50);
set(gca, "xticklabel", "");
set(gca, "yticklabel", "");
xlabel('$200\un{ns/div}$', 'interpreter', 'latex');
ylabel('$50\un{V/div},\,\,\, 2\un{A/div},\,\,\, 2\un{S/div}$', 'interpreter', 'latex');



figure;
plot(mer_300_08.tus, [mer_300_08.vc/10, mer_300_08.ic*2.5, mer_300_08.ic./mer_300_08.vc*2.5]);
xlim([128 129.5]);
title("BJT 300V 8A");
legend("uc", "ic", "gce");
grid;
set(gca, "xtick", ceil(mer_300_08.tus*5)/5:.2:mer_300_08.tus(end));
set(gca, "ytick", 0:5:50);
set(gca, "xticklabel", "");
set(gca, "yticklabel", "");
xlabel('$200\un{ns/div}$', 'interpreter', 'latex');
ylabel('$50\un{V/div},\,\,\, 2\un{A/div},\,\,\, 2\un{S/div}$', 'interpreter', 'latex');



figure;
plot(mer_300_06.tus, [mer_300_06.vc/10, mer_300_06.ic*2.5, mer_300_06.ic./mer_300_06.vc*2.5]);
xlim([103.8 105.3]);
title("BJT 300V 6A");
legend("uc", "ic", "gce");
grid;
set(gca, "xtick", ceil(mer_300_06.tus*5)/5:.2:mer_300_06.tus(end));
set(gca, "ytick", 0:5:50);
set(gca, "xticklabel", "");
set(gca, "yticklabel", "");
xlabel('$200\un{ns/div}$', 'interpreter', 'latex');
ylabel('$50\un{V/div},\,\,\, 2\un{A/div},\,\,\, 2\un{S/div}$', 'interpreter', 'latex');



figure;
plot(mer_300_04.tus, [mer_300_04.vc/10, mer_300_04.ic*2.5, mer_300_04.ic./mer_300_04.vc*2.5]);
xlim([83 84.5]);
title("BJT 300V 4A");
legend("uc", "ic", "gce");
grid;
set(gca, "xtick", ceil(mer_300_04.tus*5)/5:.2:mer_300_04.tus(end));
set(gca, "ytick", 0:5:50);
set(gca, "xticklabel", "");
set(gca, "yticklabel", "");
xlabel('$200\un{ns/div}$', 'interpreter', 'latex');
ylabel('$50\un{V/div},\,\,\, 2\un{A/div},\,\,\, 2\un{S/div}$', 'interpreter', 'latex');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 150V
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
plot(mer_150_10.tus, [mer_150_10.vc/10, mer_150_10.ic*2.5, mer_150_10.ic./mer_150_10.vc*2.5]);
xlim([153.4 154.9]);
title("BJT 150V 10A");
legend("uc", "ic", "gce");
grid;
set(gca, "xtick", ceil(mer_150_10.tus*5)/5:.2:mer_150_10.tus(end));
set(gca, "ytick", 0:5:50);
set(gca, "xticklabel", "");
set(gca, "yticklabel", "");
xlabel('$200\un{ns/div}$', 'interpreter', 'latex');
ylabel('$50\un{V/div},\,\,\, 2\un{A/div},\,\,\, 2\un{S/div}$', 'interpreter', 'latex');



figure;
plot(mer_150_08.tus, [mer_150_08.vc/10, mer_150_08.ic*2.5, mer_150_08.ic./mer_150_08.vc*2.5]);
xlim([128 129.5]);
title("BJT 150V 8A");
legend("uc", "ic", "gce");
grid;
set(gca, "xtick", ceil(mer_150_08.tus*5)/5:.2:mer_150_08.tus(end));
set(gca, "ytick", 0:5:50);
set(gca, "xticklabel", "");
set(gca, "yticklabel", "");
xlabel('$200\un{ns/div}$', 'interpreter', 'latex');
ylabel('$50\un{V/div},\,\,\, 2\un{A/div},\,\,\, 2\un{S/div}$', 'interpreter', 'latex');



figure;
plot(mer_150_06.tus, [mer_150_06.vc/10, mer_150_06.ic*2.5, mer_150_06.ic./mer_150_06.vc*2.5]);
xlim([103.8 105.3]);
title("BJT 150V 6A");
legend("uc", "ic", "gce");
grid;
set(gca, "xtick", ceil(mer_150_06.tus*5)/5:.2:mer_150_06.tus(end));
set(gca, "ytick", 0:5:50);
set(gca, "xticklabel", "");
set(gca, "yticklabel", "");
xlabel('$200\un{ns/div}$', 'interpreter', 'latex');
ylabel('$50\un{V/div},\,\,\, 2\un{A/div},\,\,\, 2\un{S/div}$', 'interpreter', 'latex');



figure;
plot(mer_150_04.tus, [mer_150_04.vc/10, mer_150_04.ic*2.5, mer_150_04.ic./mer_150_04.vc*2.5]);
xlim([83 84.5]);
title("BJT 150V 4A");
legend("uc", "ic", "gce");
grid;
set(gca, "xtick", ceil(mer_150_04.tus*5)/5:.2:mer_150_04.tus(end));
set(gca, "ytick", 0:5:50);
set(gca, "xticklabel", "");
set(gca, "yticklabel", "");
xlabel('$200\un{ns/div}$', 'interpreter', 'latex');
ylabel('$50\un{V/div},\,\,\, 2\un{A/div},\,\,\, 2\un{S/div}$', 'interpreter', 'latex');
