
library(shellpipes)

library(dplyr)
class <- (csvRead()
	|> transmute(idnum=OrgDefinedId)
)
scans <- tsvRead(col_names=FALSE)

scans <- (scans
	|> transmute(num=1:nrow(scans)
		, idnum = paste0("#", X1)
	)
	|> anti_join(class)
)

tsvSave(scans)
