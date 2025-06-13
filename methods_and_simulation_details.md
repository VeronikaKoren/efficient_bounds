
# Methods and Simulation Details

**Anonymous Author**  
**Anonymous Institute**

## Simulation of a Divergent Spiking Sequence

In Figure 1A, we show a simulation of a divergent spiking sequence. The spiking sequence is defined as

$$ \{ t_n = 1 - \frac{1}{\sqrt{n}} | n = 1, 2, \cdots, N, \; N < \infty \} $$

and is computed in the script `result_Figure1.m`.

## Simulation of the Biophysical Model

Figure 1B and Figure 2 use simulations of the biophysical model developed in previous works (Boerlin et al., 2013; Koren et al., 2025), consisting of an Excitatory-Inhibitory network of generalized integrate-and-fire neurons. The set of parameters necessary to replicate our simulations is specified in Table 1 and is the same as the default set of parameters in Koren et al. (2025).

### Specification of Model Parameters

In what follows, we briefly describe how model parameters were chosen (for further details, see Koren et al., 2025). The number of E neurons $N^E$, the number of input stimuli $M$, the time constant of the stimuli $\tau$ and the standard deviation of the distribution of decoding weights of E neurons $\sigma_w^E$ were chosen for their biological plausibility and computational simplicity. The ratio of the number of E to I neurons $N^E : N^I$, time constants of adaptation in E and I neurons $\tau_r^E$ and $\tau_r^I$, the noise intensity $\sigma$, the metabolic constant $\mu$ and the ratio of standard deviations of decoding weights $\sigma_w^I : \sigma_w^E$ were chosen as parameters that minimize the time-averaged Loss. The time-averaged Loss is defined as the weighted sum of the time-averaged square root of the Squared error and the time-averaged square root of the Metabolic cost. The default weighting of these two variables in the average Loss is $g = 0.7$ in favor of the Squared error against $1-g = 0.3$ for the Metabolic cost.

### Table 1: Default Model and Stimulus Parameters

| Parameter | Notation | Value |
|----------|----------|-------|
| Number of E neurons | $N^E$ | 400 |
| Ratio of E to I neurons | $N^E:N^I$ | 4:1 |
| Number of input features | $M$ | 3 |
| Time constant of population readout (E and I) | $\tau$ | 10 ms |
| Time constant of single neuron readout | $\tau_r^E = \tau_r^I$ | 10 ms |
| Noise strength | $\sigma$ | 5.0 mV |
| Mean of decoding weights (E and I) | $\mu_w^E = \mu_w^I$ | 0 (mV)$^{1/2}$ |
| Std. dev. of decoding weights (E) | $\sigma_w^E$ | 1.0 (mV)$^{1/2}$ |
| Ratio of std. devs. of decoding weights | $\sigma_w^I : \sigma_w^E$ | 3:1 |
| Metabolic constant | $\mu$ | 14 mV |
| Squared error vs Metabolic cost weight | $g$ | 0.7 |
| Time step | dt | 0.01 ms |
| Stimulus time constant | $\tau_s$ | 10 ms |
| Stimulus variance | $\sigma_s$ | 2 (mV)$^{1/2}$ |

### Table 2: Parameter Ranges for Exploration

| Notation | $N^E$ | $M$ | $\sigma$ | $\mu$ | $g$ | $\tau_s$ |
|----------|-------|-----|-----------|--------|-----|-----------|
| Range | 25–1600 | 1–50 | 0–16 mV | 0–50 mV | 0–1 | 5–50 ms |

### Numerical Simulation of the Biophysical Model

**Numerical Integration of the Membrane Potential.**  
We integrate stochastic differential equations using Euler's method. A spike is registered and the membrane potential is reset when a neuron hits its threshold. Synaptic delay is one time step.

**Computation of the Squared Error, Metabolic Cost, and Loss.**  
Using the spiking activity of the network, we compute the population readout $\hat{\vec{x}}^y(t)$ for $y \in \{E,I\}$. The Squared error for E is the squared distance between $\vec{x}(t)$ and $\hat{\vec{x}}^E(t)$ ; for I, it's between $\hat{\vec{x}}^E(t)$ and $\hat{\vec{x}}^I(t)$. Metabolic cost is computed as the sum of low-pass filtered spikes. Loss is a weighted sum of these two. Results are shown in Figure 2A.

**Spike-triggered Averages.**  
We computed values of variables just before and after spikes and averaged them. A negative jump at lag 0 ms indicates a decrease due to the spike, seen in Squared error and Loss. Metabolic cost always shows a positive jump. Results are in Figure 2B.

**Proportion of Error-Decreasing and Loss-Decreasing Spikes.**  
We measured how often spikes led to reductions in error or loss. If a spike caused a decrease in the respective metric, it was counted. Results are from 50s simulations and computed in `result_proportion_good_spikes.m`.

**Parameter Exploration.**  
We varied one parameter at a time while holding others fixed to evaluate effects on efficiency. Results are shown in Figure 2C and 2D. Scripts used include:  
- `result_Figure_2C_mu_sigma.m`  
- `result_Figure_2C_g.m`  
- `result_Figure_2C_network_size.m`  
- `result_Figure_2C_stimulus.m`

### Computation Time

A 10s simulation takes ~53s on a laptop. Most time is spent integrating membrane potentials.

## References

Boerlin, M., Machens, C. K., & Denève, S. (2013). Predictive coding of dynamical variables in balanced spiking networks. *PLoS Comput Biol*, 9(11): e1003258.  
Koren, V., Malerba, S. B., Schwalger, T., & Panzeri, S. (2025). Efficient coding in biophysically realistic excitatory-inhibitory spiking networks. *eLife*, 13: RP99545.
