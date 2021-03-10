default:
	@echo "There is no default target. Use: make <specific_target>"
build:
	@echo "##### Build PM Https Server docker image #####"
	docker build . -t onap/org.onap.integration.simulators.pmhttpsserver
	@echo "##### DONE #####"
start:
	@echo "##### Start PM Https Server #####"
	docker-compose -f docker-compose.yml up
	@echo "##### DONE #####"
stop:
	@echo "##### Stop PM Https Server #####"
	docker-compose -f docker-compose.yml down
	rm -rf ~/httpservervolumes/ || true
	@echo "##### DONE #####"
upload-file:
	@echo "##### Upload file to PM Https Server #####"
	curl -F "uploaded_file=@./resources/E_VES_bulkPM_IF_3GPP_3_example_1.xml.gz" -u demo:demo123456! http://localhost:32080/upload.php
	@echo "\n##### DONE #####"
clean:
	rm -rf target