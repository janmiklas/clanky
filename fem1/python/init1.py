from dolfin import *
import numpy
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.ticker import NullFormatter
from time import sleep
import ff as ff
#import fff
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

q = 1.602e-19
eps0 = 8.854e-12 * 1/m2cm # [F / m] * 1/m2cm
epsr_Si = 11.68
eps_Si = eps0 * epsr_Si
'''
Na_E= 0
Nd_E= 1e+1 #1e14
Na_C= 0
Nd_C= 1e+1 #1e14
'''
Na_E= 1e+14
Nd_E= 0e+1 #1e14
Na_C= 0
Nd_C= 1e+14 #1e14

LEN = XLEN = x_length = 3e-3
YLEN = y_length = .2e-4
x_Econ = 0
x_junct = XLEN / 2
x_Ccon = x_length

val_mob_n = 1e3 #1400 # [cm2 / V / s]
val_mob_p =  1e3 #450
val_D_n =  1 #36 # [cm2 / s]
val_D_p =  1 #12

val_mob_n = 1e4 #1400 # [cm2 / V / s]
val_mob_p =  1e4 #450
val_D_n =  1e-1 #36 # [cm2 / s]
val_D_p =  1e-1 #12

val_mob_n = 1400 #1400 # [cm2 / V / s]
val_mob_p =  450 #450
val_D_n =  36 #36 # [cm2 / s]
val_D_p =  12 #12

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
bcn_E = neumann_Econ()
bcn_E.mark(sub_domains, 1)
bcn_C = neumann_Ccon()
bcn_C.mark(sub_domains, 2)

# redefinovat  measure ds:
ds = Measure('ds', domain=mesh, subdomain_data=sub_domains)
#dx = Measure('dx', domain=mesh, subdomain_data=sub_domains)

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



Nd = Expression('x[0]<x_junct ? Nd_E: Nd_C', x_junct=x_junct, Nd_E=Nd_E, Nd_C=Nd_C, degree=1)
Na = Expression('x[0]<x_junct ? Na_E: Na_C', x_junct=x_junct, Na_E=Na_E, Na_C=Na_C, degree=1)
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




xcoord = mesh.coordinates()[:,0]
#xx1 = xx1d = mesh.coordinater()[:,0][:nx+1]
xx1 = xx1d = np.linspace(0, x_length, 1000)
xx = xx1
Yhore = y_length
Ystred = y_length/2.
Ydole = 0.
yy_doping = project(N, V).vector().get_local()

plt.ion()
#fig, axes = plt.subplots(3, 2, sharex='col')
fig, axes = plt.subplots(3, 2)

