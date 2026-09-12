pcall(function()
    local function w(g) if not g then return end for _,v in ipairs(g:GetChildren()) do if v.Name=="Rayfield" or v.Name=="Rayfield-Old" then pcall(function() v:Destroy() end) end end end
    if gethui then local o,h=pcall(gethui); if o and h then w(h) end end
    local cg=game:GetService("CoreGui"); if cg then w(cg) end
end)
local ok,RF=pcall(function()return loadstring(game:HttpGet("https://sirius.menu/rayfield"))()end)
if not ok or not RF then warn("[TD] RF FAIL")return end
local W=RF:CreateWindow({Name="EZVC Hub",LoadingTitle="EZVC",LoadingSubtitle="...",ConfigurationSaving={Enabled=false},Discord={Enabled=false},KeySystem=false})
task.spawn(function()
    task.wait(.8)
    local r
    if gethui then local o,h=pcall(gethui); if o and h then r=h:FindFirstChild("Rayfield") end end
    if not r then local cg=game:GetService("CoreGui"); if cg then r=cg:FindFirstChild("Rayfield") end end
    local m=r and r:FindFirstChild("Main")
    local cam=workspace.CurrentCamera
    if not m or not cam then return end
    local vh=cam.ViewportSize.Y
    if vh and vh>0 and m.AbsoluteSize.Y>vh*.85 then
        local nh=math.floor(vh*.8)
        pcall(function() m.Size=UDim2.new(0,500,0,nh); m.Position=UDim2.new(.5,-250,.5,-math.floor(nh/2)) end)
    end
end)
local Tab,P,M=W:CreateTab("Main"),W:CreateTab("Play"),W:CreateTab("Macro")
local RS,HS=game:GetService("ReplicatedStorage"),game:GetService("HttpService")
local PLR=game:GetService("Players").LocalPlayer
local FO="tdmacro/" local CF=FO.."config.json"
if type(isfolder)=="function" and type(makefolder)=="function" and not isfolder(FO) then pcall(makefolder,FO) end
local function wj(p,d) if type(writefile)~="function" then return false end local o,s=pcall(function()return HS:JSONEncode(d)end) if not o then return false end return pcall(writefile,p,s) end
local function rj(p) if type(isfile)~="function" or type(readfile)~="function" or not isfile(p)then return nil end local o,d=pcall(readfile,p) if not o then return nil end local k,a=pcall(function()return HS:JSONDecode(d)end) if not k or type(a)~="table" then return nil end return a end
local function lf()
    if type(listfiles)~="function" then return{}end
    local sn,n={},{}
    for _,p in ipairs{FO,"tdmacro","./tdmacro/"}do local o,l=pcall(listfiles,p) if o and type(l)=="table" then for _,f in ipairs(l)do local x=tostring(f):match("([^/\\]+)%.json$") if x and x~="state" and x~="config" and not sn[x]then sn[x]=true;n[#n+1]=x end end end end
    return n
end
local function rd(d,o) if not d then return end if type(d.Refresh)=="function" then pcall(d.Refresh,d,o)end if type(d.SetOptions)=="function" then pcall(d.SetOptions,d,o)end end

local Cfg={}
do local c=rj(CF) if c and type(c)=="table" then Cfg=c end end
for k,v in pairs({gs="1",mn="",sel="",sk=false,rp=false,lb=false,rec=false,pl=false,s10=false,s1=false,spn=false})do if Cfg[k]==nil then Cfg[k]=v end end
local _init=true local _pend=false
local function save() if _init or _pend then return end _pend=true task.spawn(function() task.wait(.2);_pend=false;pcall(function() wj(CF,Cfg) end) end) end
local function set(k,v) Cfg[k]=v;save() end

local cL,sDD,sel=nil,nil,Cfg.sel or ""
local C={L=0,P=0,U=0,S=0}
local rec={a={},n=1,t={},k={},l=0,active=false}
local R={}
local function ens(k,f,n)
    if R[k] and R[k].Parent then return R[k] end
    local fo=RS:FindFirstChild(f) if not fo then return nil end
    local r=fo:FindFirstChild(n)
    if r and (r:IsA("RemoteEvent") or r:IsA("RemoteFunction")) then R[k]=r;return r end
end
local function N(t,c)pcall(function()RF:Notify({Title=t,Content=c,Duration=4})end)end
local function nm(o) if type(o)=="string" or type(o)=="number" then return tostring(o)end if type(o)=="table" then return tostring(o.Name or o.Value or o[1]or"")end return tostring(o or"") end
local function rfC()if cL then pcall(function()cL:Set(string.format("Lobby %d | Place %d | Upgrade %d | Sell %d",C.L,C.P,C.U,C.S))end)end end
local function vis(d) if not d.Visible then return false end local p=d.Parent while p do if p:IsA("GuiObject")and not p.Visible then return false end p=p.Parent end return true end
local function fB(tx)
    local nd=tx:lower()
    local rr={PLR:FindFirstChild("PlayerGui")}
    if gethui then local o,h=pcall(gethui) if o and h then rr[#rr+1]=h end end
    for _,r in ipairs(rr)do if r then for _,d in ipairs(r:GetDescendants())do
        if (d:IsA("TextButton")or d:IsA("ImageButton"))and vis(d)then
            local t=d.Text
            if d:IsA("ImageButton")then local lb=d:FindFirstChildOfClass("TextLabel") if lb then t=lb.Text end end
            if tostring(t or""):lower():find(nd,1,true)then return d end
        end
    end end end
end
local function lose()return fB("replay")~=nil end
local function resetRec() rec.a={};rec.n=1;rec.t={};rec.k={};rec.l=tick() C.P=0;C.U=0;C.S=0;rfC() end

-- AUTO SUMMON
local function invokeSummon(a)
    local ev
    pcall(function() local fo=RS:FindFirstChild("RemoteFunctions") if fo then ev=fo:FindFirstChild("SummonUnits") end end)
    if not ev or not ev:IsA("RemoteFunction") then return false end
    return pcall(function() ev:InvokeServer(a) end)
end
task.spawn(function()
    while true do
        if Cfg.s10 then if invokeSummon(10) then C.L=C.L+1;rfC() end task.wait(1) else task.wait(.5) end
    end
end)
task.spawn(function()
    while true do
        if Cfg.s1 then if invokeSummon(1) then C.L=C.L+1;rfC() end task.wait(1) else task.wait(.5) end
    end
end)

-- AUTO SPIN
task.spawn(function()
    while true do
        if Cfg.spn then
            local ev
            pcall(function() local fo=RS:FindFirstChild("RemoteFunctions") if fo then ev=fo:FindFirstChild("SpinWheel") end end)
            if ev and ev:IsA("RemoteFunction") then
                pcall(function() ev:InvokeServer() end)
            end
            task.wait(.5)
        else
            task.wait(.2)
        end
    end
end)

Tab:CreateToggle({Name="Auto Summon 10",CurrentValue=Cfg.s10,Callback=function(v)
    local on
    if type(v)=="table" then on=v.Value==true else on=v==true end
    set("s10",on)
end})
Tab:CreateToggle({Name="Auto Summon 1",CurrentValue=Cfg.s1,Callback=function(v)
    local on
    if type(v)=="table" then on=v.Value==true else on=v==true end
    set("s1",on)
end})
Tab:CreateToggle({Name="Auto Spin",CurrentValue=Cfg.spn,Callback=function(v)
    local on
    if type(v)=="table" then on=v.Value==true else on=v==true end
    set("spn",on)
end})

-- ROUND WATCHER
task.spawn(function()
    local was=false
    while true do
        local now=lose()
        if now and not was and rec.active then resetRec() end
        was=now
        task.wait(.5)
    end
end)

local lastW=nil
local function getWS() local o,ws=pcall(function()return RS:WaitForChild("WaveState",5)end) return o and ws or nil end
local function getBtn() local o,b=pcall(function()return PLR.PlayerGui.MainGameUI.UpSide.InfoDop.AutoSkip end) return o and b or nil end
local function setVis(on)
    pcall(function()
        local b=getBtn() if not b then return end
        for _,v in ipairs(b:GetDescendants())do if v:IsA("UIGradient")then
            if v.Name=="AutoOff"then v.Enabled=not on elseif v.Name=="AutoOn"then v.Enabled=on end
        end end
    end)
end
task.spawn(function()
    while true do
        if Cfg.sk then
            local ws=getWS()
            if ws then pcall(function()
                local w=ws:GetAttribute("CurrentWave")
                local c=ws:GetAttribute("CanSkipWave")
                local r=ws:GetAttribute("Result")
                if c==true and r~="Win" and r~="Lose" and lastW~=w then
                    lastW=w
                    local sk=ens("w","RemoteEvents","SkipWaveVote")
                    if sk and pcall(function() sk:FireServer(w) end) then C.L=C.L+1;rfC() end
                end
            end) end
        end
        task.wait(.5)
    end
end)

local rpL=false
local function startRP()
    if rpL then return end
    rpL=true
    task.spawn(function()
        while Cfg.rp do
            local re=RS:FindFirstChild("RemoteEvents")
            local rv=re and re:FindFirstChild("ReplayVote")
            if rv and pcall(function() rv:FireServer() end) then C.L=C.L+1;rfC() end
            task.wait(1)
        end
        rpL=false
    end)
end

task.spawn(function()
    local lf2=false
    while true do
        if lose() then
            if Cfg.lb and not Cfg.rp and not lf2 then
                lf2=true;task.wait(3)
                local tl=RS:FindFirstChild("ReturnToLobby")
                if tl and pcall(function() tl:FireServer() end) then C.L=C.L+1;rfC() end
            end
        elseif lf2 then lf2=false end
        task.wait(.2)
    end
end)

-- HOOK
pcall(function()
    if not(getrawmetatable and setreadonly and newcclosure and getnamecallmethod) then return end
    local mt=getrawmetatable(game);local old=mt.__namecall
    setreadonly(mt,false)
    mt.__namecall=newcclosure(function(self,...)
        local m,x=getnamecallmethod(),{...}
        local r=old(self,...)
        if rec.active then pcall(function()
            local PL=ens("p","RemoteFunctions","PlaceTower")
            local UP=ens("u","RemoteFunctions","UpgradeTower")
            local SE=ens("s","RemoteFunctions","SellTower")
            local SK=ens("w","RemoteEvents","SkipWaveVote")
            local SP=ens("g","RemoteEvents","SetGameSpeed")
            if m=="InvokeServer" and PL and self==PL then
                local n,cf=x[1],x[2]
                if typeof(cf)=="CFrame" then
                    C.P=C.P+1
                    task.spawn(function()
                        local tw=workspace:FindFirstChild("Towers")
                        local bd,b=20,nil
                        if tw then for _,xx in ipairs(tw:GetChildren()) do if not rec.k[xx] then
                            local o,q=pcall(function() return xx:GetPivot().Position end)
                            if o and q then local d=(q-cf.Position).Magnitude if d<bd then b,bd=xx,d end end
                        end end end
                        local id=rec.n;rec.n=id+1
                        if b then rec.t[id]=b;rec.k[b]=id end
                        local t=tick()
                        rec.a[#rec.a+1]={t="P",n=n,p={cf.Position.X,cf.Position.Y,cf.Position.Z},i=id,d=t-(rec.l or t)}
                        rec.l=t;rfC()
                    end)
                end
            elseif m=="InvokeServer" and UP and self==UP then
                local id=rec.k[x[1]]
                if id then C.U=C.U+1;local t=tick();rec.a[#rec.a+1]={t="U",i=id,d=t-(rec.l or t)};rec.l=t;rfC() end
            elseif m=="InvokeServer" and SE and self==SE then
                local i,id=x[1],rec.k[x[1]]
                if id then C.S=C.S+1;local t=tick();rec.a[#rec.a+1]={t="S",i=id,d=t-(rec.l or t)};rec.l=t;rec.t[id]=nil;rec.k[i]=nil;rfC() end
            elseif m=="FireServer" and SK and self==SK then
                local t=tick();rec.a[#rec.a+1]={t="W",d=t-(rec.l or t)};rec.l=t
            elseif m=="FireServer" and SP and self==SP then
                local t=tick();rec.a[#rec.a+1]={t="G",v=x[1],d=t-(rec.l or t)};rec.l=t
            end
        end) end
        return r
    end)
    setreadonly(mt,true)
end)

-- PLAY LOOP
local pToggle
task.spawn(function()
    local function nf(p,ctx)
        local tw=workspace:FindFirstChild("Towers") if not tw then return nil end
        local bd,b=20,nil
        for _,x in ipairs(tw:GetChildren())do if not ctx.k[x]then
            local o,q=pcall(function()return x:GetPivot().Position end)
            if o and q then local d=(q-p).Magnitude if d<bd then b,bd=x,d end end
        end end
        return b
    end
    while true do
        if Cfg.pl and Cfg.sel~="" then
            local data=rj(FO..Cfg.sel..".json")
            if data and #data>0 then
                local P2={t={},k={},i=1}
                while Cfg.pl and P2.i<=#data do
                    local a=data[P2.i]
                    if a then
                        if (a.d or 0)>0 then task.wait(a.d) end
                        if not Cfg.pl then break end
                        if a.t=="P" then
                            local PL=ens("p","RemoteFunctions","PlaceTower")
                            if PL then
                                local cf=CFrame.new(a.p[1],a.p[2],a.p[3])
                                pcall(function() PL:InvokeServer(a.n,cf) end)
                                local t0=tick()
                                while tick()-t0<2 do local i=nf(cf.Position,P2) if i then P2.t[a.i]=i;P2.k[i]=a.i;break end task.wait(.05) end
                            end
                        elseif a.t=="U" then local UP=ens("u","RemoteFunctions","UpgradeTower") local i=P2.t[a.i] if UP and i and i.Parent then pcall(function() UP:InvokeServer(i) end) end
                        elseif a.t=="S" then local SE=ens("s","RemoteFunctions","SellTower") local i=P2.t[a.i] if SE and i and i.Parent then pcall(function() SE:InvokeServer(i) end)P2.t[a.i]=nil;P2.k[i]=nil end
                        elseif a.t=="W" then local SK=ens("w","RemoteEvents","SkipWaveVote") if SK then pcall(function() SK:FireServer(1) end) end
                        elseif a.t=="G" then local SP=ens("g","RemoteEvents","SetGameSpeed") if SP then pcall(function() SP:FireServer(a.v) end) end
                        end
                    end
                    P2.i=P2.i+1
                end
                if Cfg.pl then task.wait(2) end
            else task.wait(1) end
        else task.wait(.5) end
    end
end)

-- PLAY TAB
P:CreateDropdown({Name="Game Speed",Options={"1","1.50","2"},CurrentOption=tostring(Cfg.gs),Callback=function(v)
    local s=nm(v);set("gs",s)
    local n=tonumber(s) if not n then return end
    local g=ens("g","RemoteEvents","SetGameSpeed") if not g then return end
    pcall(function() g:FireServer(n) end)
end})
P:CreateToggle({Name="Auto Skip Wave",CurrentValue=Cfg.sk,Callback=function(v) set("sk",v) if v then lastW=nil;setVis(true)else setVis(false)end end})
P:CreateToggle({Name="Auto Replay",CurrentValue=Cfg.rp,Callback=function(v) set("rp",v) if v then startRP()else rpL=false end end})
P:CreateToggle({Name="Auto Lobby",CurrentValue=Cfg.lb,Callback=function(v) set("lb",v) end})

-- MACRO TAB
M:CreateInput({Name="Macro Name",CurrentValue=Cfg.mn,PlaceholderText="np. EasyFarm",RemoveTextAfterFocusLost=false,Callback=function(t) set("mn",t or "") end})
cL=M:CreateLabel("Lobby 0 | Place 0 | Upgrade 0 | Sell 0")
M:CreateButton({Name="Create/Save Macro",Callback=function()
    local n=(Cfg.mn~="" and Cfg.mn or "")
    if n=="" then N("TD","Wpisz nazwę macro") return end
    if type(isfile)~="function" or not isfile(FO..n..".json") then wj(FO..n..".json",{}) end
    sel=n;set("sel",n)
    local f=lf();rd(sDD,f)
    if sDD then pcall(function() sDD:Set(n) end) end
    N("TD","Macro gotowe: "..n)
end})
sDD=M:CreateDropdown({Name="Saved Macros",Options=lf(),CurrentOption=Cfg.sel or "",Callback=function(o) sel=nm(o);set("sel",sel) end})
local rToggle
rToggle=M:CreateToggle({Name="Record Macro",CurrentValue=Cfg.rec,Callback=function(v)
    local on
    if type(v)=="table" then on=v.Value==true else on=v==true end
    set("rec",on)
    if on then
        if Cfg.sel=="" then N("TD","Najpierw wybierz macro") return end
        resetRec();rec.active=true
        N("TD","Nagrywanie → "..Cfg.sel)
    else
        rec.active=false
        if #rec.a>0 and Cfg.sel~="" then
            if wj(FO..Cfg.sel..".json",rec.a) then N("TD","Zapisano "..#rec.a.." → "..Cfg.sel) end
        else N("TD","Nic do zapisania") end
        resetRec()
    end
end})
M:CreateButton({Name="Delete Macro",Callback=function()
    if Cfg.sel=="" then N("TD","Wybierz macro") return end
    if type(delfile)~="function" then return end
    pcall(delfile,FO..Cfg.sel..".json")
    local f=lf();rd(sDD,f)
    if sDD then pcall(function() sDD:Set("") end) end
    sel="";set("sel","")
    N("TD","Usunięto")
end})
pToggle=M:CreateToggle({Name="Play Macro",CurrentValue=Cfg.pl,Callback=function(v)
    local on
    if type(v)=="table" then on=v.Value==true else on=v==true end
    set("pl",on)
    if on and Cfg.sel=="" then N("TD","Najpierw wybierz macro") end
end})

-- POST-LOAD
_init=false
task.spawn(function()
    task.wait(1.5)
    local gs=tonumber(Cfg.gs)
    if gs then local g=ens("g","RemoteEvents","SetGameSpeed") if g then pcall(function() g:FireServer(gs) end) end end
    if Cfg.sk then lastW=nil;setVis(true) end
    if Cfg.rp then startRP() end
    if sDD and Cfg.sel~="" then pcall(function() sDD:Set(Cfg.sel) end) end
    if Cfg.rec and Cfg.sel~="" then
        resetRec();rec.active=true
        if rToggle and rToggle.Set then pcall(function() rToggle:Set(true) end) end
    elseif Cfg.rec then
        Cfg.rec=false;save()
        if rToggle and rToggle.Set then pcall(function() rToggle:Set(false) end) end
    end
    if pToggle and pToggle.Set then pcall(function() pToggle:Set(Cfg.pl==true) end) end
end)

rfC()
N("TD","EZVC Ready")
print("[TD] DONE")
