# bacchus-lab-env

## PPA dependencies

* ppa:cmssnu/os-env
* ppa:mmk2410/intellij-idea
* ppa:webupd8team/atom

## Repositories

```bash
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] http://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
```
