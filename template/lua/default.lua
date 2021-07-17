module 'common_aliases'
module 'modcore'
module 'utils'
module 'comboview'

setEditor(false)
setBeatOffset(0)

on('on', function()
    hideObjects()
    toggleModsListVisible(true)
end)

mod({0, 0, {
    {0, 0, 'Tiny', 'outQuad'}, 
    {0, 100, 'Beat', 'outQuad'}, 
    {0, scx, 'x', 'outQuad'}, 
    {0, scy, 'y', 'outQuad'},
    {0, 0, 'rotationx', 'outQuad'}, 
    {0, 0, 'rotationy', 'outQuad'}, 
    {0, 0, 'rotationz', 'outQuad'},
    {0, 1, 'zoomx', 'outQuad'}, 
    {0, 1, 'zoomy', 'outQuad'}, 
    {0, 1, 'zoomz', 'outQuad'},
    {0, 1, 'zoom', 'outQuad'}
}})

action({0.1, function()
    P1:visible(true)
    P2:visible(true)
end})

perframe({0, 8, function()
    msg(beat)
end})
