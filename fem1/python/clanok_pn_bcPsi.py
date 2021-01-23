from dolfin import *
import numpy
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.ticker import NullFormatter
from time import sleep
import ff as ff
import matplotlib.tri as tri

plt.style.use('classic')

pop_plot = True
## unit: 1cm


# conversions
m2mm = 1000
mm2m = 1/1000
cm2mm = 10
mm2cm = 1/10
m2cm = 100
cm2m = 1/100

# Scaling factors


#
q = 1 #1.602e-19
eps0 = 1#8.854e-12 * 1/m2cm # [F / m] * 1/m2cm
epsr_Si =  1 #11.68
eps_Si = eps0 * epsr_Si
'''
Na_E= 0
Nd_E= 1e+1 #1e14
Na_B= 1e-0 #1e17
Nd_B= 0
Na_drift = 0
Nd_drift = 1e+1
Na_C= 0
Nd_C= 1e+1 #1e14
'''
Na_E= 1e+1
Nd_E= 0e+1 #1e14
Na_B= 1e+1 #1e17
Nd_B= 0
Na_drift = 0
Nd_drift = 1e+1
Na_C= 0
Nd_C= 1e+1 #1e14

LEN = XLEN = x_length = 5e-2
YLEN = y_length = .2e-2
x_BE = x_length*0.2
x_BC = x_length*0.3
x_drift = x_length*0.8
x_Econ = 0
x_Ccon = x_length

val_mob_n = 1e3 #1400 # [cm2 / V / s]
val_mob_p =  1e3 #450
val_D_n =  1 #36 # [cm2 / s]
val_D_p =  1 #12

val_mob_n = 1e4 #1400 # [cm2 / V / s]
val_mob_p =  1e4 #450
val_D_n =  1e-1 #36 # [cm2 / s]
val_D_p =  1e-1 #12

Psi_B = 0
Psi_C_nul = 0 
Psi_C_pos = +3e-2
Psi_C_neg = -.2e-3
Psi_E_nul = 0
Psi_E_pos = 1e-3
Psi_E_neg = -.3e-3 
Psi_E_neg2 = -3e-3 

Jb_pos = .01
Jb_nul = 0
Jc_pos = 50

####################
## Time variables
####################
t=0
#dt=1e-6
dt=1e-6
T = 20*dt
T1 = 200*dt
T2 = 800*dt
T3 = 2000*dt
t_vector = []
####################

Jn_drift_vector=[]
Jn_diff_vector=[]
Jp_drift_vector=[]
Jp_diff_vector=[]
Jn_vector=[]
Jp_vector=[]
J_vector=[]
Psi_vector=[]
Psi_EB_vector=[]
Psi_BC_vector=[]

Psi_vector_ustal=[]
J_vector_ustal=[]

# Mesh and function space
#mesh = Mesh("pn.xml")
nx = 1000
ny = 1
mesh = RectangleMesh(Point(0.0, 0.0), Point(x_length, y_length) , nx, ny, 'crossed')
#mesh = IntervalMesh(1000, 0, LEN)
'''
cell_markers = CellFunction('bool', mesh)
cell_markers.set_all(False)
for cell in cells(mesh):
    p = cell.midpoint()
    if distance(Point(
        cell_markers[cell] = True
mesh = refine(mesh, cell_markers)
'''

#V = FunctionSpace(mesh, 'Lagrange', 1)
V = FunctionSpace(mesh, "CG", 1)
Vn = FunctionSpace(mesh, "CG", 1)
Vp = FunctionSpace(mesh, "CG", 1)
Vn=V
Vp=V

#boundaries = MeshFunction("size_t", mesh, "pn_facet_region.xml")
#subdomains = MeshFunction("size_t", mesh, "pn_physical_region.xml")


# Okrajove podmienky


# Dirichlet.
def boundary_E(x):
    return x[0] < DOLFIN_EPS
def boundary_C(x):
    #return x[0] == x_length
    return x[0] >= x_length-DOLFIN_EPS
def boundary_B(x):
    #x_B = x_BE + (x_BC-x_BE)/2
    #x_B = x_BE + (x_BC-x_BE)*0.9
    x_B = x_BE + (x_BC-x_BE)*1.0
    return x[0] > x_B-DOLFIN_EPS and x[0] < x_B+DOLFIN_EPS
def boundary_Bcon(x):
    x_Bconleft = x_BE + (x_BC-x_BE)*0.3
    x_Bconright = x_BC - (x_BC-x_BE)*0.3
    return x[0] > x_Bconleft-DOLFIN_EPS and x[0] < x_Bconright+DOLFIN_EPS and x[1] > y_length-DOLFIN_EPS

