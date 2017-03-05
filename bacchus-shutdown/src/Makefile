all:
	true
install:
	mkdir -p $(DESTDIR)/usr/sbin
	cp bacchus-shutdown $(DESTDIR)/usr/sbin/
	mkdir -p $(DESTDIR)/usr/lib/systemd/system
	cp -rT systemd $(DESTDIR)/usr/lib/systemd/system
