default:
	@echo "There is no default target. Use: make <specific_target>"

build-http-server:
	@echo "##### Build pm https server docker image #####"
	docker build . -t onap/org.onap.integration.simulators.pmhttpsserver
	@echo "##### DONE #####"

start-http-server:
	@echo "##### Start Http Server #####"
	docker-compose -f docker-compose.yml up
	@echo "##### DONE #####"

stop-http-server:
	@echo "##### Stop Http Server #####"
	docker-compose -f docker-compose.yml down
	rm -rf ~/httpservervolumes/ || true
	@echo "##### DONE #####"
upload-file-http-server:
	@echo "##### Upload file to Http server #####"
	curl -F "uploaded_file=@./resources/E_VES_bulkPM_IF_3GPP_3_example_1.xml.gz" -u demo:demo123456! http://localhost:7080/upload.php
	@echo "\n##### DONE #####"
