# 🧠 fMRI Study of Cognitive Control in the Flanker Task

<p align="center">

**A complete FSL-based fMRI analysis of cognitive control and interference using the Eriksen Flanker Task**

</p>

---

## 📌 Project Overview

This project investigates the neural correlates of **cognitive control and interference processing** using functional MRI data collected during the **Eriksen Flanker Task**.

The analysis was performed using the **FMRIB Software Library (FSL)** and follows a complete group-level fMRI General Linear Model (GLM) workflow, progressing from preprocessing and spatial registration to first-, second-, and third-level statistical analysis.

The main objective was to characterize brain activation associated with:

- Incongruent trials
- Congruent trials
- Incongruent versus congruent conditions
- Cognitive conflict and interference
- Response inhibition
- Attention and visual processing

The project also includes **ROI-based analysis** to investigate activation within selected brain regions associated with cognitive control.

---

## 📊 Dataset

**Dataset:** NYU Slow Flanker  
**OpenNeuro ID:** `ds000102`  
**Participants:** 26  
**Task:** Eriksen Flanker Task  
**Functional Runs:** 2 per participant

The Eriksen Flanker Task is designed to investigate **cognitive interference and response control**.

Participants respond to a central target while ignoring surrounding flanking stimuli that can either be compatible or conflict with the required response.

### Task Conditions

| Condition | Description | Cognitive Demand |
|------------|-------------|------------------|
| **Congruent** | Flanking stimuli are compatible with the target | Lower interference |
| **Incongruent** | Flanking stimuli conflict with the target | Higher interference |

The primary cognitive-control comparison investigated in this project is:

```text
Incongruent > Congruent
```

This contrast highlights brain regions showing increased activation during conditions requiring greater interference resolution.

---

# 🔬 Analysis Pipeline

The complete analysis followed the workflow below:

```text
                         Raw fMRI Data
                               │
                               ▼
                    ┌─────────────────────┐
                    │   Quality Control   │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │    Preprocessing    │
                    │                     │
                    │ • Brain extraction  │
                    │ • Motion correction │
                    │ • Smoothing         │
                    │ • Temporal handling │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │     Registration    │
                    │                     │
                    │ EPI → T1 → MNI152   │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │   First-Level GLM   │
                    │                     │
                    │   Run × Subject     │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │  Second-Level GLM  │
                    │                     │
                    │ Within-subject     │
                    │ Fixed Effects      │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │  Third-Level GLM   │
                    │                     │
                    │    FLAME 1         │
                    │  Group Inference   │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │ Statistical Maps   │
                    │                     │
                    │ Cluster Correction │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │    ROI Analysis    │
                    │                     │
                    │ Anatomical +       │
                    │ Spherical ROIs     │
                    └─────────────────────┘
```

---

# 🧪 Preprocessing

The functional MRI data were processed using standard FSL-based preprocessing procedures to prepare the BOLD data for statistical analysis.

The workflow included:

### 1. Brain Extraction

Non-brain tissue was removed from the functional images using **BET (Brain Extraction Tool)**.

### 2. Motion Correction

Head-motion artifacts were corrected using **MCFLIRT**, aligning functional volumes to a reference volume.

### 3. Spatial Smoothing

Spatial smoothing was applied using a Gaussian kernel to improve the signal-to-noise ratio and support the assumptions of subsequent statistical analysis.

### 4. Temporal Processing

Temporal aspects of the BOLD acquisition were accounted for during the analysis and GLM modelling.

### 5. Registration

Functional images were registered to the participant's anatomical space and subsequently normalized to standard **MNI152 space**.

```text
Functional EPI
      │
      ▼
Participant T1 Space
      │
      ▼
MNI152 Standard Space
```

---

## 🖼️ EPI → MNI Registration

<p align="center">
  <img src="assets/reg-mni.jpg" width="850">
</p>

*Registration of functional MRI data into standard MNI152 space for group-level analysis.*

---

# 📐 First-Level Analysis

First-level analysis was performed for each participant and functional run using the **General Linear Model (GLM)**.

The GLM models the relationship between the experimental design and the observed BOLD signal:

```text
Y = Xβ + ε
```

where:

- `Y` = observed fMRI signal
- `X` = design matrix
- `β` = estimated model parameters
- `ε` = residual error

### Contrasts

Three main contrasts were investigated:

| Contrast | Vector | Interpretation |
|----------|--------|----------------|
| **COPE 1** | `[1, 0]` | Incongruent > Baseline |
| **COPE 2** | `[0, 1]` | Congruent > Baseline |
| **COPE 3** | `[1, -1]` | Incongruent > Congruent |

The **Incongruent > Congruent** contrast is particularly relevant to cognitive control because it isolates the additional neural response associated with resolving conflicting information.

