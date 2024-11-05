library(shellpipes)
manageConflicts()

library(dplyr)

mc <- (rdsRead()
	|> select(-idnum)
)

sa <- (tsvRead()
	|> filter(!is.na(SAscore))
	|> mutate(macid = paste0("#", macid))
)

comb <- full_join(mc, sa)
summary(comb)

print(comb |> filter(is.na(SAscore)))
print(comb |> filter(is.na(score)))

(comb
	|> mutate(total=score+SAscore)
	|> rdsSave()
)
