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
loadpath = '../../../dis/merania/mer_BUX/mer/kolektor_v_lufte/vs_Ton/'
#filename = '300V_bb'
filenames = ['ibpos1']
savefilename = "priebeh_vsTon2"

###########

aaaa=[]

for IBX in filenames:
    aaaa.append([])
    #for i in range(40):
    for i in [12, 10, 8]:
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
        ax1.fill_between(aa.tus[aa.tr1:aa.tr3]-tshift, aa.ch1[aa.tr1:aa.tr3], color=fillcolors[i], label=r'$Q_{defl}, T_{on}=$' + f'{int(aa.Ton)}' + r'$\mu s$')
        ax1.plot(aa.tus-tshift, aa.ch1, 'k')
        fig.tight_layout() # a kuknut aj constrained_layout
        if i is 0:
            ax1.vlines(aa.tus[aa.tr0]-tshift, -.75, 0)
            ax1.vlines(aa.tus[aa.tr1]-tshift, -.75, 0)
            ax1.vlines(aa.tus[aa.tr2]-tshift, -.75, -.45)
            #ax1.vlines(aa.tus[aa.tr3]-tshift, -.55, 0)
            ax1.vlines(23, -.75, 0)
            ax1.annotate(s='', xy=(-aa.Ton, -.73), xytext=(0, -.73), arrowprops=dict(arrowstyle='<->'))
            #ax1.annotate(s='', xy=(0, -.52), xytext=(aa.tus[aa.tr3-aa.tr1], -.52), arrowprops=dict(arrowstyle='<->'))
            ax1.annotate(s='', xy=(0, -.73), xytext=(aa.tus[aa.tr2-aa.tr1], -.73), arrowprops=dict(arrowstyle='<->'))
            ax1.annotate(s='', xy=(aa.tus[aa.tr2-aa.tr1], -.73), xytext=(23, -.73), arrowprops=dict(arrowstyle='<->'))
            #ax1.text(aa.tus[aa.tr3-aa.tr1]*0.45, -.5, r"$T_{deflation}$")
            ax1.text(-aa.Ton*0.7, -.70, r"$T_{on}$")
            ax1.text(0.5, -.70, r"$T_{1}$")
            ax1.text(12, -.70, r"$T_{2}$")
        i+=1
ax1.legend(loc='best')
ax1.grid()
#ax1.set_ylim(bottom=0)
ax1.set_xlim(-20, 32)
fig.tight_layout() # a kuknut aj constrained_layout
ax1.set_xlabel(r'Time ($\mu s$)')
ax1.set_ylabel(r'Base Drive Current ($A$)')
plt.tight_layout() # a kuknut aj constrained_layout
plt.savefig('plots/'+savefilename+'.png')
plt.savefig('plots/'+savefilename+'.eps')
plt.ion()
plt.show()
