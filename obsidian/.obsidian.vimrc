" inspiration:
" https://github.com/sspaeti/dotfiles/blob/ed6239b202d703b98ab72235d6cfb784e363fe5e/obsidian/.vimrc#L60

unmap <Space>

set clipboard=unnamed

nmap j gj
nmap k gk


imap kj <Esc>
imap jk <Esc>

" vim fold navigation
exmap unfoldall obcommand editor:unfold-all
nmap zR :unfoldall<CR>

exmap foldall obcommand editor:fold-all
nmap zM :foldall<CR>

exmap foldtoggle obcommand editor:toggle-fold
nmap za :foldtoggle<CR>

" exmap back obcommand app:go-back
" nmap <C-o> :back<CR>
" exmap forward obcommand app:go-forward
" nmap <C-i> :forward<CR>


exmap switcher obcommand switcher:open
nmap <Space>ff :switcher<CR>
vmap <Space>ff :switcher<CR>

" exmap globalsearch obcommand global-search:open
" nmap <Space>/ :globalsearch<CR>

"fuzzy serach with omnisearch plugin
exmap omnisearch_search obcommand omnisearch:show-modal
nmap <Space>fs :omnisearch_search<CR>
vmap <Space>fs :omnisearch_search<CR>

exmap close_others obcommand workspace:close-others
nmap <Space>q :close_others<CR>

exmap next_tab obcommand workspace:next-tab
nmap L :next_tab<CR>
exmap prev_tab obcommand workspace:previous-tab
nmap H :prev_tab<CR>

exmap close_others_buffers obcommand workspace:close-others-tab-group
nmap <Space>bo :close_others_buffers<CR>

exmap delete_buffer obcommand workspace:close
nmap <Space>bd :delete_buffer<CR>

" reveal active file in left explorer
exmap reveal_file obcommand file-explorer:reveal-active-file
nmap <Space>ef :reveal_file<CR>

exmap close_tab_group obcommand workspace:close-tab-group
nmap <C-w>q :close_tab_group<CR>

exmap theme_switch obcommand theme:switch
nmap <Space>ub :theme_switch<CR>

" workspace:split-vertical and split-horizontal
exmap split_vertical obcommand workspace:split-vertical
nmap <C-w>v :split_vertical<CR>
exmap split_horizontal obcommand workspace:split-horizontal
nmap <C-w>s :split_horizontal<CR>

" editor:focus directions
exmap focus_top obcommand editor:focus-top
nmap <C-w>k :focus_top<CR>
nmap <C-k> :focus_top<CR>
exmap focus_bottom obcommand editor:focus-bottom
nmap <C-w>j :focus_bottom<CR>
nmap <C-j> :focus_bottom<CR>
exmap focus_left obcommand editor:focus-left
nmap <C-w>h :focus_left<CR>
nmap <C-h> :focus_left<CR>
exmap focus_right obcommand editor:focus-right
nmap <C-w>l :focus_right<CR>
nmap <C-l> :focus_right<CR>

