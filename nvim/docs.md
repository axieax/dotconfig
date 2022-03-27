# Random Docs

## Inspiration

- https://github.com/rockerBOO/awesome-neovim
- https://github.com/NTBBloodbath/doom-nvim/blob/main/docs/modules.md#list-of-modules
- https://github.com/siduck76/NvChad theme
- https://bluz71.github.io/2021/09/10/vim-tips-revisited.html
- TODO: https://github.com/jose-elias-alvarez/dotfiles/blob/main/config/nvim/lua/plugins/init.lua
- TODO: https://github.com/numToStr/dotfiles/blob/master/neovim/.config/nvim/lua/numToStr/plugins.lua
- https://github.com/LunarVim/Neovim-from-scratch/blob/master/lua/user/options.lua
- https://github.com/Gelio/ubuntu-dotfiles/blob/master/install/neovim/stowed/.config/nvim/lua/lsp/tsserver.lua#L13
- https://www.reddit.com/r/neovim/comments/s2ziys/alternative_lua_parser_for_nvimtreesitter_it/
- https://github.com/danymat/champagne/blob/main/lua/plugins.lua
- https://github.com/kabinspace/AstroVim

## TODO

- PRIORITY: focus.nvim incorrect auto resize for toggleterm and bqf
- Augroup instead of aucommand to clear for multiple source
- NvimTree show_file_info border config (https://github.com/kyazdani42/nvim-tree.lua/pull/1042#discussion_r819122836)
- Telescope `man` docs
- Custom require which takes module_name, ... args (pcall wrapper)
- Lua function map -> define custom wrapper func(f, ...) which returns another function
- PRIORITY: Separate telescope extensions, use Packer sequencing (after)
- PRIORITY: set up https://github.com/renerocksai/telekasten.nvim
- PRIORITY: out of mem for large files (e.g. ~/.cache/nvim/lsp.log)
- IMPORTANT: group which-key bindings
- IMPORTANT: lsp bindings into on_attach
- IMPORTANT: util map function use which-key (pcall) https://github.com/neovim/neovim/pull/16594
- IMPORTANT: uncomment adjacent lines https://github.com/numToStr/Comment.nvim/issues/22
- IMPORTANT: set up toggleterm - and warn if exit with hidden terminal
- TODO: use bufferline https://www.youtube.com/watch?v=vJAmjAax2H0
- TODO: use luasnip instead of vsnip
- READ: https://stackoverflow.com/questions/26708822/why-do-vim-experts-prefer-buffers-over-tabs/26710166#26710166
- TODO: use vim-fugitive instead of gitlinker?
- TODO: ]n or ]b next note / todo (todo-commments go to next bookmark)
- TODO: Telescope picker for LSP commands
- TODO: <space>lU to update lsp servers?
- TODO: rust-tools debug setup
- TODO: global toggle inlay hints command (inc rust as well)
- TODO: emmet-ls jsx/tsx support
- TODO: nvim-tree goto location of current buffer in cwd
- TODO: python3 provider (OS, venv)
- TODO: use https://github.com/danymat/neogen
- Update lsp config for installation
- and use https://github.com/mjlbach/neovim/blob/master/runtime/lua/vim/lsp/buf.lua#L187-L229?
- Telescope setup, find_files wrapper if buffer is directory
- Set up snippets (custom and emmet)
- Automatic lspinstall and treesitter parsers
- Add auto packer clean, install, compile under autoinstall packer
- Merge conflict resolver (like vscode) - fugitive has this
- Cursor hover lsp hover or line diagnostic?
- nvim cmp dadbod source
- nvim cmp tzachar/cmp-fzy-buffer?
- Plugin and config split into separate modules?
- TODO: wildmode (command completion) prefer copen over Copen (default > user-defined)
- vim-sandwich (remap s?) or surround.nvim instead of surround.vim
- surround nvim = vim sandwich + vim surround?
- https://github.com/stevearc/stickybuf.nvim
- TODO: lsp config separate into install, setup, utils
- TODO: toggle cmp
- List prereqs
- Tab before indent spot jumps to correct indent spot
- Relative line number disabled ft manually defined?
- Markdown tab and shift tab conditional mapping based on bullet
- TODO: hlslens + vim-visual-multi

## Features/plugins

