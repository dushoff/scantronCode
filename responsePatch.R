library(shellpipes)
manageConflicts()
library(dplyr)

responses <- (tsvRead("responses", col_names=FALSE)
	|> rename(idnum=X1)
)

patches <- (tsvRead("patch")
	|> mutate(idnum = paste0("#", idnum))
)

new <- (left_join(responses, patches)
	|> mutate(idnum = if_else(!is.na(newID), newID, idnum))
	|> select(-c(Name, newID))
)

tsvSave(new, col_names=FALSE)
