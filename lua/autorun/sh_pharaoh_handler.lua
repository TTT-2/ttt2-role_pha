PHARAOH_HANDLER = {}

function PHARAOH_HANDLER:PlacedAnkh(placer)
	local p_graverobber = self:SelectGraverobber()

	p_graverobber:SetRole(ROLE_GRAVEROBBER)
end

---
-- Returns a player that can be converted to a graverobber
-- Vanilla T players are preferred, other team traitor players are used as
-- a fallback
function PHARAOH_HANDLER:SelectGraverobber()
	local p_vanilla_traitor = {}
	local p_team_traitor = {}

	local plys = player.GetAll()

	for i = 1, #plys do
		local ply = plys[i]

		if ply:GetSubRole() == ROLE_TRAITOR then
			p_vanilla_traitor[#p_vanilla_traitor + 1] = ply
		end

		if ply:GetTeam() == TEAM_TRAITOR then
			p_team_traitor[#p_team_traitor + 1] = ply
		end
	end

	if #p_vanilla_traitor > 0 then
		return p_vanilla_traitor[math.random(1, #p_vanilla_traitor)]
	end

	if #p_team_traitor > 0 then
		return p_team_traitor[math.random(1, #p_team_traitor)]
	end
end