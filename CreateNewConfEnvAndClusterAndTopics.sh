ccloud login --save 
environment_name="TestEnv-cli1"
echo "create a new confluent cloud environment $environment_name"
output=$(ccloud environment create $environment_name -o json)
echo "$output"
echo "Specify $ENVIRONMENT as the active environment"
ENVIRONMENT=$(echo "$output" | jq -r ".id")
echo "ccould environment use $ENVIRONMENT"
ccloud environment use $ENVIRONMENT
cluster_name="demo1-kafka-cluster"
cluster_cloud="azure"
cluster_region="westeurope"
output=$(ccloud kafka cluster create $cluster_name --cloud $cluster_cloud --region $cluster_region -o json)
Start-Sleep -s 15
echo "$output"
cluster=$(echo "$output" | jq -r ".id")
echo "Specify $CLUSTER as the active Kafka cluster"
echo "ccloud kafka cluster use $cluster"
ccloud kafka cluster use $cluster
echo "create new API key for the cluster"
echo "list clusters to see if the new created cluster is up and running"
echo "this is a condition for the api-key in the next step can be bound to the cluster"
outputListClusters=$(ccloud kafka cluster list -o json)
echo "$outputListClusters"
echo "Please let Confluent to create the cluster $cluster for you"
echo "Press enter after few seconds to proceed"
read
output_api_key=$(ccloud api-key create --description "Demo credentials" --resource $cluster -o json)
echo "$output_api_key"
api_key=$(echo $output_api_key | jq -r ".key")
echo "bind api-key $api_key with the cluster"
echo "Press enter after few seconds to proceed to let Confluent bind the api-key to cluster"
read
ccloud api-key use $api_key --resource $cluster
topic_1="kria_ens-movement"
topic_2="kria_arrival-movement"
echo "Press enter after few seconds letting Confluent to create the topics"
read
echo "Creating new Kafka topics, $topic_1"
output_cr_topic_1=$(ccloud kafka topic create $topic_1)
echo "Before you proceed, please press enter after few seconds to let Confluent finishing the creation process of the topic $topic_1"
read
echo "$output_cr_topic_1"
output_cr_topic_2=$(ccloud kafka topic create $topic_2)
echo "Before you proceed, please press enter after few seconds to let Confluent finishing the creation process of the topic $topic_2"
read
echo "$output_cr_topic_2"
echo "finished creating environment, cluster, api-key, and topics"
read