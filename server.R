library(shiny)
library("ggplot2")

  function(input, output, session) {
    ######### DOWNLOAD EXAMPLE FILE ###############
    info <- reactiveValues(data = NULL)
    data1 <- read.csv("./Data/hsf_vs_all_tf.csv",header=FALSE)
    colnames(data1) <- c("gene", "RNA", "group")
    output$downloadData1 <- downloadHandler(
      filename = function() {
        paste("upload_file_example_1", ".csv", sep="")
      },
      content = function(filename) {
        write.table(data1, filename, sep=",",  col.names=FALSE,row.names = F,quote=F)
      }
    )
    data2 <- read.csv("./Data/hsf_vs_all_tf_normal.csv",header=FALSE)
    colnames(data2) <- c("gene", "RNA", "group")
    output$downloadData2 <- downloadHandler(
      filename = function() {
        paste("upload_file_example_2", ".csv", sep="")
      },
      content = function(filename) {
        write.table(data2, filename, sep=",",  col.names=FALSE,row.names = F,quote=F)
      }
    )
    
######## aditional test data ###########
    data3 <- read.csv("./Data/Gramene-UV-stress.csv",header=FALSE)
    output$downloadData3 <- downloadHandler(
      filename = function() {
        paste("Gramene-UV-stress", ".csv", sep="")
      },
      content = function(filename) {
        write.table(data3, filename, sep=",",  col.names=FALSE,row.names = F,quote=F)
      }
    )
    
    data4 <- read.csv("./Data/maize-GAMER-UV-stress.csv",header=FALSE)
    output$downloadData4 <- downloadHandler(
      filename = function() {
        paste("maize-GAMER-UV-stress", ".csv", sep="")
      },
      content = function(filename) {
        write.table(data4, filename, sep=",",  col.names=FALSE,row.names = F,quote=F)
      }
    )
    
    data5 <- read.csv("./Data/Gramene-non-stress.csv",header=FALSE)
    output$downloadData5 <- downloadHandler(
      filename = function() {
        paste("Gramene-non-stress", ".csv", sep="")
      },
      content = function(filename) {
        write.table(data5, filename, sep=",",  col.names=FALSE,row.names = F,quote=F)
      }
    )
    
    data6 <- read.csv("./Data/maize-GAMER-non-stress.csv",header=FALSE)
    output$downloadData6 <- downloadHandler(
      filename = function() {
        paste("maize-GAMER-non-stress", ".csv", sep="")
      },
      content = function(filename) {
        write.table(data6, filename, sep=",",  col.names=FALSE,row.names = F,quote=F)
      }
    )
    
    data7 <- read.csv("./Data/Gramene-non-stress-biological-replicate-1.csv",header=FALSE)
    output$downloadData7 <- downloadHandler(
      filename = function() {
        paste("Gramene-non-stress-biological-replicate-1", ".csv", sep="")
      },
      content = function(filename) {
        write.table(data7, filename, sep=",",  col.names=FALSE,row.names = F,quote=F)
      }
    )
    
    data8 <- read.csv("./Data/Gramene-non-stress-biological-replicate-2.csv",header=FALSE)
    output$downloadData8 <- downloadHandler(
      filename = function() {
        paste("Gramene-non-stress-biological-replicate-2", ".csv", sep="")
      },
      content = function(filename) {
        write.table(data8, filename, sep=",",  col.names=FALSE,row.names = F,quote=F)
      }
    )
    
    data9 <- read.csv("./Data/Gramene-non-stress-biological-replicate-1.csv",header=FALSE)
    output$downloadData9 <- downloadHandler(
      filename = function() {
        paste("maize-GAMER-non-stress-biological-replicate-1", ".csv", sep="")
      },
      content = function(filename) {
        write.table(data9, filename, sep=",",  col.names=FALSE,row.names = F,quote=F)
      }
    )
    
    data10 <- read.csv("./Data/maize-GAMER-non-stress-biological-replicate-2.csv",header=FALSE)
    output$downloadData10 <- downloadHandler(
      filename = function() {
        paste("maize-GAMER-non-stress-biological-replicate-2", ".csv", sep="")
      },
      content = function(filename) {
        write.table(data10, filename, sep=",",  col.names=FALSE,row.names = F,quote=F)
      }
    )
    
######################################## submit user data #################
    observeEvent(input$submit,
      {
        withProgress(message = 'Reading data in progress',
                     detail = 'This may take a while...', value = 1, {
      inFile <- input$file
      # Instead # if (is.null(inFile)) ... use "req"
      req(inFile)
      # Changes in read.table
      data1 <- read.csv(inFile$datapath, header = FALSE)
      colnames(data1) <- c("gene", "RNA", "group")
      # Update select input immediately after clicking on the action button.
      updateSelectInput(session, "group1", "Select Gene Group 1", choices = data1$group)
      updateSelectInput(session, "group2", "Select Gene Group 2", choices = data1$group)
      info$data1 <- data1
                     })
      })
    observeEvent(input$submitexam1,
                 {
                   withProgress(message = 'Reading data in progress',
                                detail = 'This may take a while...', value = 1, {
                   updateSelectInput(session, "group1", "Select Gene Group 1", choices = data1$group)
                   updateSelectInput(session, "group2", "Select Gene Group 2", choices = data1$group)
                   info$data1 <- data1
                                })
                 })
    output$distr <- renderPlot({
      if (is.null(info$data1)) return()
      withProgress(message = 'Calculation in progress',
                   detail = 'This may take a while...', value = 1, {
                     f <- info$data1
                     sub1<-subset(f,f[,3]==input$group1)
                     sub2<-subset(f,f[,3]==input$group2)
                     all<-rbind(sub1,sub2)
                     normal_hk <-
                       subset(f, f[, 3] == "housekeeping genes")
                     normal_mean <- mean(log(normal_hk[, 2] + 1))
                     ggplot(all, aes(log(RNA+1) / normal_mean,color=group)) +
                       geom_density(alpha = 0.5) + theme(axis.text = element_text(size =
                                                                                    20),
                                                         axis.title = element_text(size = 20),
                                                         legend.title = element_text(colour="black", size=20),
                                                         legend.text = element_text(colour="black", size = 20)) +
                       theme(
                         panel.background = element_blank(),
                         panel.grid.minor = element_blank(),
                         panel.border = element_rect(
                           colour = "black",
                           fill = NA,
                           size = 1.5
                         )
                       ) +
                       xlab("RNA expression level") + ylab("Percentage of genes %")+
                       scale_x_continuous(expand = c(0, 0)) +
                       scale_y_continuous(expand = c(0, 0))
                   })
                   
    })
    output$qqtitle1 <- renderText({
      if (is.null(info$data1)) return()
      input$group1
    })
    output$qqplot1 <- renderPlot({
      if (is.null(info$data1)) return()
      withProgress(message = 'Calculation in progress',
                   detail = 'This may take a while...', value = 1, {
                     f <- info$data1
                     sub<-subset(f,f[,3]==input$group1)
                     qqnorm(log(sub[,2]+1))
                     qqline(log(sub[,2]+1))
                   })
    })
    output$qqtitle2 <- renderText({
      input$group2
    })
    output$qqplot2 <- renderPlot({
      if (is.null(info$data1)) return()
      withProgress(message = 'Calculation in progress',
                   detail = 'This may take a while...', value = 1, {
                     f <- info$data1
                     sub<-subset(f,f[,3]==input$group2)
                     normal_hk<-subset(f, f[, 3] == "housekeeping genes")
                     normal_mean <- mean(log(normal_hk[, 2] + 1))
                     qqnorm(log(sub[,2]+1)/normal_mean)
                     qqline(log(sub[,2]+1)/normal_mean)
                   })
    })
    output$ttest<-renderText({
      if (is.null(info$data1)) return()
      withProgress(message = 'Student T-test in progress',
                   detail = 'This may take a while...',
                   value = 1,
                   {
                     f <- info$data1
                     sub1 <- subset(f, f[, 3] == input$group1)
                     sub2 <- subset(f, f[, 3] == input$group2)
                     
                     normal_hk <- subset(f, f[, 3] == "housekeeping genes")
                     normal_mean <- mean(log(normal_hk[, 2] + 1))
                     
                     p<-t.test(log(sub1[, 2] + 1) / normal_mean,
                            log(sub2[, 2] + 1) / normal_mean)$p.value
                     if(p>=0.05)
                     {
                       result<-p
                     }
                     
                     if(p<0.05 && p>=0.01)
                     {
                       result<-"p<0.05"
                     }
                     
                     if(p<0.01 && p>=0.001)
                     {
                       result<-"p<0.01"
                     }
                     
                     if(p<0.001 && p>=0.0001)
                     {
                       result<-"p<0.001"
                     }
                     
                     if(p<0.0001)
                     {
                       result<-"p<0.0001"
                     }
                     result
                     
                   })
    })
    output$parametric<-renderTable({
      if (is.null(info$data1)) return()
      withProgress(message = 'Statistics summury in progress',
                   detail = 'This may take a while...',
                   value = 1,
                   {
      f <- info$data1
      sub1<-subset(f,f[,3]==input$group1)
      sub2<-subset(f,f[,3]==input$group2)
      normal_hk<-subset(f, f[,3] == "housekeeping genes")
      normal_mean <- mean(log(normal_hk[,2] + 1))
      data.frame(
                 mean1 = mean(log(sub1[,2]+1))/normal_mean,
                 mean2 = mean(log(sub2[,2]+1))/normal_mean,
                 sd1=sd(log(sub1[,2]+1)/normal_mean),
                 sd2=sd(log(sub2[,2]+1)/normal_mean)
                 )   
                   })
    })
    output$wilcox<-renderText({
      if (is.null(info$data1)) return()
      withProgress(message = 'Wilcoxon rank-sum test in progress',
                   detail = 'This may take a while...',
                   value = 1,
                   {
      f <- info$data1
      sub1<-subset(f,f[,3]==input$group1)
      sub2<-subset(f,f[,3]==input$group2)
      normal_hk<-subset(f, f[, 3] == "housekeeping genes")
      normal_mean <- mean(log(normal_hk[, 2] + 1))
      p<-wilcox.test(log(sub1[,2]+1)/normal_mean, log(sub2[,2]+1)/normal_mean,paired = FALSE)$p.value
      if(p>=0.05)
      {
        result<-p
      }
      
      if(p<0.05 && p>=0.01)
      {
        result<-"p<0.05"
      }
      
      if(p<0.01 && p>=0.001)
      {
        result<-"p<0.01"
      }
      
      if(p<0.001 && p>=0.0001)
      {
        result<-"p<0.001"
      }
      
      if(p<0.0001)
      {
        result<-"p<0.0001"
      }
      result
      
    })
    })
    
    
    ######################### ACROSS SAMPLE COMPARISON  ###############################
    
    observeEvent(input$submit2, {
      inFile <- input$file2_1
      # Instead # if (is.null(inFile)) ... use "req"
      req(inFile)
      
      # Changes in read.table
      
      f <- read.csv(inFile$datapath, header = FALSE)
      colnames(f) <- c("gene", "RNA", "group")
      # Update select input immediately after clicking on the action button.
      updateSelectInput(session, "group2_1", "Select Gene Group 1 from file 1", choices = f$group)
      info$data2<-f
    })
    observeEvent(input$submit2, {
      inFile <- input$file2_2
      # Instead # if (is.null(inFile)) ... use "req"
      req(inFile)
      
      # Changes in read.table
      
      f <- read.csv(inFile$datapath, header = FALSE)
      colnames(f) <- c("gene", "RNA", "group")
      # Update select input immediately after clicking on the action button.
      updateSelectInput(session, "group2_2", "Select Gene Group 2 from file 2", choices = f$group)
      info$data3<-f
    })
    observeEvent(input$submitexam2, {
      data2 <- read.csv("./Data/maize-GAMER-UV-stress.csv",header=FALSE)
      colnames(data2) <- c("gene", "RNA", "group")
      # Update select input immediately after clicking on the action button.
      updateSelectInput(session, "group2_1", "Select Gene Group 1", choices = data2$group)
      info$data2<-data2
      
      data3 <- read.csv("./Data/maize-GAMER-non-stress.csv",header=FALSE)
      colnames(data3) <- c("gene", "RNA", "group")
#       Update select input immediately after clicking on the action button.
      updateSelectInput(session, "group2_2", "Select Gene Group 2", choices = data3$group)
      info$data3<-data3
    })
    
    output$distr2 <- renderPlot({
      if (is.null(info$data2)) return()
      withProgress(message = 'Plotting in progress',
                   detail = 'This may take a while...', value = 0.1, {
                     f1 <- info$data2
                     sub1<-subset(f1,f1[,3]==input$group2_1)
                     new_name_1<-paste(input$group2_1," from file 1")
                     sub1[,3]<-new_name_1
                     f2 <- info$data3
                     sub2<-subset(f2,f2[,3]==input$group2_2)
                     new_name_2<-paste(input$group2_2," from file 2")
                     sub2[,3]<-new_name_2
                     
                     normal_hk_1 <-
                       subset(f1, f1[, 3] == "housekeeping genes")
                     normal_hk_2 <-
                       subset(f2, f2[, 3] == "housekeeping genes")
                     normal_mean_1 <- mean(log(normal_hk_1[, 2] + 1))
                     normal_mean_2 <- mean(log(normal_hk_2[, 2] + 1))
                     # normalize before rbind ####
                     sub1$RNA_normalized<-log(sub1$RNA+1)/normal_mean_1
                     sub2$RNA_normalized<-log(sub2$RNA+1)/normal_mean_2
                     all<-rbind(sub1,sub2)
                     ggplot(all, aes(RNA_normalized,color=group)) +
                       geom_density(alpha = 0.5) + theme(axis.text = element_text(size =
                                                                                    20),
                                                         axis.title = element_text(size = 20),
                                                         legend.title = element_text(colour="black", size=20),
                                                         legend.text = element_text(colour="black", size = 20)) +
                       theme(
                         panel.background = element_blank(),
                         panel.grid.minor = element_blank(),
                         panel.border = element_rect(
                           colour = "black",
                           fill = NA,
                           size = 1.5
                         )
                       ) +
                       xlab("RNA expression level") + ylab("Percentage of genes %")+
                       scale_x_continuous(expand = c(0, 0)) +
                       scale_y_continuous(expand = c(0, 0))
                   })
    })
    output$qqtitle2_1 <- renderText({
      if (is.null(info$data2)) return()
      input$group2_1
    })
    output$qqplot2_1 <- renderPlot({
      if (is.null(info$data2)) return()
      withProgress(message = 'Calculation in progress',
                   detail = 'This may take a while...', value = 1, {
                     f <- info$data2
                     sub<-subset(f,f[,3]==input$group2_1)
                     qqnorm(log(sub[,2]+1))
                     qqline(log(sub[,2]+1))
                   })
    })
    output$qqtitle2_2 <- renderText({
      if (is.null(info$data2)) return()
      input$group2_2
    })
    output$qqplot2_2 <- renderPlot({
      if (is.null(info$data2)) return()
      withProgress(message = 'Calculation in progress',
                   detail = 'This may take a while...', value = 1, {
                     f <- info$data3
                     sub<-subset(f,f[,3]==input$group2_2)
                     qqnorm(log(sub[,2]+1))
                     qqline(log(sub[,2]+1))
                   })
    })
    output$ttest2<-renderText({
      if (is.null(info$data2)) return()
      f1 <- info$data2
      sub2_1<-subset(f1,f1[,3]==input$group2_1)
      f2 <- info$data3
      sub2_2<-subset(f2,f2[,3]==input$group2_2)
      if(nrow(sub2_1) ==nrow(sub2_2))
      {
        num2<-TRUE
      }
      if(nrow(sub2_1) !=nrow(sub2_2))
      {
        num2<-FALSE
      }     
      normal_hk_1 <-
        subset(f1, f1[, 3] == "housekeeping genes")
      normal_hk_2 <-
        subset(f2, f2[, 3] == "housekeeping genes")
      normal_mean_1 <- mean(log(normal_hk_1[, 2] + 1))
      normal_mean_2 <- mean(log(normal_hk_2[, 2] + 1))
      # paired t-test is over powerful to distinguish small random changes even between biological replicates
      p<-t.test(log(sub2_1[,2]+1)/normal_mean_1,log(sub2_2[,2]+1)/normal_mean_2)$p.value
      if(p>=0.05)
      {
        result<-p
      }
      
      if(p<0.05 && p>=0.01)
      {
        result<-"p<0.05"
      }
      
      if(p<0.01 && p>=0.001)
      {
        result<-"p<0.01"
      }
      
      if(p<0.001 && p>=0.0001)
      {
        result<-"p<0.001"
      }
      
      if(p<0.0001)
      {
        result<-"p<0.0001"
      }
      result
      
      
    })
    output$parametric2<-renderTable({
      if (is.null(info$data2)) return()
      f1 <- info$data2
      sub2_1<-subset(f1,f1[,3]==input$group2_1)
      f2 <- info$data3
      sub2_2<-subset(f2,f2[,3]==input$group2_2)
      normal_hk_1 <-
        subset(f1, f1[, 3] == "housekeeping genes")
      normal_hk_2 <-
        subset(f2, f2[, 3] == "housekeeping genes")
      normal_mean_1 <- mean(log(normal_hk_1[,2] + 1))
      normal_mean_2 <- mean(log(normal_hk_2[,2] + 1))
      data.frame(
                 mean1 = mean(log(sub2_1[,2]+1))/normal_mean_1,
                 mean2 = mean(log(sub2_2[,2]+1))/normal_mean_2,
                 sd1=sd(log(sub2_1[,2]+1)/normal_mean_1),
                 sd2=sd(log(sub2_2[,2]+1)/normal_mean_2)
                 )
    })
    output$wilcox2<-renderText({
      if (is.null(info$data2)) return()
      f1 <- info$data2
      sub2_1<-subset(f1,f1[,3]==input$group2_1)
      f2 <- info$data3
      sub2_2<-subset(f2,f2[,3]==input$group2_2)
      normal_hk_1 <-
        subset(f1, f1[, 3] == "housekeeping genes")
      normal_hk_2 <-
        subset(f2, f2[, 3] == "housekeeping genes")
      normal_mean_1 <- mean(log(normal_hk_1[,2] + 1))
      normal_mean_2 <- mean(log(normal_hk_2[,2] + 1))
      p<-wilcox.test(log(sub2_1[,2]+1)/normal_mean_1, log(sub2_2[,2]+1)/normal_mean_2,paired=TRUE)$p.value
      if(p>=0.05)
      {
        result<-p
      }
      
      if(p<0.05 && p>=0.01)
      {
        result<-"p<0.05"
      }
      
      if(p<0.01 && p>=0.001)
      {
        result<-"p<0.01"
      }
      
      if(p<0.001 && p>=0.0001)
      {
        result<-"p<0.001"
      }
      
      if(p<0.0001)
      {
        result<-"p<0.0001"
      }
      result
      
    })
    output$wilcox3<-renderText({
      if (is.null(info$data2)) return()
      f1 <- info$data2
      sub2_1<-subset(f1,f1[,3]==input$group2_1)
      f2 <- info$data3
      sub2_2<-subset(f2,f2[,3]==input$group2_2)
      normal_hk_1 <-
        subset(f1, f1[, 3] == "housekeeping genes")
      normal_hk_2 <-
        subset(f2, f2[, 3] == "housekeeping genes")
      normal_mean_1 <- mean(log(normal_hk_1[,2] + 1))
      normal_mean_2 <- mean(log(normal_hk_2[,2] + 1))
      p<-wilcox.test(log(sub2_1[,2]+1)/normal_mean_1, log(sub2_2[,2]+1)/normal_mean_2,paired = FALSE)$p.value
      if(p>=0.05)
      {
        result<-p
      }
      
      if(p<0.05 && p>=0.01)
      {
        result<-"p<0.05"
      }
      
      if(p<0.01 && p>=0.001)
      {
        result<-"p<0.01"
      }
      
      if(p<0.001 && p>=0.0001)
      {
        result<-"p<0.001"
      }
      
      if(p<0.0001)
      {
        result<-"p<0.0001"
      }
      result
      
    })
    email_address_1 <- eventReactive(input$email_click_1, {
      print("edifice1989@gmail.com")
    })
    output$email_out_1 <- renderText({
     email_address_1()
    })
    email_address_2 <- eventReactive(input$email_click_2, {
      print("triffid@iastate.edu")
    })
    output$email_out_2 <- renderText({
      email_address_2()
    })
}
