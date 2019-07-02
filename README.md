# jmeter-helper
JMeter helper scripts and other useful samples.

## Makefile
Makefile for commands to run JMeter and generate reports.
Example: 
```
make test PROPERTIES=staging_environment.properties SCRIPT=Heavy_GET_Requests THREADS=200 RAMP_UP=240 DURATION=1200
jmeter \
	-n -t Heavy_GET_Requests \
	-q staging_environment.properties \
	-l Heavy_GET_Requests_200users_20minutes_2019-07-02_13-38.jtl \
	-j Heavy_GET_Requests_200users_20minutes_2019-07-02_13-38.log \
	-e -o Heavy_GET_Requests_200users_20minutes_2019-07-02_13-38 \
	-Jthreads=200 \
	-Jrampup=240 \
	-Jduration=1200
```
