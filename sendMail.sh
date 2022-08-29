#!/bin/bash

######## VAR's ########
WORK_DIR_SCRIPT_MAIL="/home/auto.k8s/cleanEnvironmentReviewK8S";
cd "$WORK_DIR_SCRIPT_MAIL";
CURRENT_LOCAL="$(pwd)";
SMTP_SRV="smtp.office365.com";
SMTP_PORT="587";
SMTP_USR="$(echo -ne '<e-mail>' | base64 -d)";
SMTP_PASS="$(echo -ne '<password>' | base64 -d)";
MAIL_FROM="$(echo -ne '<e-mail>' | base64 -d)";
MAIL_TO="$(echo -ne "<e-mail>" | base64 -d)";
SUBJECT="REPORT: REVIEW ENVIRONMENTS REMOVAL - SRM";

HEADER_REPORT_FILE="
From: "$MAIL_FROM"
To: "$MAIL_TO"
Subject: "$SUBJECT"

`echo "
#################################################################
#################################################################
##                                                             
##                  REPORT: REVIEW ENVIRONMENTS REMOVAL - SRM              
##                                                             
##  DATE: "$CURRENT_DAY" "$CURRENT_DAY_MONTH"-"$CURRENT_MONTH"-"$CURRENT_YEAR" "$CURRENT_HOUR":"$CURRNT_MINUTE" "$CURRENT_TIMEZONE"
##  CONPANY: AGILITY                                            
##  TEAM: "Digital Transformation"                                      
#################################################################
## STATISTICS:                                                 			       				
##  Total deploys: <totDep> - Total deploys deleted: <totDepDel> - Total remaining deploys: <totDepRem>                         
##  Total services: <totSvc> - Total services deleted: <totSvcDel> - Total remaining services: <totSvcRem>       
##  Total ingress's: <totIng> - Total ingress's deleted: <totIngDel> - Total remaining ingress's: <totIngRem>  			
#################################################################
######################## REPORT DETAILS #########################
"`
";

function createHeaderReportFile(){
    echo "$HEADER_REPORT_FILE" | sed 1d > "$CURRENT_LOCAL"/report.txt;
}

createHeaderReportFile;

function sendMailNotification(){
        cd "$CURRENT_LOCAL";
        curl --ssl-reqd \
          --url "$SMTP_SRV":"$SMTP_PORT" \
          --user "$SMTP_USR":"$SMTP_PASS" \
          --mail-from "$MAIL_FROM" \
          --mail-rcpt "$MAIL_TO" \
          --upload-file report.txt
}

#sendMailNotification;
