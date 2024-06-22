include config/config.proj

SED_RULES= \
	-e "s@^MY_PATH=.*@MY_PATH=/opt/june-cheque@g" \
	-e "s@__VERSION__@${VERSION}@g"

PACKAGE_NAME=june-cheque.${VERSION}

pkg-debi: spool/pkg/${PACKAGE_NAME}/DEBIAN/control spool/pkg/${PACKAGE_NAME}/DEBIAN/postinst spool/pkg/${PACKAGE_NAME}/DEBIAN/postrm
	if [ -f ${PACKAGE_NAME}.deb ]; then \
		echo "There is already a package file ${PACKAGE_NAME}.deb"; \
		exit 1; \
	fi
	mkdir -p spool/pkg/${PACKAGE_NAME}/opt/june-cheque/bin
	cp *.py *.sh spool/pkg/${PACKAGE_NAME}/opt/june-cheque/bin
	cat createCheques.sh  | sed ${SED_RULES} > spool/pkg/${PACKAGE_NAME}/opt/june-cheque/bin/createCheques.sh
	mkdir -p spool/pkg/${PACKAGE_NAME}/opt/june-cheque/images
	cp images/logo.png spool/pkg/${PACKAGE_NAME}/opt/june-cheque/images
	chmod 755 spool/pkg/${PACKAGE_NAME}/DEBIAN/postinst spool/pkg/${PACKAGE_NAME}/DEBIAN/postrm
	cd spool/pkg; dpkg-deb -Z xz --build ${PACKAGE_NAME}
	mv spool/pkg/${PACKAGE_NAME}.deb .
	${MAKE} clean-pkg
	echo "The package ${PACKAGE_NAME}.deb is ready"
	
	
clean: clean-pkg

clean-pkg:
	rm -rf spool/pkg

spool/pkg/${PACKAGE_NAME}/DEBIAN/%: pkg/debian/%.template
	mkdir -p spool/pkg/${PACKAGE_NAME}/DEBIAN
	cat $^ | sed ${SED_RULES} > $@
