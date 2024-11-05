## Makefile to be used by other projects, not this one

## scantron.csv generally made in Tests/, can be exported
Ignore += *.scoring.csv
%.scoring.csv: %.scantron.csv scantronCode/scoring.pl
	$(PUSH)

## Cribbing rule still needed?? 2024 Nov 05 (Tue)
.PRECIOUS: scantronCode/%
scantronCode/%: | ../../3SS/Marking/%
	$(pcopy)

## Local copy of itemized responses
## Does not chain well, and I've been having trouble with wildcard stuff. Maybe best to list sources in Makefile.
.PRECIOUS: %.autoscan.tsv
Ignore += *.autoscan.tsv
%.autoscan.tsv: %_scans
	cat $*_scans/*/BIOLOGY*.dlm | \
	perl -ne 'print' > $@

Ignore += *.ourscan.tsv
%.ourscan.tsv: %_scans/manual.tsv scantronCode/scanClean.pl
	$(PUSH)

Ignore += *.scanned.tsv
%.scanned.tsv: %.autoscan.tsv
	$(cat)

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

impmakeR += macid
%.macid.Rout: scantronCode/macid.R %.scores.rds scores/classlist.csv
	$(pipeR)

impmakeR += saMerge
%.saMerge.Rout: scantronCode/saMerge.R %.macid.rds scores/saSheet.tsv
	$(pipeR)

impmakeR += curve
%.curve.Rout: scantronCode/curve.R %.curvePars.rda %.saMerge.rds
	$(pipeR)

%.curvePars.Rout: %.curvePars.R
	$(pipeR)

impmakeR += versions
%.versions.Rout: scantronCode/versions.R scores/saSheet.tsv scores/classlist.csv %.scores.rds
	$(pipeR)
