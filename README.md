Introduction
===
vim-copycat provides much simpler way to share clipboard between terminal and system


Requirement
===

1. [copycat-clipboard](https://github.com/littleq0903/copycat)
2. Python 2.7


Command
===

1. virtual mode type `<C-c>c` copy into system clipboard or copycat reg 0
2. insert mode type `<C-c>p` paste with system clipboard or copycat reg 0
3. virtual mode type `<C-c>C` like `<C-c>c` but copy into set reg
4. insert mode type `<C-c>P` like `<C-c>p` but paste from reg
5. normal mode type `<C-c>l` show copycat data
6. normal mode type `<C-c>d` type reg name then remove copycat reg


Installation
===

1. `sudo apt-get install python-pip`
1. `sudo pip install copycat-clipboard`
2. `cd ~/.vim/bundles`
3. `git clone git@github.com:georgefs/vim-copycat.git`

then you're all set, from now you're able to use system clipboard as in Vim.


Available Settings
===

You could set the following settings in your `~/.vimrc`:

### `g:copycat#reg`
default register in Vim

### `g:copycat#clip`
clipboard which will be used by copycat-clipboard, default is empty, which means the system clipboard.

### `g:copycat#overwrite_ctrlkeys`
Ctrl-c, Ctrl-v style hotkey bindings

### `g:copycat#auto_sync`
do or do not sync with copycat
