# Urbanize

## Brief

A final project for Brown University's CSCI 147
0 - "Deep Learning" course in Spring 2025. Urbanize explores whether
conditional generative models can learn and reproduce human perceptions of urban environments — such as perceived
wealth and liveliness — by training on large-scale crowdsourced Street View data.

- **Project Type**: Team Project

- **Skills**: Python, Deep Learning, GANs, Conditional Generation, Remote Training (SLURM/OSCAR)

> Base GAN output samples
> 
> ![base_gan.png](/assets/assets/images/projects/urbanize/base_gan.png)

## Overview

Human perception of urban spaces — how wealthy, lively, safe, or beautiful a place looks — plays a real role in city
planning and social research. Most prior work focuses on predicting these attributes from images. Urbanize tackles
the inverse: can a model generate urban scenes that look more or less wealthy, more or less lively, on demand?

The project uses the Place Pulse 2.0 dataset — 110,688 Google Street View images annotated through pairwise human
comparisons across perceptual attributes — to train a series of conditional GAN variants.

My contributions covered model training, the GAN architecture and conditioning pipeline, image generation, and
running experiments remotely on Brown's OSCAR cluster via SLURM scripts.

### Model Architecture

We implemented and compared four GAN variants, progressing from a baseline to increasingly complex conditioning:

- **Baseline GAN** — trained on raw images only, no perception labels
- **Wealth-Conditioned GAN** — conditioned on continuous wealth perception scores
- **Multi-Attribute GAN** — conditioned on all six perceptual attributes
- **Wealth + Lively GAN** — jointly conditioned on wealth and liveliness

Conditioning was introduced through auxiliary inputs to both the generator and discriminator. All models used a
standard adversarial training setup with the PP2 dataset split 80/10/10 across train, validation, and test.

> Algorithmic overview of the GAN architecture
> 
> ![algo.png](/assets/assets/images/projects/urbanize/algo.png)
> 

### Training on OSCAR

Training GANs on a dataset this size locally wasn't practical, so I set up and managed remote training jobs on
Brown's OSCAR computing cluster using SLURM scripts. This involved writing job submission scripts, managing
checkpointing, and monitoring runs — a good introduction to working with HPC infrastructure.

### Results

The single-attribute wealth model produced clear and interpretable results — high wealth generations consistently
showed greenery, modern buildings, and wide streets, while low wealth leaned toward sparse vegetation and older
architecture.



The Wealth + Lively combination was our strongest model. High liveliness correlated with denser building layouts,
visible cars, and general activity cues. The two attributes seemed to complement each other well, producing
coherent and visually compelling outputs.

> Wealthy Lively GAN results, left to right: low to high wealth. top to bottom: low to high liveliness.
> 
> ![wealthy_lively.png](/assets/assets/images/projects/urbanize/wealthy_lively.png)
> 
> ![wealthy_lively_2.png](/assets/assets/images/projects/urbanize/wealthy_lively_2.png)

### Challenges

Training stability was the biggest difficulty throughout. The discriminator would often gain too much confidence
early on, throwing off the adversarial balance. Mode collapse was a recurring issue — the generator would settle
into producing near-identical scenes regardless of the conditioning input.

The multi-attribute model was where this hit hardest. With more than two attributes, the generator struggled to
meaningfully differentiate outputs. Conflicting attribute combinations — like wealthy but depressing — were
particularly difficult to model, resulting in degraded or unstable generations. We had the most consistent luck
keeping it to two complementary attributes.

<!-- Image: Comparison of conditioned outputs -->
