library(readr)
library(dplyr)

library(shellpipes)

scores <- rdsRead()
summary(scores)

class <- (csvRead()
	|> transmute(idnum=OrgDefinedId, macid=Username) 
)

summary(class)

scores <- (scores
	|> left_join(class)
	|> transmute(macid, idnum, score=bestScore)
)

tsvSave(scores)
rdsSave(scores)

avenue <- (scores
	|> filter(!is.na(macid))
	|> transmute(Username=macid
		, `MC Points Grade` = score 
		, `End-of-Line Indicator` = "#"
	)
)

csvSave(avenue, ext="avenue.csv")
