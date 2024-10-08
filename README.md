# 🌐 Neural CPS Verification Framework

A novel approach to **Neural Cyber-Physical System (CPS)** verification, focusing on ensuring robust and reliable verification of systems that incorporate **neural networks** and **physical components**. This framework introduces a **backward-induction and sequential verification** methodology to verify component-level properties using **Metric Interval Temporal Logic (MITL)**.

---

## 📄 **Table of Contents**

1. [Introduction](#introduction)
2. [Key Features](#key-features)
3. [Methodology](#methodology)
4. [Installation](#installation)
5. [Usage](#usage)
6. [Results](#results)
7. [Contributors](#contributors)
8. [License](#license)

---

## 🚀 **Introduction**

In this repository, we introduce a formal verification framework for neural **Cyber-Physical Systems (CPS)**. This framework addresses the challenges of verifying neural networks integrated into safety-critical systems by applying a **decomposition-based approach**.

Key highlights include:
> **Component-level verification** using Metric Interval Temporal Logic (MITL).  
> Application of **backward-induction** to ensure both system and component robustness.  
> **Distributed sequential verification** to localize potential points of failure.

---

## 🛠️ **Key Features**

- **Backward Induction Verification**: Sequentially verifies each component of the CPS to ensure adherence to the system’s operational limits.
- **Component Decomposition**: Breaks the system into manageable components for easier verification.
- **Scalability**: Efficiently scales to handle complex hybrid systems with multiple interconnected subsystems.
- **MATLAB Integration**: Fully implemented using MATLAB for ease of integration with existing Simulink® models.

---

## 🧠 **Methodology**

The methodology introduces a **backward-induction and sequential verification approach**. Each component is checked individually, ensuring that:
1. **Initialization**: Signal datasets are created for each component based on simulation data.
2. **Range and Step Size Selection**: Maximum and minimum signal ranges are derived from simulation results.
3. **Neural Network Verification**: Neural components are verified using a custom verification algorithm.
4. **MITL Property Verification**: Each component satisfies the MITL properties before system-wide verification.
5. **Overall System Verification**: The minimum step size across components is used to ensure system-wide consistency.

### 🖼️ **Proposed Methodology**:
![Proposed Methodology Diagram](https://github.com/shantanu49001/verif_/blob/main/a1.png)  
*Caption: Overview of the sequential distributed verification process using backward induction.*

### 📊 **Example Components Verified**:
![Example CPS Structure](https://github.com/shantanu49001/verif_/blob/main/a2.png)  
![Example Cyber-Physical System](https://github.com/shantanu49001/verif_/blob/main/a3.png)  

- **Custom Neural Network**: Processes weather stimuli to predict temperature changes.
- **Weather Predictor**: Uses state-flow logic to forecast temperature variations.
- **Fuel Level Control**: Adjusts fuel consumption based on thermodynamic equations.
- **Max/Min Velocity Modulation**: Ensures velocity stays within safe operational limits based on fuel availability.

### 🖼️ **Example Model Verification**:
![Model Verification](![Proposed Methodology Diagram](https://github.com/shantanu49001/verif_/blob/main/a4.png)    
*Caption: The structure and components of the neural CPS model used for verification.*

---

## 💻 **Installation**

To set up the verification framework, follow these steps:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-repo-name
   cd your-repo-name
