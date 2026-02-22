This project was completed as a final project for CSCI1470: Deep Learning in Spring 2025 at Brown University. Urbanize explores how machine learning models internalize and reproduce human perceptions of urban environments, such as perceived wealth and liveliness, by training conditional generative models on large-scale crowdsourced data.

Urban environments

Background
Human perception of urban spaces—how safe, wealthy, lively, or beautiful a place appears—plays a critical role in city planning, social research, and public policy. Prior work such as Deep Learning the City (Dubey et al., 2016) demonstrated that these perceptions can be quantified at scale using pairwise comparisons of Google Street View images.

However, most existing work focuses on predicting perceptual attributes from images. Far less attention has been given to the inverse problem:
Can generative models learn and manipulate the visual cues that shape human perception of urban environments?

Urbanize addresses this gap by generating urban scenes conditioned on perceptual attributes, providing insight into how models encode socioeconomic and activity-based visual signals.

GitHub Repository:
https://github.com/jeffreymu1/urbanize

Final Poster (PDF):
https://drive.google.com/file/d/1nJrO0u9iBa9XqdJKSajn-ckW4DDPxzC0/view?usp=sharing

Algo

Project Goal
The primary goal of Urbanize was to design a controllable generative framework capable of synthesizing urban scenes that differ systematically in perceived wealth and liveliness, as judged by humans.

Specifically, we aimed to:

Train generative models on large-scale urban imagery
Condition image generation on human perception labels
Analyze which visual features emerge when models are optimized for perceptual traits
Compare conditioned outputs against an unconditioned baseline
Methodology
Dataset and Preprocessing
We used the Place Pulse 2.0 (PP2) dataset, consisting of 110,688 Google Street View images annotated via pairwise comparisons across perceptual attributes.

Preprocessing steps included:

Cropping images from 400×300 → 300×300
Normalization and augmentation for GAN training
Aggregation of pairwise judgments into continuous perception scores
The attributes considered included:

Wealthy
Lively
Safe
Beautiful
Boring
Depressing
Model Architecture
We implemented and trained four GAN variants:

Baseline GAN
Trained solely on raw images, without access to perception labels.

Wealth-Conditioned GAN
Conditioned on continuous “wealth” perception scores.

Multi-Attribute GAN
Conditioned on all available perceptual attributes.

Wealth + Lively GAN
Conditioned jointly on wealth and liveliness to study attribute interaction.

All models followed a standard adversarial training framework, with conditioning introduced through auxiliary inputs to the generator and discriminator.

GAN outputs

Training and Evaluation
Dataset split: 80% training / 10% validation / 10% testing
Baseline and single-attribute models trained for 100 epochs
Wealth + Lively model trained for 150 epochs
We monitored:

Generator output quality
Mode collapse
Discriminator confidence
Visual consistency across conditioning values
While quantitative metrics (e.g., FID) were tracked, qualitative visual analysis was the primary evaluation tool, given the subjective nature of perceptual attributes.

Results and Analysis
Baseline Model
Produced realistic urban scenes
Showed adversarial imbalance, with the discriminator stabilizing around ~10% confidence on generated images
Exhibited occasional mode collapse
Wealth-Conditioned Model
Consistently associated greenery, trees, and modern/tall buildings with high perceived wealth
Low-wealth generations tended toward sparse vegetation and older architectural styles
Wealth + Lively Model
Produced the strongest and most coherent results
High liveliness correlated with:
Cars
Dense building layouts
Visible activity cues
Combining wealthy + lively attributes yielded the most visually compelling outputs, suggesting strong synergy between these traits
Conflicting attribute combinations resulted in degraded or unstable generations, highlighting limitations in disentangling perceptual dimensions.

GAN outputs 2

What Worked and What Didn’t
Successes:

Demonstrated that GANs can internalize human perceptual biases
Clear, interpretable visual mappings from labels to features
Strong results for compatible attribute combinations
Effective pivot from an infeasible original project direction
Limitations:

Adversarial imbalance limited training stability
Resolution constrained to 300×300
Dependence on noisy, biased human perception labels
Difficulty modeling conflicting perceptual traits simultaneously
Conclusion
Urbanize shows that conditional generative models can do more than produce realistic images—they can encode and amplify the visual cues humans associate with socioeconomic and activity-based perceptions.

By generating urban scenes along perceptual dimensions such as wealth and liveliness, this project provides insight into how machine learning models reflect—and potentially reinforce—human visual bias. These findings raise important questions about fairness, interpretability, and downstream applications in urban analytics.

Future Work
Explore fine-grained feature manipulation (e.g., adding trees or façade changes)
Train higher-resolution or diffusion-based generative models
Investigate disentanglement of conflicting perceptual traits
Analyze and mitigate bias embedded in perceptual labels