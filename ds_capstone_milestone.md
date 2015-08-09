---
title: "Data Science Specialization SwiftKey Capstone"
author: "JoeriW"
date: "Friday, July 24, 2015"
output: html_document
---

###Introduction

Swiftkey, corporate partner for this Data Science Capstone project, builds keyboards that makes it easier for users to type on mobile phones. One cornerstone of their intelligent keyboards are so called predictive text models. In essence these models assess what the user is typing and based on this input it estimates what might be the next word.

The goal of this capstone is to work on understanding and building such a predictive text model.

###Milestone Report

The aim of this milestone report is to demonstrate that the data was successfully downloaded and to explain some major features of the obtained dataset. Next to some exploratory data analysis we'll briefly summarize the plans of the creation of the prediction algorithm.

In order to keep the document to be concise, the code itself is not included. However, for those interested the same document including the actual code can be found on my github page.

- [My github page](https://github.com/JoeriW/DataScienceCapstone)

###Data

Language models commonly use large databases comprising of text. The data used for this capstone is from a corpus (a corpus is a large and structured set of text) called HC Corpora ([www.corpora.heliohost.org](www.corpora.heliohost.org)). The data is downloaded from the Coursera website.

- [Capstone Dataset](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip)

The data contains corpora of multiple languages, however for this project only the **English** corpus is retained. This corpus has been collected from numerous different webpages searched from:

-personal and professional blogs   
-newspapers  
-Twitter updates  



  
A basic summary table of the raw dataset is given below:



| source | # lines | # words | # characters | # words/line | # chrs/word |
|:------------------:|:------------------:|:------------------:|:------------------:|:------------------:|:------------------:|
|    Blogs   |    899,288   |    37,546,246   |    206,824,505   |    42   |    5.5   |
|    News   |    1,010,242   |    34,762,395   |    203,223,155   |    34   |    5.8   |
|    Twitter   |    2,360,148   |    30,093,369   |    162,096,031   |    13   |    5.4   |


The number words per line is considerably lower for Twitter updates (13) compared to the words per line of text in newspapers (34) and blogs (42). This shouldn't be a surprise given that Twitter limits the number of characters per tweet to 140. The fact that blogs have a higher number of words per line compared to newspaper articles intuitively makes sense given that newspaper articles often publish information in a concise way, whereas writing style for blogs is often more prosaic, with use of longer sentences. 

Although the number of characters per words is the lowest for Twitter updates, I would have expected that given the character limit of 140 characters, users would use much more abbrevations in Twitter updates and that the difference with newsarticles and blogs would be bigger.

Below a boxplot is given for the words per line and the characters per word of each source type. Note that a log transformation has been performed in both boxplots given that the initial data was highly skewed.

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png) 


The first boxplot shows that Twitter updates have the lowest median words/line and that there are no upside outliers (again explained by the character limitation). Blogs has the widest range of words/line with a considerable amount of outliers to the upisde. Newsarticles have a narrower range than Blogs but also show a considerable amount of upside outliers, additionally they also show some outliers at the downside.

The second boxplot doesn't reveal a lot of differences between blogs,newsupdates and Twitter. The number of characters per word is highly concentrated with a significant amount of outliers for all source types, both at the up - and downside.

**Important note**: all above statistic were calculated on the raw data set, so before doing any transformations. Numbers can/will be different when other approaches/functions are used.

###Sampling

Given that the initial set is very large a sample will created. Such a sample of randomly selected amounts of text should be suffisant to get accurate approximations about how the complete datasets looks like. Whether or not to use a sample for the actual prediction model is a decision to be made later on in the project.



Our sample will be **5%** of the initial data, randomly selected across the whole dataset.

###Data cleaning





Before making further analysis on the sample the data will be cleaned.

Practically this means that:

  - punctuations will be removed
  - double (or more) whitespaces will be removed
  - numbers will be removed
  - different types of apostrophes will be transformed to one single type of apostrophe
  - special characters will be removed
  - & is changed to and
  - all characters are converted to lower case
  
    
 
####Profanity filter


Additionally, the data contains words of offensive and profane meaning. These words will be removed from our prediction algorithm. The list with profane words that will be filtered out of the dataset can be found at my github page

- [Profane word file](https://github.com/JoeriW/DataScienceCapstone/blob/master/download/profanity.csv)




###Tokenization

Currently, the dataset is basically a collection of lines of text and is not seen as a collection of words. Next step therefore is to break up the stream of text into processable words (a process called tokenization). Tokenized data allows for further analysis and will be crucial for our text mining algorithm. A process n-gram tokenization will be performened with ***n*** indicating the number of words that will be grouped into one token. 1-gram (or unigram) tokenization segments the corpus into single words. 2-gram (or bigram) tokenization segments the corpus into set of 2 words, and so on. Once tokenized the frequency that each (set of) word(s) occurs within the corpus can be given.

####unigram tokenization


        
1-gram (or unigram) tokenization allows to have a closer look to the frequency of occurence of single words. Wordclouds are a visual way of summarizing the frequency of each word within the Corpus. The colour and size indicate the relative importance of the word.
        
            
        
#####Wordclouds
![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8-1.png) 
      
    
From the wordclouds above it becomes clear that the most frequent words in the corpus are ****stopwords****. We'll need to decide in a later stage whether or not we include stopwords in our prediction algorithm. If we remove these stopwords the resulting wordclouds will be completely different. Below we run the same wordclouds but this time with stopwords excluded.  
            
                  
                        
#####Wordclouds (excluding stopwords)
![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-9-1.png) 

####2,3 and 4-gram tokenization

Next to unigrams we'll also create a graphical overview of the most frequent occuring sets of 2,3 and 4 words across the 3 text sources.

![plot of chunk unnamed-chunk-10](figure/unnamed-chunk-10-1.png) 

###Next Steps

In the next steps we will create a prediction algorithm that will search matches between the last 3 words of an input sentence and the first three words of the 4-grams. If not found, matches will be searched between the last 2 words of the input sentence and the first 2 words of the 3-grams.If not found, matches will be searched between the last word of the input sentence and the first word of the 2-grams. In case of matches the last word of the relevant n-gram table will be proposed as a possible next word. Based on frequency of occurence a probability will be assigned to each possible next word. We'll also need to handle unseen (set of) words.

Once our algorithm is decently tested we can start thinking about creating a shiny app.
