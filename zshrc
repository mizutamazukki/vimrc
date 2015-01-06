export MAILCHECK=0
PATH=/bin:/usr/bin:/usr/local/bin:${PATH}
export SCALA_HOME=/path/to/scala
export PATH=PATH:SCALA_HOME/bin
#export PATH=$PATH:/usr/local/play
# (d) is default on
#
# # ------------------------------
# # General Settings
# # ------------------------------
 export EDITOR=vim        # エディタをvimに設定
 export LANG=ja_JP.UTF-8  # 文字コードをUTF-8に設定
 export KCODE=u           # KCODEにUTF-8を設定
 export AUTOFEATURE=true  # autotestでfeatureを動かす
#
 bindkey -v              # キーバインドをviモードに設定
#
 setopt auto_pushd        # cd時にディレクトリスタックにpushdする
 setopt correct           # コマンドのスペルを訂正する
 setopt prompt_subst      # プロンプト定義内で変数置換やコマンド置換を扱う
 setopt notify            # バックグラウンドジョブの状態変化を即時報告する
setopt equals            # =commandを`which command`と同じ処理にする

# ### Complement ###
 autoload -U compinit; compinit # 補完機能を有効にする
 setopt auto_list               # 補完候補を一覧で表示する(d)
 setopt auto_menu               # 補完キー連打で補完候補を順に表示する(d)
 setopt list_packed             # 補完候補をできるだけ詰めて表示する
 setopt list_types              # 補完候補にファイルの種類も表示する
 bindkey "^[[Z" reverse-menu-complete  # Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)
 zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 補完時に大文字小文字を区別しない
# ### History ###
 HISTFILE=~/.zsh_history   # ヒストリを保存するファイル
 HISTSIZE=10000            # メモリに保存されるヒストリの件数
 SAVEHIST=10000            # 保存されるヒストリの件数
 setopt extended_history   # ヒストリに実行時間も保存する
 #setopt hist_ignore_dups   # 直前と同じコマンドはヒストリに追加しない
 setopt share_history      # 他のシェルのヒストリをリアルタイムで共有する
 setopt hist_reduce_blanks # 余分なスペースを削除してヒストリに保存する
  setopt AUTO_CD
  cdpath=(.. ~ ~/src)

# # マッチしたコマンドのヒストリを表示できるようにする
 autoload history-search-end
 zle -N history-beginning-search-backward-end history-search-end
 zle -N history-beginning-search-forward-end history-search-end
 bindkey "^P" history-beginning-search-backward-end
 bindkey "^N" history-beginning-search-forward-end
#
# # すべてのヒストリを表示する
 function history-all { history -E 1 }
#
# # ------------------------------
# # Look And Feel Settings
# # ------------------------------
# ### Ls Color ###
# # 色の設定
 export LSCOLORS=Exfxcxdxbxegedabagacad
# # 補完時の色の設定
 export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
# # ZLS_COLORSとは？
export ZLS_COLORS=$LS_COLORS
# # lsコマンド時、自動で色がつく(ls -Gのようなもの？)
export CLICOLOR=true
# # 補完候補に色を付ける
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
#
# ### Prompt ###
# # プロンプトに色を付ける
autoload -U colors; colors
# # 一般ユーザ時
tmp_prompt="%F{cyan}[%n@%D{%m/%d %T}]%f "
tmp_prompt="%{${fg[cyan]}%}%n%# %{${reset_color}%}"
tmp_prompt2="%{${fg[cyan]}%}%_> %{${reset_color}%}"
tmp_rprompt="%{${fg[green]}%}[%~]%{${reset_color}%}"
tmp_sprompt="%{${fg[yellow]}%}%r is correct? [Yes, No, Abort, Edit]:%{${reset_color}%}"
#
# # rootユーザ時(太字にし、アンダーバーをつける)
if [ ${UID} -eq 0 ]; then
    tmp_prompt="%B%U${tmp_prompt}%u%b"
    tmp_prompt2="%B%U${tmp_prompt2}%u%b"
    tmp_rprompt="%B%U${tmp_rprompt}%u%b"
    tmp_sprompt="%B%U${tmp_sprompt}%u%b"
fi

PROMPT=$tmp_prompt    # 通常のプロンプト
PROMPT2=$tmp_prompt2  # セカンダリのプロンプト(コマンドが2行以上の時に表示される)
RPROMPT=$tmp_rprompt  # 右側のプロンプト
SPROMPT=$tmp_sprompt  # スペル訂正用プロンプト
# SSHログイン時のプロンプト
[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
    PROMPT="%{${fg[white]}%}${HOST%%.*} ${PROMPT}"
;

#Title
precmd() {
    [[ -t 1 ]] || return
    case $TERM in
        *xterm*|rxvt|(dt|k|E)term)
            print -Pn "\e]2;[%~]\a"    
            ;;
        #a screen)
            #print -Pn "\e]0;[%n@%m %~] [%l]\a"
            #print -Pn "\e]0;[%n@%m %~]\a"
            #      ;;
    esac
    alias history='history -E'
    builtin cd $@ && ls;
}

case "$TERM" in
    xterm*|kterm*|rxvt*)
        function precmd () {
        #  Shorten the path of pwd
        pwd=`pwd | \
            perl -pe 's!$ENV{"HOME"}!~!;s!^(.{10,}?/)(.+)(/.{15,})$!$1...$3!'`
        PROMPT=$(print "%B%{\e[34m%}%m:${pwd}%{\e[33m%}%# %b")
        PROMPT=$(print "%{\e]2;%n@%m: %~^G%}$PROMPT")  # title bar
    }
    ;;
         esac

         alias -g ...='../..'
         alias -g ....='../../..'
         alias -g .....='../../../..'
         alias -g L='| less'
         alias -g H='| head'
         alias -g T='| tail'
         alias -g G='| grep'
         alias -g W='| wc'
         alias -g S='| sed'
         alias -g A='| awk'
         alias -g X='| xargs'

         alias where="command -v"
         alias j="jobs -l"
         alias ls="ls -G -w"
         alias l=ls
         alias la="ls -a"
         alias lf="ls -F"
         alias ll="ls -l"
         alias l.="ls -d .*"
         alias du="du -h"
         alias df="df -h"
         alias su="su -l"
         #
         # rbenv & bundle
         alias re="rbenv exec"
         alias be="bundle exec"
         alias rebe="rbenv exec bundle exec"

         ## git
         alias gco="git checkout"
         alias gst="git status"
         alias gci="git commit"
         alias gdf="git diff"
         alias gbr="git branch"
         alias gad="git add"
         alias glo="git log"
         alias gps="git push"
         alias g="google -f"
         #alias 大学に接続
         #alias sh = "ssh -i ./ssh/id_rsa e12117@proxy.edu.tuis.ac.jp"a
        #web検索
         function web_search {
         local url=$1       && shift
         local delimiter=$1 && shift
         local prefix=$1    && shift
         local query

         while [ -n "$1" ]; do
             if [ -n "$query" ]; then
                 query="${query}${delimiter}${prefix}$1"
             else
                 query="${prefix}$1"
             fi
             shift
         done

         open "${url}${query}"
     }
     function google () {
     web_search "https://www.google.co.jp/search?&q=" "+" "" $*
 }
export PATH=/bin:/usr/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Applications/eclipse/android/platform-tools
