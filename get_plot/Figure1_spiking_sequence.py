import sys, os
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))
import numpy as np
import matplotlib.pyplot as plt
import scipy.io as sio
from matplotlib.ticker import ScalarFormatter

# Set custom style


# Set Seaborn style
# sns.set(style='whitegrid')
plt.style.use({
    'font.family': 'sans-serif',  # Choose a serif font
    'font.serif': ['Arial'],  # Specify the serif font
    'font.size': 7,  # Set the font size
    'axes.labelsize': 9,  # Set the label size
    'axes.titlesize': 9,  # Set the title size
    'axes.titleweight': "bold",
    'xtick.labelsize': 9,  # Set the x-axis tick label size
    'ytick.labelsize': 9,  # Set the y-axis tick label size
    'legend.fontsize': 7  # Set the legend font size
})


# Define the spiking time function
def spiking_time_log(n):
    return 1 - 1 / np.log2(n + 1)

def spiking_time_inv(n):
    return 1 - 1 / (n + 1)

def spiking_time_invsqr(n):
    return 1 - 1 / (n + 1)**2

def spiking_time_sqrrt(n):
    return 1 - 1 / np.sqrt(n + 1)

def spiking_time_cbrt(n):
    return 1 - 1 / np.cbrt(n + 1)



# Generate n values for the spiking times
n_values = np.arange(1, 10000)
spike_times = spiking_time_sqrrt(n_values)
spiking_exc_raw = sio.loadmat('spiking_Exc.mat')
spike_times_efficient = spiking_exc_raw['fe']
highest_spiking_neuron = np.argmax(np.sum(spike_times_efficient,axis=1))
spk_times_neuron = np.nonzero(spike_times_efficient[highest_spiking_neuron,5000:15000])
spk_times_neuron = (spk_times_neuron - np.min(spk_times_neuron))/np.max(spk_times_neuron)

# Create the plot
cm = 1/2.54  # centimeters in inches
figsize = (12*cm, 6*cm)
fig, axes = plt.subplots(3,2, figsize=figsize, dpi=300, gridspec_kw={'height_ratios': [2.5, 1, 3]}, sharex=True)

lw = 0.5  # line width for membrane potential

# Plot the spiking times
for i, spike_time in enumerate(spike_times):
    if i == 0:
        axes[0,0].plot([0, spike_time], [0, 2], 'k-', linewidth=lw, label='Membrane \n Potential')
    else:
        axes[0,0].plot([spike_times[i - 1], spike_time], [0, 2], 'k-', linewidth=lw)
    # add horizontal dotted line to the current spike time going to 0
    axes[0,0].plot([spike_time, spike_time], [0, 2], 'k--', linewidth=lw)

for i, spike_time in enumerate(np.squeeze(spk_times_neuron)):
    if i == 0:
        axes[0,1].plot([0, spike_time], [0, 2], 'k-', linewidth=lw, label='Membrane\nPotential')
    else:
        axes[0,1].plot([spk_times_neuron[0,i - 1], spike_time], [0, 2], 'k-', linewidth=lw)
    # add horizontal dotted line to the current spike time going to 0
    axes[0,1].plot([spike_time, spike_time], [0, 2], 'k--', linewidth=lw)

plt.tight_layout()

# Turns off grid
axes[0,0].grid(False)

# Plot the reset potential

limits_linewidth=.8
axes[0,0].axhline(y=0, color='g', linestyle='--', linewidth=limits_linewidth, label='Reset Potential')
axes[0,1].axhline(y=0, color='g', linestyle='--', linewidth=limits_linewidth, label='Reset Potential')
# Plot the firing threshold
axes[0,0].axhline(y=2, color='r', linestyle='--', linewidth=limits_linewidth, label='Firing Threshold')
axes[0,1].axhline(y=2, color='r', linestyle='--', linewidth=limits_linewidth, label='Firing Threshold')
# Add legend
#ax.legend(bbox_to_anchor=(1.04, 1), loc="upper left")

# Add labels and title
#axes[0,0].set_ylabel('Membrane Potential')
axes[0,0].set_title('Convergent Spiking Example')
axes[0,1].set_title('Non-convergent Spiking Sequence')
plt.tight_layout()

# Show ticks only for the firing threshold and voltage reset
axes[0,0].set_yticks([0, 2])
axes[0,0].set_yticklabels(['$V_{\\mathrm{reset}}$', '$V_{\\mathrm{th}}$'])
axes[0,1].set_yticks([0, 2])
axes[0,1].set_yticklabels([])
axes[0,0].tick_params(axis='both', which='major', pad=5)

axes[0,0].set_xticks([])
axes[0,0].set_xticklabels([])
axes[0,0].set_ylabel('Membrane potential')

plt.tight_layout()

axes[1,0].eventplot(spike_times, linewidths=.2, colors='k')
axes[1,0].set_xticks([])
axes[1,0].set_xticklabels([])
axes[1,0].set_yticks([])
axes[1,0].set_yticklabels([])

axes[1,1].eventplot(spk_times_neuron, linewidths=.2, colors='k')
axes[1,1].set_yticks([])
axes[1,1].set_yticklabels([])
axes[1,0].set_ylabel('Spikes')

plt.tight_layout()


hist, bin_edges = np.histogram(spike_times, bins=70)
bin_midpoints = (bin_edges[1:]+bin_edges[:-1])/2
hist = np.insert(hist, 0, 0)
bin_midpoints = np.insert(bin_midpoints, 0, 0)
hist *= 80
# axes[2,0].hist(spike_times, bins='auto')
axes[2,0].axvline(x=1, color='k', linestyle='--', linewidth=.8)
axes[2,0].plot(bin_midpoints, hist, 'k', linewidth=.8, solid_capstyle='round')
axes[2,0].set_xlabel('Time [s]')
axes[2,0].set_ylabel('Spike \n rate [sp/s]')
axes[2,1].set_xlabel('Time [s]')

axes[2,0].set_xticks([0,1])
axes[2,0].set_xticklabels([0,1])
plt.tight_layout()

hist, bin_edges = np.histogram(spk_times_neuron)
print(hist.shape)
hist *= 10
bin_midpoints = (bin_edges[1:]+bin_edges[:-1])/2
hist = np.insert(hist, 0, hist[0])
hist = np.append(hist, hist[-1])

bin_midpoints = np.insert(bin_midpoints, 0, 0)
bin_midpoints = np.append(bin_midpoints, 1)
axes[2,1].plot(bin_midpoints, hist, 'k', linewidth=.8, solid_capstyle='round')
axes[2,0].margins(.1, .1)
axes[2,1].margins(.1, .1)
axes[2,0].yaxis.set_major_formatter(ScalarFormatter(useMathText=True))
axes[2,0].ticklabel_format(style='sci', axis='y', scilimits=(0,0))
plt.tight_layout()
plt.savefig('fig1.svg')

