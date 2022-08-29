#!/bin/bash

######## VAR's ########
ENVIRONMENT_K8S_APP="review";
declare -i THRESHOLD_DAYS=14;
declare -i CONT_DEPLOY_TOTAL_DELETEDS=0;
declare -i CONT_SERVICE_TOTAL_DELETEDS=0;
declare -i CONT_INGRESS_TOTAL_DELETEDS=0;
declare -i TOTAL_DEPLOY="$(kubectl get deploy --all-namespaces | egrep -i "$ENVIRONMENT_K8S_APP" | wc -l)";
declare -i TOTAL_SERVICE="$(kubectl get svc --all-namespaces | egrep -i "$ENVIRONMENT_K8S_APP" | wc -l)";
declare -i TOTAL_INGRESS="$(kubectl get ingress --all-namespaces | egrep -i "$ENVIRONMENT_K8S_APP" | wc -l)";
WORK_DIR_SCRIPT="/home/auto.k8s/cleanEnvironmentReviewK8S";
cd "$WORK_DIR_SCRIPT";
CURRENT_LOCAL="$(pwd)";
CURRENT_DAY="$(date +%a)";
CURRENT_DAY_MONTH="$(date +%d)";
CURRENT_MONTH="$(date +%m)";
CURRENT_YEAR="$(date +%Y)";
CURRENT_HOUR="$(date +%H)";
CURRNT_MINUTE="$(date +%M)";
CURRENT_TIMEZONE="$(cat /etc/timezone)";

##### Include | Import sendmail script #####
source "$CURRENT_LOCAL"/sendMail.sh;

