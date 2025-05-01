use git-status.nu

# Environment Variables
$env.config.show_banner = false
$env.PATH = ($env.PATH | prepend [
    $"($env.HOME)/bin",
    $"($env.HOME)/.local/bin",
    "/usr/local/bin",
    $"($env.HOME)/.cargo/bin",
    $"($env.HOME)/.nix-profile/bin"
])

$env.EDITOR = "nvim"
$env.MANPAGER = "nvim +Man!"

$env.config.buffer_editor = "nvim"

# FZF Configuration
$env.FZF_CTRL_T_COMMAND = "exa --icons"
$env.FZF_CTRL_T_OPTS = "--accept-nth=2"
$env.FZF_CTRL_R_OPTS = "--with-nth=2,-1"
$env.FZF_DEFAULT_OPTS = (
    "--height 40% --history-size=10000000000 " +
    "--layout=reverse --border=rounded --exact --cycle --wrap " +
    $"--history=($env.HOME)/.zsh_history " +
    "--color=bg:#00070B,bg+:#000f12,fg:#A9A9A9,fg+:#A9A9A9 " +
    "--color=hl:#F26E74,hl+:#F26E74 " +
    "--color=info:#79AAEB,prompt:#E9967E,pointer:#C488EC " +
    "--color=marker:#78B892,spinner:#78B892 " +
    "--color=border:#E89982"
)

# Prompt Configuration

$env.PROMPT_COMMAND_RIGHT = ""
$env.PROMPT_COMMAND = {
    # Hex to RGB conversions
    let brack_hex = "\e[38;2;83;89;95m"    # #53595f
    let user_hex = "\e[38;2;120;184;146m"  # #78B892
    let at_hex = "\e[38;2;201;147;138m"    # #c9938a
    let host_hex = "\e[38;2;196;136;236m"  # #C488EC
    let cwd_hex = "\e[38;2;103;145;201m"   # #6791C9
    let uid_hex = "\e[38;2;242;110;116m"   # #F26E74
    let reset = "\e[0m"

    let username = $env.USER
    let hostname = (hostname | str trim)
    let cwd = $env.PWD | str replace $env.HOME "~"
    let uid = if (id -u) == 0 { "#" } else { "$" }

    $"($brack_hex)[($user_hex)($username)($at_hex)@($host_hex)($hostname) ($cwd_hex)($cwd)($brack_hex)](git-status)($uid_hex)($uid)($reset)"
}


# Aliases

def nls [...args] {
  hide ls;
  if ($args | is-empty) {
    ls
  } else { ls ...$args }
}

alias ls = exa --icons --git
alias ll = exa -h --git --icons -l
alias l = exa -h --git --icons -l
alias la = exa -h --git --icons -la
alias lt = exa -h --tree --git --icons -l
alias lta = exa -h --tree --git --icons -la

alias grep = grep --color=always
alias objdump = objdump --disassembler-color=on --visualize-jumps=extended-color
alias b64 = base64
alias q = exit
alias sudo = doas
alias cb = cargo build
alias cr = cargo run

# Custom Functions
## def sshot [delay: int] {
##     sleep ($delay | into duration --unit sec)
##     grim $"($env.HOME)/Pictures/p.png"
##     cat $"($env.HOME)/Pictures/p.png" | wl-copy
## }
## 
## def shot [delay: int] {
##     sleep ($delay | into duration --unit sec)
##     grim -g (slurp) $"($env.HOME)/Pictures/p.png"
##     cat $"($env.HOME)/Pictures/p.png" | wl-copy
## }

# Fixed Aliases as Functions
alias gst = git status
alias gp = git push
def gac [message: string] {
    git add .
    git commit -m $message
}

def iamb [] {
    with-env { EDITOR: "nvim" } { iamb }
}
