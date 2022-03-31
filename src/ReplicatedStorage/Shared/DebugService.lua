local DebugService = {
    DebugEnabled = false,
}

function DebugService.Print(text)
    if DebugService.DebugEnabled then
        print(text)
    end
end

return DebugService