for NAMESPACE in $(kubectl get ns --all-namespaces | sed 1d | cut -d " " -f1);
do
    if [ "$NAMESPACE" == "default" ];
    then
	echo "Nada a fazer" > /dev/null;
    elif [ "$NAMESPACE" == "gitlab-managed-apps" ];
    then
        echo "Nada a fazer" > /dev/null;
    elif [ "$NAMESPACE" == "grafana-monitor-1110" ];
    then
        echo "Nada a fazer" > /dev/null;
    elif [ "$NAMESPACE" == "grafana-resultados-maquinas-977" ];
    then
        echo "Nada a fazer" > /dev/null;
    elif [ "$NAMESPACE" == "ingress-nginx" ];
    then
        echo "Nada a fazer" > /dev/null;
    elif [ "$NAMESPACE" == "kibana-redirect-1109" ];
    then
        echo "Nada a fazer" > /dev/null;	
    elif [ "$NAMESPACE" == "kube-node-lease" ];
    then
	echo "Nada a fazer" > /dev/null;
    elif [ "$NAMESPACE" == "kube-public" ];
    then
	echo "Nada a fazer" > /dev/null;
    elif [ "$NAMESPACE" == "kube-system" ];
    then
        echo "Nada a fazer" > /dev/null;
    elif [ "$NAMESPACE" == "logging" ];
    then
        echo "Nada a fazer" > /dev/null;
    elif [ "$NAMESPACE" == "monitoring" ];
    then
        echo "Nada a fazer" > /dev/null;
    elif [ "$NAMESPACE" == "monitoringv1" ];
    then
        echo "Nada a fazer" > /dev/null;
    elif [ "$NAMESPACE" == "nexus-2" ];
    then
        echo "Nada a fazer" > /dev/null;
    elif [ "$NAMESPACE" == "sonarqube-33" ];
    then
        echo "Nada a fazer" > /dev/null;
    else

	echo "NAMESPACE: "$NAMESPACE"" >> "$CURRENT_LOCAL"/report.txt;
	echo "Deleted Deploys:" >> "$CURRENT_LOCAL"/report.txt;
    
	for DEPLOY_ENVIRONMENT in $(kubectl get deploy -n "$NAMESPACE" | egrep -i "$ENVIRONMENT_K8S_APP" | cut -d " " -f1);
        do 
		DEPLOY_AMOUNT_OF_PAST_DAYS_FULL_FORMAT="$(kubectl get deploy "$DEPLOY_ENVIRONMENT" -n "$NAMESPACE" | awk '{print $6 "\t"}' | sed 1d)";
		DEPLOY_AMOUNT_OF_PAST_DAYS_1_POSITION="$(echo "$DEPLOY_AMOUNT_OF_PAST_DAYS_FULL_FORMAT" | cut -c1)";
		DEPLOY_AMOUNT_OF_PAST_DAYS_1_2_POSITION="$(echo "$DEPLOY_AMOUNT_OF_PAST_DAYS_FULL_FORMAT" | cut -c1-2)";
		DEPLOY_AMOUNT_OF_PAST_DAYS_2_POSITION="$(echo "$DEPLOY_AMOUNT_OF_PAST_DAYS_FULL_FORMAT" | cut -c2)";
		DEPLOY_AMOUNT_OF_PAST_DAYS_3_POSITION="$(echo "$DEPLOY_AMOUNT_OF_PAST_DAYS_FULL_FORMAT" | cut -c3)";
		DEPLOY_AMOUNT_OF_PAST_DAYS_1_2_3_POSITION="$(echo "$DEPLOY_AMOUNT_OF_PAST_DAYS_FULL_FORMAT" | cut -c1-3)";
		DEPLOY_AMOUNT_OF_PAST_DAYS_4_POSITION="$(echo "$DEPLOY_AMOUNT_OF_PAST_DAYS_FULL_FORMAT" | cut -c4)";

	if [ "$DEPLOY_AMOUNT_OF_PAST_DAYS_2_POSITION" == "d" ] && [ "$DEPLOY_AMOUNT_OF_PAST_DAYS_3_POSITION" != "d" ];
	then
        	if [ "$DEPLOY_AMOUNT_OF_PAST_DAYS_1_POSITION" -ge "$THRESHOLD_DAYS" ];
        	then
			CONT_DEPLOY_TOTAL_DELETEDS=$(($CONT_DEPLOY_TOTAL_DELETEDS + 1));
			DEPLOY_NAME="$(kubectl get deploy "$DEPLOY_ENVIRONMENT" -n "$NAMESPACE" | egrep -i "$ENVIRONMENT_K8S_APP" | cut -d " " -f1)";
			#kubectl get deploy "$DEPLOY_NAME" -n "$NAMESPACE" >> "$CURRENT_LOCAL"/report.txt; 
			kubectl delete deploy "$DEPLOY_NAME" -n "$NAMESPACE" >> "$CURRENT_LOCAL"/report.txt; 
        	fi
	elif [ "$DEPLOY_AMOUNT_OF_PAST_DAYS_2_POSITION" != "s" ] && [ "$DEPLOY_AMOUNT_OF_PAST_DAYS_2_POSITION" != "m" ] && [ "$DEPLOY_AMOUNT_OF_PAST_DAYS_2_POSITION" != "h" ] && [ "$DEPLOY_AMOUNT_OF_PAST_DAYS_2_POSITION" != "d" ] && [ "$DEPLOY_AMOUNT_OF_PAST_DAYS_2_POSITION" != "y" ] && [ "$DEPLOY_AMOUNT_OF_PAST_DAYS_3_POSITION" == "d" ];
	then
        	if [ "$DEPLOY_AMOUNT_OF_PAST_DAYS_1_2_POSITION" -ge "$THRESHOLD_DAYS" ];
        	then
			CONT_DEPLOY_TOTAL_DELETEDS=$(($CONT_DEPLOY_TOTAL_DELETEDS + 1));
			DEPLOY_NAME="$(kubectl get deploy "$DEPLOY_ENVIRONMENT" -n "$NAMESPACE" | egrep -i "$ENVIRONMENT_K8S_APP" | cut -d " " -f1)";
			#kubectl get deploy "$DEPLOY_NAME" -n "$NAMESPACE" >> "$CURRENT_LOCAL"/report.txt; 
                        kubectl delete deploy "$DEPLOY_NAME" -n "$NAMESPACE" >> "$CURRENT_LOCAL"/report.txt;
        	fi
	elif [ "$DEPLOY_AMOUNT_OF_PAST_DAYS_2_POSITION" != "s" ] && [ "$DEPLOY_AMOUNT_OF_PAST_DAYS_2_POSITION" != "m" ] && [ "$DEPLOY_AMOUNT_OF_PAST_DAYS_2_POSITION" != "h" ] && [ "$DEPLOY_AMOUNT_OF_PAST_DAYS_2_POSITION" != "d" ] && [ "$DEPLOY_AMOUNT_OF_PAST_DAYS_2_POSITION" != "y" ] && [ "$DEPLOY_AMOUNT_OF_PAST_DAYS_3_POSITION" != "s" ] && [ "$DEPLOY_AMOUNT_OF_PAST_DAYS_3_POSITION" != "m" ] && [ "$DEPLOY_AMOUNT_OF_PAST_DAYS_3_POSITION" != "h" ] && [ "$DEPLOY_AMOUNT_OF_PAST_DAYS_3_POSITION" != "d" ] && [ "$DEPLOY_AMOUNT_OF_PAST_DAYS_3_POSITION" != "y" ] && [ "$DEPLOY_AMOUNT_OF_PAST_DAYS_4_POSITION" == "d" ];
	then
        	if [ "$DEPLOY_AMOUNT_OF_PAST_DAYS_1_2_3_POSITION" -ge "$THRESHOLD_DAYS" ];
        	then
			CONT_DEPLOY_TOTAL_DELETEDS=$(($CONT_DEPLOY_TOTAL_DELETEDS + 1));
			DEPLOY_NAME="$(kubectl get deploy "$DEPLOY_ENVIRONMENT" -n "$NAMESPACE" | egrep -i "$ENVIRONMENT_K8S_APP" | cut -d " " -f1)";
			#kubectl get deploy "$DEPLOY_NAME" -n "$NAMESPACE" >> "$CURRENT_LOCAL"/report.txt; 
                        kubectl delete deploy "$DEPLOY_NAME" -n "$NAMESPACE" >> "$CURRENT_LOCAL"/report.txt;
        	fi
	elif [ "$DEPLOY_AMOUNT_OF_PAST_DAYS_2_POSITION" == "y" ] || [ "$DEPLOY_AMOUNT_OF_PAST_DAYS_3_POSITION" == "y" ] || [ "$DEPLOY_AMOUNT_OF_PAST_DAYS_4_POSITION" == "y" ];
	then	
		CONT_DEPLOY_TOTAL_DELETEDS=$(($CONT_DEPLOY_TOTAL_DELETEDS + 1));
		DEPLOY_NAME="$(kubectl get deploy "$DEPLOY_ENVIRONMENT" -n "$NAMESPACE" | egrep -i "$ENVIRONMENT_K8S_APP" | cut -d " " -f1)";
		#kubectl get deploy "$DEPLOY_NAME" -n "$NAMESPACE" >> "$CURRENT_LOCAL"/report.txt; 
                kubectl delete deploy "$DEPLOY_NAME" -n "$NAMESPACE" >> "$CURRENT_LOCAL"/report.txt;
	else
        	echo "Nada a fazer" > /dev/null;
	fi				
        done
		echo "Deleted Services:" >> "$CURRENT_LOCAL"/report.txt;	

	for SERVICE_ENVIRONMENT in $(kubectl get svc -n "$NAMESPACE" | sed 1d | egrep -i "$ENVIRONMENT_K8S_APP" | cut -d " " -f1);
	do
		SERVICE_AMOUNT_OF_PAST_DAYS_FULL_FORMAT="$(kubectl get svc "$SERVICE_ENVIRONMENT" -n "$NAMESPACE" | awk '{print $6 "\t"}' | sed 1d)";
                SERVICE_AMOUNT_OF_PAST_DAYS_1_POSITION="$(echo "$SERVICE_AMOUNT_OF_PAST_DAYS_FULL_FORMAT" | cut -c1)";
                SERVICE_AMOUNT_OF_PAST_DAYS_1_2_POSITION="$(echo "$SERVICE_AMOUNT_OF_PAST_DAYS_FULL_FORMAT" | cut -c1-2)";
                SERVICE_AMOUNT_OF_PAST_DAYS_2_POSITION="$(echo "$SERVICE_AMOUNT_OF_PAST_DAYS_FULL_FORMAT" | cut -c2)";
                SERVICE_AMOUNT_OF_PAST_DAYS_3_POSITION="$(echo "$SERVICE_AMOUNT_OF_PAST_DAYS_FULL_FORMAT" | cut -c3)";
                SERVICE_AMOUNT_OF_PAST_DAYS_1_2_3_POSITION="$(echo "$SERVICE_AMOUNT_OF_PAST_DAYS_FULL_FORMAT" | cut -c1-3)";
                SERVICE_AMOUNT_OF_PAST_DAYS_4_POSITION="$(echo "$SERVICE_AMOUNT_OF_PAST_DAYS_FULL_FORMAT" | cut -c4)";

	if [ "$SERVICE_AMOUNT_OF_PAST_DAYS_2_POSITION" == "d" ] && [ "$SERVICE_AMOUNT_OF_PAST_DAYS_3_POSITION" != "d" ];
	then
        	if [ "$SERVICE_AMOUNT_OF_PAST_DAYS_1_POSITION" -ge "$THRESHOLD_DAYS" ];
        	then
			CONT_SERVICE_TOTAL_DELETEDS=$(($CONT_SERVICE_TOTAL_DELETEDS + 1));
			SERVICE_NAME="$(kubectl get svc "$SERVICE_ENVIRONMENT" -n "$NAMESPACE" | egrep -i "$ENVIRONMENT_K8S_APP" | cut -d " " -f1)";
			#kubectl get svc "$SERVICE_NAME" -n "$NAMESPACE" >> "$CURRENT_LOCAL"/report.txt;
                	kubectl delete svc "$SERVICE_NAME" -n "$NAMESPACE" >> "$CURRENT_LOCAL"/report.txt;
        	fi
	elif [ "$SERVICE_AMOUNT_OF_PAST_DAYS_2_POSITION" != "s" ] && [ "$SERVICE_AMOUNT_OF_PAST_DAYS_2_POSITION" != "m" ] && [ "$SERVICE_AMOUNT_OF_PAST_DAYS_2_POSITION" != "h" ] && [ "$SERVICE_AMOUNT_OF_PAST_DAYS_2_POSITION" != "d" ] && [ "$SERVICE_AMOUNT_OF_PAST_DAYS_2_POSITION" != "y" ] && [ "$SERVICE_AMOUNT_OF_PAST_DAYS_3_POSITION" == "d" ];
	then
        	if [ "$SERVICE_AMOUNT_OF_PAST_DAYS_1_2_POSITION" -ge "$THRESHOLD_DAYS" ];
        	then
			CONT_SERVICE_TOTAL_DELETEDS=$(($CONT_SERVICE_TOTAL_DELETEDS + 1));
			SERVICE_NAME="$(kubectl get svc "$SERVICE_ENVIRONMENT" -n "$NAMESPACE" | egrep -i "$ENVIRONMENT_K8S_APP" | cut -d " " -f1)";
			#kubectl get svc "$SERVICE_NAME" -n "$NAMESPACE" >> "$CURRENT_LOCAL"/report.txt;
                        kubectl delete svc "$SERVICE_NAME" -n "$NAMESPACE" >> "$CURRENT_LOCAL"/report.txt;
        	fi
	elif [ "$SERVICE_AMOUNT_OF_PAST_DAYS_2_POSITION" != "s" ] && [ "$SERVICE_AMOUNT_OF_PAST_DAYS_2_POSITION" != "m" ] && [ "$SERVICE_AMOUNT_OF_PAST_DAYS_2_POSITION" != "h" ] && [ "$SERVICE_AMOUNT_OF_PAST_DAYS_2_POSITION" != "d" ] && [ "$SERVICE_AMOUNT_OF_PAST_DAYS_2_POSITION" != "y" ] && [ "$SERVICE_AMOUNT_OF_PAST_DAYS_3_POSITION" != "s" ] && [ "$SERVICE_AMOUNT_OF_PAST_DAYS_3_POSITION" != "m" ] && [ "$SERVICE_AMOUNT_OF_PAST_DAYS_3_POSITION" != "h" ] && [ "$SERVICE_AMOUNT_OF_PAST_DAYS_3_POSITION" != "d" ] && [ "$SERVICE_AMOUNT_OF_PAST_DAYS_3_POSITION" != "y" ] && [ "$SERVICE_AMOUNT_OF_PAST_DAYS_4_POSITION" == "d" ];
	then
        	if [ "$SERVICE_AMOUNT_OF_PAST_DAYS_1_2_3_POSITION" -ge "$THRESHOLD_DAYS" ];
        	then
			CONT_SERVICE_TOTAL_DELETEDS=$(($CONT_SERVICE_TOTAL_DELETEDS + 1));
			SERVICE_NAME="$(kubectl get svc "$SERVICE_ENVIRONMENT" -n "$NAMESPACE" | egrep -i "$ENVIRONMENT_K8S_APP" | cut -d " " -f1)";
			#kubectl get svc "$SERVICE_NAME" -n "$NAMESPACE" >> "$CURRENT_LOCAL"/report.txt;
                        kubectl delete svc "$SERVICE_NAME" -n "$NAMESPACE" >> "$CURRENT_LOCAL"/report.txt;
        	fi
	elif [ "$SERVICE_AMOUNT_OF_PAST_DAYS_2_POSITION" == "y" ] || [ "$SERVICE_AMOUNT_OF_PAST_DAYS_3_POSITION" == "y" ] || [ "$SERVICE_AMOUNT_OF_PAST_DAYS_4_POSITION" == "y" ];
	then
		CONT_SERVICE_TOTAL_DELETEDS=$(($CONT_SERVICE_TOTAL_DELETEDS + 1));
		SERVICE_NAME="$(kubectl get svc "$SERVICE_ENVIRONMENT" -n "$NAMESPACE" | egrep -i "$ENVIRONMENT_K8S_APP" | cut -d " " -f1)";
		#kubectl get svc "$SERVICE_NAME" -n "$NAMESPACE" >> "$CURRENT_LOCAL"/report.txt;
                kubectl delete svc "$SERVICE_NAME" -n "$NAMESPACE" >> "$CURRENT_LOCAL"/report.txt;
	else
        	echo "Nada a fazer" > /dev/null;
	fi
	done
		echo "Deleted Ingress's:" >> "$CURRENT_LOCAL"/report.txt;

	for INGRESS_ENVIRONMENT in $(kubectl get ingress -n "$NAMESPACE" | sed 1d | egrep -i "$ENVIRONMENT_K8S_APP" | cut -d " " -f1);
        do
        	INGRESS_AMOUNT_OF_PAST_DAYS_FULL_FORMAT="$(kubectl get ingress "$INGRESS_ENVIRONMENT" -n "$NAMESPACE" | awk '{print $6 "\t"}' | sed 1d)";
                INGRESS_AMOUNT_OF_PAST_DAYS_1_POSITION="$(echo "$INGRESS_AMOUNT_OF_PAST_DAYS_FULL_FORMAT" | cut -c1)";
                INGRESS_AMOUNT_OF_PAST_DAYS_1_2_POSITION="$(echo "$INGRESS_AMOUNT_OF_PAST_DAYS_FULL_FORMAT" | cut -c1-2)";
                INGRESS_AMOUNT_OF_PAST_DAYS_2_POSITION="$(echo "$INGRESS_AMOUNT_OF_PAST_DAYS_FULL_FORMAT" | cut -c2)";
                INGRESS_AMOUNT_OF_PAST_DAYS_3_POSITION="$(echo "$INGRESS_AMOUNT_OF_PAST_DAYS_FULL_FORMAT" | cut -c3)";
                INGRESS_AMOUNT_OF_PAST_DAYS_1_2_3_POSITION="$(echo "$INGRESS_AMOUNT_OF_PAST_DAYS_FULL_FORMAT" | cut -c1-3)";
                INGRESS_AMOUNT_OF_PAST_DAYS_4_POSITION="$(echo "$INGRESS_AMOUNT_OF_PAST_DAYS_FULL_FORMAT" | cut -c4)";

	if [ "$INGRESS_AMOUNT_OF_PAST_DAYS_2_POSITION" == "d" ] && [ "$INGRESS_AMOUNT_OF_PAST_DAYS_3_POSITION" != "d" ];
