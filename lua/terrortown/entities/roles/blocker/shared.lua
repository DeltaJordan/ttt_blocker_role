if SERVER then
	AddCSLuaFile()
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_block.vmt")
end

function ROLE:PreInitialize()
	self.color = Color(112, 62, 62, 255)

	self.abbr = "block"
	self.surviveBonus = 0.5 -- bonus multiplier for every survive while another player was killed
	self.scoreKillsMultiplier = 5 -- multiplier for kill of player of another team
	self.scoreTeamKillsMultiplier = -16 -- multiplier for teamkill
	self.preventFindCredits = false
	self.preventKillCredits = false
	self.preventTraitorAloneCredits = false

	self.isOmniscientRole = true

	self.defaultTeam = TEAM_TRAITOR

	self.conVarData = {
		pct = 0.17, -- necessary: percentage of getting this role selected (per player)
		maximum = 1, -- maximum amount of roles in a round
		minPlayers = 6, -- minimum amount of players until this role is able to get selected
		credits = 1, -- the starting credits of a specific role
		togglable = true, -- option to toggle a role for a client if possible (F1 menu)
		random = 20,
		traitorButton = 1, -- can use traitor buttons
		shopFallback = SHOP_FALLBACK_TRAITOR
	}
end

function ROLE:Initialize()
	roles.SetBaseRole(self, ROLE_TRAITOR)
end

local function CheckBlockerAlive()
	for _, ply in ipairs(player.GetAll()) do
		if ply:GetSubRole() == ROLE_BLOCKER and ply:Alive() then
			return true
		end
	end

	return false
end

if SERVER then
	hook.Add('TTTCanSearchCorpse', 'TTT2BlockerPreventIdentifyCorpse', function(idPlayer, deadRagdoll, isCovert, isLongRange)
		-- Prevent any players that aren't the Blocker from identifying bodies while a Blocker is still alive
		if CheckBlockerAlive()
		and idPlayer:GetSubRole() != ROLE_BLOCKER then
			idPlayer:PrintMessage(HUD_PRINTTALK, 'Cannot identify bodies while the Blocker is alive!')
			return false
		end

		return true
	end)

	hook.Add('TTT2PostPlayerDeath', 'TTT2BlockerDeath', function(victim, _, _)
		-- Identify all of the current dead players if all of the Blockers are dead
		if victim:GetSubRole() == ROLE_BLOCKER and not CheckBlockerAlive() then
			LANG.MsgAll("ttt2_blocker_role_death", nil, MSG_MSTACK_WARN) -- Show message stating bodies are identified

			for _, ply in ipairs(player.GetAll()) do
				if not ply:Alive() then
					ply:ConfirmPlayer(true)
				end
			end
		end
	end)
end
