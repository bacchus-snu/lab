all:
	true
install:
	mkdir -p $(DESTDIR)/etc
	cp -r dconf $(DESTDIR)/etc/
	mkdir -p $(DESTDIR)/usr/share
	cp -r polkit-1 $(DESTDIR)/usr/share/
	mkdir -p $(DESTDIR)/etc/fonts/conf.d
	cp 49-bacchus-desktop-env.conf $(DESTDIR)/etc/fonts/conf.d/