---

## 🖼️ First-Level Results

<p align="center">
  <img src="assets/first level.jpg" width="850">
</p>

*First-level statistical activation maps showing task-related BOLD responses for the modeled Flanker conditions and contrasts.*

---

# 📊 Second-Level Analysis

The second-level analysis combined the functional runs within each participant.

A **Fixed Effects** model was used to aggregate the run-level contrast estimates and obtain a subject-level estimate.

The analysis can be represented as:

```text
Run 1 ─────────┐
               │
               ├──► Fixed Effects ──► Subject-Level COPE
               │
Run 2 ─────────┘
```

This stage provides a single subject-level statistical map for each contrast before performing group-level inference.

---

## 🖼️ Second-Level Results

<p align="center">
  <img src="assets/second level.jpeg" width="850">
</p>

*Second-level results showing the within-subject aggregation of functional runs.*

---

# 👥 Third-Level / Group Analysis

The third-level analysis was performed to investigate the effects across the participant group.

A **FLAME 1 mixed-effects model** was used for group-level inference.

The primary contrast of interest was:

```text
Incongruent > Congruent
```

This comparison was used to identify regions showing increased activity during conditions involving greater cognitive interference.

### Statistical Threshold

The group-level statistical maps were evaluated using cluster-based correction:

```text
Z > 3.1
Cluster-corrected p < 0.05
```

---

## 🖼️ Third-Level Group Results

<p align="center">
  <img src="assets/third level.png" width="850">
</p>

*Third-level group activation maps obtained using FLAME 1 mixed-effects analysis.*

---

# 🧠 Group Activation Map

The group-level results were visualized in standard MNI space to examine the spatial distribution of task-related brain activation.

The resulting maps provide a whole-brain view of regions involved in processes related to:

- Visual processing
- Attention
- Cognitive control
- Conflict monitoring
- Response inhibition
- Salience processing

---

## 🖼️ Group Map

<p align="center">
  <img src="assets/group map.jpeg" width="900">
</p>

*Whole-brain group-level activation maps illustrating the spatial distribution of task-related responses.*

---

# 🔄 Difference Map

The difference map focuses specifically on the comparison:

```text
Incongruent − Congruent
```

This contrast is central to the investigation of **cognitive interference**.

By comparing incongruent and congruent trials, the analysis highlights brain regions that show a stronger response when participants must resolve conflicting information.

---

## 🖼️ Incongruent vs. Congruent Difference Map

<p align="center">
  <img src="assets/difference map.jpeg" width="900">
</p>

*Difference map showing activation associated with increased cognitive interference during incongruent relative to congruent trials.*

---

# 🎯 ROI Analysis

In addition to whole-brain analysis, selected **Regions of Interest (ROIs)** were examined to investigate task-related activation in specific brain regions.

The ROIs were selected based on the group-level results and their relevance to cognitive control and the Flanker paradigm.

### Investigated Functional Regions

| Region | Functional Relevance |
|--------|----------------------|
| **Lateral Occipital Cortex** | Visual processing and spatial attention |
| **Occipital Regions** | Visual stimulus processing |
| **Paracingulate / Superior Frontal Region** | Conflict monitoring and cognitive control |
| **Inferior Frontal / Precentral Region** | Response inhibition |
| **Insular Cortex** | Salience and task engagement |

Two complementary ROI approaches were considered:

### Anatomical ROIs

Anatomically defined masks were used to extract statistical values from selected brain regions.

### Spherical ROIs

Spherical masks centered around significant peak coordinates were used to obtain more spatially focused measurements.

Using both approaches provides a comparison between broader anatomical regions and spatially focused peak-based measurements.

---

# 📈 Main Findings

The group-level analysis identified task-related activation associated with the Flanker paradigm.

The **Incongruent > Congruent** contrast highlighted brain regions associated with the increased processing demands caused by conflicting stimuli.

The observed activation patterns involved functional systems associated with:

- **Visual processing**
- **Spatial attention**
- **Conflict monitoring**
- **Response inhibition**
- **Salience detection**
- **Cognitive control**

Overall, the analysis demonstrates that cognitive control during the Flanker task involves a **distributed network of interacting brain regions** rather than a single isolated area.

---

# 🧩 Interpretation

The Flanker task can be viewed as a sequence of interacting cognitive processes:

```text
              Flanker Stimulus
                     │
                     ▼
             Visual Processing
                     │
                     ▼
                  Attention
                     │
                     ▼
            Conflict Detection
                     │
                     ▼
             Cognitive Control
                     │
                     ▼
           Response Selection
                     │
                     ▼
           Response Inhibition
                     │
                     ▼
             Behavioral Response
```

