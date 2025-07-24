
function GetSocietalClassOfModelType(model)
    if Config.Debug then print("GetSocietalClassOfModelType", model) end
    local type = ""
    for i,v in pairs(Config.Models) do
        for c,k in pairs(v) do
            if k == model then
                type = i 
                return type --"Rich", "Poor", "Nightlady", "Police"
            end
        end
    end
    return "None" --"Rich", "Poor", "Nightlady", "Police"
end