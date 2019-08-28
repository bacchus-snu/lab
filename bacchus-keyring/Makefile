all: output/bacchus-keyring.gpg

clean:
	rm -rf output/

output/bacchus-keyring.gpg: keys/0x*
	mkdir -p output
	cat keys/0x* > $@
