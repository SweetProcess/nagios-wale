build:

install:
	mkdir -p $(DESTDIR)/usr/lib/nagios/plugins-wale
	cp scripts/* $(DESTDIR)/usr/lib/nagios/plugins-wale/
	rsync -a etc $(DESTDIR)
	setfacl -m user:nagios:rx -R /etc/wal-e.d/env
