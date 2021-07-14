local oldNewIndex
oldNewIndex = hookmetamethod(game, "__newindexx", function(Object, Property, Value)
    if string.find(tostring(Object), "Stamina") and tostring(Object) ~= "StaminaServer" and tostring(Property) == "Value" then
       return oldNewIndex(Object, Property, 100)
    end
    return oldNewIndex(Object, Property, Value)
end)
