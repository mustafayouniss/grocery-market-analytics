# Grocery Market Analytics App 🛒 

An interactive data analytics dashboard built with **R** and **Shiny** to analyze grocery store transactions and extract actionable insights.

---

## 📄 Documentation

For full project details, explanations, and screenshots:

📎 **grocery-market-analytics-report.pdf**

---

## ▶️ How to Run the app

Follow these steps to run the application:

### 1️⃣ Install R & RStudio
Make sure you have:
- R installed  
- RStudio installed  

---

### 2️⃣ Install Required Libraries

Open RStudio and run the following command in RStudio:

```r
install.packages(c(
  "shiny",
  "shinythemes",
  "reader",
  "magrittr",
  "dplyr",
  "RColorBrewer",
  "plotly",
  "arules"
))
```

---

### 4️⃣ Run the Application

Open the project file (app.R) in RStudio and click:
👉 Run App

---

### 5️⃣ Prepare Your Dataset Path ⚠️

Make sure you have the dataset file:  
📄 **grocery-market-data.csv**

- Copy the full file path  
- Replace `\` with:
  - `/` OR  
  - `\\`  
- Don't forget to include the file name with `.csv` extension  

---

### Wrong Path Format ❌

<p align="center">
  <img src="screenshots/wrong-path-example.png" width="600"/>
</p>

---

### Correct Path Format ✅

<p align="center">
  <img src="screenshots/correct-path-example.png" width="600"/>
</p>

---

### 6️⃣ Use the Application 🎯

Paste the dataset path inside the app
Click Read Data
Then proceed with:
Data Cleaning
Dashboard
Clustering
Association Rules