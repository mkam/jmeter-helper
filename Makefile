SHELL = /bin/bash

# User input variables
SCRIPT ?= GET_Requests
THREADS ?= 100
DURATION ?= 600
RAMP_UP ?= 60
PROPERTIES ?= staging_environment.properties

# Derived variables
DURATION_MINUTES = $(shell echo $$(( $(DURATION)/60 )) )
TIME = $(shell TZ=America/Chicago date +"%Y-%m-%d_%H-%M")
FILENAME ?= $(SCRIPT)_$(THREADS)users_$(DURATION_MINUTES)minutes_$(TIME)

test:
	jmeter \
	-n -t $(SCRIPT) \
	-q $(PROPERTIES) \
	-l $(FILENAME).jtl \
	-j $(FILENAME).log \
	-e -o $(FILENAME) \
	-Jthreads=$(THREADS) \
	-Jrampup=$(RAMP_UP) \
	-Jduration=$(DURATION)

report:
	$(JMETER) -g $(NAME).jtl -o $(NAME)

aggregate-report:
	sh $(JMETER_HOME)/libexec/bin/JMeterPluginsCMD.sh --plugin-type AggregateReport \
		--generate-csv $(OUTPUT) --input-jtl $(INPUT)

help:
	@echo 'Options:'
	@echo ' test:	Runs JMeter test and names results files and HTML report based on inputs and timestamp.'
	@echo '	SCRIPT: Path to JMeter JMX test file.'
	@echo '	DURTION: Duration to run test in seconds, passed to script as a JMeter property.'
	@echo '	RAMP_UP: Ramp up time in seconds, passed to script as a JMeter property.'
	@echo '	THREADS: Number of concurrent users, passed to script as a JMeter property.'
	@echo '	PROPERTIES: Property file to use when running tests.'
	@echo ''
	@echo ' report: Creates JMeter HTML report from JTL file.'
	@echo '	NAME: Name of JTL file, minus extension. Also used to name the output directory.'
	@echo ''
	@echo ' aggregate-report: Creates JMeter CSV aggregate report from JTL file.'
	@echo '	INPUT: Name of JTL input file.'
	@echo '	OUTPUT: Name of CSV output file.'