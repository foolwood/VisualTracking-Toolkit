import numpy as np
import matplotlib.pyplot as plt
import imageio


def draw_arch(arch, draw_aspp=False):
    ax = plt.axes()
    r = 0.2
    for i in range(12):
        for j in range(4):
            if j > (i+1):
                continue
            circle = plt.Circle((i, 4 - j), radius=r+0.05, color='lightgrey')
            ax.add_patch(circle)
            circle = plt.Circle((i, 4-j), radius=r, color='dodgerblue')
            ax.add_patch(circle)

    for i, j in [[-3,-2],[-2,-1],[-1, 0]]:
        circle = plt.Circle((i, 4 - j), radius=r+0.05, color='lightgrey')
        ax.add_patch(circle)
        circle = plt.Circle((i, 4-j), radius=r, color='whitesmoke')
        ax.add_patch(circle)

    if draw_aspp:
        i = 12
        for j in range(4):
            ax.add_patch(plt.Polygon([[i-r, 4-j+3*r],[i-r, 4-j-3*r],[i+3*r,4-j-2*r],[i+3*r,4-j+2*r]], facecolor='white', edgecolor='lightgrey', alpha=1))
            plt.text(i+0.5*r, 4-j, 'AS\nPP', fontsize=8, rotation=270, verticalalignment='center', horizontalalignment='center')
    i = -4
    for j in range(-2,4):
        plt.text(i, 4-j, str(int(4* 2**j)), fontsize=8, verticalalignment='center',horizontalalignment='center')

    j = -3
    plt.text(-2.3, 4-j, "Downsample\Layer", fontsize=8, verticalalignment='center',horizontalalignment='center')
    for i in range(1, 6):
        plt.text(i-1, 4-j, str(i), fontsize=8, verticalalignment='center',horizontalalignment='center')

    plt.text(7, 4-j, "......", fontsize=8, verticalalignment='center',horizontalalignment='center')
    plt.text(10, 4-j, "L-1", fontsize=8, verticalalignment='center',horizontalalignment='center')
    plt.text(11, 4-j, "L", fontsize=8, verticalalignment='center',horizontalalignment='center')

    r = r+0.03
    for i, j in [[-3,-2],[-2,-1]]:
        ax.arrow(i+r*np.sqrt(0.5), 4 - j-r*np.sqrt(0.5), 1-2*r*np.sqrt(0.5)-0.1, -1+2*r*np.sqrt(0.5)+0.1, head_width=0.1, head_length=0.1, fc='k', ec='k')

    for i in range(-1, 11):
        for j in range(4):
            if j > (i+1):
                continue
            if arch[i+1] == j and arch[i+1] == (arch[i+2]+1):
                color = 'k'
            else:
                color = 'silver'

            if arch[i+1] == j and (arch[i+1] == arch[i+2]):
                color1 = 'k'
            else:
                color1 = 'silver'

            if arch[i+1] == j and arch[i+1] == (arch[i+2]-1):
                color2 = 'k'
            else:
                color2 = 'silver'

            if j != 0 and (arch[i+1] == -1 or color == 'k'):
                ax.arrow(i+r*np.sqrt(0.5), 4 - j+r*np.sqrt(0.5), 1-2*r*np.sqrt(0.5)-0.1, +1-2*r*np.sqrt(0.5)-0.1, head_width=0.1, head_length=0.1, fc=color, ec=color)
            if arch[i+1] == -1 or color1 == 'k':
                ax.arrow(i+r, 4 - j, 1-2*r-0.14, +0, head_width=0.1, head_length=0.1, fc=color1, ec=color1)
            if j != 3 and (arch[i+1] == -1 or color2 == 'k'):
                ax.arrow(i+r*np.sqrt(0.5), 4 - j-r*np.sqrt(0.5), 1-2*r*np.sqrt(0.5)-0.1, -1+2*r*np.sqrt(0.5)+0.1, head_width=0.1, head_length=0.1, fc=color2, ec=color2)

    i = 11
    if arch[-1] == -1:
        for j in range(4):
            ax.arrow(i+r, 4 - j, 1-2*r-0.14, +0, head_width=0.1, head_length=0.1, fc='k', ec='k')
    else:
        ax.arrow(i + r, 4 - arch[-1], 1 - 2 * r - 0.14, +0, head_width=0.1, head_length=0.1, fc='k', ec='k')


    plt.axis('scaled')

    ax.set_axis_off()
    ax.get_xaxis().set_visible(False)
    ax.get_yaxis().set_visible(False)


if __name__ == '__main__':
    archs = {
        'default':[-1]*13,
        'deeplabv3':[0] + [1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2],
        'conv-deconv':[0] + [0, 1, 1, 2, 2, 3, 3, 2, 2, 1, 1, 0],
        'hourglass':[0] + [1, 2, 3, 2, 1, 0, 1, 2, 3, 2, 1, 0],
        'autodeeplab':[0] + [0, 0, 0, 1, 2, 1, 2, 2, 3, 3, 2, 1]
    }

    out_gif_name = 'Auto-DeepLab.gif'
    ims = []
    for mode in ['default', 'deeplabv3', 'conv-deconv', 'hourglass', 'autodeeplab']:
        arch = archs[mode]
        draw_arch(arch, draw_aspp=mode in ['default', 'deeplabv3', 'autodeeplab'])
        plt.savefig(mode + '_arch.pdf')
        plt.savefig(mode + '_arch.png')
        ims.append(imageio.imread(mode + '_arch.png'))
        plt.show()
    imageio.mimsave(out_gif_name, ims, 'GIF', duration=1)
