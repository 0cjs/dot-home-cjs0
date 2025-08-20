" ----------------------------------------------------------------------
"   Convert '#rrggbb' colour values to closest from 256-colour palette.
"   Written mostly by claude.ai.

"   Helper function for more concise syntax of :highlight lines.
"   :call Hi('Comment', 'ctermfg=#6a9955', 'ctermbg=#2d2d2d', 'cterm=italic')
function! RgbHighlight(group, ...)
    let cmd = 'hi ' . a:group
    for arg in a:000
        if arg =~ '=.*#'
            " Convert #rrggbb to color index
            let parts = split(arg, '=')
            let cmd .= ' ' . parts[0] . '=' . RgbTo256(parts[1])
        else
            let cmd .= ' ' . arg
        endif
    endfor
    "echo 'cmd='.cmd
    execute cmd
endfunction

" Example usage:
" :echo RgbTo256('#ff5733')  " Returns closest 256-color index
" :execute 'hi Comment ctermfg=' . RgbTo256('#6a9955')

"
" Convert RGB hex color (#rrggbb) to closest 256-color palette index
function! RgbTo256(rgb_hex)
    " Remove # if present
    let hex = substitute(a:rgb_hex, '^#', '', '')

    " Convert hex to RGB values
    let r = str2nr(hex[0:1], 16)
    let g = str2nr(hex[2:3], 16)
    let b = str2nr(hex[4:5], 16)

    " Check if it matches a grayscale color (232-255)
    if r == g && g == b
        if r < 8
            return 16
        elseif r > 248
            return 231
        else
            return float2nr((r - 8) / 10.0) + 232
        endif
    endif

    " Map to 6x6x6 color cube (16-231)
    let r_idx = s:RgbToIndex(r)
    let g_idx = s:RgbToIndex(g)
    let b_idx = s:RgbToIndex(b)

    let cube_color = 16 + (36 * r_idx) + (6 * g_idx) + b_idx

    " Also check grayscale colors for best match
    let gray_val = float2nr((r + g + b) / 3.0)
    let gray_color = s:FindClosestGray(gray_val)

    " Calculate distances and return closest
    let cube_dist = s:ColorDistance(r, g, b, cube_color)
    let gray_dist = s:ColorDistance(r, g, b, gray_color)

    return (cube_dist <= gray_dist) ? cube_color : gray_color
endfunction

" Convert RGB component (0-255) to 6-level index (0-5)
function! s:RgbToIndex(val)
    if a:val < 48
        return 0
    elseif a:val < 114
        return 1
    else
        return (a:val - 35) / 40
    endif
endfunction

" Find closest grayscale color
function! s:FindClosestGray(gray_val)
    if a:gray_val < 8
        return 16
    elseif a:gray_val > 248
        return 231
    else
        return float2nr((a:gray_val - 8) / 10.0) + 232
    endif
endfunction

" Calculate color distance using RGB values
function! s:ColorDistance(r, g, b, color_idx)
    let [cr, cg, cb] = s:IndexToRgb(a:color_idx)
    return (a:r - cr) * (a:r - cr) + (a:g - cg) * (a:g - cg) + (a:b - cb) * (a:b - cb)
endfunction

" Convert color index back to RGB for distance calculation
function! s:IndexToRgb(idx)
    if a:idx < 16
        " Standard colors - approximate values
        let colors = [
            \ [0, 0, 0], [128, 0, 0], [0, 128, 0], [128, 128, 0],
            \ [0, 0, 128], [128, 0, 128], [0, 128, 128], [192, 192, 192],
            \ [128, 128, 128], [255, 0, 0], [0, 255, 0], [255, 255, 0],
            \ [0, 0, 255], [255, 0, 255], [0, 255, 255], [255, 255, 255]
        \ ]
        return colors[a:idx]
    elseif a:idx < 232
        " 6x6x6 color cube
        let idx = a:idx - 16
        let r = idx / 36
        let g = (idx % 36) / 6
        let b = idx % 6
        return [s:IndexToRgbComponent(r), s:IndexToRgbComponent(g), s:IndexToRgbComponent(b)]
    else
        " Grayscale
        let gray = 8 + (a:idx - 232) * 10
        return [gray, gray, gray]
    endif
endfunction

"   Convert 6-level index back to RGB component
function! s:IndexToRgbComponent(idx)
    if a:idx == 0
        return 0
    else
        return 55 + a:idx * 40
    endif
endfunction