- Faded unused variables/imports? https://github.com/narutoxy/dim.lua
- https://github.com/mvllow/modes.nvim
- https://github.com/PlatyPew/format-installer.nvim
- https://github.com/sudormrfbin/cheatsheet.nvim
- Git worktree (https://github.com/ThePrimeagen/git-worktree.nvim)
- Dictionary/thesaurus (alternative to rudism/telescope-dict.nvim)
- cmp-rg source https://github.com/lukas-reineke/cmp-rg
- Highlight text temporarily https://www.reddit.com/r/neovim/comments/rmq4gd/is_there_an_alternative_to_vimmark_to_colorize/
- LSPCommands Telescope interface
- https://github.com/ii14/lsp-command ?
- Terminal (float/horizontal) which autosizes
- Coverage
- Gradle (https://github.com/aloussase/telescope-gradle.nvim)
- Lazy loading (event = "BufWinEnter"?) https://youtu.be/JPEx2kI6pfo
- Emmet support for jsx/tsx
- Emmet / autoclose HTML
- Gradual undo
- Markdown HTML Treesitter highlighting + Autotag support
- Autosave and swapfiles?
- Set up quick compiler
- Code runner (Codi, https://github.com/dccsillag/magma-nvim)
- Markdown continue list on next line
- Text object for separate parts of variable name, e.g. helloGoodbye, hello_goodbye
- Telescope-cheat.nvim
- mrjones2014/dash.nvim for linux?
- https://github.com/zim0369/butcher string to array
- https://github.com/ripxorip/aerojump.nvim
- bufferline.nvim or cokeline.nvim instead of barbar?
- windline instead of galaxyline?
- nvimtree config migration
- Calltree (https://github.com/ldelossa/calltree.nvim)
- gcc diagnostics? (https://gitlab.com/andrejr/gccdiag)
- Markdown code block syntax highlighting
- with line for startup time (v -startuptime and read tmp file?)
- something like https://github.com/henriquehbr/nvim-startup.lua?
- https://github.com/VonHeikemen/fine-cmdline.nvim
- Themes: try sonokai and monokai
- Telescope frecency, smart-history
- https://github.com/kwkarlwang/bufresize.nvim
- https://github.com/sQVe/sort.nvim
- https://github.com/nvim-neo-tree/neo-tree.nvim
- https://github.com/NTBBloodbath/rest.nvim API
- PackerUpdate force pull (git fetch origin, git reset -hard origin/master)
- https://github.com/LudoPinelli/comment-box.nvim
- inccommand split preview-window scroll
- https://github.com/natecraddock/workspaces.nvim
- https://github.com/hrsh7th/nvim-cmp/issues/429#issuecomment-980843997

## Notes / issues

- https://github.com/kyazdani42/nvim-tree.lua/issues/806 (plugin being refactored)
- Weird undos https://github.com/hrsh7th/nvim-cmp/issues/328
- Zen mode with nvim-treesitter-context?
- stabilize.nvim view jumps
  - https://github.com/luukvbaal/stabilize.nvim/issues/3
  - https://github.com/booperlv/nvim-gomove/issues/1
  - floats may be closed soon after nvim startup (e.g. Telescope, lazygit)
- Markdown issues - code block cindent, normal nocindent (<CR> on normal line gets extra indent) - autopairs?
- Markdown header folds https://github.com/nvim-treesitter/nvim-treesitter/issues/2145, https://github.com/plasticboy/vim-markdown
- https://www.reddit.com/r/neovim/comments/r8qcxl/nvimcmp_deletes_the_first_word_after_autocomplete/
- https://github.com/hrsh7th/nvim-cmp/issues/611
- nvim-cmp treesitter completion source vs buffer source?
- Opening buffer for file (nvim-tree) replaces barbar buffers
- Markdown TS Parser (https://github.com/MDeiml/tree-sitter-markdown)
- Colorizer disabled on PackerCompile (changing colorscheme), no support for lowercase, unmaintained
- autopairs may start to break after a while (can't insert characters)

## Current PRs / Issues

- https://github.com/nvim-neo-tree/neo-tree.nvim/issues/211
- https://github.com/nvim-neo-tree/neo-tree.nvim/issues/212
- https://github.com/beauwilliams/focus.nvim/issues/82
- https://github.com/j-hui/fidget.nvim/issues/57#issuecomment-1072548339
- https://github.com/simrat39/symbols-outline.nvim/issues/115#issuecomment-1065854099
- https://github.com/anuvyklack/pretty-fold.nvim/issues/9#issuecomment-1013661876
- https://github.com/kevinhwang91/nvim-hlslens/issues/20#issuecomment-981329510
- https://github.com/wbthomason/packer.nvim/issues/760
- https://github.com/folke/todo-comments.nvim/issues/77
- https://github.com/folke/todo-comments.nvim/issues/80
- https://github.com/norcalli/nvim-colorizer.lua/pull/18
- https://github.com/vuki656/package-info.nvim/issues/75
- My surround-wrap plugin (future: URL paste md) - replaced by LuaSnip new feature?
- Git change watch plugin
