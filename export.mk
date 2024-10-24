
## scantron.csv generally made in Tests/, can be exported
Ignore += *.scoring.csv
%.scoring.csv: %.scantron.csv scantronCode/scoring.pl
	$(PUSH)

.PRECIOUS: scantronCode/%
scantronCode/%: | ../../3SS/Marking/%
	$(pcopy)

## Editable copy of itemized responses
## Should be primarily for fixing student numbers (versions should be addressed programatically)
.PRECIOUS: %.scanned.tsv
scores/%.scanned.tsv: | %_scans/BIOLOGY*.dlm
	$(pcopy)

## Process the file a bit (not really a merge)
Ignore += *.responses.tsv
%.responses.tsv: scores/%.scanned.tsv scantronCode/rmerge.pl
	$(PUSH)

## Score the students (ancient, deep matching)
## How many have weird bubble versions? How many have best ≠ bubble?
impmakeR += scores
%.scores.Rout: scantronCode/scores.R %.responses.tsv %.scoring.csv
	$(pipeR)

## Scantron-office scores 
## Select only the ones with matched macids for now
Ignore += *.office.csv
%.office.csv:%_scans/StudentScoresWebCT.csv
	perl -ne 'print if /^[a-z0-9]*@/' $< > $@

impmakeR += scorecomp
%.scorecomp.Rout: %.office.csv %.scores.rds scantronCode/scorecomp.R
	$(pipeR)

