library(readr)
library(dplyr)

library(shellpipes)

bubbles <- (csvRead()
	|> transmute(macid=Username, idnum=OrgDefinedId)
	|> right_join(rdsRead())
	|> filter(bestScore > verScore + 2)
	|> select(macid, bubVer, bestVer)
)
summary(bubbles |> mutate_if(is.character, as.factor))

sa <- (tsvRead()
	|> mutate(macid = paste0("#", macid))
)

(bubbles |>
	full_join(sa)
	|> select(-SAscore)
	|> filter(bestVer != SAver)
) |> print(n=Inf)

