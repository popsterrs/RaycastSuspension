local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")

local InputHandler = {
    BoundActions = {},
    Typing = false,

    Settings = require(script.InputSettings),
}

function InputHandler.BindAction(name, actionFunction, keycode)
    ContextActionService:BindAction(name, actionFunction, false, keycode)

    for i, data in pairs(InputHandler.BoundActions) do
      if data.Name == name then
        table.remove(InputHandler.BoundActions, i)
      end
    end

    table.insert(InputHandler.BoundActions, {Name = name, Function = actionFunction})
end

function InputHandler.UnBindAction(name)
    ContextActionService:UnbindAction(name)

    for i, data in pairs(InputHandler.BoundActions) do
        if data.Name == name then
          table.remove(InputHandler.BoundActions, i)
        end
    end
end

UserInputService.TextBoxFocused:Connect(function()
	InputHandler.Typing = true
end)

UserInputService.TextBoxFocusReleased:Connect(function()
	InputHandler.Typing = false
end)

return InputHandler