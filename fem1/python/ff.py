from dolfin import *
import numpy
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.ticker import NullFormatter
from time import sleep
import ff as ff
import matplotlib.tri as tri

plt.style.use('classic')


def my_eval_on_line(u, V, xx, yy):
    ## kontrola 'isiterable':
    if not hasattr(xx, '__iter__'):
        xx = [xx]
    if not hasattr(yy, '__iter__'):
        yy = [yy]
    #uu = interpolate(u, V)
    uu = project(u, V)
    return(np.array([uu(X,Y) for X in xx for Y in yy]))

def mesh2triang(mesh):
    xy = mesh.coordinates()
    return tri.Triangulation(xy[:, 0], xy[:, 1], mesh.cells())

def myplot_2d(obj, ax, num_contours=10, plotmesh=True, aspect_equal=False):
    #plt.gca().set_aspect('equal')
    if aspect_equal == True:
        ax.set_aspect('equal')
    if isinstance(obj, Function):
        mesh = obj.function_space().mesh()
        if (mesh.geometry().dim() != 2):
            raise(AttributeError)
        if obj.vector().size() == mesh.num_cells():
            C = obj.vector().array()
            ax.tripcolor(mesh2triang(mesh), C)
        else:
            C = obj.compute_vertex_values(mesh)
            ax.tricontour(mesh2triang(mesh), C, num_contours,linewidths=.5, colors='k')
            ax.tripcolor(mesh2triang(mesh), C, shading='gouraud')
    elif isinstance(obj, Mesh):
        if (obj.geometry().dim() != 2):
            raise(AttributeError)
        if plotmesh == True:
            ax.triplot(mesh2triang(obj), color='k')

