#!/usr/bin/env bash
# Create new folder in ~/.vim/pack that contains a start folder and cd into it.
#
# Arguments:
#   package_group, a string folder name to create and change into.
#
# Examples:
#   set_group syntax-highlighting
#
function set_group () {
  package_group=$1
  path="$HOME/.vim/pack/$package_group/start"
  mkdir -p "$path"
  cd "$path" || exit
}
# Clone or update a git repo in the current directory.
#
# Arguments:
#   repo_url, a URL to the git repo.
#
# Examples:
#   package https://github.com/tpope/vim-endwise.git
#
function package () {
  repo_url=$1
  expected_repo=$(basename "$repo_url" .git)
  if [ -d "$expected_repo" ]; then
    cd "$expected_repo" || exit
    result=$(git pull --force)
    echo "$expected_repo: $result"
  else
    echo "$expected_repo: Installing..."
    git clone -q "$repo_url"
  fi
}

(
set_group prettycolorsowo
package https://github.com/chriskempson/base16-vim &
package https://github.com/vim-airline/vim-airline-themes &
package https://github.com/dracula/vim.git &
package https://github.com/rust-lang/rust.vim.git &
package https://github.com/arzg/vim-rust-syntax-ext &
package https://github.com/tssm/fairyfloss.vim &
wait
) &

(
set_group hypertext
package https://github.com/ap/vim-css-color &
package https://github.com/mattn/emmet-vim &
wait
) &

(
set_group spaces
package https://github.com/ntpeters/vim-better-whitespace &
package https://github.com/Yggdroot/indentLine &
wait
) &

(
set_group line
package https://github.com/edkolev/tmuxline.vim &
package https://github.com/vim-airline/vim-airline &
wait
) &

(
set_group misc
package https://github.com/airblade/vim-gitgutter &
package https://github.com/ycm-core/YouCompleteMe &
package https://github.com/scrooloose/nerdtree &
wait
) &

wait
