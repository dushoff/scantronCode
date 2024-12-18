library(shellpipes)
manageConflicts()
library(dplyr)

responses <- (tsvRead("responses", col_names=FALSE)
	|> mutate(sheetnum = 1:length(X1))
)

patches <- (tsvRead("patch")
	|> mutate(newID = paste0("#", newID)
		, sheetnum = as.numeric(sheetnum) ## in case empty
	)
)

summary(responses)
summary(patches)

new <- (left_join(responses, patches)
	|> mutate(X1 = if_else(!is.na(newID), newID, X1))
	|> select(-c(Name, newID, sheetnum, idnum))
	|> rename(idnum=X1)
)

tsvSave(new, col_names=FALSE)
