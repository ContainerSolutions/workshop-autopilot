APPS=nginx customers sales

help:
	cat README.md

build: check
	make -C mantl_base_images all
	for app in $(APPS); do echo "Building $${app}"; make -C $${app} mantl; done

publish: check
	@for app in $(APPS); do \
		echo Pushing $${IMAGE_PREFIX}/ap-$${app}; \
		docker push $${IMAGE_PREFIX}/ap-$${app}; \
	done

add: check
	@for app in $(APPS); do \
		echo "## adding $${app}"; \
		cat $${app}/marathon.json |  \
			sed "s/\$${env.IMAGE_PREFIX}/$${IMAGE_PREFIX}/" | \
			curl -q -u $$MANTL_LOGIN:$$MANTL_PASSWORD -k -X POST -H 'Content-Type: application/json' https://$${MANTL_CONTROL_HOST}:8080/v2/apps -d@-; \
			echo -e "\n"; \
	done

del: check
	@for app in $(APPS); do \
		echo "## deleting $${app}"; \
		curl -q -u $$MANTL_LOGIN:$$MANTL_PASSWORD -k -X DELETE -H 'Content-Type: application/json' https://$${MANTL_CONTROL_HOST}:8080/v2/apps/$${IMAGE_PREFIX}/ap-$$app; \
		echo -e "\n"; \
	done

check:
	@test_present() { \
		if [[ -n "$${1}" ]] && test -n "$$(eval "echo "\$${$${1}+x}"")"; then \
			export ok=1; \
		else \
			echo Variable $$1 is not set; \
			exit 1; \
		fi; \
	}; \
	for varname in IMAGE_PREFIX MANTL_LOGIN MANTL_PASSWORD MANTL_CONTROL_HOST; do \
		test_present $$varname; \
	done; \

.PHONY: help build publish check
