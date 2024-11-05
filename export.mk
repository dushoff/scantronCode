## Makefile to be used by other projects, not this one

## scantron.csv generally made in Tests/, can be exported
Ignore += *.scoring.csv
%.scoring.csv: %.scantron.csv scantronCode/scoring.pl
	$(PUSH)

.PRECIOUS: scantronCode/%
scantronCode/%: | ../../3SS/Marking/%
	$(pcopy)

## Local copy of itemized responses
## Just cats; manual needs to be reformatted downstream
.PRECIOUS: %.scanned.tsv
Ignore += *.scanned.tsv
%.scanned.tsv: %_scans
	cat *_scans/*/BIOLOGY*.dlm | \
	perl -ne 'print' > $@

%.unmatched.Rout: scantronCode/unmatched.R scores/classlist.csv %.scanned.tsv
	$(pipeR)

impmakeR += responses
%.responses.Rout: scantronCode/responsePatch.R %.responses.tsv scores/%.patch.tsv
	$(pipeR)

## Process the file a bit (not really a merge)
Ignore += *.responses.tsv
%.responses.tsv: %.scanned.tsv scantronCode/rmerge.pl
	$(PUSH)

## Score the students (ancient, deep matching)
## How many have weird bubble versions? How many have best ≠ bubble?
impmakeR += scores
%.scores.Rout: scantronCode/scores.R %.responses.Rout.tsv %.scoring.csv
	$(pipeR)

## Scantron-office scores 
Ignore += *.office.csv
%.office.csv: %_scans
	cat *_scans/StudentScoresWebCT.csv *_scans/*/StudentScoresWebCT.csv | \
	perl -ne 'print if /^[a-z0-9]*@/' > $@

impmakeR += scorecomp
%.scorecomp.Rout: %.office.csv %.scores.rds scantronCode/scorecomp.R
	$(pipeR)

