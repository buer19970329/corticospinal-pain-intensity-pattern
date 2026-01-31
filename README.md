# corticospinal-pain-intensity-pattern (CsPIP)

This repository contains the code accompanying the paper **"A Predictive Corticospinal Model for Pain Perception"**. It includes all the Jupyter notebooks used for analyses and figure generation in the study.

---

## Contents

- [Requirements](#requirements)
- [Notebooks](#notebooks)
  - [01_model_training.ipynb](#01_model_training.ipynb)
  - [02_model_specificity.ipynb](#02_model_specificity.ipynb)
  - [03_model_tens.ipynb](#03_model_tens.ipynb)

---

## Requirements

- Python 3
- NumPy, SciPy (version 1.13.1), antspyx (version 0.4.2), Nibabel (version 5.2.1), pingouin (version 0.5.4), and scikit-learn (version 1.3.0).
(version tested on nilearn 0.11.1, Scipy 1.11.4, scikit-learn 1.5.2)

## Installation (1 min)
python -m pip install numpy antspyx nibabel pingouin scikit-learn
## Notebooks

**01_model_training.ipynb**

Description: CsPIP Training

Contents:

```
This notebook implements the primary predictive-model training pipeline for the CsPIP dataset. After loading pre-split neuro-behavioural matrices (d1_train_*, d1_test_*), it constructs a standardised PCA → Lasso regression (Lasso-PCR) pipeline executed under group-wise cross-validation ( GroupKFold) to control for subject leakage. Model performance is reported with both mean-squared error and coefficient of determination (R²), and a non-parametric bootstrap routine estimates sampling variability. Trained estimators and intermediate artefacts are serialised with joblib for downstream reuse. The notebook therefore serves as the canonical, reproducible specification of the model-training procedure referenced throughout the project.
```

**02_model_specificity.ipynb**

Description: Phenotype-Specific Generalisation

Contents:

```
Building on the trained Lasso-PCR estimator, this notebook assesses construct specificity across two independent challenge sets representing low- versus high-itch (Study 2) and empathy (Study 3) phenotypes. Neural predictors are forwarded to the frozen model and predictive fidelity is quantified by Pearson product-moment correlations between observed and predicted behavioural scores.
```

**03_model_tens.ipynb**

Description: Confirmatory TENS ANOVA & Post-hoc Modelling

Contents:

```
This notebook interrogates a Transcutaneous Electrical Nerve Stimulation (TENS) experiment. Pre-processed fMRI volumes are masked with Nilearn and subjected to:
- Repeated-measures ANOVA contrasting stimulation side (left/right) and time-point (pre/post), with family-wise control over voxel-wise tests;
- correlations between changes of behavioural scores and CsPIP signature responses
```

---

**License**
-------

This project is licensed under the MIT License.

**Contact**
-------

For questions or further information, please contact:

```
•	Xiaomin Lin
•	Email: linxm@psych.ac.cn
```

Feel free to explore the notebooks and reproduce the analyses. Contributions and feedback are welcome!
