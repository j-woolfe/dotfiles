# Uncomment if using anaconda
# source ~/anaconda3/etc/fish/conf.d/conda.fish

# set -U PATH /home/linuxbrew/.linuxbrew/bin $PATH
# set -gx PATH /$PATH /opt/altera/19.1/nios2eds/bin/gnu/H-x86_64-pc-linux-gnu/bin/
# set -gx PATH /$PATH /opt/altera/19.1/University_Program/Monitor_Program/bin/

# FZF settings
set -gx FZF_DEFAULT_COMMAND 'rg --files --no-ignore --follow --glob \'!.git/*\''
set -gx FZF_CTRL_T_COMMAND "rg --files --no-ignore --follow --glob '!.git/*'"
set -U FZF_TMUX 1
set -U FZF_LEGACY_KEYBINDINGS 0

kitty + complete setup fish | source

# Setup zoxide
zoxide init fish | source

# Fix cyan on green ls when using seaweed colours 
set -gx LS_COLORS 'rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=01;42;30:st=01;44;30:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:'

# Aliases
abbr ga "git add"
abbr gc "git commit"

abbr vi "nvim"

abbr yay "paru"

# abbr n "nnn"

alias universal_ctags "uctags"

# Install fisher if not already present
# Currently used to install:
# Installed plugins in fishfile
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end


# # nnn Config
# function n --wraps nnn --description 'support nnn quit and change directory'
#     # Block nesting of nnn in subshells
#     if test -n "$NNNLVL"
#         if [ (expr $NNNLVL + 0) -ge 1 ]
#             echo "nnn is already running"
#             return
#         end
#     end

#     # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
#     # To cd on quit only on ^G, remove the "-x" as in:
#     #    set NNN_TMPFILE "$XDG_CONFIG_HOME/nnn/.lastd"
#     if test -n "$XDG_CONFIG_HOME"
#         set -x NNN_TMPFILE "$XDG_CONFIG_HOME/nnn/.lastd"
#     else
#         set -x NNN_TMPFILE "$HOME/.config/nnn/.lastd"
#     end

#     # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
#     # stty start undef
#     # stty stop undef
#     # stty lwrap undef
#     # stty lnext undef

#     nnn $argv

#     if test -e $NNN_TMPFILE
#         source $NNN_TMPFILE
#         rm $NNN_TMPFILE
#     end
# end
