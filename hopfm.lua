local JobIdList, LastScrapeTime

local function GetJobIds()
    local success, response = pcall(function()
        return request({
            Url = "https://ducdesigner.site/JobId/fullmoon",
            Method = "GET"
        })
    end)

    if success and response.Success then
        local data = game.HttpService:JSONDecode(response.Body)
        if data.Amount and data.Amount > 0 then
            local ids, seen = {}, {}
            for _, job in ipairs(data.JobId) do
                for id, _ in pairs(job) do
                    if not seen[id] then
                        table.insert(ids, id)
                        seen[id] = true
                    end
                end
            end
            LastScrapeTime = tick()
            return ids
        end
    end

    return nil
end

local function AutoHop()
    if not JobIdList or tick() - LastScrapeTime > 100 then
        JobIdList = GetJobIds()
        if not JobIdList then
            warn("")
            return
        end
    end

    for _, jobId in ipairs(JobIdList) do
        game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", jobId)
        wait(5)
    end
end

AutoHop()
