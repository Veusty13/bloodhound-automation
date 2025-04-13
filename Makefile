run-database : 
	python3 bloodhound-automation.py start -bp 10001 -np 10501 -wp 8001 my_project
load-data-goadV2 : 
	python3 bloodhound-automation.py data -z ./data/ESSOS_20240410083816_BloodHound-2.3.3.zip my_project
	python3 bloodhound-automation.py data -z ./data/NORTH_20240410083414_BloodHound-2.3.3.zip my_project
	python3 bloodhound-automation.py data -z ./data/SEVENKINGDOMS_20240410083609_BloodHound-2.3.3.zip my_project
load-data-bloodhound-example-data : 
	python3 bloodhound-automation.py data -z ./data/ad_example_data.zip my_project
delete-project : 
	python3 bloodhound-automation.py delete my_project
clear-project : 
	python3 bloodhound-automation.py clear my_project
# run inside neo4j container to add gds if failed
add-gds:
	sudo docker exec my_project_graph-db_1 bash -c "\
		apt update && \
		apt install -y curl && \
		curl -k -L -o /var/lib/neo4j/plugins/graph-data-science.jar https://github.com/neo4j/graph-data-science/releases/download/2.4.0/neo4j-graph-data-science-2.4.0.jar &&\
		echo "dbms.security.procedures.unrestricted=gds.*" >> /var/lib/neo4j/conf/neo4j.conf && \
    	echo "dbms.security.procedures.allowlist=gds.*" >> /var/lib/neo4j/conf/neo4j.conf"
	docker container stop my_project_graph-db_1
	docker container start my_project_graph-db_1