class neumann_Bcon(SubDomain):
    def inside(self, x, on_boundary):
        x_Bconleft = x_BE + (x_BC-x_BE)*0.3
        x_Bconright = x_BC - (x_BC-x_BE)*0.3
        #return x[0] > x_Bconleft-DOLFIN_EPS and x[0] < x_Bconright+DOLFIN_EPS and x[1] > y_length-DOLFIN_EPS and on_boundary
        return x[0] > x_Bconleft-DOLFIN_EPS and x[0] < x_Bconright+DOLFIN_EPS and x[1] > y_length-DOLFIN_EPS
        tol = 1E-14
        #return on_boundary and near(x[1], y_length, tol) and x[0]>=x_Bconleft-tol and x[0]<=x_Bconright+tol # +tol?

class neumann_Econ(SubDomain):
    def inside(self, x, on_boundary):
        tol = 1E-14
        return on_boundary and near(x[0], x_Econ, tol)

class neumann_Ccon(SubDomain):
    def inside(self, x, on_boundary):
        tol = 1E-14
        return on_boundary and near(x[0], x_Ccon, tol)


sub_domains = MeshFunction('size_t', mesh, mesh.topology().dim() - 1)
# marking facets
bcn_B = neumann_Bcon()
bcn_B.mark(sub_domains, 1)
bcn_E = neumann_Econ()
bcn_E.mark(sub_domains, 2)
bcn_C = neumann_Ccon()
bcn_C.mark(sub_domains, 3)

# redefinovat  measure ds:
ds = Measure('ds', domain=mesh, subdomain_data=sub_domains)
#dx = Measure('dx', domain=mesh, subdomain_data=sub_domains)

bc_psi_B = DirichletBC(V, Psi_B, boundary_Bcon)
bc_psi_E_nul = DirichletBC(V, Psi_E_nul, boundary_E)
bc_psi_E_neg = DirichletBC(V, Psi_E_neg, boundary_E)
bc_psi_E_neg2 = DirichletBC(V, Psi_E_neg2, boundary_E)
bc_psi_E_pos = DirichletBC(V, Psi_E_pos, boundary_E)
bc_psi_C_nul = DirichletBC(V, Psi_C_nul, boundary_C)
bc_psi_C_neg = DirichletBC(V, Psi_C_neg, boundary_C)
bc_psi_C_pos = DirichletBC(V, Psi_C_pos, boundary_C)
bc_n1 = DirichletBC(Vn, Nd_E, boundary_E)
bc_n2 = DirichletBC(Vn, Nd_C, boundary_C)
bc_p1 = DirichletBC(Vp, Na_E, boundary_E)
bc_p2 = DirichletBC(Vp, Na_C, boundary_C)

#V0 = FunctionSpace(mesh, "DG", 0)   # discontinuous Galerkin - konst. na 1 elemente, stupen 0 - konst.

## Neumann
#g = Expression("-vykon/vodivost", vykon=vykon, vodivost=vodivost_Si, t=0)


Nd = Expression("x[0]<x_BE ? Nd_E : x[0]<x_BC ? Nd_B : x[0]<x_drift ? Nd_drift : Nd_C", x_BE=x_BE, x_BC=x_BC, x_drift=x_drift, Nd_E=Nd_E, Nd_B=Nd_B, Nd_drift=Nd_drift, Nd_C=Nd_C, degree=1)
Na = Expression("x[0]<x_BE ? Na_E : x[0]<x_BC ? Na_B : x[0]<x_drift ? Na_drift : Na_C", x_BE=x_BE, x_BC=x_BC, x_drift=x_drift, Na_E=Na_E, Na_B=Na_B, Na_drift=Na_drift, Na_C=Na_C, degree=1)
#Nd = Expression("Nd*(-2*x[0]/xlen+2)", Nd=Nd2, xlen=LEN, degree=1)
#Na = Expression("Na*(2*x[0]/xlen+0)", Na=Nd2, xlen=LEN, degree=1)

N = Nd - Na

n0 = Nd
p0 = Na
#p0 = Expression("x[0] < x_junction-0.00000 ? Na1 : 0", x_junction=x_junction, Na1=Na1)
#n0 = Expression("x[0] > x_junction+0.000 ? Nd2 : 0", x_junction=x_junction, Nd2=Nd2)
#n0 = Constant(0)
#p0 = Constant(0)