then
        	if [ "$INGRESS_AMOUNT_OF_PAST_DAYS_1_POSITION" -ge "$THRESHOLD_DAYS" ];
        	then
			CONT_INGRESS_TOTAL_DELETEDS=$(($CONT_INGRESS_TOTAL_DELETEDS + 1));
			INGRESS_NAME="$(kubectl get ingress "$INGRESS_ENVIRONMENT" -n "$NAMESPACE" | egrep -i "$ENVIRONMENT_K8S_APP" | cut -d " " -f1)";
			#kubectl get ingress "$INGRESS_NAME" -n "$NAMESPACE" >> "$CURRENT_LOCAL"/report.txt;
                	kubectl delete ingress "$INGRESS_NAME" -n "$NAMESPACE" >> "$CURRENT_LOCAL"/report.txt;
        	fi
	elif [ "$INGRESS_AMOUNT_OF_PAST_DAYS_2_POSITION" != "s" ] && [ "$INGRESS_AMOUNT_OF_PAST_DAYS_2_POSITION" != "m" ] && [ "$INGRESS_AMOUNT_OF_PAST_DAYS_2_POSITION" != "h" ] && [ "$INGRESS_AMOUNT_OF_PAST_DAYS_2_POSITION" != "d" ] && [ "$INGRESS_AMOUNT_OF_PAST_DAYS_2_POSITION" != "y" ] && [ "$INGRESS_AMOUNT_OF_PAST_DAYS_3_POSITION" == "d" ];
	then
        	if [ "$INGRESS_AMOUNT_OF_PAST_DAYS_1_2_POSITION" -ge "$THRESHOLD_DAYS" ];
        	then
			CONT_INGRESS_TOTAL_DELETEDS=$(($CONT_INGRESS_TOTAL_DELETEDS + 1));
			INGRESS_NAME="$(kubectl get ingress "$INGRESS_ENVIRONMENT" -n "$NAMESPACE" | egrep -i "$ENVIRONMENT_K8S_APP" | cut -d " " -f1)";
			#kubectl get ingress "$INGRESS_NAME" -n "$NAMESPACE" >> "$CURRENT_LOCAL"/report.txt;
                        kubectl delete ingress "$INGRESS_NAME" -n "$NAMESPACE" >> "$CURRENT_LOCAL"/report.txt;
        	fi
	elif [ "$INGRESS_AMOUNT_OF_PAST_DAYS_2_POSITION" != "s" ] && [ "$INGRESS_AMOUNT_OF_PAST_DAYS_2_POSITION" != "m" ] && [ "$INGRESS_AMOUNT_OF_PAST_DAYS_2_POSITION" != "h" ] && [ "$INGRESS_AMOUNT_OF_PAST_DAYS_2_POSITION" != "d" ] && [ "$INGRESS_AMOUNT_OF_PAST_DAYS_2_POSITION" != "y" ] && [ "$INGRESS_AMOUNT_OF_PAST_DAYS_3_POSITION" != "s" ] && [ "$INGRESS_AMOUNT_OF_PAST_DAYS_3_POSITION" != "m" ] && [ "$INGRESS_AMOUNT_OF_PAST_DAYS_3_POSITION" != "h" ] && [ "$INGRESS_AMOUNT_OF_PAST_DAYS_3_POSITION" != "d" ] && [ "$INGRESS_AMOUNT_OF_PAST_DAYS_3_POSITION" != "y" ] && [ "$INGRESS_AMOUNT_OF_PAST_DAYS_4_POSITION" == "d" ];
	then
        	if [ "$INGRESS_AMOUNT_OF_PAST_DAYS_1_2_3_POSITION" -ge "$THRESHOLD_DAYS" ];
        	then
			CONT_INGRESS_TOTAL_DELETEDS=$(($CONT_INGRESS_TOTAL_DELETEDS + 1));
			INGRESS_NAME="$(kubectl get ingress "$INGRESS_ENVIRONMENT" -n "$NAMESPACE" | egrep -i "$ENVIRONMENT_K8S_APP" | cut -d " " -f1)";
			#kubectl get ingress "$INGRESS_NAME" -n "$NAMESPACE" >> "$CURRENT_LOCAL"/report.txt;
                        kubectl delete ingress "$INGRESS_NAME" -n "$NAMESPACE" >> "$CURRENT_LOCAL"/report.txt;
        	fi
	elif [ "$INGRESS_AMOUNT_OF_PAST_DAYS_2_POSITION" == "y" ] || [ "$INGRESS_AMOUNT_OF_PAST_DAYS_3_POSITION" == "y" ] || [ "$INGRESS_AMOUNT_OF_PAST_DAYS_4_POSITION" == "y" ];
	then
		CONT_INGRESS_TOTAL_DELETEDS=$(($CONT_INGRESS_TOTAL_DELETEDS + 1));
		INGRESS_NAME="$(kubectl get ingress "$INGRESS_ENVIRONMENT" -n "$NAMESPACE" | egrep -i "$ENVIRONMENT_K8S_APP" | cut -d " " -f1)";
		#kubectl get ingress "$INGRESS_NAME" -n "$NAMESPACE" >> "$CURRENT_LOCAL"/report.txt;
                kubectl delete ingress "$INGRESS_NAME" -n "$NAMESPACE" >> "$CURRENT_LOCAL"/report.txt;
	else
        	echo "Nada a fazer" > /dev/null;
	fi
	done
		echo "#################################################################" >> "$CURRENT_LOCAL"/report.txt;
    fi
