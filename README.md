# PSU Normal Impedance Tube Data Processing

MATLAB code to process normal impedance tube data according to ASTM standard E1050 

<ins>Getting Started</ins>

Clone repository ([Git Bash Download](https://git-scm.com/downloads))
```
git clone git@github.com:ats5662/PSU_Normal_Impedance_Tube.git
```

or


```
git clone https://github.com/ats5662/PSU_Normal_Impedance_Tube.git
```

Change directory to the main mlx scipt 

```
cd "~/PSU_Normal_Impedance_Tube/ProcessData/"
```
Open mlx file and set paths 

```
dataFilesPath = "~/PSU_Normal_Impedance_Tube/ExampleData/";
processScriptPath = "~/PSU_Normal_Impedance_Tube/ProcessData/ProcessDataNIT_ASTM_E1050.mlx";
outputPath = "~/PSU_Normal_Impedance_Tube/ExampleOutputs/";
outputReportName = "ExampleOutput.pdf";
addpath("~/PSU_Normal_Impedance_Tube/Functions/")
```

Navigate to the live editor ribbon and hit run 

---

<ins>2 different outputs</ins>
* PDF and HTML report with 

  - OASPL vs. time plots for each test

  -	Absorption coefficient vs. frequency plots for each test

  - Attenuation vs. frequency plots for each test

  - Specific impedance ratio (resistance and reactance) vs. frequency plots for each test

* CSV data export

  - Absorption, reflection, attenuation, and specific impedance ratio (resistance and reactance) as a function of frequency for each test

  - Timeseries OASPL data for each test