mob_n = Expression("val_mob_n", val_mob_n=val_mob_n, degree=1)
mob_p = Expression("val_mob_p", val_mob_p=val_mob_p, degree=1)
D_n = Expression("val_D_n", val_D_n=val_D_n, degree=1)
D_p = Expression("val_D_p", val_D_p=val_D_p, degree=1)


####################
## Poisson
####################
rho = Expression("q * (p - n + Nd - Na)", q=q, p=p0, n=n0, Nd=Nd, Na=Na, degree=1)
g_Jb = Expression("-J/(q*(mob_n*n + mob_p*p))", q=q, mob_n=mob_n, mob_p=mob_p, p=p0, n=n0, J=Jb_pos, degree=1)
g_Jc = Expression("J/(q*(-mob_n*n + mob_p*p))", q=q, mob_n=mob_n, mob_p=mob_p, p=p0, n=n0, J=Jc_pos, degree=1)
#g_Jb = Constant('200')
#g_Jc = Constant('400')
#rho = Expression("0")
Psi = TrialFunction(V)
v_psi = TestFunction(V)
#a = -eps_Si * dot(grad(Psi), grad(v_psi)) * dx # v 2D funguje dot aj inner, v 1D neviem
#a = -eps_Si * inner(grad(Psi), grad(v_psi)) * dx
#L = -rho*v_psi*dx 
a = -inner(grad(Psi), grad(v_psi)) * dx
#L = -rho/eps_Si*v_psi*dx - g_Jb*v_psi*ds(1) - g_Jc*v_psi*ds(3)
L = -rho/eps_Si*v_psi*dx - g_Jb*v_psi*ds(1)
#L1 = -rho/eps_Si*v_psi*dx - g_Je*v_psi*ds(2) - g_Jb*v_psi*ds(1)

Psi_result = Function(V)
#solve(a==L, Psi_result, [bc_psi1, bc_psi2])

####################
## n, p Continuity
####################
n_i1 = Function(Vn)
n_i1.assign(n0)
n = TrialFunction(Vn)
vn = TestFunction(Vn)
#an = n*vn*dx + dt*Dn*inner(grad(n), grad(vn))*dx
an = n*vn*dx + dt*D_n*inner(grad(n), grad(vn))*dx
Ln = n_i1*vn*dx + dt*mob_n*n_i1*inner(grad(Psi_result), grad(vn))*dx

n_result = Function(Vn)
#solve(an==Ln, n_result, [bc_n1, bc_n2])

p_i1 = Function(Vp)
p_i1.assign(p0)
p = TrialFunction(Vp)
vp = TestFunction(Vp)
ap = p*vp*dx + dt*D_p*inner(grad(p), grad(vp))*dx
Lp = p_i1*vp*dx - dt*mob_p*p_i1*inner(grad(Psi_result), grad(vp))*dx

p_result = Function(Vp)
#solve(ap==Lp, p_result, [bc_p1, bc_p2])

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


n_result.assign(n0)
p_result.assign(p0)

#################
###ustaleny stav:
#################
for i in range(300):
    print("cycle (i):")
    print(i)
    print("Time:")
    print(t)
    solve(a==L, Psi_result, bc_psi_E_nul)
    #solve(an==Ln, n_result)
    #solve(ap==Lp, p_result)
    solve(an==Ln, n_result, [bc_n1, bc_n2])
    solve(ap==Lp, p_result, [bc_p1, bc_p2])
    #solve(an==Ln, n_result, [bc_n2])
    #solvt(ap==Lp, p_result, [ bc_p1])

    n_i1.assign(n_result)
    p_i1.assign(p_result)
    rho.n = n_result
    rho.p = p_result
    g_Jb.n = n_result
    g_Jb.p = p_result
    g_Jb.J = 0
    g_Jc.n = n_result
    g_Jc.p = p_result
    g_Jc.J = 0


Psi_builtin = ff.my_eval_on_line(Psi_result, V, LEN, Ystred)
Jn_diff = q*D_n*grad(n_result)
Jn_drift = -q*mob_n*n_result*grad(Psi_result)
Jp_diff = -q*D_p*grad(p_result)
Jp_drift = -q*mob_p*p_result*grad(Psi_result)
Jn = Jn_drift+Jn_diff
Jp = Jp_drift+Jp_diff
J = Jn+Jp

#J_vector.append(project(J[0], V)(XLEN, Ystred))

if pop_plot:
    ff.grafy1(axes, V, xx, Yhore, Ystred, Ydole, rho, N, n_result, p_result, Psi_result, J, Jn, Jp, Jn_drift, Jn_diff, Jp_drift, Jp_diff, t_vector, Psi_vector, J_vector)