done

function formatHeaderReportFile(){
	cd "$CURRENT_LOCAL";
	sed -i s/"<totDep>"/"$TOTAL_DEPLOY"/g report.txt
        sed -i s/"<totSvc>"/"$TOTAL_SERVICE"/g report.txt
        sed -i s/"<totIng>"/"$TOTAL_INGRESS"/g report.txt

	sed -i s/"<totDepDel>"/"$CONT_DEPLOY_TOTAL_DELETEDS"/g report.txt 
	sed -i s/"<totSvcDel>"/"$CONT_SERVICE_TOTAL_DELETEDS"/g report.txt
	sed -i s/"<totIngDel>"/"$CONT_INGRESS_TOTAL_DELETEDS"/g report.txt
	
	TOTAL_DEPLOY_REMAINING=$(($TOTAL_DEPLOY - $CONT_DEPLOY_TOTAL_DELETEDS));
	TOTAL_SERVICE_REMAINING=$(($TOTAL_SERVICE - $CONT_SERVICE_TOTAL_DELETEDS));
	TOTAL_INGRESS_REMAINING=$(($TOTAL_INGRESS - $CONT_INGRESS_TOTAL_DELETEDS));

	sed -i s/"<totDepRem>"/"$TOTAL_DEPLOY_REMAINING"/g report.txt
        sed -i s/"<totSvcRem>"/"$TOTAL_SERVICE_REMAINING"/g report.txt
        sed -i s/"<totIngRem>"/"$TOTAL_INGRESS_REMAINING"/g report.txt
}

function remove_report_file(){

  cd "$WORK_DIR_SCRIPT" && rm -rf report.txt;

}

formatHeaderReportFile;
sendMailNotification;
remove_report_file;
