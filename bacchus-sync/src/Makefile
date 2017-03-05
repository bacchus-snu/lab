all: bacchus-sync
bacchus-sync: bacchus-sync.vala
	valac --pkg gtk+-3.0 --pkg posix --target-glib 2.32 bacchus-sync.vala
clean:
	rm -f bacchus-sync.c bacchus-sync
install: all
	mkdir -p $(DESTDIR)/usr/bin
	cp bacchus-sync $(DESTDIR)/usr/bin/
	cp -rT scripts $(DESTDIR)/usr/bin/
	mkdir -p $(DESTDIR)/etc/systemd/system
	cp -rT override $(DESTDIR)/etc/systemd/system/
	mkdir -p $(DESTDIR)/usr/lib/systemd/system
	cp -rT systemd $(DESTDIR)/usr/lib/systemd/system/
	mkdir -p $(DESTDIR)/usr/share/xsessions
	cp snucse-lab.desktop $(DESTDIR)/usr/share/xsessions/
	mkdir -p $(DESTDIR)/etc/gdm3
	cp -rT gdm $(DESTDIR)/etc/gdm3
