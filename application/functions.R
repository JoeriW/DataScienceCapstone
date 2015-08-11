library(stringi)
library(tm)


txt_cleaning <- function(text){
        txt <- text
        txt <- removeNumbers(txt)
        txt <- gsub("[\u0030|\u0031|\u0032|\u0033|\u0034|\u0035|\u0036|\u0037|\u0038|\u0039]","", txt)
        txt <- gsub("[\u0023|\u002A|\u003B|\u003A|\u0028|\u0029|\u002C|\u002E|\u003F|\u0021|\u201D|\u201C|\u002F|\u00B8|\u0153]","", txt)
        txt <- gsub("[\u002D|\u2026|\u2013|\u2014|\u2018|\u2019|\u00AB|\u00BB|\u207B|\u208B|\uFE63|\uFF0D|\uE002D|\u00BD|\u005C|\u0022|\u0040|\u003C|\u003E|\u005F|\u00ED]", "", txt)
        txt <- gsub("\u2019|\u0060", "'", txt)
        txt <- gsub("^\\s+|\\s+$","", txt)
        txt <- gsub("\\s+", " ",txt)
        txt <- tolower(txt)
        return(txt)
}

txt_sizing <- function(text,size){
        txt <- unlist(strsplit(text," "))
        if (length(txt) >size) {
                txt <- paste(txt[(length(txt)-(size-1)):length(txt)],collapse=" ")                  
        }
        return(txt)      
}

txt_profanitycheck <- function(text){
        regEx <- paste0(bannedWords$V1,collapse="|")
        txt <- gsub(regEx,"",text)
        return(txt)
}

ngram_prob <- function(txt_ngrams) {
        prob <-txt_ngrams$freq/as.numeric(lapply(txt_ngrams$predictor,FUN=function(x)sum(txt_ngrams[grep(x,txt_ngrams$predictor),1])))              
        return(prob)
}

txt_prediction <- function(text,predictions){
        txt <- unlist(strsplit(text," "))
        alpha <- 0.4
        backoff <- 0
        temp4 <- NULL
        temp3<- NULL
        temp2<- NULL
        temp1<-NULL
        temp<-NULL
        
        if (length(txt)==3){
                txt <- paste(txt,collapse=" ")
                temp4 <- fourgrams[grep(paste0("^",txt,"$"),x=fourgrams$predictor),]
                temp4$pseudoprob <- (alpha^backoff) * ngram_prob(temp4)
                temp <- rbind(temp4,temp)
                
                if (nrow(temp) < predictions){
                        backoff <- backoff + 1
                        txt <- unlist(strsplit(txt_sizing(txt,2)," "))
                        
                }  
        }
        if (length(txt)==2){
                txt <- paste(txt,collapse=" ")
                temp3 <- trigrams[grep(paste0("^",txt,"$"),x=trigrams$predictor),]
                temp3$pseudoprob <- (alpha^backoff) * ngram_prob(temp3)
                temp <- rbind(temp3,temp)
                
                if (nrow(temp) < predictions){
                        backoff <- backoff + 1
                        txt <- unlist(strsplit(txt_sizing(txt,1)," "))
                        
                }  
        }
        if (length(txt)==1){
                txt <- paste(txt,collapse=" ")
                temp2 <- bigrams[grep(paste0("^",txt,"$"),x=bigrams$predictor),]
                temp2$pseudoprob <- (alpha^backoff)*ngram_prob(temp2)
                temp <- rbind(temp2,temp)
                
                if (nrow(temp)<predictions){
                        backoff <- backoff + 1
                        topUnigrams <- head(unigrams,predictions-nrow(temp))
                        temp1$freq <- topUnigrams$freq
                        temp1$predictor <- "NA"
                        temp1$prediction <- topUnigrams$word
                        temp1$pseudoprob <- (alpha^backoff) * (temp1$freq/sum(unigrams$freq))
                        temp1 <- as.data.frame(temp1)
                        temp <- rbind(temp1,temp)
                }
        }
        
        temp <- temp[order(temp$predictor,decreasing=T),]
        return(head(temp,predictions))
}

