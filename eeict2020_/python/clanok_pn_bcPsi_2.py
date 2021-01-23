from dolfin import *
import numpy
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.ticker import NullFormatter
from time import sleep
import ff as ff
import fff
import matplotlib.tri as tri

plt.style.use('classic')


from init1 import *


pop_plot = True


####################
## Poisson
####################
rho = Expression("q * (p - n + Nd - Na)", q=q, p=p0, n=n0, Nd=Nd, Na=Na, degree=1)
g_Jb = Expression("-J/(q*(mob_n*n + mob_p*p))", q=q, mob_n=mob_n, mob_p=mob_p, p=p0, n=n0, J=Jb_pos, degree=1)
g_Jc = Expression("J/(q*(-mob_n*n + mob_p*p))", q=q, mob_n=mob_n, mob_p=mob_p, p=p0, n=n0, J=Jc_pos, degree=1)
Psi = TrialFunction(V)
v_psi = TestFunction(V)
#a = -eps_Si * dot(grad(Psi), grad(v_psi)) * dx # v 2D funguje dot aj inner, v 1D neviem
#a = -eps_Si * inner(grad(Psi), grad(v_psi)) * dx
#L = -rho*v_psi*dx 
a = -inner(grad(Psi), grad(v_psi)) * dx
L = -rho/eps_Si*v_psi*dx
#L = -rho/eps_Si*v_psi*dx - g_Jb*v_psi*ds(1) - g_Jc*v_psi*ds(3)
#L = -rho/eps_Si*v_psi*dx - g_Jb*v_psi*ds(1)
#L1 = -rho/eps_Si*v_psi*dx - g_Je*v_psi*ds(2) - g_Jb*v_psi*ds(1)

Psi_result = Function(V)
#solve(a==L, Psi_result, [bc_psi1, bc_psi2])

####################
## n, p Continuity
####################
dt_expr=Expression('dt', dt=dt, degree=1)

n_i1 = Function(Vn)
n_i1.assign(n0)
n = TrialFunction(Vn)
vn = TestFunction(Vn)
#an = n*vn*dx + dt*Dn*inner(grad(n), grad(vn))*dx
an = n*vn*dx + dt_expr*D_n*inner(grad(n), grad(vn))*dx
Ln = n_i1*vn*dx + dt_expr*mob_n*n_i1*inner(grad(Psi_result), grad(vn))*dx

n_result = Function(Vn)
#solve(an==Ln, n_result, [bc_n1, bc_n2])

p_i1 = Function(Vp)
p_i1.assign(p0)
p = TrialFunction(Vp)
vp = TestFunction(Vp)
ap = p*vp*dx + dt_expr*D_p*inner(grad(p), grad(vp))*dx
Lp = p_i1*vp*dx - dt_expr*mob_p*p_i1*inner(grad(Psi_result), grad(vp))*dx

p_result = Function(Vp)
#solve(ap==Lp, p_result, [bc_p1, bc_p2])


#################
#################
#################
#################

plt.ion()
#fig, axes = plt.subplots(3, 2, sharex='col')
fig, axes = plt.subplots(3, 2)

xcoord = mesh.coordinates()[:,0]
#xx1 = xx1d = mesh.coordinater()[:,0][:nx+1]
xx1 = xx1d = np.linspace(0, x_length, 1000)
xx = xx1
Yhore = y_length
Ystred = y_length/2.
Ydole = 0.
yy_doping = project(N, V).vector().get_local()



#################
#################
#################
#################
#################
#################

#################
### ustaleny stav:
#################
myglobals = [a, L, an, Ln, ap, Lp, Psi_result, n_result, p_result, n_i1, p_i1, rho, g_Jb, g_Jc, dt_expr]
bcs_psi = bc_psi_E_nul
bcs_n = [bc_n1, bc_n2]
bcs_p = [bc_p1, bc_p2]
bcs_n = []
bcs_p = []
n_init = n0
p_init = p0

dt=1e-12
T=100*dt

Psi_result, n_result, p_result, J, Jn, Jp, Jn_diff, Jn_drift, Jp_diff, Jp_drift, J_vector, Psi_vector, J_ustal, Psi_ustal = fff.my_solve_pn_bcPsi(myglobals, T, dt, bcs_psi, bcs_n, bcs_p, n_init, p_init, num_iter_plot=5, pop_plot=True)

#################
myglobals = [a, L, an, Ln, ap, Lp, Psi_result, n_result, p_result, n_i1, p_i1, rho, g_Jb, g_Jc, dt_expr]
n_init = n_result
p_init = p_result
dt=1e-12
T=500*dt
Psi_result, n_result, p_result, J, Jn, Jp, Jn_diff, Jn_drift, Jp_diff, Jp_drift, J_vector, Psi_vector, J_ustal, Psi_ustal = fff.my_solve_pn_bcPsi(myglobals, T, dt, bcs_psi, bcs_n, bcs_p, n_init, p_init, num_iter_plot=5, pop_plot=True)

#################

Psi_builtin = ff.my_eval_on_line(Psi_result, V, LEN, Ystred)

plt.ioff()
if pop_plot:
    plt.show()

np.save('results/IV1.npy', dict(Psi=Psi_vector_ustal, J=J_vector_ustal))

plt.ion()
plt.plot(np.array(Psi_vector_ustal)+Psi_builtin, np.array(J_vector_ustal))
plt.plot(np.array(Psi_vector_ustal)+Psi_builtin, np.array(J_vector_ustal), '.')
plt.plot(np.array(Psi_vector_ustal)+0, np.array(J_vector_ustal))
plt.grid()
plt.savefig('IV.eps')
plt.show()

