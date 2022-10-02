<h1 align="center">Conference Bulletins Interactive Word Cloud</h1>
<p align="center">
  <a href = "https://www.r-project.org/"><img src="https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white"></a>
  <a href = "https://github.com/yauyenching/bandung-bulletins/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-MIT-informational?style=for-the-badge"></a>
</p>
This project aims to provide an easily accessible at-a-glance visual summary of the 1955 Asian-African Conference bulletin contents which were made publicly available by the Indonesian ministry of information. Users can filter the output according to content categories, delegate head, and press region. This project was completed as part of my digital humanities project for the module YHU3263 The Bandung Conference of 1955 at Yale-NUS College.

## ✨ Preview ##
<div align="center">
  <img src="https://user-images.githubusercontent.com/50619632/169779478-4300f27a-dbfd-4148-ba19-cecd5ffd45aa.png" width="650">
  <h3>Visit the website <a href="https://yauyenching.shinyapps.io/bandung-bulletins/">here</a>!</h3>
</div>

## 🛠️ Implementation ##
This web app was made using the R [shiny](https://shiny.rstudio.com/) package and deployed on the platform [shinyapps.io](https://www.shinyapps.io/).

## ⚙️ Building the Project ##
To deploy the web application locally, clone the repository and navigate to its directory. Then, in the R console,
```
install.packages("shiny") # install the shiny package
library(shiny) # load the required package
runApp() # run a local instance of the web app
```

## 📂 File Structure ##
This is a single-file app. Both the UI and server-side code can be found in `.\app.R`.

## 💾 Data ##
The conference bulletins are available [here](https://bandung60.wordpress.com/bandung-bulletin/). I digitized them manually using optical character recognition technology. My digitization output can be found [here](https://github.com/yauyenching/bandung-bulletins/tree/main/document_text).

## 🚩 Known Issues ##
* **The word cloud does not dynamically resize in the event of window resizing.** One should refresh the page to resize the word cloud.
* **The output is not 100% accurate.** The PDFs were not of high quality, so mispelled words (e.g., "asianafrican") can be found.

Currently, there are no plans to revisit these issues in the near future.

## 📝 License ##
This project is licensed under the MIT License - see the [LICENSE](https://github.com/yauyenching/bandung-bulletins/blob/main/LICENSE) file for details.
