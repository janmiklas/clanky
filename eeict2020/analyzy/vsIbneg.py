import os
import numpy as np
import matplotlib.pyplot as plt
import sys
#sys.path.append('/home/janik/skola/mypymodules')
sys.path.append('/tmp/mypymodules')
sys.path.append('../../../../mypymodules')
#from mypymodules.scope import *
#import mypymodules.ff_vut_ as ff
from scope import *
import ff as ff
from ff import *


loadpath = '../../../dis/merania/mer_BUX/mer/kolektor_v_lufte/vs_Ibneg/'
#filename = '300V_bb'
filenames = ['ibpos1', 'ibpos2', 'ibpos3']
#filenames = ['ibpos1']
savefilename = "vsIbneg"

###########

aaaa=[]

for IBX in filenames:
    aaaa.append([])
    for i in range(40):
        FN = f'{loadpath}{IBX}_{i:02d}.npy'
        if os.path.isfile(FN):
            aaaa[-1].append(Mer())
            print('load ', FN, ' ...')
            aaaa[-1][-1].load(FN, eachn=10)
            #aaa.append(Mer())
            #aaa[-1].load(FN, old=True)

            n = 4700
            #uuuu[-1].append(mymean(aaaa[-1][-1].ch3, n, 5))


### PLOTTING
plt.style.use('classic')
plt.rcParams['figure.figsize'] = [6, 8]
plt.rcParams['legend.fontsize'] = 'medium'
plt.rcParams.update({'mathtext.default': 'regular'})

#fig = plt.figure()
#ax = fig.gca()
fig, (ax1, ax2, ax3) = plt.subplots(3, sharex=True)

for aaa in aaaa:
    for aa in aaa:
        aa.tr0 = trig_dopredu_hore(aa.ch1, 0.1)
        aa.tr1 = trig_dopredu_dole(aa.ch1, 0.0, aa.tr0)
        aa.ic = mymean(aa.ch4, aa.tr1)
        #aa.tr2 = trig_dopredu_hore(aa.ch3, 15, aa.tr1)
        aa.tr2 = trig_dopredu_dole(aa.ch2, -.0, aa.tr1)
        # aby sa prehupli triggre u vsetkych pod ib<-.1
        #aa.tr30 = trig_dopredu_dole(aa.ch1, -.1, aa.tr2)
        #aa.tr3 = trig_dopredu_hore(aa.ch1, -0.05, aa.tr30)
        aa.tr3 = trig_dopredu_dole(aa.ch2, -7.0, aa.tr2)
        
        aa.ibpos = mymean(aa.ch1, int(np.mean([aa.tr0, aa.tr1])))
        aa.ibneg = mymean(aa.ch1, int(np.mean([aa.tr1, aa.tr2])))

        aa.qq = abs(np.sum(aa.ch1[aa.tr1:aa.tr3])*aa.dt)
        aa.qq1 = abs(np.sum(aa.ch1[aa.tr1:aa.tr2])*aa.dt)
        aa.qq2 = abs(np.sum(aa.ch1[aa.tr2:aa.tr3])*aa.dt)
        
        ######
    
        ### plot priebehy
        tshift = aa.tus[aa.tr1]
        ax1.plot(aa.tus-tshift, aa.ch3, 'k')
        ax2.plot(aa.tus-tshift, aa.ch2, 'k')
        ax3.plot(aa.tus-tshift, aa.ch1, 'k')
        #ax3.vlines(aa.tus[aa.tr1]-tshift, -1, 1)
        #ax3.vlines(aa.tus[aa.tr2]-tshift, -1, 1)
        #ax3.vlines(aa.tus[aa.tr3]-tshift, -1, 1)
        plt.tight_layout() # a kuknut aj constrained_layout
