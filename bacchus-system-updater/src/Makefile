all:
	true

install:
	install -D -m 700 -t $(DESTDIR)/usr/sbin sbin/bacchus-script-executor sbin/bacchus-system-updater
	install -D -m 600 -t $(DESTDIR)/usr/share/bacchus bacchus-common-script.sh
	install -D -m 600 -t $(DESTDIR)/etc config/script-executor.conf config/system-updater.conf
