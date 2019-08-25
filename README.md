# About the Project
The main goal of this project was to maximize Indeed's revenue. Since Indeed's business model is PayPerClick, we wanted to achieve the goal by increasing number of clicks of job postings. Consequently, we accessed the potential business value of a job upon posting and correspondingly optimized ranks of job postings.

# Methodology
* Data was provided by *[Indeed](https://www.indeed.com/)* (data size: 2.58GB)
* Defined number of clicks and max day posted as two main KPIs of potential business value of a job posting
* Implemented XGBoost regression to derive significant features and corresponding weights for two KPIs
* Regarded the significant features as the driving factors of potential business value of job postings
* Computed potential values to any future job posting using important features and weightings (score 0-100)
* Optimized ranks of job postings on *indeed.com* by ascending order of potential values
* **Won Best Insights Award**

<em>This project was done in 48 hours, and was presented to statisticians and Indeed data scientists. </em>

# Further Details
For more information, check out the presentation deck <em><a href="deck.pdf">here</a></em>

# About DataFest
ASA DataFestTM is a data hackathon for undergraduate students, sponsored by the American Statistical Association and founded at UCLA, in 2011. <br /> <br />
For more information, check out the official website <em><a href="http://datafest.stat.ucla.edu/">here</a></em>
