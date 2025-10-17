" ----------------------------------------------------------------------
"   Find and execute a modeline in the current buffer. This allows us
"   to leave 'nomodeline' set and execute only modelines we've examined
"   to confirm they're not doing anything weird. (There are still
"   additional safety features here in the form of an allowed options
"   list.)
"
"   Unlike standard Vim, the modeline *must* be preceded by whitespace;
"   it may not start at the beginning of a line.
"
"   Significant parts of this were written by claude.ai.

set nomodeline
set modelines=5         " default=5; number of lines at top/bottom to check

function! s:FindExecModeline()
    let count_from_ends = min([&modelines, line('$')])
    let startrange = range(1, count_from_ends)
    let endrange   = range(max([1, line('$') - count_from_ends + 1]), line('$'))
    for i in startrange + endrange
        let line = getline(i)
        if match(line, '\svim:') != -1
            call s:ExecuteModeline(line)
            return
        endif
    endfor
endfunction

function! s:ExecuteModeline(line)
    "   Identify 'vim:' or 'vim: set' portion and extract just the
    "   key=value forms after it.
    let match = matchstr(a:line, '\svim:\s*\%(set\s\+\)\?\zs.\{-}\ze\s*:\?\s*$')
    if empty(match)
        echoerr 'Modeline: could not parse settings from line'
        return
    endif

    echom "Setting modeline" match
    for setting in split(match, '[ \t:]\+')      " split on space/tab/colons
        if s:IsSafeSetting(setting)
            try
                execute 'set ' . setting
            catch
                echoerr 'Modeline: invalid setting "' . setting . '"'
            endtry
        else
            echoerr 'Modeline: blocked unsafe setting "' . setting . '"'
        endif
    endfor
endfunction

"   Whitelist of safe options for modelines.
function! s:IsSafeSetting(setting)
    let safe = [
    \   'autoindent', 'ai',
    \   'background', 'bg',
    \   'backspace', 'bs',
    \   'cindent', 'cin',
    \   'cinkeys', 'cink',
    \   'cinoptions', 'cino',
    \   'comments', 'com',
    \   'commentstring', 'cms',
    \   'encoding', 'enc',
    \   'expandtab', 'et',
    \   'fileformat', 'ff',
    \   'fileencoding', 'fenc',
    \   'filetype', 'ft',
    \   'formatoptions', 'fo',
    \   'formatprg', 'fp',
    \   'infercase', 'inf',
    \   'iskeyword', 'isk',
    \   'nofold',
    \   'noexpandtab',
    \   'nolist',
    \   'nosmarttab',
    \   'notextmode',
    \   'nowrap',
    \   'number', 'nu',
    \   'nonumber',
    \   'shiftround', 'sr',
    \   'shiftwidth', 'sw',
    \   'smartcase', 'scs',
    \   'smartindent', 'si',
    \   'smarttab', 'sta',
    \   'softtabstop', 'sts',
    \   'spell',
    \   'nospell',
    \   'spelllang', 'spl',
    \   'spellsuggest', 'sps',
    \   'tabstop', 'ts',
    \   'textwidth', 'tw',
    \   'virtualedit', 've',
    \   'wrap'
    \   ]
    let opt_name = substitute(a:setting, '[=!?&].*', '', '')
    return index(safe, opt_name) != -1
endfunction

command! Modeline call <SID>FindExecModeline()