def grafy1(axes, V, xx, Yhore, Ystred, Ydole, rho, N, n_result, p_result, Psi_result, J, Jn, Jp, Jn_drift, Jn_diff, Jp_drift, Jp_diff, t_vector, Psi_vector, J_vector, with_legend=False):
    ### GRAFY:

    linestyles = ['-', '--', '-.', ':']

    ax = axes[0,0]
    ax.cla()
    #l1 = ax.plot(xx, project(rho, V).vector().get_local(), "k", linestyle = linestyles[0], label = r"rho")
    #l2= ax.plot(xx, project(N, V).vector().get_local(), "k", linestyle = linestyles[1], label = r"doping")
    #l3 = ax.plot(xx, n_result.vector().get_local(), "b", linestyle = linestyles[0], label = r"n")
    #l4 = ax.plot(xx, p_result.vector().get_local(), "g", linestyle = linestyles[0], label = r"p")
    
    l1 = ax.plot(xx, my_eval_on_line(rho, V, xx, Ystred), "k", linestyle = linestyles[0], label = r"rho")
    l2= ax.plot(xx, my_eval_on_line(N, V, xx, Ystred), "k", linestyle = linestyles[1], label = r"doping")
    l3 = ax.plot(xx, my_eval_on_line(n_result, V, xx, Ystred), "b", linestyle = linestyles[0], label = r"n")
    l4 = ax.plot(xx, my_eval_on_line(p_result, V, xx, Ystred), "g", linestyle = linestyles[0], label = r"p")
    ax.set_ylabel(r'rho')
    #ax.set_xlim([0, LEN])
    #plt1.xaxis.set_major_formatter(NullFormatter())
    #ax.yaxis.set_major_formatter(NullFormatter())
    #ax.grid()
    #ax.legend()

    ax = axes[2,0]
    ax.cla()
    ax.set_ylabel(r'Psi')
    #ax.plot(xx, Psi_result.vector().get_local(), "k", linestyle = linestyles[0], label = r"Psi")
    ax.plot(xx, my_eval_on_line(Psi_result, V, xx, Yhore), "r", linestyle = linestyles[0], label = r"Psi")
    ax.plot(xx, my_eval_on_line(Psi_result, V, xx, Ystred), "k", linestyle = linestyles[0], label = r"Psi")
    ax.plot(xx, my_eval_on_line(Psi_result, V, xx, Ydole), "b", linestyle = linestyles[0], label = r"Psi")
    #plt1.xaxis.set_major_formatter(NullFormatter())
    #ax.grid()
    if with_legend:
        ax.legend()


    ax = axes[1,0]
    ax.cla()
    ax.set_ylabel(r'J')
    #ax.plot(xx, project(J, V).vector().get_local(), "k-", label = r"J")
    #ax.plot(xx, project(Jn, V).vector().get_local(), "b-", label = r"Jn")
    #ax.plot(xx, project(Jp, V).vector().get_local(), "g-", label = r"Jp")
    #ax.plot(xx, project(Jn_diff, V).vector().get_local(), "b--", label = r"Jn_diff")
    #ax.plot(xx, project(Jn_drift, V).vector().get_local(), "b:", label = r"Jn_drift")
    #ax.plot(xx, project(Jp_diff, V).vector().get_local(), "g--", label = r"Jp_diff")
    #ax.plot(xx, project(Jp_drift, V).vector().get_local(), "g:", label = r"Jp_drift")
    ax.plot(xx, my_eval_on_line(J[0], V, xx, Ystred), "k-", label = r"J") # grad(u)[0] je x-ova zlozka
    ax.plot(xx, my_eval_on_line(Jn[0], V, xx, Ystred), "b-", label = r"Jn")
    ax.plot(xx, my_eval_on_line(Jp[0], V, xx, Ystred), "g-", label = r"Jp")
    ax.plot(xx, my_eval_on_line(Jn_diff[0], V, xx, Ystred), "b--", label = r"Jn_diff")
    ax.plot(xx, my_eval_on_line(Jn_drift[0], V, xx, Ystred), "b:", label = r"Jn_drift")
    ax.plot(xx, my_eval_on_line(Jp_diff[0], V, xx, Ystred), "g--", label = r"Jp_diff")
    ax.plot(xx, my_eval_on_line(Jp_drift[0], V, xx, Ystred), "g:", label = r"Jp_drift")

    '''
    ax.plot(xx, my_eval_on_line(J[0], V, xx, Yhore), "k-", alpha=0.3, label = r"J") # grad(u)[0] je x-ova zlozka
    ax.plot(xx, my_eval_on_line(Jn[0], V, xx, Yhore), "b-", alpha=0.3, label = r"Jn")
    ax.plot(xx, my_eval_on_line(Jp[0], V, xx, Yhore), "g-", alpha=0.3, label = r"Jp")
    ax.plot(xx, my_eval_on_line(Jn_diff[0], V, xx, Yhore), "b--", alpha=0.3, label = r"Jn_diff")
    ax.plot(xx, my_eval_on_line(Jn_drift[0], V, xx, Yhore), "b:", label = r"Jn_drift")
    ax.plot(xx, my_eval_on_line(Jp_diff[0], V, xx, Yhore), "g--", alpha=0.3, label = r"Jp_diff")
    ax.plot(xx, my_eval_on_line(Jp_drift[0], V, xx, Yhore), "g:", label = r"Jp_drift")
    #plt1.xaxis.set_major_formatter(NullFormatter())
    #ax.grid()
    #ax.legend()
    '''

    ### J Jn Jp ###
    ax = axes[0,1]
    ax.cla()
    ax.set_ylabel(r'J')
    ax.plot(xx, my_eval_on_line(J[0], V, xx, Ystred), "k-", label = r"J") # grad(u)[0] je x-ova zlozka
    ax.plot(xx, my_eval_on_line(Jn[0], V, xx, Ystred), "b-", label = r"Jn")
    ax.plot(xx, my_eval_on_line(Jp[0], V, xx, Ystred), "g-", label = r"Jp")

    '''
    triang=mesh2triang(mesh)
    each=1*(ny+1)
    each = int(nx/10)
    each = 10

    ax = axes[0,1]
    ax.cla()
    ax.set_ylabel(r'')
    myplot_2d(n_result, ax, num_contours=30)
    ax.quiver(triang.x[::each], triang.y[::each], project(Jn[0], V).compute_vertex_values(mesh)[::each], project(Jn[1], V).compute_vertex_values(mesh)[::each], color='w')
    
    ax = axes[1,1]
    ax.cla()
    ax.set_ylabel(r'')
    myplot_2d(n_result, ax, num_contours=30)
    ax.quiver(triang.x[0::each], triang.y[0::each], project(Jp[0], V).compute_vertex_values(mesh)[0::each], project(Jp[1], V).compute_vertex_values(mesh)[0::each], color='w')
    ''' 
    #ax = axes[2,1]
    #ax.cla()
    #ax.set_ylabel(r'')
    ##ax.plot(xx, project(Psi_result.dx(0), V).vector().get_local(), "k", linestyle = linestyles[0], label = r"grad(Psi)")
    #ax.plot(xx, my_eval_on_line(Psi_result.dx(0), V, xx, Ystred), "k", linestyle = linestyles[0], label = r"grad(Psi)")
    #ax.plot(xx, my_eval_on_line(g_Jb, V, xx, Ystred), "b", linestyle = linestyles[1], label = r"g_Jb")
    #ax.plot(xx, my_eval_on_line(g_Jc, V, xx, Ystred), "k", linestyle = linestyles[1], label = r"g_Jc")

    #ax = axes[2,1]
    #ax.cla()
    #ax.set_ylabel(r'Psi')
    #myplot_2d(Psi_result, ax, num_contours=30)

    ax = axes[1,1]
    ax.cla()
    ax.set_ylabel(r'IV')
    ax.plot(Psi_vector[1:], J_vector[1:], '.')
    #ax.set_ylim(ymin=-20)
    
    ax = axes[2,1]
    ax.cla()
    ax.set_ylabel(r'vs time')
    #ax.plot(t_vector[1:], Psi_vector[1:], 'b')
    ax.plot(t_vector[1:], np.array(J_vector[1:])/1e2, 'r')
    
    plt.xlabel(r'x (cm)')

    #plt.subplots_adjust(wspace=0, hspace=0)
    
    plt.draw()
    plt.pause(0.05)
    #sleep(0.5)


