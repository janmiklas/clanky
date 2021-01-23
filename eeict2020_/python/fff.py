from dolfin import *
import numpy
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.ticker import NullFormatter
from time import sleep
import ff as ff
#import fff
import matplotlib.tri as tri

from init1 import *

plt.style.use('classic')


def my_solve_pn_bcPsi(myglobals, T, dt, bcs_psi, bcs_n, bcs_p, n_init, p_init, num_iter_plot=4, pop_plot=True):
    # myglobals: [a, L, an, Ln, ap, Lp, Psi_result, n_result, p_result, n_i1, p_i1, rho, g_Jb, g_Jc, dt_expr]
#return Psi_result, n_result, p_result, J, Jn, Jp, Jn_diff, Jn_drift, Jp_diff, Jp_drift, J_vector, Psi_vector, J_ustal, Psi_ustal

    a, L, an, Ln, ap, Lp, Psi_result, n_result, p_result, n_i1, p_i1, rho, g_Jb, g_Jc, dt_expr = myglobals
    J_vector=[]
    Psi_vector=[]
    t_vector = []

    t = 0
    num_iter = int(T / dt + 0)
    ITER_PLOT = num_iter / num_iter_plot
    iter_plot = 0

    n_result.assign(n_init)
    p_result.assign(p_init)

    for i in range(num_iter):
        print("cycle (i):")
        print(i)
        print("Time:")
        print(t)
        dt_expr.dt = dt
        solve(a==L, Psi_result, bcs_psi)
        solve(an==Ln, n_result, bcs_n)
        solve(ap==Lp, p_result, bcs_p)

        n_i1.assign(n_result)
        p_i1.assign(p_result)
        rho.n = n_result
        rho.p = p_result
        '''
        g_Jb.n = n_result
        g_Jb.p = p_result
        g_Jb.J = Jb_i[i] #0
        g_Jc.n = n_result
        g_Jc.p = p_result
        g_Jc.J = Jc_i[i]
        '''
        g_Jb.n = n_result
        g_Jb.p = p_result
        g_Jb.J = 0
        g_Jc.n = n_result
        g_Jc.p = p_result
        g_Jc.J = 0
        
        Jn_diff = q*D_n*grad(n_result)
        Jn_drift = -q*mob_n*n_result*grad(Psi_result)
        Jp_diff = -q*D_p*grad(p_result)
        Jp_drift = -q*mob_p*p_result*grad(Psi_result)
        Jn = Jn_drift+Jn_diff
        Jp = Jp_drift+Jp_diff
        J = Jn+Jp

        t += dt
        t_vector.append(t)
            
        J_vector.append(project(J[0], V)(XLEN, Ystred))
        Psi_vector.append(project(Psi_result, V)(XLEN, Ystred))
        
        
        iter_plot+=1
        if iter_plot == ITER_PLOT:
            print('i:', i)
            print('dt:', dt)
            iter_plot = 0
            ### GRAFY:
            if pop_plot:
                ff.grafy1(axes, V, xx, Yhore, Ystred, Ydole, rho, N, n_result, p_result, Psi_result, J, Jn, Jp, Jn_drift, Jn_diff, Jp_drift, Jp_diff, t_vector, Psi_vector, J_vector)

    J_ustal = J_vector[-1]
    Psi_ustal = Psi_vector[-1]

    return Psi_result, n_result, p_result, J, Jn, Jp, Jn_diff, Jn_drift, Jp_diff, Jp_drift, J_vector, Psi_vector, J_ustal, Psi_ustal




