library(stringi)
library(tm)



bannedWords <- c("4r5e","5h1t","5hit","a55","anal","anus","ar5e","arrse","arse","ass","ass-fucker","asses","assfucker",
                 "assfukka","asshole","assholes","asswhole","a_s_s","b!tch","b00bs","b17ch","b1tch","ballbag","balls",
                 "ballsack","bastard","beastial","beastiality","bellend","bestial","bestiality","bi+ch","biatch","bitch",
                 "bitcher","bitchers","bitches","bitchin","bitching","bloody","blowjob","blowjob","blowjobs","boiolas",
                 "bollock","bollok","boner","boob","boobs","booobs","boooobs","booooobs","booooooobs","breasts","buceta",
                 "bugger","bum","bunnyfucker","butt","butthole","buttmuch","buttplug","c0ck","c0cksucker","carpetmuncher",
                 "cawk","chink","cipa","cl1t","clit","clitoris","clits","cnut","cock","cock-sucker","cockface","cockhead",
                 "cockmunch","cockmuncher","cocks","cocksuck","cocksucked","cocksucker","cocksucking","cocksucks","cocksuka",
                 "cocksukka","cok","cokmuncher","coksucka","coon","cox","crap","cum","cummer","cumming","cums","cumshot",
                 "cunilingus","cunillingus","cunnilingus","cunt","cuntlick","cuntlicker","cuntlicking","cunts","cyalis",
                 "cyberfuc","cyberfuck","cyberfucked","cyberfucker","cyberfuckers","cyberfucking","d1ck","damn","dick",
                 "dickhead","dildo","dildos","dink","dinks","dirsa","dlck","dog-fucker","doggin","dogging","donkeyribber",
                 "doosh","duche","dyke","ejaculate","ejaculated","ejaculates","ejaculating","ejaculatings","ejaculation",
                 "ejakulate","fuck","fucker","f4nny","fag","fagging","faggitt","faggot","faggs","fagot","fagots","fags",
                 "fanny","fannyflaps","fannyfucker","fanyy","fatass","fcuk","fcuker","fcuking","feck","fecker","felching",
                 "fellate","fellatio","fingerfuck","fingerfucked","fingerfucker","fingerfuckers","fingerfucking",
                 "fingerfucks","fistfuck","fistfucked","fistfucker","fistfuckers","fistfucking","fistfuckings","fistfucks",
                 "flange","fook","fooker","fuck","fucka","fucked","fucker","fuckers","fuckhead","fuckheads","fuckin",
                 "fucking","fuckings","fuckingshitmotherfucker","fuckme","fucks","fuckwhit","fuckwit","fudgepacker",
                 "fudgepacker","fuk","fuker","fukker","fukkin","fuks","fukwhit","fukwit","fux","fux0r","f_u_c_k","gangbang",
                 "gangbanged","gangbangs","gaylord","gaysex","goatse","God","god-dam","god-damned","goddamn","goddamned",
                 "hardcoresex","hell","heshe","hoar","hoare","hoer","homo","hore","horniest","horny","hotsex","jack-off",
                 "jackoff","jap","jerk-off","jism","jiz","jizm","jizz","kawk","knob","knobead","knobed","knobend","knobhead",
                 "knobjocky","knobjokey","kock","kondum","kondums","kum","kummer","kumming","kums","kunilingus","l3i+ch",
                 "l3itch","labia","lmfao","lust","lusting","m0f0","m0fo","m45terbate","ma5terb8","ma5terbate","masochist",
                 "master-bate","masterb8","masterbat*","masterbat3","masterbate","masterbation","masterbations",
                 "masturbate","mo-fo","mof0","mofo","mothafuck","mothafucka","mothafuckas","mothafuckaz","mothafucked",
                 "mothafucker","mothafuckers","mothafuckin","mothafucking","mothafuckings","mothafucks","motherfucker",
                 "motherfuck","motherfucked","motherfucker","motherfuckers","motherfuckin","motherfucking","motherfuckings",
                 "motherfuckka","motherfucks","muff","mutha","muthafecker","muthafuckker","muther","mutherfucker","n1gga",
                 "n1gger","nazi","nigg3r","nigg4h","nigga","niggah","niggas","niggaz","nigger","niggers","nob","nobjokey",
                 "nobhead","nobjocky","nobjokey","numbnuts","nutsack","orgasim","orgasims","orgasm","orgasms","p0rn","pawn",
                 "pecker","penis","penisfucker","phonesex","phuck","phuk","phuked","phuking","phukked","phukking","phuks",
                 "phuq","pigfucker","pimpis","piss","pissed","pisser","pissers","pisses","pissflaps","pissin","pissing",
                 "pissoff","poop","porn","porno","pornography","pornos","prick","pricks","pron","pube","pusse","pussi",
                 "pussies","pussy","pussys","rectum","retard","rimjaw","rimming","shit","s.o.b.","sadist","schlong",
                 "screwing","scroat","scrote","scrotum","semen","sex","sh!+","sh!t","sh1t","shag","shagger","shaggin",
                 "shagging","shemale","shi+","shit","shitdick","shite","shited","shitey","shitfuck","shitfull","shithead",
                 "shiting","shitings","shits","shitted","shitter","shitters","shitting","shittings","shitty","skank",
                 "slut","sluts","smegma","smut","snatch","son-of-a-bitch","spac","spunk","s_h_i_t","t1tt1e5","t1tties",
                 "teets","teez","testical","testicle","tit","titfuck","tits","titt","tittie5","tittiefucker","titties","
                 tittyfuck","tittywank","titwank","tosser","turd","tw4t","twat","twathead","twatty","twunt","twunter",
                 "v14gra","v1gra","vagina","viagra","vulva","w00se","wang","wank","wanker","wanky","whoar","whore",
                 "willies","willy","xrated","xxx")



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
        regEx <- paste0(bannedWords,collapse="|")
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
                        topUnigrams <- head(unigrams,predictions - nrow(temp))
                        temp1 <- matrix(nrow=predictions-nrow(temp),ncol=4,rep(1,times=(predictions-nrow(temp))*4))
                        temp1[c(1:predictions),1] <- topUnigrams$freq
                        temp1[c(1:predictions),2] <- "NA"
                        temp1[c(1:predictions),3] <- topUnigrams$word
                        temp1[c(1:predictions),4] <- (alpha^backoff) * topUnigrams$freq
                        
                        if (nrow(temp)==0){
                                temp <- temp1
                        }
                        else {
                                temp <- rbind(temp1,temp)    
                        }           
                        
                        
                }
        }
        if (length(txt) == 0){
                temp <- as.data.frame(temp)
                temp[c(1:predictions),1] <- 1
                temp[c(1:predictions),2] <- "NA"
                temp[c(1:predictions),3] <- "No valid word(s) detected, please try again with new input"
                temp[c(1:predictions),4] <- c(1:predictions)
                
        }
        
        
        
        
        temp <- temp[order(temp[,4],decreasing=T),]
        return(head(temp,predictions))
}