def grafy_save(V, xx, Yhore, Ystred, Ydole, rho, N, n_result, p_result, Psi_result, J, Jn, Jp, Jn_drift, Jn_diff, Jp_drift, Jp_diff, t_vector, Psi_vector, J_vector, savename_prefix, filetype='png', with_legend=True):
    ### GRAFY:

    bezrozmerne = True

    linestyles = ['-', '--', '-.', ':']

    fig, axes = plt.subplots(1, 1)
    ax = axes
    ax.cla()
    
    l1 = ax.plot(xx, my_eval_on_line(rho, V, xx, Ystred), "k", linestyle = linestyles[0], label = r"rho")
    l2= ax.plot(xx, my_eval_on_line(N, V, xx, Ystred), "k", linestyle = linestyles[1], label = r"doping")
    l3 = ax.plot(xx, my_eval_on_line(n_result, V, xx, Ystred), "b", linestyle = linestyles[0], label = r"n")
    l4 = ax.plot(xx, my_eval_on_line(p_result, V, xx, Ystred), "g", linestyle = linestyles[0], label = r"p")
    ax.set_xlabel(r'x')
    ax.set_ylabel(r'rho')
    #ax.set_xlim([0, LEN])
    #plt1.xaxis.set_major_formatter(NullFormatter())
    if bezrozmerne:
        ax.yaxis.set_major_formatter(NullFormatter())
        ax.set_yticks([0])
        ax.set_xticks([])
        ax.grid()
    if with_legend:
        ax.legend()
    fig.savefig(savename_prefix + '_N.' + filetype)

    ax = axes
    ax.cla()
    ax.set_xlabel(r'x')
    ax.set_ylabel(r'Psi')
    #ax.plot(xx, Psi_result.vector().get_local(), "k", linestyle = linestyles[0], label = r"Psi")
    ax.plot(xx, my_eval_on_line(Psi_result, V, xx, Yhore), "r", linestyle = linestyles[0], label = r"Psi")
    ax.plot(xx, my_eval_on_line(Psi_result, V, xx, Ystred), "k", linestyle = linestyles[0], label = r"Psi")
    ax.plot(xx, my_eval_on_line(Psi_result, V, xx, Ydole), "b", linestyle = linestyles[0], label = r"Psi")
    #plt1.xaxis.set_major_formatter(NullFormatter())
    if bezrozmerne:
        ax.yaxis.set_major_formatter(NullFormatter())
        ax.set_yticks([0])
        ax.set_xticks([])
        ax.grid()
    if with_legend:
        ax.legend()
    fig.savefig(savename_prefix + '_Psi.' + filetype)


    ### J ###
    ax = axes
    ax.cla()
    ax.set_xlabel(r'x')
    ax.set_ylabel(r'J')
    ax.plot(xx, my_eval_on_line(J[0], V, xx, Ystred), "k-", label = r"J") # grad(u)[0] je x-ova zlozka
    ax.plot(xx, my_eval_on_line(Jn[0], V, xx, Ystred), "b-", label = r"Jn")
    ax.plot(xx, my_eval_on_line(Jp[0], V, xx, Ystred), "g-", label = r"Jp")
    ax.plot(xx, my_eval_on_line(Jn_diff[0], V, xx, Ystred), "b--", label = r"Jn_diff")
    ax.plot(xx, my_eval_on_line(Jn_drift[0], V, xx, Ystred), "b:", label = r"Jn_drift")
    ax.plot(xx, my_eval_on_line(Jp_diff[0], V, xx, Ystred), "g--", label = r"Jp_diff")
    ax.plot(xx, my_eval_on_line(Jp_drift[0], V, xx, Ystred), "g:", label = r"Jp_drift")

    '''
    ax.plot(xx, my_eval_on_line(J[0], V, xx, Yhore), "k-", alpha=0.3, label = r"J") # grad(u)[0] je x-ova zlozka
    ax.plot(xx, my_eval_on_line(Jn[0], V, xx, Yhore), "b-", alpha=0.3, label = r"Jn")
    ax.plot(xx, my_eval_on_line(Jp[0], V, xx, Yhore), "g-", alpha=0.3, label = r"Jp")
    ax.plot(xx, my_eval_on_line(Jn_diff[0], V, xx, Yhore), "b--", alpha=0.3, label = r"Jn_diff")
    ax.plot(xx, my_eval_on_line(Jn_drift[0], V, xx, Yhore), "b:", label = r"Jn_drift")
    ax.plot(xx, my_eval_on_line(Jp_diff[0], V, xx, Yhore), "g--", alpha=0.3, label = r"Jp_diff")
    ax.plot(xx, my_eval_on_line(Jp_drift[0], V, xx, Yhore), "g:", label = r"Jp_drift")
    '''
    #plt1.xaxis.set_major_formatter(NullFormatter())
    #ax.grid()
    if bezrozmerne:
        ax.yaxis.set_major_formatter(NullFormatter())
        ax.set_yticks([0])
        ax.set_xticks([])
        ax.grid()
    if with_legend:
        ax.legend()
    fig.savefig(savename_prefix + '_J.' + filetype)

    ### J, Jn, Jp ###
    ax = axes
    ax.cla()
    ax.set_xlabel(r'x')
    ax.set_ylabel(r'J')
    ax.plot(xx, my_eval_on_line(J[0], V, xx, Ystred), "k-", label = r"J") # grad(u)[0] je x-ova zlozka
    ax.plot(xx, my_eval_on_line(Jn[0], V, xx, Ystred), "b-", label = r"Jn")
    ax.plot(xx, my_eval_on_line(Jp[0], V, xx, Ystred), "g-", label = r"Jp")
    #plt1.xaxis.set_major_formatter(NullFormatter())
    #ax.grid()
    if bezrozmerne:
        ax.yaxis.set_major_formatter(NullFormatter())
        ax.set_yticks([0])
        ax.set_xticks([])
        ax.grid()
    if with_legend:
        ax.legend()
    fig.savefig(savename_prefix + '_JnJp.' + filetype)
