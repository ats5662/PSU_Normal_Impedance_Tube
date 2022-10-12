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
