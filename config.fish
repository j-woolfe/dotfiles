source ~/anaconda3/etc/fish/conf.d/conda.fish

set -U PATH /home/linuxbrew/.linuxbrew/bin $PATH

set -gx FZF_DEFAULT_COMMAND 'rg --files --no-ignore --follow --glob \'!.git/*\''
set -gx FZF_CTRL_T_COMMAND "rg --files --no-ignore --follow --glob '!.git/*'"

kitty + complete setup fish | source

