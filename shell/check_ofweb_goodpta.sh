#!/bin/bash
# File: check_ofweb
# Created by Marcelo on 11/Jan/2012
# This script tests OFWeb PTA validation service. This is another level of
# testing in order to validate the Administrative Services servers health...
# Modified by Melvin.W on July 25, 2016

OFWEBOUTPUT=`curl -s "https://ofweb.stanford.edu:8051/pls/OF1PRD/XXDL_validate_ptaeo_WS?p_project_number=1019719&p_task_number=2&p_award_number=ALAAJ&P_EXPENDITURE_TYPE=55140" | sha1sum`

if [ "$?" -gt 0 ]
then
	echo OFWEB ERROR: $OFWEBOUTPUT
 	exit 3
fi

if [ "$OFWEBOUTPUT" = "8529645b0bbbf63a083c8b4b0a63265dffc67045  -" ]
then
	echo 0
	exit 0
else
	echo 1
	exit 1
fi

exit 3