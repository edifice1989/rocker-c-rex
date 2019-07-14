fluidPage(
  tags$head(includeScript("google-analytics.js")),
  navbarPage("C-REx",
             
             tabPanel("Within sample comparison",
                      sidebarLayout(
                        sidebarPanel(
                          titlePanel("Use Example Data"),
                          actionButton("submitexam1", "Apply heat stress RNA-seq sample"),
                          titlePanel("Or Upload Your Own Input Data"),
                          # Inputs excluded for brevity
                          fileInput("file", "Choose CSV File",
                                    multiple = TRUE
                          ),
                          actionButton("submit", "Submit this file"),
                          conditionalPanel(
                            "input.submitexam1>0 |input.submit>0",
                            br(),
                            h2('Choose Gene Groups to Compare'),
                            selectInput("group1", "Select Gene Group 1", choices = NULL),
                            selectInput("group2", "Select Gene Group 2", choices = NULL),
                            br(),
                            h4("Attention:"),
                            p("This webpage might freeze for a few seconds during reading and computing data!"),
                            p("Please sit tight and do not panic!"),
                            br()
                          )
                        ),
                        
                        mainPanel(# no choices before uploading
                          tabsetPanel(
                            tabPanel("Gene Distribution",
                                     fluidRow(column(8, offset = 1,
                                                     h3("Log-transformed gene expression distribution"),
                                                     h4("Please note:"),
                                                     br(),
                                                     p("-A little asymmetry of distribution is expected when the sample size is small (i.e., <30) 
                                                       even it comes from a standard normal distribution"),
                                                     p("-When sample size is large, 
                                                       further normality examination should be based on normality test in the next tab"),
                                                     plotOutput("distr")
                                                     ))),         
                            tabPanel("Normality test", 
                                     fluidRow(column(8, offset = 1,                                              
                                                     h3("Normality test for log-transformed data"),
                                                     br(),
                                                     p("Attention should be paid if there is a large number of outliers in either tail, 
                                                       which violates the normality assumption."),
                                                     p("The dots should follow the straight line if they come from normal distribution. 
                                                       Then the t-test is recommended. If not, please use the Wilcoxon signed-rank test."),
                                                     br(),
                                                     textOutput("qqtitle1"),
                                                     plotOutput("qqplot1"),
                                                     br(),
                                                     textOutput("qqtitle2"),
                                                     plotOutput("qqplot2")
                                                     
                                                     ))),
                            tabPanel("Student's t-test", 
                                     fluidRow(column(8, offset = 1,
                                                     
                                                     h2("Key summary statistics"),
                                                     p("The observed sample statistics were:"),
                                                     tableOutput('parametric'),
                                                     h2("Hypothesis of the t-test"),
                                                     p("We are testing the null hypothesis that the means of each population equal"),                       
                                                     p("P-value from t-test:"),
                                                     verbatimTextOutput("ttest"),
                                                     p("A low P value (e.g., <0.05) suggests that your sample provides enough evidence that you can reject the null hypothesis.")
                                                     ))),
                            tabPanel("Wilcoxon rank-sum test",
                                     fluidRow(column(8, offset = 1,
                                                     h2("About this test"),
                                                     p("This non-parametric test is less powerfull than parametric tests (including the t-test). It is used when data do not follow the normal distribution.
                                                        However, it could be an alternative when the log-transformed data distribution fails to meet normality requirement.
                                                        This test is also called Mann–Whitney U test, and Mann–Whitney–Wilcoxon (MWW)."),
                                                     h2("Hypothesis of the Wilcoxon rank-sum test"),
                                                     p("The null hypothesis is that it is equally likely that a randomly selected value from one sample will
                                                        be less than or greater than a randomly selected value from a second sample. Note, we use two-sided test here as default."),
                                                     p("P-value from Wilcoxon rank-sum test"),
                                                     verbatimTextOutput("wilcox"),
                                                     p("A low P value (e.g., <0.05) suggests that your sample provides enough evidence that you can reject the null hypothesis."))))
                            )
                    )
              )
        ),
tabPanel("Between sample comparison",
         sidebarLayout(
           sidebarPanel(
             titlePanel("Use Example Data"),
             actionButton("submitexam2", "Apply UV stress and non-stressed RNA-seq samples"),
             titlePanel("Or Upload Your Own Input Data"),
             fileInput("file2_1", "Choose CSV File 1",
                       multiple = TRUE,
                       accept = c("text/csv",
                                  "text/comma-separated-values,text/plain",
                                  ".R",
                                  ".csv")),
             fileInput("file2_2", "Choose CSV File 2",
                       multiple = TRUE,
                       accept = c("text/csv",
                                  "text/comma-separated-values,text/plain",
                                  ".R",
                                  ".csv")),
             actionButton("submit2", "Submit these files"),
             conditionalPanel(
               "input.submitexam2>0 |input.submit2>0",
               br(),
               h2('Choose Gene Groups to Compare'),
               selectInput("group2_1", "Select Gene Group 1 from file 1", choices = NULL),
               selectInput("group2_2", "Select Gene Group 2 from file 2", choices = NULL),
               br(),
               h4("Attention:"),
               p("This webpage might freeze for a few seconds during reading and computing data!"),
               p("Please sit tight and do not panic!"),
               br()
             )
           ),
           mainPanel(# no choices before uploading
             tabsetPanel(
               tabPanel("Gene Distribution",
                        fluidRow(column(8, offset = 1,
                                        h3("Log-transformed gene expression distribution"),
                                        br(),
                                        p("If either group follow normal distribution, it should follow a bell shape"),
                                        br(),
                                        h4("Please note:"),
                                        br(),
                                        p("-A little asymmetry of distribution is expected when sample size is small (<30) 
                                          even it comes from a standard normal distribution"),
                                        p("-When sample size is large, 
                                          further normality examination should rely on normality test in the next tab"),
                                        plotOutput("distr2")
                                        ))),
               tabPanel("Normality test", 
                        fluidRow(column(8, offset = 1,  
                                        h3("Normality test for log-transformed data"),
                                        br(),
                                        p("Attention should be paid if there is a large number of outliers in either tail, 
                                          which violates the normality assumption."),
                                        p("The dots should follow the straight line if they come from normal distribution.
                                          Then the t-test is recommended. If not, please use the Wilcoxon signed-rank test."),
                                        br(),
                                        h3("File 1"),
                                        textOutput("qqtitle2_1"),
                                        plotOutput("qqplot2_1"),
                                        br(),
                                        h3("File 2"),
                                        textOutput("qqtitle2_2"),
                                        plotOutput("qqplot2_2")
                                        
                        ))),
               tabPanel("Student's t-test", 
                        fluidRow(column(8, offset = 1,
                                        
                                        h2("Key summary statistics"),
                                        p("The observed sample statistics were:"),
                                        tableOutput('parametric2'),
                                        h2("Hypothesis of the t-test"),
                                        p("We are testing the null hypothesis that the means of each population equal"),                       
                                        p("P-value from t-test:"),
                                        verbatimTextOutput("ttest2"),
                                        p("A low P value (e.g., <0.05) suggests that your sample provides enough evidence that you can reject the null hypothesis.")
                                        ))),
               tabPanel("Wilcoxon signed-rank test (same gene group across samples)",
                        fluidRow(column(8, offset = 1,
                                        h2("About this test"),
                                        p("This non-parametric test is a less powerfull than parametric tests (including the t-test). It is used when data do not follow the normal distribution or sample size is too small to tell.
                                          However, it could be an alternative when the log-transformed data distribution fails to meet normality requirement."),
                                        h2("Hypothesis of the Wilcoxon signed-rank test"),
                                        p("compare two related samples, matched samples, or repeated measurements on a single sample to assess whether their population mean ranks differ"),
                                        p("P-value from Wilcoxon signed-rank test:"),
                                        verbatimTextOutput("wilcox2"),
                                        p("A low P value (e.g., <0.05) suggests that your sample provides enough evidence that you can reject the null hypothesis.")))),
               tabPanel("Wilcoxon rank-sum test (different gene groups)",
                        fluidRow(column(8, offset = 1,
                                        h2("About this test"),
                                        p("This non-parametric test is less powerfull than parametric tests (including the t-test). It is used when data do not follow the normal distribution.
                                          However, it could be an alternative when the log-transformed data distribution fails to meet normality requirement.
                                          This test is also called Mann–Whitney U test, and Mann–Whitney–Wilcoxon (MWW)."),
                                        h2("Hypothesis of the Wilcoxon rank-sum test"),
                                        p("The null hypothesis is that it is equally likely that a randomly selected value from one sample will
                                          be less than or greater than a randomly selected value from a second sample. Note, we use two-sided test here as default."),
                                        p("P-value from Wilcoxon rank-sum test"),
                                        verbatimTextOutput("wilcox3"),
                                        p("A low P value (e.g., <0.05) suggests that your sample provides enough evidence that you can reject the null hypothesis."))))
           )
             )
         )
             ),
	     tabPanel("About",
	     		 br(),
                      img(src = "icon.png", width=600,height=450),
                      h2('Purpose'),
                      br(),
                      p(
                        "C-REx enables gene group expression comparison within or across samples."
                      ),
                      br(),
                      p("A quick instance where our method could be helpful:"),
                      p(
                        "Suppose you have a group of genes of unknown function , such as a novel family of transcription factors (TF)."
                      ),
                      p(
                        "You want to test a hypothesis that this novel TF gene group could be activated in a specific stress condition, such as heat stress."
                      ),
                      p(
                        "C-REx provides a data-processing pipeline to enable statistical testing (via Student t-test/Wilcoxon signed-rank test) to determine whether RNA expression patterns are significantly different between stress and non-stress samples."
                      ),
                      p(
                        "The difference between the typical differential expression (DE), discovery-based approach and our group-to-group RNA expression comparison is illustrated below.
                        We use a distribution of gene expression values for gene group rather than DE gene sets where gene expression is analyzed individually."
                      ),
                      br(),
                      img(src = "flowchart_1.png", width=600,height=450),
                      img(src = "flowchart_2.png", width=600,height=450),
                      br(),
                      h2('Features'),
                      br(),
                      p(
                        "1. We provide a webtool to transform your FPKM/TPM RNA dataset into normal distributions, which enables student t-test for downstream analysis"
                      ),
                      p(
                        "2. Visualization of log-transformed gene group expression distribution and draw QQ-plot to test normality"
                      ),
                      p("3. Use housekeeping gene to normalize across sample gene group expression level"),
                      p("4. T-test on gene groups within a sample or across samples"),
                      p("5. An alternative non-parametric Wilcoxon signed-rank test is also provided if log-transformed distribution does not follow normal distribution")
                      ),
             tabPanel("How to",
                      h2('Upload input file format'),
                      br(),
                      p("-Should be in csv, separated by comma, NOT zipped!"),
                      p("-Has 3 columns, namely Gene ID, Gene Expression value (TPM/FPKM), Gene Group"),
                      br(),                      
                      h2("Two examples as below:"),
                      br(),
                      a("data from Makarevitch et al. 2015", 
                        href = "http://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.1004915"),
                      br(),
                      h3("maize B73 RNA-seq under heat stress conditions"),
                         
                        
                      pre("
                      AC147602.5_FG004,188.42990159969,non TF genes\n
                      AC148152.3_FG005,8.73844335765158,non TF genes\n
                      AC148152.3_FG008,93.7227957598519,non TF genes\n
                      AC148167.6_FG001,96.1663916765039,non TF genes\n
                      AC149475.2_FG002,17.846234593301,non TF genes\n
                      AC149475.2_FG003,37.1563876166064,non TF genes\n
                      AC149475.2_FG005,39.795811239933,non TF genes\n
                      AC149475.2_FG007,1.69852605933062,non TF genes\n
                      AC149810.2_FG008,3.9723493339935,non TF genes\n
                      AC149818.2_FG001,7.13727197998732,non TF genes\n"),
                      downloadButton("downloadData1", label = "Download example 1 data"),
                      h3("maize B73 RNA-seq under non-stress conditions"),
                      pre("
                      AC147602.5_FG004,201.411825599906,non TF genes\n
                      AC148152.3_FG005,4.97887906298883,non TF genes\n
                      AC148152.3_FG008,78.8313272531063,non TF genes\n
                      AC148167.6_FG001,69.2050966298259,non TF genes\n
                      AC149475.2_FG002,6.16576535299732,non TF genes\n
                      AC149475.2_FG003,12.7370309176619,non TF genes\n
                      AC149475.2_FG005,20.9201998332308,non TF genes\n
                      AC149475.2_FG007,1.51412422166159,non TF genes\n
                      AC149818.2_FG001,2.77512580265959,non TF genes\n
                      AC149818.2_FG006,10.113616006654,non TF genes\n"),
                      downloadButton("downloadData2", label = "Download example 2 data"),
                      br(),  
                      h3("Notes:"),
                      br(),
                      p("-Please do not include commas inside gene group names, a bad example would be 'Human,embryo genes'"),
                      p("-If there are more than one annotation for the same gene, you need to DUPLICATE each gene entry, such as:"),
                      p(" AC149818.2_FG001,188.42990159969,non TF genes"),
                      p(" AC149818.2_FG001,188.42990159969,housekeeping genes"),
                      p("-If you are comparing the same group of genes under two conditions, genes with TPM or FPKM values smaller than 1 in both condition should be removed. Usually such small measurement is not reliable."),
                      p("-Also, please use the gene group label 'housekeeping genes' to annotate housekeeping genes, some bad examples would be Housekeeping Genes, housekeeping, HOUSEKEEPING..."),
                      h3("Additional test data:"),
                      p("Those files also used in publication"),
                      downloadButton("downloadData3", label = "Download Gramene-UV-stress.csv"),
                      br(),
                      downloadButton("downloadData4", label = "Download maize-GAMER-UV-stress.csv"),
                      br(),
                      downloadButton("downloadData5", label = "Download Gramene-non-stress.csv"),
                      br(),
                      downloadButton("downloadData6", label = "Download maize-GAMER-non-stress.csv"),
                      br(),
                      downloadButton("downloadData7", label = "Download Gramene-non-stress-biological-replicate-1.csv"),
                      br(),
                      downloadButton("downloadData8", label = "Download Gramene-non-stress-biological-replicate-2.csv"),
                      br(),
                      downloadButton("downloadData9", label = "Download maize-GAMER-non-stress-biological-replicate-1.csv"),
                      br(),
                      downloadButton("downloadData10", label = "Download maize-GAMER-non-stress-biological-replicate-2.csv")
             ),
tabPanel("Citation",
         h3("Please cite:"),
         a("A hypothesis-driven approach to assessing significance of differences in RNA expression levels among specific groups of genes. 
           Mingze He, Peng Liu, Carolyn J Lawrence-Dill
           2017 Dec Current Plant Biology", 
           href = "https://www.sciencedirect.com/science/article/pii/S2214662817301007")
),
tabPanel("Contact us",
         titlePanel("Contact information"),
         
        p("Developer and maintainer: Mingze He"),
        actionButton("email_click_1", "Click for email address"),
        br(),
        textOutput("email_out_1"),
        br(),
        p("PI: Carolyn Lawrence-Dill"),
        actionButton("email_click_2", "Click for email address"),
        br(),
        textOutput("email_out_2"),
        br(),
        br(),
         a("Lawrence-Dill lab", 
           href = "https://dill-picl.org/")
        )         
    )
)
