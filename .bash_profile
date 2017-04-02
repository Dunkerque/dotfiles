#  ---------------------------------------------------------------------------
#
#  Description:  This file holds all my BASH configurations and aliases
#
#  Sections:
#  1. Alias Configuration
#  2. Env Configuration 
#
#  ---------------------------------------------------------------------------

#   -------------------------------
#   1. ALIAS CONFIGURATION
#   -------------------------------

alias disk="du -hs *"			    # list disk usage
alias mysqlc="mysql -u root"		    # connect mysql server 
alias mysqls="mysql.server start"	    # start mysql server
alias mysqlr="mysql.server restart"	    # restart mysql server
alias cp='cp -iv'                           # Preferred 'cp' implementation
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias ll='ls -FGlAhp'                       # Preferred 'ls' implementation
alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias f='open -a Finder ./' 
alias ~="cd ~"                              # ~:            Go Home
alias vimc="vim ~/.vimrc"

#   -------------------------------
#   1. Env CONFIGURATION
#   -------------------------------
export VISUAL=vim
export EDITOR="$VISUAL"


. ~/.bashrc
