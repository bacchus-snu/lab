all: pam-bacchus
pam-bacchus:
	$(MAKE) -C pam_bacchus
install:
	install -D -m 644 pam_bacchus/pam_bacchus.so $(DESTDIR)/lib/x86_64-linux-gnu/security/pam_bacchus.so
