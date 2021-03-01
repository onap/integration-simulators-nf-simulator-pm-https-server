default:
	@echo "There is no default target. Use: make <specific_target>"

build:
	@echo "##### Build PM Https Server docker image #####"
	mkdir -p target/usr/local/apache2/passwd/ && cp resources/.htpasswd target/usr/local/apache2/passwd/
	mkdir -p target/usr/local/apache2/htdocs/ && cp resources/.htaccess target/usr/local/apache2/htdocs/
	mkdir -p target/usr/local/apache2/conf/ && cp resources/upload.php target/usr/local/apache2/conf/
	mkdir -p target/etc/apache2/sites-enabled/ && cp resources/apache-config.conf target/etc/apache2/sites-enabled/000-default.conf
	mkdir -p target/etc/apache2/certs && cp resources/cert/* target/etc/apache2/certs
	cp resources/apache2.conf target/etc/apache2/
	tar cf target/resources.tar --directory=target usr/ etc/
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
	curl -F "uploaded_file=@./resources/E_VES_bulkPM_IF_3GPP_3_example_1.xml.gz" -u demo:demo123456! http://localhost:7080/upload.php
	@echo "\n##### DONE #####"

clean:
	rm -rf target