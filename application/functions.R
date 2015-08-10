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
}
                      
     

txt_prediction <- function(text,predictions){
        txt <- unlist(strsplit(text," "))
        alpha <- 0.4
        backoff <- 0
        temp <- NULL
        
        if (length(txt)==3){
                temp <- rbind(fourgrams[grep(paste(txt,collapse=" "),x=fourgrams$predictor),],temp)
                temp$prob <- (alpha^backoff) * ngram_prob(temp)
                
                if (nrow(temp) < predictions){
                        txt_sizing(txt,2)
                        backoff <- backoff + 1
                }
                
        }
        if (length(txt)==2){
                temp <- rbind(trigrams[grep(paste(txt,collapse=" "),x=trigrams$predictor),],temp)
                temp$prob <- (alpha^backoff) * ngram_prob(temp)
                
                if (nrow(temp) < predictions){
                        txt_sizing(txt,1)
                        backoff <- backoff + 1
                }
                
                
        }
        if (length(txt)==1){
                temp <- bigrams[grep(paste(txt,collapse=" "),x=bigrams$predictor),]
                temp$prob <- (alpha^backoff)*ngram_prob(temp)
                
                if (nrow(temp) < predictions){
                        txt_sizing(txt,1)
                        backoff <- backoff + 1
                }
        }
        if (backoff > 0){
                temp$prob <- (alpha^backoff) * (unigrams$freq/sum(unigrams$freq))
                temp <- head(temp,predictions)               
                
        }
        
        temp <- head(temp,predictions)
        return(temp)
}

