 #!/bin/bash
 
 cd /tmp
 git clone https://github.com/NodyHub/dot-files.git
 cd /tmp/dot-files
 ./deploy.sh
 cd /tmp
 rm -rf /tmp/dot-files
 sudo chsh -s $(which zsh) $(whoami)
 
 exit 0
