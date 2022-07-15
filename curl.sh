 #!/bin/bash
 
 cd ~
 git clone https://github.com/NodyHub/dot-files.git
 cd ~/dot-files
 ./deploy.sh
 cd ~
 rm -rf ~/dot-filest
 sudo chsh -s $(which zsh) $(whoami)
 
 exit 0
