#Libraries that were used

library("shiny")
library("shinythemes")
library("reader")
library("magrittr")
library("dplyr")
library("RColorBrewer")
library("plotly")
library("RColorBrewer")
library("arules")



#Shiny_User_InterFace

ui <- fluidPage(
  
  theme =shinytheme("cyborg"),
  
  titlePanel("Analytical Program For Grocery Market"),
  
  tabsetPanel(
    tabPanel("1-Getting Ready♻️📥",
             div(style = "text-align: center; font-size: 45px;","Welcome"),
             h3("Please Type Your Csv File Location:👀\n"),
             textInput("Data_Path","replacing each Backslash( \\ ) to ( / ) or Double Backslash( \\\\ ) and end this path with the ( File name ) followed by (.csv)",width = 800),
             actionButton("Read_Button","Read Data🧐"),
             h1(""),
             actionButton("Clean_Button","Clean Data🧹"),
             h1(""),
             verbatimTextOutput("Data_Path"),
             verbatimTextOutput("Data_Str"),
             verbatimTextOutput("Data_Clean")),
    tabPanel("2-Dashboard📊📈",
             plotOutput("Dashboard",width = "1250", height = "810")),
    tabPanel("3-Clustering👨🏻‍👩🏻‍👦🏻‍👦🏻👨‍👨‍👦",
              sidebarLayout(
               sidebarPanel(selectInput("Number_Of_Clusters",h3("Select Number Of Clusters:"),choices = c(2,3,4),width=500),width=10),
               mainPanel(verbatimTextOutput("Data_Final"),width=10))),
    tabPanel("4-Association Rule(Apriori Algorithm)🛒🛍️",
               sidebarLayout(
                sidebarPanel(textInput("Min_Support","Enter Minimum Support ( value must between 0.001:1 ):"),textInput("Min_Confidence","Enter Minimum Confidence ( value must between 0.001:1 ):"),sliderInput("Min_Length","Select The Minimum Length",min=2,max=10,value=2,step=1,width=500),width=10),
                mainPanel(verbatimTextOutput("Data_Association"),width=10))),
    tabPanel("About Me😎🙋‍♂️",
               sidebarLayout(
                sidebarPanel(h4("This Project Implemented BY :"),width=50),
                mainPanel(h3(" * Mustafa Younis "),
                          h3(" * mustafa.younis.asran@gmail.com"                ),   
                          h3(" * 01273522694"                  ),
                          h3(" * coderixxx@youtube" ),
                          h3(" * mustafayouniss@github"                  ),
                          h3(" " ),
                          h4("💗💗💗💗💗💗💗💗💗💗💗Thanks💗💗💗💗💗💗💗💗💗💗💗"),width=50,height=50)))
    )
  )
  
  
  
  #Shiny_Server
  
  read_data_safe <- function(path){
   tryCatch({
     read.csv(path)
   }, error = function(e){
      return(NULL)
      })
  }

  server<- function(input , output ,session ){
  
   #First_Panel_(Read_Data_Button)
   observeEvent(input$Read_Button,{
     
      Data_Path<-input$Data_Path 
      
      output$Data_Path<-renderText({
        print(paste("Your File Path: ",input$Data_Path))
      })
      
      if(file.exists(Data_Path)){
        
        Data<-read_data_safe(Data_Path)
        if(is.null(Data)){
        output$Data_Str<-renderText("Invalid file path or file format ❌")
        return()
        }
        
        Counter_Numeric<-0
        Counter_Character<-0
        
        output$Data_Str<-renderPrint({
          print(paste("Here We Have",length(Data),"Columns (Variables) , and ",nrow(Data),"Rows. 😊"))
          
          for(x in 1:ncol(Data)){
           if(is.character(Data[,x])){
            Counter_Character<-Counter_Character+1
           }else if(is.numeric(Data[,x])||is.integer(Data[,x])){
              Counter_Numeric<-Counter_Numeric+1
            }
          }
          
          cat("There is:
            (",Counter_Numeric,")Rows As Numeric Data Type
            (",Counter_Character,")Rows As Charcter Data Type\n")
          cat("\n")
          
          for(x in 1:ncol(Data)){
            print(paste(x,"-",names(Data)[x],"Column (",class(Data[,x]),")--->",Data[1,x]))
          }
        })
      }else{
        output$Data_Str<-renderText("File not found 🤷🏻‍♂️")
      }
   })
    
   #First_Panel_(Clean_Data_Button) 
   observeEvent(input$Clean_Button,{
      
      Data_Path<-input$Data_Path
      
      if(file.exists(Data_Path)){
        
        Data<-read_data_safe(Data_Path)
        if(is.null(Data)){
        output$Data_Clean<-renderText("Invalid file path or file format ❌")
        return()
        }
        
        output$Data_Clean <- renderPrint({
          
         #Remove_Duplicated_Rows
          if(sum(duplicated(Data))!=0){
            print(paste("number of Duplicated Rows : ",sum(duplicated(Data))))
            Data<-unique(Data)
            print("Duplicated Rows Has Been Deleted♻️")
          }else{
            print("There isn't Duplicated Rows👏🏻")
          }
          print("------------------------------------------------------------------------------------------")
         
         #Remove_NA_Values  
          if(sum(is.na(Data))!=0){
            print(paste("number of NA Values : ",sum(is.na(Data))))
            Data<-na.omit(Data)
            print("NA Value's Rows Has Been Deleted♻️")
          }else{
            print("There isn't NA Values👏🏻")
          }
          print("------------------------------------------------------------------------------------------")
          
         #Remove_Outliers 
          Data_Edit<- subset(Data, select = -which(sapply(Data, is.character)))
          
          for(x in 1:ncol(Data_Edit)) {
            #كوندشن عشان يتماشى مع الفايل اللي عندنا وميمسحش الاوتلايرز بتوع عمود الكونت 
            if(max(Data_Edit[,x]) - min(Data_Edit[,x]) < 50) {
              print(paste("There isn't any outliers in ", names(Data_Edit)[x], "column👏🏻"))  
              print("------------------")
               next
            }
            
            outlier <- boxplot(Data_Edit[,x], plot = FALSE)$out
            if(length(outlier) != 0) {
              print(paste(names(Data_Edit)[x], "column has", length(outlier), "outliers:", outlier))
              Data_Edit[-which(Data_Edit[,x]%in%outlier),]
              print("Outliers Has Been Deleted♻️")
            }else {
              print(paste("There isn't any outliers in ", names(Data_Edit)[x], "column👏🏻"))  
            }
            print("------------------")
          }
          
          
        })
      }else{
        output$Data_Clean<-renderText("File not found 🤷🏻‍♂️")
      }
   })
    
   #Second_Panel_(Dashboard)
   output$Dashboard <- renderPlot({
     
      Data_Path<-input$Data_Path
      par(mfrow=c(2,2))

      Data<-read_data_safe(Data_Path)
      if(is.null(Data)){
      return()
      }
      
      Data<-unique(Data)
      
      
      #Distribution_Of_Total_Spending_(Box_Plot)
      boxplot(Data$total,col="skyblue",ylab="Total Spending",main="Distribution Of Total Spending",width=450)
      
      #City_Vs_Total_Spending_(Bar_Plot)
      City_total<-Data %>%
      group_by(city) %>%
      summarize(total=sum(total))
      City_total <- arrange(City_total, desc(total))
      n <- length(unique(City_total$city))
      city_colors <- brewer.pal(n, "Set2")
      barplot(height =City_total$total,
              pch = 19,
              las = 2,
              cex.names = 1.2,
              name=City_total$age,
              names.arg = City_total$city,
              main="Total Spending by each City",
              col=city_colors,
              ylim=c(0,3000000))
      legend("topright", legend = unique(City_total$city), col = city_colors,title="City" ,pch = 19, bty = "n")
      
      
      #Cash_Vs_Credit_(Pie_Chart)
      t<-table(Data$paymentType)
      percentage<-paste0(round(100*t/sum(t),digits=2),"%")
      pie(t , labels=percentage , main="Compare cash and credit totals", col=c("lightblue","pink",width=500),cex = 1.5,init.angle = 90)
      legend("bottomleft",title="Payment Type",legend = c("cash","credit"),fill = c("lightblue","pink"))
      
      
      #Age_Vs_Total_Spending_(Bar_Plot)
      summary_age_total<-Data %>%
      group_by(age) %>%
      summarize(total=sum(total)) 
      barplot(height = summary_age_total$total,
              name = summary_age_total$age,
              xlab = "age",
              ylab = "total",
              main = "total spending by age",
              col="orange",
              ylim=c(0,2000000))
      
   },bg = "whitesmoke")
   
   #Third_Panel_Kmeans_(Clustring) 
   observe({
   
    if(file.exists(input$Data_Path)){
        Data_Path<-input$Data_Path

        Data<-read_data_safe(Data_Path)
        if(is.null(Data)){
        return()
        }

        Data<-unique(Data)
        Data<-Data[,-c(1,2,7,8)]
      
        Total_Vector<-rep(0,max(Data$rnd))
        Name_Vector<-rep(NA,max(Data$rnd))
        Age_Vector<-rep(0,max(Data$rnd))
      
      
        for(i in 1:max(Data$rnd)){
         for(x in 1:nrow(Data)){
          if(i == Data[x,2]){
            Total_Vector[i]<-Total_Vector[i]+Data[x,1]
            Name_Vector[i]<-Data[x,3]
            Age_Vector[i]<-Data[x,4]
          }else{
            next
            }
         }
        }
    
      #Verify
      sum(Data$total)-sum(Total_Vector)
      
      Data_K<-data.frame(Name_Vector,Total_Vector,Age_Vector)
      names(Data_K)<-c("Name","Total","Age")
      Data_Kk<-Data_K[,-1]
      
      Data_Kmeans<-kmeans(Data_Kk,centers=input$Number_Of_Clusters)
      
      Cluster<-Data_Kmeans$cluster
      
      Data_Final<-cbind(Data_K,Cluster)
      
      output$Data_Final<-renderPrint({print(Data_Final)})
      
      }else{
        output$Data_Final<-renderPrint({print("File not Found 🤷🏻‍♂️")})
    }
      
   })
    
   #Fourth_Panel_Association_Rule_(Apriori)
   observe({
      
      if(file.exists(input$Data_Path)){
        
       Data_Path<-input$Data_Path

       Data<-read_data_safe(Data_Path)
       if(is.null(Data)){
       return()
       }

       unique(Data)
       
        if(0.001 <= input$Min_Support && input$Min_Support <= 1 &&
           0.001 <= input$Min_Confidence && input$Min_Confidence <= 1 &&
           2 <= input$Min_Length && input$Min_Length <= 10){
        
             Items_Excel<-paste(Data$items)
             write(Items_Excel , file = "Items.txt") 
             Data <- read.transactions("Items.txt",sep=",")
             Apriori<-apriori(Data,parameter=list(supp=as.numeric(input$Min_Support),conf=as.numeric(input$Min_Confidence),minlen=as.numeric(input$Min_Length)))
             
             output$Data_Association<-renderPrint({
              print("Right Values,Here We Go: 🎉")
              print(Apriori)
              options(max.print = 9999)
              inspect(Apriori)
             })
        
        }else{ output$Data_Association<-renderPrint({print("Values Isn't Stable 🙂")})}
      
      }else{output$Data_Association<-renderText({print("File not Found 🤷🏻‍♂️")})}
   })
      
      
  } 
  

  #Shiny_App
  shinyApp(ui = ui , server = server)
  #Done
  