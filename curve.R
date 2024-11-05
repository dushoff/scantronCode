library(readr)
library(dplyr)

library(shellpipes)
loadEnvironments()

df <- (rdsRead()
	%>% mutate(
		curve=((m-b)*N*total+b*N^2)/((m-b-1)*total+(b+1)*N)
		, curve = round(curve, 1)
	)
)

summary(df)

df |> select (macid, curve) |> tsvSave()