#plt.legend()
ax1.grid()
ax2.grid()
ax3.grid()
#ax3.set_xlim([-1, 5]) # tr1
#ax3.set_ylim([-.6, .4])
#ax2.set_ylim([-0, 12])
#ax2.set_ylim(bottom=0)
#ax1.set_ylim(bottom=0)
#ax3.text(0.3, iiibneg[0]+.02, r'$i_{B-} = $' + f'{round(abs(iiibneg[0]), 2)} A')
#ax3.text(0.3, iiibneg[-1]-.08, r'$i_{B-} = $' + f'{round(abs(iiibneg[-1]), 2)} A')
ax3.set_xlabel(r'Time ($\mu s$)')
ax1.set_ylabel(r'Collector Voltage ($V$)')
ax3.set_ylabel(r'Base Drive Current ($A$)')
#ax2.set_ylabel(r'Collector Current ($A$)')
plt.tight_layout() # a kuknut aj constrained_layout
plt.savefig('plots/'+savefilename+'_prieb.png')
plt.savefig('plots/'+savefilename+'_prieb.eps')
plt.ion()
plt.show()



qqqq = [[AA.qq for AA in AAA] for AAA in aaaa]
qqqq1 = [[AA.qq1 for AA in AAA] for AAA in aaaa]
qqqq2 = [[AA.qq2 for AA in AAA] for AAA in aaaa]
iiiic = [[AA.ic for AA in AAA] for AAA in aaaa]
iiiibpos = [[AA.ibpos for AA in AAA] for AAA in aaaa]
iiiibneg = [[AA.ibneg for AA in AAA] for AAA in aaaa]
tttt = [[AA.tus[AA.tr3-AA.tr1] for AA in AAA] for AAA in aaaa]
tttt1 = [[AA.tus[AA.tr2-AA.tr1] for AA in AAA] for AAA in aaaa]
tttt2 = [[AA.tus[AA.tr3-AA.tr2] for AA in AAA] for AAA in aaaa]
        
### PLOTTING
plt.style.use('classic')
#plt.rcParams['figure.figsize'] = [6, 4.5]
plt.rcParams['figure.figsize'] = [4.5, 4.0]
plt.rcParams['legend.fontsize'] = 'medium'

plt.rcParams.update({'mathtext.default': 'regular'})

#fig = plt.figure(figsize=[6, 4.5])
fig11 = plt.figure()
ax11 = fig11.gca()
fig12 = plt.figure()
ax12 = fig12.gca()

ax11.set_xlabel("Negative Base Drive Current (A)")
ax11.set_ylabel(r'Deflated Charge ($\mu C$)')
ax12.set_xlabel("Negative Base Drive Current (A)")
ax12.set_ylabel(r'Total Deflation Time ($\mu s$)')

colors = ['white', 'black', 'gray']
for i in range(len(iiiibneg)):
#for i in range(1,3):

    Ibpos = abs(round(aaaa[i][0].ibpos,1))
    iiibneg = iiiibneg[i][:]
    sort_index = np.argsort(iiibneg)
    iiibneg=np.abs(iiibneg)[sort_index]
    # scaling na mikro
    qqq=np.array(qqqq[i][:])[sort_index]/1e-6
    ttt = np.array(tttt[i][:])[sort_index]

    iiibneg = iiibneg[1:]
    qqq = qqq[1:]
    ttt = ttt[1:]

    xs, ys = myspline_w(iiibneg[:], qqq[:], wwextra=1.35, k=3)
    #xs, ys = myfit_exp(iiibneg[:], qqq[:])
    ax11.plot(xs, ys, 'k')
    ax11.plot(iiibneg, qqq, 'o', color=colors[i], label=r'$I_{B+}=$'+f'{Ibpos}A')

    xs, ys = myspline_w(iiibneg[:], ttt[:], wwextra=4)
    #xs, ys = myfit_exp(iiibneg[:], ttt[:])
    ax12.plot(xs, ys, 'k')
    ax12.plot(iiibneg, ttt, 'o', color=colors[i], label=r'$I_{B+}=$'+f'{Ibpos}A')
#ax.set_ylim(bottom = 0)
#ax.set_ylim(0, 0.8)
#ax.set_xlim(.1, .5)

ax11.grid()
ax11.legend(loc='best', numpoints=1)
ax12.grid()
ax12.legend(loc='best', numpoints=1)

#plt.tight_layout() # a kuknut aj constrained_layout
fig11.tight_layout() # a kuknut aj constrained_layout
fig12.tight_layout() # a kuknut aj constrained_layout

fig11.savefig('plots/Q'+savefilename+'.eps')
fig11.savefig('plots/Q'+ savefilename+'.png')
fig12.savefig('plots/T'+savefilename+'.eps')
fig12.savefig('plots/T'+ savefilename+'png')