The **Incongruent > Congruent** contrast provides a measure of the additional neural processing required when irrelevant surrounding information conflicts with the target response.

---

# 📁 Repository Structure

```text
fMRI/
│
├── README.md
│
├── assets/
│   ├── difference map.png
│   ├── first level.png
│   ├── group map.png
│   ├── reg-mni.png
│   ├── second level.png
│   └── third level.png
│
├── Scripts/
│   └── ...
│
├── First Level Analysis Example/
│   └── ...
│
├── Second Level Analysis/
│   └── ...
│
├── Third Level Analysis/
│   └── ...
│
├── design.fsf
├── dataset_description.json
├── participants.tsv
│
├── Detailed Report - Zeyad Ashraf.pdf
└── Paper - Zeyad Ashraf 2026.pdf
```

Large raw/generated neuroimaging files are excluded from the Git repository through `.gitignore` to keep the repository focused on the analysis workflow, scripts, documentation, and representative results.

---

# 🛠️ Tools & Technologies

| Tool / Technology | Purpose |
|-------------------|---------|
| **FSL** | fMRI preprocessing and statistical analysis |
| **FEAT** | fMRI GLM analysis |
| **BET** | Brain extraction |
| **MCFLIRT** | Motion correction |
| **FLAME 1** | Group-level mixed-effects inference |
| **FSLeyes** | Neuroimaging visualization |
| **Python** | Supporting analysis and scripting |
| **Git / GitHub** | Version control and reproducibility |

---

# 📚 Analysis Levels

| Analysis Level | Unit of Analysis | Main Purpose |
|----------------|------------------|--------------|
| **First Level** | Run × Subject | Model task-related BOLD responses |
| **Second Level** | Subject | Combine multiple runs within each subject |
| **Third Level** | Group | Perform population-level inference |
| **ROI Analysis** | Selected regions | Quantify regional task-related activation |

---

# 🔍 Why the Flanker Task?

The **Eriksen Flanker Task** is a widely used paradigm for studying **cognitive interference and executive control**.

Participants must respond to a central target while ignoring surrounding distractors.

### Congruent Condition

```text
> > > > >
    ↑
  Target
```

The surrounding stimuli support the same response as the target.

### Incongruent Condition

```text
> > < > >
    ↑
  Target
```

The surrounding stimuli conflict with the target and require the participant to suppress irrelevant information.

Therefore, the comparison:

```text
Incongruent > Congruent
```

provides a useful way to investigate the neural processes involved in **conflict resolution and cognitive control**.

---

# 📄 Project Documentation

The repository includes additional project documentation:

### Detailed Report

`Detailed Report - Zeyad Ashraf.pdf`

Contains the detailed methodology, analysis workflow, statistical procedures, results, and interpretation.

### Project Paper

`Paper - Zeyad Ashraf 2026.pdf`

Contains the written project documentation and scientific discussion.

---

# 🎓 Academic Context

This project was conducted as part of an academic **fMRI / Neuroimaging analysis project** at **Cairo University**.

The project provided practical experience in:

- Functional MRI preprocessing
- BOLD signal analysis
- General Linear Models
- First-level statistical modelling
- Fixed-effects analysis
- Mixed-effects group analysis
- MNI spatial normalization
- Statistical thresholding
- ROI-based analysis
- Neuroimaging visualization
- Reproducible research workflows

---

# 👤 Author

## Zeyad Ashraf

**Biomedical Engineering — Cairo University**

### Research Interests

- Artificial Intelligence & Machine Learning
- Medical Imaging
- Neuroimaging
- Brain MRI / fMRI
- Computational Neuroscience
- Computer Vision
- AI in Healthcare

---

# 🙏 Acknowledgements

This project builds upon established methodologies and educational resources for functional MRI analysis and FSL-based neuroimaging workflows.

Special thanks to the instructors and supervisors involved in the neuroimaging coursework and project.

The analysis workflow was also informed by publicly available educational resources on fMRI analysis and the FSL software ecosystem.

---

# ⭐ Project Summary

This repository presents a complete **FSL-based fMRI analysis pipeline for investigating cognitive control during the Eriksen Flanker Task**.

The workflow progresses from:

```text
fMRI Data
    ↓
Preprocessing
    ↓
Registration
    ↓
First-Level GLM
    ↓
Second-Level Fixed Effects
    ↓
Third-Level FLAME 1
    ↓
Group Activation Maps
    ↓
Incongruent > Congruent Difference
    ↓
ROI Analysis
```

The project demonstrates how task-based fMRI can be used to investigate the neural systems involved in:

**Visual Processing → Attention → Conflict Monitoring → Cognitive Control → Response Inhibition**

---

<p align="center">

🧠 **Functional MRI • Cognitive Control • FSL • GLM • Neuroimaging**

</p>
