default:
	@echo "There is no default target. Use: make <specific_target>"
build:
	@echo "##### Build PM Https Server docker image #####"
	mkdir -p target/usr/local/apache2/passwd/ && cp resources/local/.htpasswd target/usr/local/apache2/passwd/
	mkdir -p target/usr/local/apache2/conf/ && cp resources/local/upload.php target/usr/local/apache2/conf/
	mkdir -p target/etc/apache2/sites-enabled/ && cp resources/sites-enabled/000-default.conf target/etc/apache2/sites-enabled/000-default.conf
	cp resources/ports.conf target/etc/apache2/
	cp resources/apache2.conf target/etc/apache2/
	mkdir -p target/etc/apache2/certs && cp resources/cert/* target/etc/apache2/certs
	mkdir -p target/usr/lib/x86_64-linux-gnu/ && cp resources/lib/libjwt.so.1.7.0 target/usr/lib/x86_64-linux-gnu/libjwt.so.1
	mkdir -p target/usr/local/apache2/modules/ && cp resources/modules/mod_authnz_jwt.so target/usr/local/apache2/modules/mod_authnz_jwt.so
	mkdir -p target//etc/apache2/mods-enabled/ && cp resources/mods-enabled/auth_jwt.load target/etc/apache2/mods-enabled/auth_jwt.load
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