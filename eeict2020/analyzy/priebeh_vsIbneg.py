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


#loadpath = '../mer/kolektor_v_lufte/vs_Ton/'
loadpath = '../../../dis/merania/mer_BUX/mer/kolektor_v_lufte/vs_Ibneg/'
#filename = '300V_bb'
filenames = ['ibpos2']
savefilename = "priebeh_vsIbneg"

###########

aaaa=[]

for IBX in filenames:
    aaaa.append([])
    #for i in range(40):
    #for i in [8, 5, 2]:
    #for i in [10, 8, 6]:
    for i in [3, 5, 7]:
        FN = f'{loadpath}{IBX}_{i:02d}.npy'
        if os.path.isfile(FN):
            aaaa[-1].append(Mer())
            print('load ', FN, ' ...')
            aaaa[-1][-1].load(FN, eachn=10)
            #aaa.append(Mer())
            #aaa[-1].load(FN, old=True)



### PLOTTING
plt.style.use('classic')
#plt.rcParams['figure.figsize'] = [6, 8]
plt.rcParams['figure.figsize'] = [4.5, 4]
plt.rcParams['legend.fontsize'] = 'medium'
plt.rcParams.update({'mathtext.default': 'regular'})

#fig = plt.figure()
#ax = fig.gca()
#fig, (ax1, ax2, ax3) = plt.subplots(3, sharex=True)
fig, (ax1) = plt.subplots(1, sharex=True)

fillcolors = ['lightgray', 'darkgray', 'gray']
i=0
for aaa in aaaa:
    for aa in aaa[::-1]:
        aa.tr0 = trig_dopredu_hore(aa.ch1, 0.04)
        aa.tr1 = trig_dopredu_dole(aa.ch1, 0.0, aa.tr0)
        aa.ic = mymean(aa.ch4, aa.tr1)
        #aa.tr2 = trig_dopredu_hore(aa.ch3, 15, aa.tr1)
        aa.tr2 = trig_dopredu_dole(aa.ch3, -.5, aa.tr1)
        # aby sa prehupli triggre u vsetkych pod ib<-.1
        #aa.tr30 = trig_dopredu_dole(aa.ch1, -.1, aa.tr2)
        #aa.tr3 = trig_dopredu_hore(aa.ch1, -0.05, aa.tr30)
        aa.tr3 = trig_dopredu_dole(aa.ch2, -7.5, aa.tr2)
        print(aa.tr0, aa.tr1, aa.tr2, aa.tr3)
        
        aa.Ton = aa.tus[aa.tr1] - aa.tus[aa.tr0]
        aa.ibpos = mymean(aa.ch1, int(np.mean([aa.tr0, aa.tr1])))
        aa.ibneg = mymean(aa.ch1, int(np.mean([aa.tr1, aa.tr2])))

        aa.qq = abs(np.sum(aa.ch1[aa.tr1:aa.tr3])*aa.dt)
        aa.qq1 = abs(np.sum(aa.ch1[aa.tr1:aa.tr2])*aa.dt)
        aa.qq2 = abs(np.sum(aa.ch1[aa.tr2:aa.tr3])*aa.dt)
        
        ######
    
        ### plot priebehy
        tshift = aa.tus[aa.tr1]
        #ax1.fill_between(aa.tus[aa.tr1:aa.tr3]-tshift, aa.ch1[aa.tr1:aa.tr3], color='black', alpha=0.3)
        ax1.fill_between(aa.tus[aa.tr1:aa.tr3]-tshift, aa.ch1[aa.tr1:aa.tr3], color=fillcolors[i], label=r'$Q_{defl.}, I_{B-}=$' + f'{round(np.abs(aa.ibneg),2)}A')
        ax1.plot(aa.tus-tshift, aa.ch1, 'k')
        fig.tight_layout() # a kuknut aj constrained_layout
        if i is 2:
            ax1.hlines([0, aa.ibneg], 0, -1.5)
            ax1.annotate(s="", xy=(-1, 0), xytext=(-1, aa.ibneg), arrowprops=dict(arrowstyle='<->'))
            ax1.text(-3.6, aa.ibneg/2, r"$I_{B-}$")
            #ax1.vlines(aa.tus[aa.tr3]-tshift, -.75, 0)
            #ax1.annotate(s='', xy=(0, -.75), xytext=(aa.tus[aa.tr3-aa.tr1], -.75), arrowprops=dict(arrowstyle='<->'))
            #ax1.annotate(s='', xy=(0, -.52), xytext=(23, -.52), arrowprops=dict(arrowstyle='<->'))
            #ax1.text(aa.tus[aa.tr3-aa.tr1]*0.45, -.5, r"$T_{deflation}$")
        i+=1
ax1.grid()
ax1.legend(loc='best')
#ax1.set_ylim(bottom=0)
ax1.set_xlim(-5, 25)
fig.tight_layout() # a kuknut aj constrained_layout
ax1.set_xlabel(r'Time ($\mu s$)')
ax1.set_ylabel(r'Base Drive Current ($A$)')
plt.tight_layout() # a kuknut aj constrained_layout
plt.savefig('plots/'+savefilename+'.png')
plt.savefig('plots/'+savefilename+'.eps')
#plt.savefig('plots/'+savefilename+'.pdf')
plt.ion()
plt.show()