else:
    ff.grafy_save(V, xx, Yhore, Ystred, Ydole, rho, N, n_result, p_result, Psi_result, J, Jn, Jp, Jn_drift, Jn_diff, Jp_drift, Jp_diff, t_vector, Psi_vector, J_vector, 'output/ustal_', filetype='eps')


    


time_i = [T1, T1+T2, T1+T2+T3]
time_i = [40*dt, 400*dt, 800*dt]
#time_i = [T1]
bcs_psi_i = [[DirichletBC(V, 0.0, sub_domains, 2)], [DirichletBC(V, 0.0, sub_domains, 2)], [DirichletBC(V, 0.0, sub_domains, 2)]] # 2 je Emitor (3 Collector, 1 Base)
Jb_i = [20e8, 10e8, 10e8]
Jc_i = [50e8, 30e8, 10e8]
Jb_i = [00e0, 0e+0, 0e+2]
Jc_i = [00e0, 1e+2, -1e+2]


num_steps = 10
bias_step_pos = [-1e-6*XX for XX in range(num_steps)]
bias_step_neg = [1e-5*XX for XX in range(2*num_steps)]
bias_step_neg_reversed = bias_step_neg[::-1]
bias_i = bias_step_neg + bias_step_neg_reversed + bias_step_pos
bcs_psi_i = [[]*5 + [DirichletBC(V, 0.0, sub_domains, 2), DirichletBC(V, XX, sub_domains, 3)] for XX in bias_i]
TIME_CYCLES = 500
ITER_PLOT = TIME_CYCLES
time_i = [TIME_CYCLES*dt*XX for XX in range(len(bias_i))]

j=0
for i in range(len(time_i)):
    print('i:', i)
    iter_plot = 0
    while(t<=time_i[i]):
        print("cycle (i):")
        print(i)
        print("Time:")
        print(t)
        solve(a==L, Psi_result, bcs_psi_i[i])
        #solve(an==Ln, n_result)
        #solve(ap==Lp, p_result)
        solve(an==Ln, n_result, [bc_n1, bc_n2])
        solve(ap==Lp, p_result, [bc_p1, bc_p2])
        #solve(an==Ln, n_result, [bc_n2])
        #solvt(ap==Lp, p_result, [ bc_p1])

        n_i1.assign(n_result)
        p_i1.assign(p_result)
        rho.n = n_result
        rho.p = p_result
        '''
        g_Jb.n = n_result
        g_Jb.p = p_result
        g_Jb.J = Jb_i[i]
        g_Jc.n = n_result
        g_Jc.p = p_result
        g_Jc.J = Jc_i[i]
        '''
        t += dt
        t_vector.append(t)

        '''
        Jn_diff = q*D_n*n_result.dx(0)
        Jn_drift = -q*mob_n*n_result*Psi_result.dx(0)
        Jp_diff = -q*D_p*p_result.dx(0)
        Jp_drift = -q*mob_p*p_result*Psi_result.dx(0)
        '''
        Jn_diff = q*D_n*grad(n_result)
        Jn_drift = -q*mob_n*n_result*grad(Psi_result)
        Jp_diff = -q*D_p*grad(p_result)
        Jp_drift = -q*mob_p*p_result*grad(Psi_result)
        Jn = Jn_drift+Jn_diff
        Jp = Jp_drift+Jp_diff
        J = Jn+Jp

        J_vector.append(project(J[0], V)(XLEN, Ystred))
        print('aaaaaaaaa')
        #Psi_BC_vector.append(project(Psi, V)(0, Ystred))
        Psi_vector.append(project(Psi_result, V)(XLEN, Ystred))
        
        
        iter_plot+=1
        if iter_plot == ITER_PLOT:
            j+=1
            print('i, j:', i, j)
            iter_plot = 0
            ### GRAFY:
            if pop_plot:
                ff.grafy1(axes, V, xx, Yhore, Ystred, Ydole, rho, N, n_result, p_result, Psi_result, J, Jn, Jp, Jn_drift, Jn_diff, Jp_drift, Jp_diff, t_vector, Psi_vector, J_vector)
            else:
                ff.grafy_save(V, xx, Yhore, Ystred, Ydole, rho, N, n_result, p_result, Psi_result, J, Jn, Jp, Jn_drift, Jn_diff, Jp_drift, Jp_diff, t_vector, Psi_vector, J_vector, 'output/iter_'+str(j), filetype='eps')

    J_vector_ustal.append(project(J[0], V)(XLEN, Ystred))
    Psi_vector_ustal.append(project(Psi_result, V)(XLEN, Ystred))
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

