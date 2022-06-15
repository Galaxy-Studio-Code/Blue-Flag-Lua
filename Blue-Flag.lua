-- Blue-Flag lua
-- Github: https://github.com/Galaxy-Studio-Code/Blue-Flag-Lua
-- init
require_game_build(2628)
local LUA_VER = '1.0.11B'
local bfmenu = menu.add_submenu('Blue-Flag\'s Lua')
-- Script core function [INT]
local function stat_set_int(hash, prefix, value, save)
	save = true
	local hash0, hash1 = hash, hash
	if prefix then
		hash0 = 'MP0_' .. hash
		hash1 = 'MP1_' .. hash
	end
	local value0 = stats.get_int(hash0)
	if value0 ~= value then
		stats.set_int(hash0, value)
	end
	if prefix then
		local value1 = stats.get_int(hash1)
		if value1 ~= value then
			stats.set_int(hash1, value)
		end
	end
end
-- BOOL
local function stat_set_bool(hash, prefix, value, save)
	save = true
	local hash0, hash1 = hash, hash
	if prefix then
		hash0 = 'MP0_' .. hash
		hash1 = 'MP1_' .. hash
	end
	local value0 = stats.get_bool(hash0)
	if value0 ~= value then
		stats.set_bool(hash0, value)
	end
	if prefix then
		local value1 = stats.get_bool(hash1)
		if value1 ~= value then
			stats.set_bool(hash1, value)
		end
	end
end
--
local hash
--
function GTAO_USER_MP()
	MP_ = stats.get_int('MPPLY_LAST_MP_CHAR')
	if not MP_ then
		MP_ = 0
	end
	return tostring(MP_)
end
local CharID = '' .. GTAO_USER_MP()
--
function CurrentMP(stat)
	local text = stat
	local MP = stats.get_int(stat)
	if not MP then
		MP = 0
	end
	return ('MP' .. MP .. '_' .. text)
end
--
function GTA_MP()
	MPx_ = stats.get_int('MPPLY_LAST_MP_CHAR')
	if not MP_ then
		MP_ = 0
	end
	return tostring(MPx_)
end
local PlayerMP = 'MP' .. GTA_MP()
-- Player Function
local Player_Function = bfmenu:add_submenu('玩家功能')
-- Kiddion's example
Player_Function:add_toggle('冻结玩家', function()
	return localplayer:get_config_flag(292)
end, function(value)
	localplayer:set_config_flag(292, value)
end)
local toggled = false
Player_Function:add_toggle('切换角色时自动补满血量、护甲和弹药', function()
	return toggled
end, function(e)
	toggle = e
	if e then
		menu.register_callback('MaxArmorHealthAmmoOnPlayerChanged', function(oldPlayer, newPlayer)
			-- When switching player, instantly refill health and armor
			if newPlayer ~= nil then
				newPlayer:set_armour(100)
				newPlayer:set_health(newPlayer:get_max_health())
				menu.max_all_ammo()
			end
		end)
	end
	if not e then
		menu.remove_callback('MaxArmorHealthAmmoOnPlayerChanged')
	end
end)
Player_Function:add_action('自杀', function()
	menu.suicide_player()
end)
local function m_health()
	if localplayer:get_max_health() < 1000 then
		return 1000
	end
	return localplayer:get_max_health()
end
Player_Function:add_int_range('玩家血量 (原血量: ' .. localplayer:get_max_health() .. ')', 10, 0, m_health(), function()
	return localplayer:get_health()
end, function(value)
	localplayer:set_health(value)
end)
Player_Function:add_action('补满零食', function()
	local items = { { 'NO_BOUGHT_YUM_SNACKS', 30 }, { 'NO_BOUGHT_HEALTH_SNACKS', 15 }, { 'NO_BOUGHT_EPIC_SNACKS', 5 }, { 'NUMBER_OF_ORANGE_BOUGHT', 10 },
                 { 'NUMBER_OF_BOURGE_BOUGHT', 10 }, { 'NUMBER_OF_CHAMP_BOUGHT', 5 }, { 'CIGARETTES_BOUGHT', 20 } }
	for i = 1, #items do
		stat_set_int(items[i][1], true, items[i][2])
	end
end)
-- Kiddion's example
Player_Function:add_toggle('缩小玩家', function()
	if localplayer == nil then
		return nil
	end
	return localplayer:get_config_flag(223)
end, function(value)
	localplayer:set_config_flag(223, value)
end)
-- [unuseable]需要对通知的操作
-- local toggled = false
-- Player_Function:add_toggle('静音模式', function()
-- 	return toggled
-- end, function(quiet)
-- 	while quiet do
-- 		toggled = quiet
-- 		menu.clear_all_notifications()
-- 		-- 防止卡住
-- 		sleep(0)
-- 	end
-- 	toggled = false
-- end)
-- Player_Function:add_action('清除通知', function()
-- 	menu.clear_visible_notifications()
-- end)
-- Weapon Function
local Weapon_Function = bfmenu:add_submenu('武器功能')
Weapon_Function:add_action('补满防弹衣', function()
	local items = { { 'MP_CHAR_ARMOUR_1_COUNT', 10 }, { 'MP_CHAR_ARMOUR_2_COUNT', 10 }, { 'MP_CHAR_ARMOUR_3_COUNT', 10 },
                 { 'MP_CHAR_ARMOUR_4_COUNT', 10 }, { 'MP_CHAR_ARMOUR_5_COUNT', 10 } }
	for i = 1, #items do
		stat_set_int(items[i][1], true, items[i][2])
	end
end)
-- Vehicle Function
local Vehicle_Function = bfmenu:add_submenu('载具功能')
-- Kiddion's example
Vehicle_Function:add_toggle('保持载具引擎开启', function()
	return localplayer:get_config_flag(241)
end, function(value)
	localplayer:set_config_flag(241, value)
end)
local toggled = false
Player_Function:add_toggle('切换角色时自动补满血量、护甲和弹药', function()
	return toggled
end, function(e)
	toggle = e
	if e then
		menu.register_callback('MaxVehicleHealth', function(oldVehicle, newVehicle)
			if newVehicle ~= nil then
				if newVehicle:get_health() < newVehicle:get_max_health() then
					newVehicle:set_health(newVehicle:get_max_health())
				end
			end
		end)
	end
	if not e then
		menu.remove_callback('MaxVehicleHealth')
	end
end)
current_vehicle = localplayer:get_current_vehicle()
local function m_v_health()
	if not current_vehicle then
		return 1000
	end
	if current_vehicle:get_max_health() < 1000 then
		return 1000
	end
	return current_vehicle:get_max_health()
end
Vehicle_Function:add_int_range('载具血量 (原血量: ) .. current_vehicle:get_max_health()', 10, 0, m_v_health(), function()
	return current_vehicle:get_health()
end, function(value)
	localplayer:set_health(value)
end)
local current_vehicle = localplayer:get_current_vehicle()
Vehicle_Function:add_int_range('修改载具极速', 10, 0, 1000, function()
	return current_vehicle:get_max_speed()
end, function(value)
	current_vehicle:set_max_speed(value)
end)
local Vehicle_Model = Vehicle_Function:add_submenu('载具模型功能')
Vehicle_Model:add_action('清除载具模型', function()
	localplayer:set_current_vehicle(nil)
end)
-- World Function
local World_Function = bfmenu:add_submenu('世界功能')
World_Function:add_action('允许非公开战局任务', function()
	globals.set_int(2714635 + 744, 0) -- NETWORK::NETWORK_SESSION_GET_PRIVATE_SLOTS
end)
local toggled = false
World_Function:add_toggle('移除CEO板条箱冷却', function()
	return toggled
end, function(e)
	toggled = e
	if e then
		script.set_global_i(262145 + 15361, 0)
		script.set_global_i(262145 + 15362, 0)
	end
	if not e then
		script.set_global_i(262145 + 15361, 300000) -- Buy
		script.set_global_i(262145 + 15362, 1800000) -- Sell
	end
end)
local toggled = false
World_Function:add_toggle('移除CEO载具货物冷却', function()
	return toggled
end, function(e)
	toggled = e
	if e then
		script.set_global_i(262145 + 19477, 0)
		script.set_global_i(262145 + 19478, 0)
		script.set_global_i(262145 + 19479, 0)
		script.set_global_i(262145 + 19480, 0)
	end
	if not e then
		script.set_global_i(262145 + 19477, 1200000) -- 1 Vehicle
		script.set_global_i(262145 + 19478, 1680000) -- 2 Vehicles
		script.set_global_i(262145 + 19479, 2340000) -- 3 Vehicles
		script.set_global_i(262145 + 19480, 2880000) -- 4 Vehicles
	end
end)
local toggled = false
World_Function:add_toggle('移除空运货物冷却', function()
	return toggled
end, function(e)
	toggled = e
	if e then
		script.set_global_i(262145 + 22522, 0)
		script.set_global_i(262145 + 22523, 0)
		script.set_global_i(262145 + 22524, 0)
		script.set_global_i(262145 + 22525, 0)
		script.set_global_i(262145 + 22561, 0)
	end
	if not e then
		script.set_global_i(262145 + 22522, 120000) -- Tobacco, Counterfeit Goods
		script.set_global_i(262145 + 22523, 180000) -- Animal Materials, Art, Jewelry
		script.set_global_i(262145 + 22524, 240000) -- Narcotics, Chemicals, Medical Supplies
		script.set_global_i(262145 + 22525, 60000) -- Additional Time per Player
		script.set_global_i(262145 + 22561, 180000) -- Sale
	end
end)
local toggled = false
World_Function:add_toggle('移除恐霸任务冷却', function()
	return toggled
end, function(e)
	toggle = e
	if e then
		script.set_global_i(262145 + 24304, 0)
		script.set_global_i(262145 + 24305, 0)
		script.set_global_i(262145 + 24306, 0)
		script.set_global_i(262145 + 24307, 0)
		script.set_global_i(262145 + 24308, 0)
	end
	if not e then
		script.set_global_i(262145 + 24304, 300000) -- Between Jobs
		script.set_global_i(262145 + 24305, 1800000) -- Robbery in Progress
		script.set_global_i(262145 + 24306, 1800000) -- Data Sweep
		script.set_global_i(262145 + 24307, 1800000) -- Targeted Data
		script.set_global_i(262145 + 24308, 1800000) -- Diamond Shopping
	end
end)
World_Function:add_action('摩托帮固定单载具出货', function()
	local scriptHash = script('gb_biker_contraband_sell')
	if scriptHash:get_int(692 + 17) ~= 0 then
		scriptHash:set_int(692 + 17, 0) -- vehicle variable
	end
end)
World_Function:add_action('移除天基炮冷却', function()
	stat_set_int('ORBITAL_CANNON_COOLDOWN', true, 0)
end)
local toggled = false
World_Function:add_toggle('冻结 NPC', function()
	return toggled
end, function(e)
	toggled = e
	if e then
		for p in replayinterface.get_peds() do
			if p == localplayer then
				goto continue
			end
			p:set_freeze_momentum(true)
			::continue::
		end
	end
	if not e then
		for p in replayinterface.get_peds() do
			if p == localplayer then
				goto continue
			end
			p:set_freeze_momentum(false)
			::continue::
		end
	end
end)
World_Function:add_action('复活附近 NPC', function()
	for p in replayinterface.get_peds() do
		if p == localplayer then
			goto continue
		end
		p:set_max_health(150)
		p:set_health(150)
		::continue::
	end
end)
-- [unuseable]需要ped判断
-- World_Function:add_action('Weaken all NPCs', function()
-- 	for k, PedIA in pairs(ped.get_all_peds()) do
-- 		if not ped.is_ped_a_player(PedIA) then
-- 			weapon.remove_all_ped_weapons(PedIA)
-- 			ped.set_ped_combat_movement(PedIA
-- 		end
-- 	end
-- end)
-- [unuseable]需要操作实体
-- This is a concept, works well, but depends in many things
-- World_Function("移除直升机/船", function()
-- 	for k, DOORs in pairs(vehicle.get_all_vehicles()) do
-- 		local ENT_ENTRY = entity.get_entity_model_hash(DOORs) or vehicle.get_all_vehicle_model_hashes(DOORs)
-- 		local AVG = 2047212121
-- 		local heliA = 2623428164
-- 		local heliB = 745926877
-- 		local boatA = 1448677353
-- 		local truck = 1747439474
-- 		if ENT_ENTRY == AVG or ENT_ENTRY == heliA or ENT_ENTRY == heliB or ENT_ENTRY == boatA or ENT_ENTRY == truck then
-- 			network.request_control_of_entity(DOORs)
-- 			local timer = utils.time_ms() + 500
-- 			while not network.has_control_of_entity(DOORs) and timer > utils.time_ms() do
-- 				system.wait(1500)
-- 			end
-- 			if network.has_control_of_entity(DOORs) then
-- 				entity.set_entity_coords_no_offset(DOORs,vector(671.389,7613.515,-109.629))
-- 			end
-- 		end
-- 	end
-- end)
-- [unuseable]需要对时间的操作
-- do
-- 	World_Function:add_action('离开战局', function()
-- 		local time = utils.time_ms() + 8500
-- 		while time > utils.time_ms() do
-- 		end
-- 	end)
-- end
-- Teleport Function
local Teleport_Function = bfmenu:add_submenu('传送功能')
local HU_JING_TELE = Teleport_Function:add_submenu('虎鲸内传送点')
HU_JING_TELE:add_action('驾驶座位', function()
	localplayer:set_position(vector3(1560.303, 381.718, -49.685))
end)
HU_JING_TELE:add_action('导弹控制座位', function()
	localplayer:set_position(vector3(1559.726, 388.009, -49.685))
end)
HU_JING_TELE:add_action('麻雀停机坪 (主甲板)', function()
	localplayer:set_position(vector3(1563.830, 409.712, -49.667))
end)
HU_JING_TELE:add_action('个人空间', function()
	localplayer:set_position(vector3(1558.518, 383.137, -53.284))
end)
HU_JING_TELE:add_action('武器工作室', function()
	localplayer:set_position(vector3(1561.609, 381.089, -56.088))
end)
HU_JING_TELE:add_action('出口 1', function()
	localplayer:set_position(vector3(1563.479, 371.470, -49.685))
end)
HU_JING_TELE:add_action('出口 2', function()
	localplayer:set_position(vector3(1561.433, 391.197, -49.685))
end)
HU_JING_TELE:add_action('出口 3', function()
	localplayer:set_position(vector3(1564.593, 447.083, -53.129))
end)
local LSC_DLC_TELE = Teleport_Function:add_submenu('洛圣都车友会')
LSC_DLC_TELE:add_action('车友会入口', function()
	localplayer:set_position(vector3(782.597, -1867.812, 29.253))
end)
LSC_DLC_TELE:add_action('车友会内部', function()
	localplayer:set_position(vector3(-2148.729, 1137.968, -24.371))
end)
LSC_DLC_TELE:add_action('测试赛道', function()
	localplayer:set_position(vector3(-2025.252, 1115.701, -27.761))
end)
LSC_BANG = Teleport_Function:add_submenu('媒体记忆棒')
LSC_BANG:add_action('赌场楼顶露台', function()
	localplayer:set_position(vector3(955.550, 50.059, 112.553))
end)
LSC_BANG:add_action('车友会角落', function()
	localplayer:set_position(vector3(-2172.616, 1159.674, -24.372))
end)
LSC_BANG:add_action('夜总会办公室', function()
	localplayer:set_position(vector3(-1619.068, -3010.602, -75.205))
end)
LSC_BANG:add_action('游戏厅吧台', function()
	localplayer:set_position(vector3(2727.082, -387.540, -48.993))
end)
local UKN_HELPSRKL = Teleport_Function:add_submenu('连环杀手')
UKN_HELPSRKL:add_action('线索 1 - 血手印', function()
	localplayer:set_position(vector3(-678.9984, 5797.6851, 17.3309))
end)
UKN_HELPSRKL:add_action('线索 2 - 砍刀', function()
	localplayer:set_position(vector3(1901.4042, 4911.5479, 48.6951))
end)
UKN_HELPSRKL:add_action('线索 3 - 断手', function()
	localplayer:set_position(vector3(1111.7750, 3142.0457, 38.4241))
end)
UKN_HELPSRKL:add_action('线索 4 -信件', function()
	localplayer:set_position(vector3(-136.5509, 1912.8038, 197.2982))
end)
local UKN_HELPSRKLC = UKN_HELPSRKL:add_submenu('线索 5 - 黑色面包车')
UKN_HELPSRKLC:add_action('线索5 - 地点 1', function()
	localplayer:set_position(vector3(2576.0391, 1251.7494, 43.6099))
end)
UKN_HELPSRKLC:add_action('线索5 - 地点 2', function()
	localplayer:set_position(vector3(2903.4150, 3644.0413, 43.8774))
end)
UKN_HELPSRKLC:add_action('线索5 - 地点 3', function()
	localplayer:set_position(vector3(2432.3904, 5846.0757, 58.8891))
end)
UKN_HELPSRKLC:add_action('线索5 - 地点 4', function()
	localplayer:set_position(vector3(-1567.880, 4424.6104, 7.2154))
end)
UKN_HELPSRKLC:add_action('线索5 - 地点 5', function()
	localplayer:set_position(vector3(-1715.793, 2618.7686, 2.9409))
end)
local UKN_KBBL_TELE = Teleport_Function:add_submenu('Kenny\'s Backyard Boogie 专辑')
UKN_KBBL_TELE:add_action('Kenny\'s Backyard Boogie - 地点 1', function()
	localplayer:set_position(vector3(-2163.025, 1083.473, -24.362))
end)
UKN_KBBL_TELE:add_action('Kenny\'s Backyard Boogie - 地点 2', function()
	localplayer:set_position(vector3(-2180.532, 1082.276, -24.367))
end)
UKN_KBBL_TELE:add_action('Kenny\'s Backyard Boogie - 地点 3', function()
	localplayer:set_position(vector3(-2162.992, 1089.790, -24.363))
end)
UKN_KBBL_TELE:add_action('Kenny\'s Backyard Boogie - 地点 4', function()
	localplayer:set_position(vector3(-2162.770, 1115.913, -24.371))
end)
-- Recovery Function
local Recovery_Function = bfmenu:add_submenu('恢复功能')
Recovery_Function:add_action('清除被杀记录', function()
	stat_set_int('MP0_ARCHENEMY_KILLS', true, 0)
	stat_set_int('MP1_ARCHENEMY_KILLS', true, 0)
	stat_set_int('MP0_DEATHS', true, 0)
	stat_set_int('MP1_DEATHS', true, 0)
	stat_set_int('MP0_DIED_IN_EXPLOSION', true, 0)
	stat_set_int('MP1_DIED_IN_EXPLOSION', true, 0)
	stat_set_int('MP0_DIED_IN_FALL', true, 0)
	stat_set_int('MP1_DIED_IN_FALL', true, 0)
	stat_set_int('MP0_DIED_IN_FIRE', true, 0)
	stat_set_int('MP1_DIED_IN_FIRE', true, 0)
	stat_set_int('MP0_DIED_IN_ROAD', true, 0)
	stat_set_int('MP1_DIED_IN_ROAD', true, 0)
	stat_set_int('MP0_DIED_IN_DROWNING', true, 0)
	stat_set_int('MP1_DIED_IN_DROWNING', true, 0)
end)
Recovery_Function:add_action('移除赌场筹码冷却', function()
	if stats.get_int('MPPLY_CASINO_CHIPS_PUR_GD') ~= 0 then
		stat_set_int('MPPLY_CASINO_CHIPS_PUR_GD', true, 0)
	end
end)
Recovery_Function:add_action('移除收支差', function()
	local a = stats.get_int(CurrentMP('MONEY_SPENT_WEAPON_ARMOR'))
	a = a + stats.get_int(CurrentMP('MONEY_SPENT_VEH_MAINTENANCE'))
	a = a + stats.get_int(CurrentMP('MONEY_SPENT_STYLE_ENT'))
	a = a + stats.get_int(CurrentMP('MONEY_SPENT_PROPERTY_UTIL'))
	a = a + stats.get_int(CurrentMP('MONEY_SPENT_JOB_ACTIVITY'))
	a = a + stats.get_int(CurrentMP('MONEY_SPENT_CONTACT_SERVICE'))
	a = a + stats.get_int(CurrentMP('MONEY_SPENT_HEALTHCARE'))
	a = a + stats.get_int(CurrentMP('MONEY_SPENT_DROPPED_STOLEN'))
	a = a + stats.get_int(CurrentMP('MONEY_SPENT_SHARED'))
	a = a + stats.get_int(CurrentMP('MONEY_SPENT_JOBSHARED'))
	local b = stats.get_int(CurrentMP('MONEY_EARN_JOBS'))
	b = b + stats.get_int(CurrentMP('MONEY_EARN_SELLING_VEH'))
	b = b + stats.get_int(CurrentMP('MONEY_EARN_BETTING'))
	b = b + stats.get_int(CurrentMP('MONEY_EARN_GOOD_SPORT'))
	b = b + stats.get_int(CurrentMP('MONEY_EARN_PICKED_UP'))
	b = b + stats.get_int(CurrentMP('MONEY_EARN_SHARED'))
	b = b + stats.get_int(CurrentMP('MONEY_EARN_JOBSHARED'))
	if a > b then
		local m = a - b
		stat_set_int('MP0_MONEY_EARN_JOBSHARED', true, stats.get_int(CurrentMP('MONEY_EARN_JOBSHARED')) + m)
	end
end)
-- Misc Function
local Misc_Function = bfmenu:add_submenu('杂项功能')
local SCENE_CUT = Misc_Function:add_submenu('过场动画')
SCENE_CUT:add_action('跳过过场动画', function()
	menu.end_cutscene()
end)
-- Heist Control
-- Edit from 2Take1 Heist-Control-v2 lua by jhowkNx
local Heist_Control = bfmenu:add_submenu('任务控制功能')
local PERICO_HEIST = Heist_Control:add_submenu('佩里科岛')
local CAYO_AUTO_PRST = PERICO_HEIST:add_submenu('预设')
local NON_EVENT = CAYO_AUTO_PRST:add_submenu('标准预设 $250w')
local AUTOMATED_SOLO = NON_EVENT:add_submenu('单人 $240w')
local AUTOMATED_2P = NON_EVENT:add_submenu('双人 $240w')
local AUTOMATED_3P = NON_EVENT:add_submenu('三人 $240w')
local AUTOMATED_4P = NON_EVENT:add_submenu('四人 $240w')
local QUICK_PRST = NON_EVENT:add_submenu('1-4人 $250w')
local WEEKLY_PRESET = CAYO_AUTO_PRST:add_submenu('活动周预设 $410w')
local WEEKLY_SOLO = WEEKLY_PRESET:add_submenu('单人 $410w')
local WEEKLY_F2 = WEEKLY_PRESET:add_submenu('双人 $410w')
local WEEKLY_F3 = WEEKLY_PRESET:add_submenu('三人 $410w')
local WEEKLY_F4 = WEEKLY_PRESET:add_submenu('四人 $410w')
local TELEPORT = PERICO_HEIST:add_submenu('传送地点')
local TELEPORT_QL = TELEPORT:add_submenu('快速传送')
local TELEPORTLOOT = TELEPORT:add_submenu('小岛地点')
local TELEPORTMANSIONO = TELEPORT:add_submenu('豪宅外部')
local TELEPORTMANSIONI = TELEPORT:add_submenu('豪宅内部')
local TELEPORTCHESTS = TELEPORT:add_submenu('藏宝箱')
local PERICO_ADV = PERICO_HEIST:add_submenu('高级功能')
local HSCUT_CP = PERICO_ADV:add_submenu('玩家分红')
local PERICO_HOST_CUT = HSCUT_CP:add_submenu('玩家 1 分红')
local PERICO_P2_CUT = HSCUT_CP:add_submenu('玩家 2 分红')
local PERICO_P3_CUT = HSCUT_CP:add_submenu('玩家 3 分红')
local PERICO_P4_CUT = HSCUT_CP:add_submenu('玩家 4 分红')
local CAYO_BAG = PERICO_ADV:add_submenu('修改背包容量')
local CAYO_VEHICLES = PERICO_HEIST:add_submenu('接近载具')
local CAYO_PRIMARY = PERICO_HEIST:add_submenu('主要目标')
local CAYO_SECONDARY = PERICO_HEIST:add_submenu('次要目标')
local CAYO_WEAPONS = PERICO_HEIST:add_submenu('武器装备')
local CAYO_EQUIPM = PERICO_HEIST:add_submenu('前置装备位置选择')
local CAYO_TRUCK = PERICO_HEIST:add_submenu('货运卡车')
local CAYO_DFFCTY = PERICO_HEIST:add_submenu('抢劫难度')
local MORE_OPTIONS = PERICO_HEIST:add_submenu('::: 更多选项')
--
local CASINO_HEIST = Heist_Control:add_submenu('名钻赌场抢劫')
local CASINO_PRESETS = CASINO_HEIST:add_submenu('预设')
local CAH_DIA_TARGET = CASINO_PRESETS:add_submenu('钻石 $350w 1-4 人')
local CAH_GOLD_TARGET = CASINO_PRESETS:add_submenu('黄金 $350w 1-4 人')
local CAH_ADVCED = CASINO_HEIST:add_submenu('高级功能')
local CASINO_BOARD1 = CASINO_HEIST:add_submenu('抢劫计划板 (第一块)')
local BOARD1_APPROACH = CASINO_BOARD1:add_submenu('选择抢劫方式和难度')
local CASINO_TARGET = CASINO_BOARD1:add_submenu('选择主要目标')
local CASINO_BOARD2 = CASINO_HEIST:add_submenu('抢劫计划板 (第二块)')
local CASINO_BOARD3 = CASINO_HEIST:add_submenu('抢劫计划板 (第三块)')
local CASINO_LBOARDS = CASINO_HEIST:add_submenu('加载/取消加载计划板')
local CASINO_MORE = CASINO_HEIST:add_submenu('::: 更多选项')
--
local DOOMS_HEIST = Heist_Control:add_submenu('末日抢劫')
local DOOMS_PRESETS = DOOMS_HEIST:add_submenu('预设')
local DDHEIST_PLYR_MANAGER = DOOMS_HEIST:add_submenu('玩家分红')
local TELEPORT_DOOMS = DOOMS_HEIST:add_submenu('传送地点')
--
local CLASSIC_HEISTS = Heist_Control:add_submenu('公寓老抢劫')
local CLASSIC_CUT = CLASSIC_HEISTS:add_submenu('你的分红 (作为房主时使用)')
--
local TH_CONTRACT = Heist_Control:add_submenu('事务所合约')
local LS_ROBBERY = Heist_Control:add_submenu('改装铺合约')
local Heist_Inspector = Heist_Control:add_submenu('抢劫检测')
local TOOLS = Heist_Control:add_submenu('工具')
--
URL = '次，'
SUB = '虎鲸'
AKT = '阿尔科诺斯特'
VEL = '梅杜莎'
STA = '隐形歼灭者'
KUT = '巡逻艇'
LOG = '长崎'
COMPLT = '完成的佩里科岛抢劫'
KOS = 'CR_SUBMARINE'
STB = 'CR_STRATEGIC_BOMBER'
SMG = 'CR_SMUGGLER_PLANE'
STE = 'CR_STEALTH_HELI'
KTT = 'CR_PATROL_BOAT'
LNG = 'CR_SMUGGLER_BOAT'
CPL = 'H4_PLAYTHROUGH_STATUS'
PAN = '猎豹雕像'
MAZ = '玛德拉索文件'
PDD = '粉钻'
BON = '不记名债券'
NCK = '红宝石项链'
TQL = '西西米托龙舌兰酒'
PAN_ = 'CR_SAPHIREPANSTAT'
MAZ_ = 'CR_MADRAZO_FILES'
PDD_ = 'CR_PINK_DIAMOND'
BON_ = 'CR_BEARER_BONDS'
NCK_ = 'CR_PEARL_NECKLACE'
TQL_ = 'CR_TEQUILA'
-- This function is from Moist Menu
local HI_a = Heist_Inspector:add_submenu('佩里科岛抢劫检测器')
local HI_Vehicle = HI_a:add_submenu('最常使用的接近载具')
HI_Vehicle:add_action('查询最常使用的接近载具', function()
	local stat = CurrentMP(KOS)
	local stat_result = stats.get_int(stat)
	if not stat_result then
		stat_result = 0
	end
	--
	local stat = CurrentMP(STB)
	local stat_result_0 = stats.get_int(stat)
	if not stat_result_0 then
		stat_result_0 = 0
	end
	--
	local stat = CurrentMP(SMG)
	local stat_result_1 = stats.get_int(stat)
	if not stat_result_1 then
		stat_result_1 = 0
	end
	--
	local stat = CurrentMP(STE)
	local stat_result_2 = stats.get_int(stat)
	if not stat_result_2 then
		stat_result_2 = 0
	end
	--
	local stat = CurrentMP(KTT)
	local stat_result_3 = stats.get_int(stat)
	if not stat_result_3 then
		stat_result_3 = 0
	end
	--
	local stat = CurrentMP(LNG)
	local stat_result_4 = stats.get_int(stat)
	if not stat_result_4 then
		stat_result_4 = 0
	end
	if not HI_Vehicle_Result then
		HI_Vehicle_Result = HI_Vehicle:add_submenu('查询结果')
	end
	HI_Vehicle_Result:clear()
	HI_Vehicle_Result:add_action('你选择了' .. SUB .. stat_result .. URL, function()
	end)
	HI_Vehicle_Result:add_action('你选择了' .. AKT .. stat_result_0 .. URL, function()
	end)
	HI_Vehicle_Result:add_action('你选择了' .. VEL .. stat_result_1 .. URL, function()
	end)
	HI_Vehicle_Result:add_action('你选择了' .. STA .. stat_result_2 .. URL, function()
	end)
	HI_Vehicle_Result:add_action('你选择了' .. KUT .. stat_result_3 .. URL, function()
	end)
	HI_Vehicle_Result:add_action('你选择了' .. LOG .. stat_result_4 .. URL, function()
	end)
end)
local HI_PRIMARY = HI_a:add_submenu('抢劫的主要目标次数')
HI_PRIMARY:add_action('查询抢劫的主要目标次数', function()
	local stat = CurrentMP(PAN_)
	local Answer_0 = stats.get_int(stat)
	if not Answer_0 then
		Answer_0 = 0
	end
	--
	local stat = CurrentMP(MAZ_)
	local Answer_1 = stats.get_int(stat)
	if not Answer_1 then
		Answer_1 = 0
	end
	--
	local stat = CurrentMP(PDD_)
	local Answer_2 = stats.get_int(stat)
	if not Answer_2 then
		Answer_2 = 0
	end
	--
	local stat = CurrentMP(BON_)
	local Answer_3 = stats.get_int(stat)
	if not Answer_3 then
		Answer_3 = 0
	end
	--
	local stat = CurrentMP(NCK_)
	local Answer_4 = stats.get_int(stat)
	if not Answer_4 then
		Answer_4 = 0
	end
	--
	local stat = CurrentMP(TQL_)
	local Answer_5 = stats.get_int(stat)
	if not Answer_5 then
		Answer_5 = 0
	end
	if not HI_PRIMARY_Result then
		HI_PRIMARY_Result = HI_PRIMARY:add_submenu('查询结果')
	end
	HI_PRIMARY_Result:clear()
	HI_PRIMARY_Result:add_action('你选择了' .. PAN .. Answer_0 .. URL, function()
	end)
	HI_PRIMARY_Result:add_action('你选择了' .. MAZ .. Answer_1 .. URL, function()
	end)
	HI_PRIMARY_Result:add_action('你选择了' .. PDD .. Answer_2 .. URL, function()
	end)
	HI_PRIMARY_Result:add_action('你选择了' .. BON .. Answer_3 .. URL, function()
	end)
	HI_PRIMARY_Result:add_action('你选择了' .. NCK .. Answer_4 .. URL, function()
	end)
	HI_PRIMARY_Result:add_action('你选择了' .. TQL .. Answer_5 .. URL, function()
	end)
end)
local HI_Complete = HI_a:add_submenu('完成的佩里克岛抢劫次数')
HI_Complete:add_action('查询完成的佩里克岛抢劫次数', function()
	local stat = CurrentMP(CPL)
	local stat_result_5 = stats.get_int(stat)
	if not stat_result_5 then
		stat_result_5 = 0
	end
	if not HI_Complete_Result then
		HI_Complete_Result = HI_Complete:add_submenu('查询结果')
	end
	HI_Complete_Result:clear()
	HI_Complete_Result:add_action('你完成了佩里克岛抢劫' .. stat_result_5 .. URL, function()
	end)
end)
local EDIT_HI = HI_a:add_submenu('编辑器')
-- [unuseable]需要用户输入
EDIT_HI:add_action('该功能暂时不可用', function()
end)
-- local valueToSet = EDIT_HI:add_action("修改佩里克岛抢劫次数", function()
-- 	local Choose, ME = input.get("输入数字", "", 1000, 3)
-- 	if Choose == 1 then return HANDLER_CONTINUE end
-- 	if Choose == 2 then return HANDLER_POP end
-- 	stats.set_int(PlayerMP .. "_H4_PLAYTHROUGH_STATUS", tonumber(ME))
-- end)
-- local valueToSet = EDIT_HI:add_action("修改虎鲸次数", function()
-- 	local Choose, ME = input.get("输入数字", "", 1000, 3)
-- 	if Choose == 1 then return HANDLER_CONTINUE end
-- 	if Choose == 2 then return HANDLER_POP end
-- 	stats.set_int(PlayerMP .. "_CR_SUBMARINE", tonumber(ME))
-- end)
-- local valueToSet = EDIT_HI:add_action("修改阿尔科诺斯特次数", function()
-- 	local Choose, ME = input.get("输入数字", "", 1000, 3)
-- 	if Choose == 1 then return HANDLER_CONTINUE end
-- 	if Choose == 2 then return HANDLER_POP end
-- 	stats.set_int(PlayerMP .. "_CR_STRATEGIC_BOMBER", tonumber(ME))
-- end)
-- local valueToSet = EDIT_HI:add_action("修改梅杜莎次数", function()
-- 	local Choose, ME = input.get("输入数字", "", 1000, 3)
-- 	if Choose == 1 then return HANDLER_CONTINUE end
-- 	if Choose == 2 then return HANDLER_POP end
-- 	stats.set_int(PlayerMP .. "_CR_SMUGGLER_PLANE", tonumber(ME))
-- end)
-- local valueToSet = EDIT_HI:add_action("修改隐型直升机次数", function()
-- 	local Choose, ME = input.get("输入数字", "", 1000, 3)
-- 	if Choose == 1 then return HANDLER_CONTINUE end
-- 	if Choose == 2 then return HANDLER_POP end
-- 	stats.set_int(PlayerMP .. "_CR_STEALTH_HELI", tonumber(ME))
-- end)
-- local valueToSet = EDIT_HI:add_action("修改巡逻艇次数", function()
-- 	local Choose, ME = input.get("输入数字", "", 1000, 3)
-- 	if Choose == 1 then return HANDLER_CONTINUE end
-- 	if Choose == 2 then return HANDLER_POP end
-- 	stats.set_int(PlayerMP .. "_CR_PATROL_BOAT", tonumber(ME))
-- end)
-- local valueToSet = EDIT_HI:add_action("修改长崎次数", function()
-- 	local Choose, ME = input.get("输入数字", "", 1000, 3)
-- 	if Choose == 1 then return HANDLER_CONTINUE end
-- 	if Choose == 2 then return HANDLER_POP end
-- 	stats.set_int(PlayerMP .. "_CR_SMUGGLER_BOAT", tonumber(ME))
-- end)
-- local valueToSet = EDIT_HI:add_action("修改猎豹雕像次数", function()
-- 	local Choose, ME = input.get("输入数字", "", 1000, 3)
-- 	if Choose == 1 then return HANDLER_CONTINUE end
-- 	if Choose == 2 then return HANDLER_POP end
-- 	stats.set_int(PlayerMP .. "_CR_SAPHIREPANSTAT", tonumber(ME))
-- end)
-- local valueToSet = EDIT_HI:add_action("修改玛德拉索文件次数", function()
-- 		local Choose, ME = input.get("输入数字", "", 1000, 3)
-- 		if Choose == 1 then return HANDLER_CONTINUE end
-- 		if Choose == 2 then return HANDLER_POP end
-- 		stats.set_int(PlayerMP .. "_CR_MADRAZO_FILES", tonumber(ME))
-- 	end)
-- local valueToSet = EDIT_HI:add_action("修改粉钻次数", function()
-- 		local Choose, ME = input.get("输入数字", "", 1000, 3)
-- 		if Choose == 1 then return HANDLER_CONTINUE end
-- 		if Choose == 2 then return HANDLER_POP end
-- 		stats.set_int(PlayerMP .. "_CR_PINK_DIAMOND", tonumber(ME))
-- 	end)
-- local valueToSet = EDIT_HI:add_action("修改不记名债券次数", function()
-- 		local Choose, ME = input.get("输入数字", "", 1000, 3)
-- 		if Choose == 1 then return HANDLER_CONTINUE end
-- 		if Choose == 2 then return HANDLER_POP end
-- 		stats.set_int(PlayerMP .. "_CR_BEARER_BONDS", tonumber(ME))
-- 	end)
-- local valueToSet = EDIT_HI:add_action("修改红宝石项链次数", function()
-- 		local Choose, ME = input.get("输入数字", "", 1000, 3)
-- 		if Choose == 1 then return HANDLER_CONTINUE end
-- 		if Choose == 2 then return HANDLER_POP end
-- 		stats.set_int(PlayerMP .. "_CR_PEARL_NECKLACE", tonumber(ME))
-- 	end)
-- local valueToSet = EDIT_HI:add_action("修改西西米托龙舌兰酒次数", function()
-- 	local Choose, ME = input.get("输入数字", "", 1000, 3)
-- 	if Choose == 1 then return HANDLER_CONTINUE end
-- 	if Choose == 2 then return HANDLER_POP end
-- 	stats.set_int(PlayerMP .. "_CR_TEQUILA", tonumber(ME))
-- end)
-- CAYO CUSTOM TELEPORT
TELEPORT_QL:add_action('虎鲸 :: 内部面板 [请先呼叫虎鲸]', function()
	localplayer:set_position(vector3(1561.224, 386.659, -49.685))
end)
TELEPORT_QL:add_action('虎鲸 :: 主甲板 [请先呼叫虎鲸]', function()
	localplayer:set_position(vector3(1563.218, 406.030, -49.667))
end)
TELEPORT_QL:add_action('排水管道 :: 入口 (切割格栅处)', function()
	localplayer:set_position(vector3(5044.726, -5816.164, -11.213))
end)
TELEPORT_QL:add_action('排水管道 :: 入口 (二次检查点)', function()
	localplayer:set_position(vector3(5054.630, -5771.519, -4.807))
end)
TELEPORT_QL:add_action('主要目标 :: 房间', function()
	localplayer:set_position(vector3(5007.895, -5755.581, 15.484))
end)
TELEPORT_QL:add_action('次要目标 :: 房间', function()
	localplayer:set_position(vector3(5003.467, -5749.352, 14.840))
end)
TELEPORT_QL:add_action('办公室 :: 金库/保险柜', function()
	localplayer:set_position(vector3(5010.753, -5757.639, 28.845))
	localplayer:set_rotation(vector3(2, 0, 0))
end)
TELEPORT_QL:add_action('豪宅 :: 大门出口', function()
	localplayer:set_position(vector3(4992.854, -5718.537, 19.880))
end)
TELEPORT_QL:add_action('海洋 :: 安全位置', function()
	if not localplayer:is_in_vehicle() then
		localplayer:set_position(vector3(4905.050, -6339.578, -89.830))
	else
		localplayer:get_current_vehicle():set_position(vector3(4905.050, -6339.578, -89.830))
	end
end)
--
TELEPORTMANSIONO:add_action('豪宅外部排水管道入口', function()
	localplayer:set_position(vector3(5047.394, -5820.962, -12.447))
end)
TELEPORTMANSIONO:add_action('豪宅外部大门入口', function()
	localplayer:set_position(vector3(4972.337, -5701.617, 19.887))
end)
TELEPORTMANSIONO:add_action('豪宅外部北墙', function()
	localplayer:set_position(vector3(5041.111, -5675.523, 19.292))
end)
TELEPORTMANSIONO:add_action('豪宅外部北大门入口', function()
	localplayer:set_position(vector3(5086.59, -5730.8, 15.773))
end)
TELEPORTMANSIONO:add_action('豪宅外部南墙', function()
	localplayer:set_position(vector3(4987.32, -5819.869, 19.548))
end)
TELEPORTMANSIONO:add_action('豪宅外部南大门入口', function()
	localplayer:set_position(vector3(4958.965, -5785.213, 20.839))
end)
--
TELEPORTLOOT:add_action('机场控制塔', function()
	localplayer:set_position(vector3(4374.47, -4577.694, 4.208))
end)
TELEPORTLOOT:add_action('机场发电站', function()
	localplayer:set_position(vector3(4478.387, -4591.498, 5.568))
end)
TELEPORTLOOT:add_action('机场逃离点', function()
	localplayer:set_position(vector3(4493.552, -4472.608, 4.212))
end)
TELEPORTLOOT:add_action('机场次要目标 (下层)', function()
	localplayer:set_position(vector3(4437.678, -4449.029, 4.328))
end)
TELEPORTLOOT:add_action('机场次要目标 (上层)', function()
	localplayer:set_position(vector3(4445.451, -4444.368, 7.237))
end)
TELEPORTLOOT:add_action('机场其他次要目标', function()
	localplayer:set_position(vector3(4503.399, -4552.043, 4.161))
end)
TELEPORTLOOT:add_action('北码头安全位置', function()
	localplayer:set_position(vector3(5064.167, -4587.988, 2.988))
end)
TELEPORTLOOT:add_action('北码头次要目标 (1)', function()
	localplayer:set_position(vector3(5065.108, -4592.708, 2.855))
end)
TELEPORTLOOT:add_action('北码头次要目标 (2)', function()
	localplayer:set_position(vector3(5134.84, -4609.992, 2.529))
end)
TELEPORTLOOT:add_action('北码头次要目标 (3)', function()
	localplayer:set_position(vector3(5090.356, -4682.487, 2.407))
end)
TELEPORTLOOT:add_action('大麻地次要目标', function()
	localplayer:set_position(vector3(5331.424, -5269.504, 33.186))
end)
TELEPORTLOOT:add_action('加工区次要目标', function()
	localplayer:set_position(vector3(5193.133, -5134.256, 3.345))
end)
TELEPORTLOOT:add_action('主码头安全位置', function()
	localplayer:set_position(vector3(4847.7, -5325.062, 15.017))
end)
TELEPORTLOOT:add_action('主码头次要目标 (1)', function()
	localplayer:set_position(vector3(4923.587, -5242.541, 2.523))
end)
TELEPORTLOOT:add_action('主码头次要目标 (2)', function()
	localplayer:set_position(vector3(4998.355, -5165.41, 2.764))
end)
TELEPORTLOOT:add_action('主码头次要目标 (3)', function()
	localplayer:set_position(vector3(4961.247, -5109.312, 2.982))
end)
TELEPORTLOOT:add_action('通信塔第一层 (底层)', function()
	localplayer:set_position(vector3(5270.362, -5422.213, 65.579))
end)
TELEPORTLOOT:add_action('通信塔第二层', function()
	localplayer:set_position(vector3(5262.419, -5428.451, 90.724))
end)
TELEPORTLOOT:add_action('通信塔第三层', function()
	localplayer:set_position(vector3(5263.550, -5428.477, 109.148))
end)
TELEPORTLOOT:add_action('通信塔第四层 (顶层)', function()
	localplayer:set_position(vector3(5266.207, -5427.754, 141.047))
end)
--
TELEPORTMANSIONI:add_action('豪宅办公室', function()
	localplayer:set_position(vector3(5008.106, -5752.442, 28.845))
end)
TELEPORTMANSIONI:add_action('豪宅地下室主要目标', function()
	localplayer:set_position(vector3(5007.573, -5754.908, 15.484))
end)
TELEPORTMANSIONI:add_action('豪宅地下室次要目标', function()
	localplayer:set_position(vector3(5001.469, -5747.327, 14.84))
end)
TELEPORTMANSIONI:add_action('豪宅次要目标房间 (1)', function()
	localplayer:set_position(vector3(5084.015, -5758.132, 15.83))
end)
TELEPORTMANSIONI:add_action('豪宅次要目标房间 (2)', function()
	localplayer:set_position(vector3(5009.42, -5790.591, 17.832))
end)
TELEPORTMANSIONI:add_action('豪宅次要目标房间 (3)', function()
	localplayer:set_position(vector3(5031.386, -5737.249, 17.866))
end)
TELEPORTMANSIONI:add_action('豪宅出口大门', function()
	localplayer:set_position(vector3(4986.727, -5723.624, 19.88))
end)
TELEPORTMANSIONI:add_action('豪宅出口北墙', function()
	localplayer:set_position(vector3(5024.82, -5682.374, 19.877))
end)
TELEPORTMANSIONI:add_action('豪宅出口南墙', function()
	localplayer:set_position(vector3(4998.833, -5801.947, 20.877))
end)
TELEPORTMANSIONI:add_action('豪宅出口北门', function()
	localplayer:set_position(vector3(5084.957, -5739.043, 15.677))
end)
TELEPORTMANSIONI:add_action('豪宅出口南门', function()
	localplayer:set_position(vector3(4967.008, -5783.731, 20.878))
end)
--
TELEPORTCHESTS:add_action('陆地藏宝箱 (1)', function()
	localplayer:set_position(vector3(5176.394, -4678.343, 2.427))
end)
TELEPORTCHESTS:add_action('陆地藏宝箱 (2)', function()
	localplayer:set_position(vector3(4855.533, -5561.123, 27.534))
end)
TELEPORTCHESTS:add_action('陆地藏宝箱 (3)', function()
	localplayer:set_position(vector3(4877.224, -4781.618, 2.068))
end)
TELEPORTCHESTS:add_action('陆地藏宝箱 (4)', function()
	localplayer:set_position(vector3(5591.956, -5215.923, 14.351))
end)
TELEPORTCHESTS:add_action('陆地藏宝箱 (5)', function()
	localplayer:set_position(vector3(5458.669, -5860.041, 19.973))
end)
TELEPORTCHESTS:add_action('陆地藏宝箱 (6)', function()
	localplayer:set_position(vector3(4855.781, -5163.507, 2.439))
end)
TELEPORTCHESTS:add_action('陆地藏宝箱 (7)', function()
	localplayer:set_position(vector3(3898.093, -4710.935, 4.771))
end)
TELEPORTCHESTS:add_action('陆地藏宝箱 (8)', function()
	localplayer:set_position(vector3(4822.828, -4322.015, 5.617))
end)
TELEPORTCHESTS:add_action('陆地藏宝箱 (9)', function()
	localplayer:set_position(vector3(4535.064, -4702.882, 2.431))
end)
TELEPORTCHESTS:add_action('陆地藏宝箱 (10)', function()
	localplayer:set_position(vector3(4179.426, -4358.279, 2.686))
end)
TELEPORTCHESTS:add_action('海洋藏宝箱 (1)', function()
	localplayer:set_position(vector3(4415.093, -4653.384, -4.172))
end)
TELEPORTCHESTS:add_action('海洋藏宝箱 (2)', function()
	localplayer:set_position(vector3(4560.742, -4355.47, -7.187))
end)
TELEPORTCHESTS:add_action('海洋藏宝箱 (3)', function()
	localplayer:set_position(vector3(5262.87, -4919.246, -1.878))
end)
TELEPORTCHESTS:add_action('海洋藏宝箱 (4)', function()
	localplayer:set_position(vector3(4561.338, -4768.874, -2.167))
end)
TELEPORTCHESTS:add_action('海洋藏宝箱 (5)', function()
	localplayer:set_position(vector3(4943.188, -4294.895, -5.481))
end)
TELEPORTCHESTS:add_action('海洋藏宝箱 (6)', function()
	localplayer:set_position(vector3(5599.706, -5604.149, -5.064))
end)
TELEPORTCHESTS:add_action('海洋藏宝箱 (7)', function()
	localplayer:set_position(vector3(3982.371, -4542.297, -5.194))
end)
TELEPORTCHESTS:add_action('海洋藏宝箱 (8)', function()
	localplayer:set_position(vector3(4775.263, -5394.031, -4.116))
end)
TELEPORTCHESTS:add_action('海洋藏宝箱 (9)', function()
	localplayer:set_position(vector3(4940.111, -5167.373, -2.564))
end)
-- DOOMSDAY CUSTOM TELEPORT
TELEPORT_DOOMS:add_action('设施 :: 抢劫计划室', function()
	localplayer:set_position(vector3(343.97885131836, 4864.76953125, -60.004898071289))
end)
TELEPORT_DOOMS:add_action('末日二 :: 拍照屏幕', function()
	localplayer:set_position(vector3(515.528, 4835.353, -62.587))
end)
TELEPORT_DOOMS:add_action('末日二 :: 囚犯牢房', function()
	localplayer:set_position(vector3(512.888, 4833.033, -68.989))
end)
do
	local HE_about_info = bfmenu:add_submenu('关于')
	HE_about_info:add_action('By : Blue-Flag', function()
	end)
	HE_about_info:add_action('Version : ' .. LUA_VER, function()
	end)
	HE_about_info:add_action('遇到 bug 请联系作者', function()
	end)
	HE_about_info:add_action('Discord:@Blue-Flag#5246', function()
	end)
	HE_about_info:add_action('Github:Galaxy-Studio-Code/Blue-Flag-Lua', function()
	end)
	HE_about_info:add_action('本脚本部分功能有风险', function()
	end)
	HE_about_info:add_action('风险自控, 封号了可以告知你使用的功能', function()
	end)
end
---- AUTO (ALL PLAYERS) NO SECONDARY TARGET
do
	local QUICK_SET_ANY =
					{ { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
					{ 'H4CNF_BS_GEN', 262143 }, { 'H4CNF_BS_ENTR', 63 }, { 'H4CNF_BS_ABIL', 63 }, { 'H4CNF_WEP_DISRP', 3 }, { 'H4CNF_ARM_DISRP', 3 },
       { 'H4CNF_HEL_DISRP', 3 }, { 'H4CNF_BOLTCUT', 4424 }, { 'H4CNF_UNIFORM', 5256 }, { 'H4CNF_GRAPPEL', 5156 }, { 'H4CNF_APPROACH', -1 },
       { 'H4LOOT_CASH_I', 0 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_WEED_I', 0 }, { 'H4LOOT_WEED_C', 0 }, { 'H4LOOT_COKE_I', 0 }, { 'H4LOOT_COKE_C', 0 },
       { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_C', 0 }, { 'H4LOOT_PAINT', 0 }, { 'H4LOOT_CASH_V', 0 }, { 'H4LOOT_COKE_V', 0 }, { 'H4LOOT_GOLD_V', 0 },
       { 'H4LOOT_PAINT_V', 0 }, { 'H4LOOT_WEED_V', 0 }, { 'H4LOOT_CASH_I_SCOPED', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_WEED_I_SCOPED', 0 },
       { 'H4LOOT_WEED_C_SCOPED', 0 }, { 'H4LOOT_COKE_I_SCOPED', 0 }, { 'H4LOOT_COKE_C_SCOPED', 0 }, { 'H4LOOT_GOLD_I_SCOPED', 0 },
       { 'H4LOOT_GOLD_C_SCOPED', 0 }, { 'H4LOOT_PAINT_SCOPED', 0 }, { 'H4CNF_TARGET', 5 }, { 'H4CNF_WEAPONS', 5 }, { 'H4_MISSIONS', -1 },
       { 'H4_PROGRESS', 126823 } }
	QUICK_PRST:add_action('加载快速预设 (不拿次要目标,可拿保险箱)', function()
		for i = 1, #QUICK_SET_ANY do
			stat_set_int(QUICK_SET_ANY[i][1], true, QUICK_SET_ANY[i][2])
		end
		globals.set_int(1973525 + 823 + 56 + 1, 145) -- original version 1710289 + 823 + 56 + 1
		globals.set_int(1973525 + 823 + 56 + 2, 145) -- original version 1710289 + 823 + 56 + 2
		globals.set_int(1973525 + 823 + 56 + 3, 145) -- original version 1710289 + 823 + 56 + 3
		globals.set_int(1973525 + 823 + 56 + 4, 145) -- original version 1710289 + 823 + 56 + 4
		-- globals.set_float(262145+29641,0.0)
		-- globals.set_float(262145+29642,0.0)
		-- globals.set_int(262145 + 29621,2455000)
	end)
end
-- WEEKLY EVENT QUICK METHOD
do
	local WEAKLY_QUICK =
					{ { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
					{ 'H4CNF_BS_GEN', 262143 }, { 'H4CNF_BS_ENTR', 63 }, { 'H4CNF_BS_ABIL', 63 }, { 'H4CNF_WEP_DISRP', 3 }, { 'H4CNF_ARM_DISRP', 3 },
       { 'H4CNF_HEL_DISRP', 3 }, { 'H4CNF_BOLTCUT', 4424 }, { 'H4CNF_UNIFORM', 5256 }, { 'H4CNF_GRAPPEL', 5156 }, { 'H4CNF_APPROACH', -1 },
       { 'H4LOOT_CASH_I', 0 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_WEED_I', 0 }, { 'H4LOOT_WEED_C', 0 }, { 'H4LOOT_COKE_I', 0 }, { 'H4LOOT_COKE_C', 0 },
       { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_C', 0 }, { 'H4LOOT_PAINT', 0 }, { 'H4LOOT_CASH_V', 0 }, { 'H4LOOT_COKE_V', 0 }, { 'H4LOOT_GOLD_V', 0 },
       { 'H4LOOT_PAINT_V', 0 }, { 'H4LOOT_WEED_V', 0 }, { 'H4LOOT_CASH_I_SCOPED', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_WEED_I_SCOPED', 0 },
       { 'H4LOOT_WEED_C_SCOPED', 0 }, { 'H4LOOT_COKE_I_SCOPED', 0 }, { 'H4LOOT_COKE_C_SCOPED', 0 }, { 'H4LOOT_GOLD_I_SCOPED', 0 },
       { 'H4LOOT_GOLD_C_SCOPED', 0 }, { 'H4LOOT_PAINT_SCOPED', 0 }, { 'H4CNF_TARGET', 5 }, { 'H4CNF_WEAPONS', 4 }, { 'H4_MISSIONS', -1 },
       { 'H4_PROGRESS', 126823 } }
	WEEKLY_PRESET:add_action('加载活动周快速预设 (不拿次要目标,可拿保险箱)', function()
		for i = 1, #WEAKLY_QUICK do
			stat_set_int(WEAKLY_QUICK[i][1], true, WEAKLY_QUICK[i][2])
		end
		globals.set_int(1973525 + 823 + 56 + 1, 100) -- original version 1710289 + 823 + 56 + 1
		globals.set_int(1973525 + 823 + 56 + 2, 145) -- original version 1710289 + 823 + 56 + 2
		globals.set_int(1973525 + 823 + 56 + 3, 145) -- original version 1710289 + 823 + 56 + 3
		globals.set_int(1973525 + 823 + 56 + 4, 145) -- original version 1710289 + 823 + 56 + 4
		globals.set_float(262145 + 29641, 0.0)
		globals.set_float(262145 + 29642, 0.0)
		globals.set_int(262145 + 29637, 4025000)
	end)
end
--- CAYO AUTOMATED PRESET SOLO PLAYER
do
	local AUTOMATED_1P_TARGET_5 =
					{ { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
					{ 'H4CNF_TARGET', 5 }, { 'H4LOOT_CASH_I', 8128 }, { 'H4LOOT_CASH_I_SCOPED', 8128 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 },
       { 'H4LOOT_COKE_I', 63 }, { 'H4LOOT_COKE_I_SCOPED', 63 }, { 'H4LOOT_COKE_C', 22 }, { 'H4LOOT_COKE_C_SCOPED', 22 }, { 'H4LOOT_GOLD_I', 0 },
       { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C', 168 }, { 'H4LOOT_GOLD_C_SCOPED', 168 }, { 'H4LOOT_WEED_I', 16769024 },
       { 'H4LOOT_WEED_I_SCOPED', 16769024 }, { 'H4LOOT_WEED_C', 65 }, { 'H4LOOT_WEED_C_SCOPED', 65 }, { 'H4LOOT_PAINT', 127 },
       { 'H4LOOT_PAINT_SCOPED', 127 }, { 'H4LOOT_CASH_V', 207386 }, { 'H4LOOT_COKE_V', 414772 }, { 'H4LOOT_GOLD_V', 553029 },
       { 'H4LOOT_PAINT_V', 414772 }, { 'H4LOOT_WEED_V', 331818 }, --
					{ 'H4_PROGRESS', 126823 }, { 'H4CNF_BS_GEN', -1 }, { 'H4CNF_BS_ENTR', -1 }, { 'H4CNF_BS_ABIL', -1 }, { 'H4CNF_WEP_DISRP', 3 },
       { 'H4CNF_ARM_DISRP', 3 }, { 'H4CNF_HEL_DISRP', 3 }, { 'H4CNF_APPROACH', -1 } }
	local AUTOMATED_1P_TARGET_5_A =
					{ { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
					{ 'H4CNF_BOLTCUT', 4424 }, { 'H4CNF_UNIFORM', 5256 }, { 'H4CNF_GRAPPEL', 5156 }, { 'H4_MISSIONS', -1 }, { 'H4CNF_WEAPONS', 4 },
       { 'H4CNF_TROJAN', 5 } }
	AUTOMATED_SOLO:add_action('猎豹雕像 (任意次要目标装满背包,不拿保险箱)', function()
		for i = 1, #AUTOMATED_1P_TARGET_5_A do
			stat_set_int(AUTOMATED_1P_TARGET_5_A[i][1], true, AUTOMATED_1P_TARGET_5_A[i][2])
		end
		for i = 1, #AUTOMATED_1P_TARGET_5 do
			stat_set_int(AUTOMATED_1P_TARGET_5[i][1], true, AUTOMATED_1P_TARGET_5[i][2])
		end
		globals.set_float(262145 + 29641, -0.1) -- pavel cut protection
		globals.set_float(262145 + 29642, -0.02) -- fency fee cut protection
		globals.set_int(262145 + 29395, 1800) -- bag protection
		globals.set_int(1973525 + 823 + 56 + 1, 100) -- original version 1710289 + 823 + 56 + 1
	end)
end
--- CAYO AUTOMATED PRESET SOLO
do
	local CAYO_SOLO_AUTO_TARGET_3 =
					{ { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
					{ 'H4CNF_TARGET', 3 }, { 'H4LOOT_CASH_I', 63 }, { 'H4LOOT_CASH_I_SCOPED', 63 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 },
       { 'H4LOOT_COKE_I', 16769024 }, { 'H4LOOT_COKE_I_SCOPED', 16769024 }, { 'H4LOOT_COKE_C', 22 }, { 'H4LOOT_COKE_C_SCOPED', 22 },
       { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C', 168 }, { 'H4LOOT_GOLD_C_SCOPED', 168 }, { 'H4LOOT_WEED_I', 8128 },
       { 'H4LOOT_WEED_I_SCOPED', 8128 }, { 'H4LOOT_WEED_C', 65 }, { 'H4LOOT_WEED_C_SCOPED', 65 }, { 'H4LOOT_PAINT', 127 },
       { 'H4LOOT_PAINT_SCOPED', 127 }, { 'H4LOOT_CASH_V', 357386 }, { 'H4LOOT_COKE_V', 714772 }, { 'H4LOOT_GOLD_V', 953029 },
       { 'H4LOOT_PAINT_V', 714772 }, { 'H4LOOT_WEED_V', 571818 }, --
					{ 'H4_PROGRESS', 126823 }, { 'H4CNF_BS_GEN', 262143 }, { 'H4CNF_BS_ENTR', 63 }, { 'H4CNF_BS_ABIL', 63 }, { 'H4CNF_WEP_DISRP', 3 },
       { 'H4CNF_ARM_DISRP', 3 }, { 'H4CNF_HEL_DISRP', 3 }, { 'H4CNF_APPROACH', -1 } }
	local USER_CAN_MDFY_PRESET_AUTO_SOLO_T3 =
					{ { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
					{ 'H4CNF_BOLTCUT', 4424 }, { 'H4CNF_UNIFORM', 5256 }, { 'H4CNF_GRAPPEL', 5156 }, { 'H4_MISSIONS', -1 }, { 'H4CNF_WEAPONS', 4 },
       { 'H4CNF_TROJAN', 5 } }
	AUTOMATED_SOLO:add_action('粉钻 (任意次要目标装满背包,不拿保险箱)', function()
		for i = 1, #USER_CAN_MDFY_PRESET_AUTO_SOLO_T3 do
			stat_set_int(USER_CAN_MDFY_PRESET_AUTO_SOLO_T3[i][1], true, USER_CAN_MDFY_PRESET_AUTO_SOLO_T3[i][2])
		end
		for i = 2, #CAYO_SOLO_AUTO_TARGET_3 do
			stat_set_int(CAYO_SOLO_AUTO_TARGET_3[i][1], true, CAYO_SOLO_AUTO_TARGET_3[i][2])
		end
		globals.set_float(262145 + 29641, -0.1) -- pavel cut protection
		globals.set_float(262145 + 29642, -0.02) -- fency fee cut protection
		globals.set_int(262145 + 29395, 1800) -- bag protection
		globals.set_int(1973525 + 823 + 56 + 1, 100) -- cut original version 1710289 + 823 + 56 + 1
	end)
end
----- AUTOMATED 2 PLAYERS
do
	local AUTOMATED_2P_TARGET_5 =
					{ { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
					{ 'H4CNF_TARGET', 5 }, { 'H4LOOT_CASH_I', 8128 }, { 'H4LOOT_CASH_I_SCOPED', 8128 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 },
       { 'H4LOOT_COKE_I', 63 }, { 'H4LOOT_COKE_I_SCOPED', 63 }, { 'H4LOOT_COKE_C', 22 }, { 'H4LOOT_COKE_C_SCOPED', 22 }, { 'H4LOOT_GOLD_I', 0 },
       { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C', 168 }, { 'H4LOOT_GOLD_C_SCOPED', 168 }, { 'H4LOOT_WEED_I', 16769024 },
       { 'H4LOOT_WEED_I_SCOPED', 16769024 }, { 'H4LOOT_WEED_C', 65 }, { 'H4LOOT_WEED_C_SCOPED', 65 }, { 'H4LOOT_PAINT', 127 },
       { 'H4LOOT_PAINT_SCOPED', 127 }, { 'H4LOOT_CASH_V', 457386 }, { 'H4LOOT_COKE_V', 914772 }, { 'H4LOOT_GOLD_V', 1219696 },
       { 'H4LOOT_PAINT_V', 914772 }, { 'H4LOOT_WEED_V', 731818 }, --
					{ 'H4_PROGRESS', 126823 }, { 'H4CNF_BS_GEN', 262143 }, { 'H4CNF_BS_ENTR', 63 }, { 'H4CNF_BS_ABIL', 63 }, { 'H4CNF_WEP_DISRP', 3 },
       { 'H4CNF_ARM_DISRP', 3 }, { 'H4CNF_HEL_DISRP', 3 }, { 'H4CNF_APPROACH', -1 } }
	local AUTOMATED_2P_TARGET_5_A =
					{ { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
					{ 'H4CNF_BOLTCUT', 4424 }, { 'H4CNF_UNIFORM', 5256 }, { 'H4CNF_GRAPPEL', 5156 }, { 'H4_MISSIONS', -1 }, { 'H4CNF_WEAPONS', 4 },
       { 'H4CNF_TROJAN', 5 } }
	AUTOMATED_2P:add_action('猎豹雕像 (任意次要目标装满背包,不拿保险箱)', function()
		for i = 1, #AUTOMATED_2P_TARGET_5_A do
			stat_set_int(AUTOMATED_2P_TARGET_5_A[i][1], true, AUTOMATED_2P_TARGET_5_A[i][2])
		end
		for i = 1, #AUTOMATED_2P_TARGET_5 do
			stat_set_int(AUTOMATED_2P_TARGET_5[i][1], true, AUTOMATED_2P_TARGET_5[i][2])
		end
		globals.set_float(262145 + 29641, -0.1) -- pavel cut protection
		globals.set_float(262145 + 29642, -0.02) -- fency fee cut protection
		globals.set_int(262145 + 29395, 1800) -- bag protection
		globals.set_int(1973525 + 823 + 56 + 1, 50)
		globals.set_int(1973525 + 823 + 56 + 2, 50)
	end)
end
--- AUTOMATED 2 Players
do
	local AUTOMATED_2_TARGET_3 =
					{ { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
					{ 'H4CNF_TARGET', 3 }, { 'H4LOOT_CASH_I', 63 }, { 'H4LOOT_CASH_I_SCOPED', 63 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 },
       { 'H4LOOT_COKE_I', 16769024 }, { 'H4LOOT_COKE_I_SCOPED', 16769024 }, { 'H4LOOT_COKE_C', 22 }, { 'H4LOOT_COKE_C_SCOPED', 22 },
       { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C', 168 }, { 'H4LOOT_GOLD_C_SCOPED', 168 }, { 'H4LOOT_WEED_I', 8128 },
       { 'H4LOOT_WEED_I_SCOPED', 8128 }, { 'H4LOOT_WEED_C', 65 }, { 'H4LOOT_WEED_C_SCOPED', 65 }, { 'H4LOOT_PAINT', 127 },
       { 'H4LOOT_PAINT_SCOPED', 127 }, { 'H4LOOT_CASH_V', 532386 }, { 'H4LOOT_COKE_V', 1064772 }, { 'H4LOOT_GOLD_V', 1419696 },
       { 'H4LOOT_PAINT_V', 1064772 }, { 'H4LOOT_WEED_V', 851818 }, { 'H4_PROGRESS', 126823 }, { 'H4CNF_BS_GEN', 262143 }, { 'H4CNF_BS_ENTR', 63 },
       { 'H4CNF_BS_ABIL', 63 }, { 'H4CNF_WEP_DISRP', 3 }, { 'H4CNF_ARM_DISRP', 3 }, { 'H4CNF_HEL_DISRP', 3 }, { 'H4CNF_APPROACH', -1 } }
	local AUTOMATED_2_TARGET_3_A =
					{ { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
					{ 'H4CNF_BOLTCUT', 4424 }, { 'H4CNF_UNIFORM', 5256 }, { 'H4CNF_GRAPPEL', 5156 }, { 'H4_MISSIONS', -1 }, { 'H4CNF_WEAPONS', 4 },
       { 'H4CNF_TROJAN', 5 } }
	AUTOMATED_2P:add_action('粉钻 (任意次要目标装满背包,不拿保险箱)', function()
		for i = 1, #AUTOMATED_2_TARGET_3_A do
			stat_set_int(AUTOMATED_2_TARGET_3_A[i][1], true, AUTOMATED_2_TARGET_3_A[i][2])
		end
		for i = 1, #AUTOMATED_2_TARGET_3 do
			stat_set_int(AUTOMATED_2_TARGET_3[i][1], true, AUTOMATED_2_TARGET_3[i][2])
		end
		globals.set_float(262145 + 29641, -0.1) -- pavel cut protection
		globals.set_float(262145 + 29642, -0.02) -- fency fee cut protection
		globals.set_int(262145 + 29395, 1800) -- bag protection
		globals.set_int(1973525 + 823 + 56 + 1, 50)
		globals.set_int(1973525 + 823 + 56 + 2, 50)
	end)
end
--- CAYO AUTOMATED PRESET 3 PLAYERS
do
	local AUTOMATED_3P_TARGET_5 =
					{ { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
					{ 'H4CNF_TARGET', 5 }, { 'H4LOOT_CASH_I', 8128 }, { 'H4LOOT_CASH_I_SCOPED', 8128 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 },
       { 'H4LOOT_COKE_I', 63 }, { 'H4LOOT_COKE_I_SCOPED', 63 }, { 'H4LOOT_COKE_C', 22 }, { 'H4LOOT_COKE_C_SCOPED', 22 }, { 'H4LOOT_GOLD_I', 0 },
       { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C', 168 }, { 'H4LOOT_GOLD_C_SCOPED', 168 }, { 'H4LOOT_WEED_I', 16769024 },
       { 'H4LOOT_WEED_I_SCOPED', 16769024 }, { 'H4LOOT_WEED_C', 65 }, { 'H4LOOT_WEED_C_SCOPED', 65 }, { 'H4LOOT_PAINT', 127 },
       { 'H4LOOT_PAINT_SCOPED', 127 }, { 'H4LOOT_CASH_V', 507034 }, { 'H4LOOT_COKE_V', 1014069 }, { 'H4LOOT_GOLD_V', 1352091 },
       { 'H4LOOT_PAINT_V', 1014069 }, { 'H4LOOT_WEED_V', 811255 }, --
					{ 'H4_PROGRESS', 126823 }, { 'H4CNF_BS_GEN', 262143 }, { 'H4CNF_BS_ENTR', 63 }, { 'H4CNF_BS_ABIL', 63 }, { 'H4CNF_WEP_DISRP', 3 },
       { 'H4CNF_ARM_DISRP', 3 }, { 'H4CNF_HEL_DISRP', 3 }, { 'H4CNF_APPROACH', -1 } }
	local AUTOMATED_3P_TARGET_5_A =
					{ { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
					{ 'H4CNF_BOLTCUT', 4424 }, { 'H4CNF_UNIFORM', 5256 }, { 'H4CNF_GRAPPEL', 5156 }, { 'H4_MISSIONS', -1 }, { 'H4CNF_WEAPONS', 4 },
       { 'H4CNF_TROJAN', 5 } }
	AUTOMATED_3P:add_action('猎豹雕像 (任意次要目标装满背包,不拿保险箱)', function()
		for i = 1, #AUTOMATED_3P_TARGET_5_A do
			stat_set_int(AUTOMATED_3P_TARGET_5_A[i][1], true, AUTOMATED_3P_TARGET_5_A[i][2])
		end
		for i = 1, #AUTOMATED_3P_TARGET_5 do
			stat_set_int(AUTOMATED_3P_TARGET_5[i][1], true, AUTOMATED_3P_TARGET_5[i][2])
		end
		globals.set_float(262145 + 29641, -0.1) -- pavel cut protection
		globals.set_float(262145 + 29642, -0.02) -- fency fee cut protection
		globals.set_int(262145 + 29395, 1800) -- bag protection
		globals.set_int(1973525 + 823 + 56 + 1, 35)
		globals.set_int(1973525 + 823 + 56 + 2, 35)
		globals.set_int(1973525 + 823 + 56 + 3, 35)
	end)
end
--- CAYO AUTOMATED 3 PLAYERS
do
	local AUTOMATED_3P_TARGET_3 =
					{ { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
					{ 'H4CNF_TARGET', 3 }, { 'H4LOOT_CASH_I', 63 }, { 'H4LOOT_CASH_I_SCOPED', 63 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 },
       { 'H4LOOT_COKE_I', 16769024 }, { 'H4LOOT_COKE_I_SCOPED', 16769024 }, { 'H4LOOT_COKE_C', 22 }, { 'H4LOOT_COKE_C_SCOPED', 22 },
       { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C', 168 }, { 'H4LOOT_GOLD_C_SCOPED', 168 }, { 'H4LOOT_WEED_I', 8128 },
       { 'H4LOOT_WEED_I_SCOPED', 8128 }, { 'H4LOOT_WEED_C', 65 }, { 'H4LOOT_WEED_C_SCOPED', 65 }, { 'H4LOOT_PAINT', 127 },
       { 'H4LOOT_PAINT_SCOPED', 127 }, { 'H4LOOT_CASH_V', 557034 }, { 'H4LOOT_COKE_V', 1114069 }, { 'H4LOOT_GOLD_V', 1485425 },
       { 'H4LOOT_PAINT_V', 1114069 }, { 'H4LOOT_WEED_V', 891255 }, --
					{ 'H4_PROGRESS', 126823 }, { 'H4CNF_BS_GEN', 262143 }, { 'H4CNF_BS_ENTR', 63 }, { 'H4CNF_BS_ABIL', 63 }, { 'H4CNF_WEP_DISRP', 3 },
       { 'H4CNF_ARM_DISRP', 3 }, { 'H4CNF_HEL_DISRP', 3 }, { 'H4CNF_APPROACH', -1 } }
	local AUTOMATED_3P_TARGET_3_A =
					{ { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
					{ 'H4CNF_BOLTCUT', 4424 }, { 'H4CNF_UNIFORM', 5256 }, { 'H4CNF_GRAPPEL', 5156 }, { 'H4_MISSIONS', -1 }, { 'H4CNF_WEAPONS', 4 },
       { 'H4CNF_TROJAN', 5 } }
	AUTOMATED_3P:add_action('粉钻 (任意次要目标装满背包,不拿保险箱)', function()
		for i = 1, #AUTOMATED_3P_TARGET_3_A do
			stat_set_int(AUTOMATED_3P_TARGET_3_A[i][1], true, AUTOMATED_3P_TARGET_3_A[i][2])
		end
		for i = 2, #AUTOMATED_3P_TARGET_3 do
			stat_set_int(AUTOMATED_3P_TARGET_3[i][1], true, AUTOMATED_3P_TARGET_3[i][2])
		end
		globals.set_float(262145 + 29641, -0.1) -- pavel cut protection
		globals.set_float(262145 + 29642, -0.02) -- fency fee cut protection
		globals.set_int(262145 + 29395, 1800) -- bag protection
		globals.set_int(1973525 + 823 + 56 + 1, 35)
		globals.set_int(1973525 + 823 + 56 + 2, 35)
		globals.set_int(1973525 + 823 + 56 + 3, 35)
	end)
end
--- CAYO AUTOMATED PRESET 4 PLAYERS
do
	local AUTOMATED_4P_TARGET_5 =
					{ { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
					{ 'H4CNF_TARGET', 5 }, { 'H4LOOT_CASH_I', 8128 }, { 'H4LOOT_CASH_I_SCOPED', 8128 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 },
       { 'H4LOOT_COKE_I', 63 }, { 'H4LOOT_COKE_I_SCOPED', 63 }, { 'H4LOOT_COKE_C', 22 }, { 'H4LOOT_COKE_C_SCOPED', 22 }, { 'H4LOOT_GOLD_I', 0 },
       { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C', 168 }, { 'H4LOOT_GOLD_C_SCOPED', 168 }, { 'H4LOOT_WEED_I', 16769024 },
       { 'H4LOOT_WEED_I_SCOPED', 16769024 }, { 'H4LOOT_WEED_C', 65 }, { 'H4LOOT_WEED_C_SCOPED', 65 }, { 'H4LOOT_PAINT', 127 },
       { 'H4LOOT_PAINT_SCOPED', 127 }, { 'H4LOOT_CASH_V', 582386 }, { 'H4LOOT_COKE_V', 1164772 }, { 'H4LOOT_GOLD_V', 1553030 },
       { 'H4LOOT_PAINT_V', 1164772 }, { 'H4LOOT_WEED_V', 931818 }, --
					{ 'H4_PROGRESS', 126823 }, { 'H4CNF_BS_GEN', 262143 }, { 'H4CNF_BS_ENTR', 63 }, { 'H4CNF_BS_ABIL', 63 }, { 'H4CNF_WEP_DISRP', 3 },
       { 'H4CNF_ARM_DISRP', 3 }, { 'H4CNF_HEL_DISRP', 3 }, { 'H4CNF_APPROACH', -1 } }
	local AUTOMATED_4P_TARGET_5_A =
					{ { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
					{ 'H4CNF_BOLTCUT', 4424 }, { 'H4CNF_UNIFORM', 5256 }, { 'H4CNF_GRAPPEL', 5156 }, { 'H4_MISSIONS', -1 }, { 'H4CNF_WEAPONS', 4 },
       { 'H4CNF_TROJAN', 5 } }
	AUTOMATED_4P:add_action('猎豹雕像 (任意次要目标装满背包,不拿保险箱)', function()
		for i = 1, #AUTOMATED_4P_TARGET_5_A do
			stat_set_int(AUTOMATED_4P_TARGET_5_A[i][1], true, AUTOMATED_4P_TARGET_5_A[i][2])
		end
		for i = 1, #AUTOMATED_4P_TARGET_5 do
			stat_set_int(AUTOMATED_4P_TARGET_5[i][1], true, AUTOMATED_4P_TARGET_5[i][2])
		end
		globals.set_float(262145 + 29641, -0.1) -- pavel cut protection
		globals.set_float(262145 + 29642, -0.02) -- fency fee cut protection
		globals.set_int(262145 + 29395, 1800) -- bag protection
		globals.set_int(1973525 + 823 + 56 + 1, 25) -- player 1
		globals.set_int(1973525 + 823 + 56 + 2, 25) -- player 2
		globals.set_int(1973525 + 823 + 56 + 3, 25) -- player 3
		globals.set_int(1973525 + 823 + 56 + 4, 25) -- player 4
	end)
end
--- CAYO AUTOMATED PRESET 4 PLAYERS
do
	local AUTOMATED_4P_TARGET_3 =
					{ { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
					{ 'H4CNF_TARGET', 3 }, { 'H4LOOT_CASH_I', 63 }, { 'H4LOOT_CASH_I_SCOPED', 63 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 },
       { 'H4LOOT_COKE_I', 16769024 }, { 'H4LOOT_COKE_I_SCOPED', 16769024 }, { 'H4LOOT_COKE_C', 22 }, { 'H4LOOT_COKE_C_SCOPED', 22 },
       { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C', 168 }, { 'H4LOOT_GOLD_C_SCOPED', 168 }, { 'H4LOOT_WEED_I', 8128 },
       { 'H4LOOT_WEED_I_SCOPED', 8128 }, { 'H4LOOT_WEED_C', 65 }, { 'H4LOOT_WEED_C_SCOPED', 65 }, { 'H4LOOT_PAINT', 127 },
       { 'H4LOOT_PAINT_SCOPED', 127 }, { 'H4LOOT_CASH_V', 619886 }, { 'H4LOOT_COKE_V', 1239772 }, { 'H4LOOT_GOLD_V', 1653030 },
       { 'H4LOOT_PAINT_V', 1239772 }, { 'H4LOOT_WEED_V', 991818 }, --
					{ 'H4_PROGRESS', 126823 }, { 'H4CNF_BS_GEN', 262143 }, { 'H4CNF_BS_ENTR', 63 }, { 'H4CNF_BS_ABIL', 63 }, { 'H4CNF_WEP_DISRP', 3 },
       { 'H4CNF_ARM_DISRP', 3 }, { 'H4CNF_HEL_DISRP', 3 }, { 'H4CNF_APPROACH', -1 } }
	local AUTOMATED_4P_TARGET_3_A =
					{ { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
					{ 'H4CNF_BOLTCUT', 4424 }, { 'H4CNF_UNIFORM', 5256 }, { 'H4CNF_GRAPPEL', 5156 }, { 'H4_MISSIONS', -1 }, { 'H4CNF_WEAPONS', 4 },
       { 'H4CNF_TROJAN', 5 } }
	AUTOMATED_4P:add_action('粉钻 (任意次要目标装满背包,不拿保险箱)', function()
		for i = 1, #AUTOMATED_4P_TARGET_3_A do
			stat_set_int(AUTOMATED_4P_TARGET_3_A[i][1], true, AUTOMATED_4P_TARGET_3_A[i][2])
		end
		for i = 1, #AUTOMATED_4P_TARGET_3 do
			stat_set_int(AUTOMATED_4P_TARGET_3[i][1], true, AUTOMATED_4P_TARGET_3[i][2])
		end
		globals.set_float(262145 + 29641, -0.1) -- pavel cut protection
		globals.set_float(262145 + 29642, -0.02) -- fency fee cut protection
		globals.set_int(262145 + 29395, 1800) -- bag protection
		globals.set_int(1973525 + 823 + 56 + 1, 25) -- player 1
		globals.set_int(1973525 + 823 + 56 + 2, 25) -- player 2
		globals.set_int(1973525 + 823 + 56 + 3, 25) -- player 3
		globals.set_int(1973525 + 823 + 56 + 4, 25) -- player 4
	end)
end
-- WEEKLY EVENT (PRESETS)
-- SOLO ONE
do
	local WKLY_SOLO_PANTHER =
					{ { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
					{ 'H4CNF_TARGET', 5 }, { 'H4LOOT_CASH_I', 6490148 }, { 'H4LOOT_CASH_I_SCOPED', 6490148 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 },
       { 'H4LOOT_COKE_I', 8421904 }, { 'H4LOOT_COKE_I_SCOPED', 8421904 }, { 'H4LOOT_COKE_C', 0 }, { 'H4LOOT_COKE_C_SCOPED', 0 },
       { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C', 255 }, { 'H4LOOT_GOLD_C_SCOPED', 255 }, { 'H4LOOT_WEED_I', 1311112 },
       { 'H4LOOT_WEED_I_SCOPED', 1311112 }, { 'H4LOOT_WEED_C', 0 }, { 'H4LOOT_WEED_C_SCOPED', 0 }, { 'H4LOOT_PAINT', 127 },
       { 'H4LOOT_PAINT_SCOPED', 127 }, { 'H4LOOT_CASH_V', 670454 }, { 'H4LOOT_COKE_V', 1340909 }, { 'H4LOOT_GOLD_V', 1787878 },
       { 'H4LOOT_PAINT_V', 1340909 }, { 'H4LOOT_WEED_V', 1072727 }, --
					{ 'H4_PROGRESS', 126823 }, { 'H4CNF_BS_GEN', 262143 }, { 'H4CNF_BS_ENTR', 63 }, { 'H4CNF_BS_ABIL', 63 }, { 'H4CNF_WEP_DISRP', 3 },
       { 'H4CNF_ARM_DISRP', 3 }, { 'H4CNF_HEL_DISRP', 3 }, { 'H4CNF_APPROACH', -1 } }
	local USER_CAN_MDFY_WKLY_SOLO_PANTHER =
					{ { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
					{ 'H4CNF_BOLTCUT', 4424 }, { 'H4CNF_UNIFORM', 5256 }, { 'H4CNF_GRAPPEL', 5156 }, { 'H4_MISSIONS', -1 }, { 'H4CNF_WEAPONS', 4 },
       { 'H4CNF_TROJAN', 5 } }
	WEEKLY_SOLO:add_action('猎豹雕像 (任意次要目标装满背包,不拿保险箱)', function()
		for i = 1, #USER_CAN_MDFY_WKLY_SOLO_PANTHER do
			stat_set_int(USER_CAN_MDFY_WKLY_SOLO_PANTHER[i][1], true, USER_CAN_MDFY_WKLY_SOLO_PANTHER[i][2])
		end
		for i = 1, #WKLY_SOLO_PANTHER do
			stat_set_int(WKLY_SOLO_PANTHER[i][1], true, WKLY_SOLO_PANTHER[i][2])
		end
		globals.set_float(262145 + 29641, -0.1) -- pavel cut protection
		globals.set_float(262145 + 29642, -0.02) -- fency fee cut protection
		globals.set_int(262145 + 29395, 1800) -- Bag protection
		globals.set_int(1973525 + 823 + 56 + 1, 100) -- Player 1 (SOLO)
	end)
end
-- WEEKLY DUO
do
	local WKLY_DUO_PANTHER =
					{ { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
					{ 'H4CNF_TARGET', 5 }, { 'H4LOOT_CASH_I', 6490148 }, { 'H4LOOT_CASH_I_SCOPED', 6490148 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 },
       { 'H4LOOT_COKE_I', 8421904 }, { 'H4LOOT_COKE_I_SCOPED', 8421904 }, { 'H4LOOT_COKE_C', 0 }, { 'H4LOOT_COKE_C_SCOPED', 0 },
       { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C', 255 }, { 'H4LOOT_GOLD_C_SCOPED', 255 }, { 'H4LOOT_WEED_I', 1311112 },
       { 'H4LOOT_WEED_I_SCOPED', 1311112 }, { 'H4LOOT_WEED_C', 0 }, { 'H4LOOT_WEED_C_SCOPED', 0 }, { 'H4LOOT_PAINT', 127 },
       { 'H4LOOT_PAINT_SCOPED', 127 }, { 'H4LOOT_CASH_V', 920454 }, { 'H4LOOT_COKE_V', 1840909 }, { 'H4LOOT_GOLD_V', 2454545 },
       { 'H4LOOT_PAINT_V', 1840909 }, { 'H4LOOT_WEED_V', 1472727 }, --
					{ 'H4_PROGRESS', 126823 }, { 'H4CNF_BS_GEN', 262143 }, { 'H4CNF_BS_ENTR', 63 }, { 'H4CNF_BS_ABIL', 63 }, { 'H4CNF_WEP_DISRP', 3 },
       { 'H4CNF_ARM_DISRP', 3 }, { 'H4CNF_HEL_DISRP', 3 }, { 'H4CNF_APPROACH', -1 } }
	local USER_CAN_MDFY_WKLY_DUO_PANTHER =
					{ { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
					{ 'H4CNF_BOLTCUT', 4424 }, { 'H4CNF_UNIFORM', 5256 }, { 'H4CNF_GRAPPEL', 5156 }, { 'H4_MISSIONS', -1 }, { 'H4CNF_WEAPONS', 4 },
       { 'H4CNF_TROJAN', 5 } }
	WEEKLY_F2:add_action('猎豹雕像 (任意次要目标装满背包,不拿保险箱)', function()
		for i = 1, #USER_CAN_MDFY_WKLY_DUO_PANTHER do
			stat_set_int(USER_CAN_MDFY_WKLY_DUO_PANTHER[i][1], true, USER_CAN_MDFY_WKLY_DUO_PANTHER[i][2])
		end
		for i = 1, #WKLY_DUO_PANTHER do
			stat_set_int(WKLY_DUO_PANTHER[i][1], true, WKLY_DUO_PANTHER[i][2])
		end
		globals.set_float(262145 + 29641, -0.1) -- pavel cut protection
		globals.set_float(262145 + 29642, -0.02) -- fency fee cut protection
		globals.set_int(262145 + 29395, 1800) -- bag protection
		globals.set_int(1973525 + 823 + 56 + 1, 50)
		globals.set_int(1973525 + 823 + 56 + 2, 50)
	end)
end
-- WEEKLY TRIO
do
	local WKLY_TRIO_PANTHER =
					{ { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
					{ 'H4CNF_TARGET', 5 }, { 'H4LOOT_CASH_I', 6490148 }, { 'H4LOOT_CASH_I_SCOPED', 6490148 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 },
       { 'H4LOOT_COKE_I', 8421904 }, { 'H4LOOT_COKE_I_SCOPED', 8421904 }, { 'H4LOOT_COKE_C', 0 }, { 'H4LOOT_COKE_C_SCOPED', 0 },
       { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C', 255 }, { 'H4LOOT_GOLD_C_SCOPED', 255 }, { 'H4LOOT_WEED_I', 1311112 },
       { 'H4LOOT_WEED_I_SCOPED', 1311112 }, { 'H4LOOT_WEED_C', 0 }, { 'H4LOOT_WEED_C_SCOPED', 0 }, { 'H4LOOT_PAINT', 127 },
       { 'H4LOOT_PAINT_SCOPED', 127 }, { 'H4LOOT_CASH_V', 948051 }, { 'H4LOOT_COKE_V', 1896103 }, { 'H4LOOT_GOLD_V', 2528137 },
       { 'H4LOOT_PAINT_V', 1896103 }, { 'H4LOOT_WEED_V', 1516882 }, --
					{ 'H4_PROGRESS', 126823 }, { 'H4CNF_BS_GEN', 262143 }, { 'H4CNF_BS_ENTR', 63 }, { 'H4CNF_BS_ABIL', 63 }, { 'H4CNF_WEP_DISRP', 3 },
       { 'H4CNF_ARM_DISRP', 3 }, { 'H4CNF_HEL_DISRP', 3 }, { 'H4CNF_APPROACH', -1 } }
	local USER_CAN_MDFY_WKLY_TRIO_PANTHER =
					{ { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
					{ 'H4CNF_BOLTCUT', 4424 }, { 'H4CNF_UNIFORM', 5256 }, { 'H4CNF_GRAPPEL', 5156 }, { 'H4_MISSIONS', -1 }, { 'H4CNF_WEAPONS', 4 },
       { 'H4CNF_TROJAN', 5 } }
	WEEKLY_F3:add_action('猎豹雕像 (任意次要目标装满背包,不拿保险箱)', function()
		for i = 1, #USER_CAN_MDFY_WKLY_TRIO_PANTHER do
			stat_set_int(USER_CAN_MDFY_WKLY_TRIO_PANTHER[i][1], true, USER_CAN_MDFY_WKLY_TRIO_PANTHER[i][2])
		end
		for i = 1, #WKLY_TRIO_PANTHER do
			stat_set_int(WKLY_TRIO_PANTHER[i][1], true, WKLY_TRIO_PANTHER[i][2])
		end
		globals.set_float(262145 + 29641, -0.1) -- pavel cut protection
		globals.set_float(262145 + 29642, -0.02) -- fency fee cut protection
		globals.set_int(262145 + 29395, 1800) -- bag protection
		globals.set_int(1973525 + 823 + 56 + 1, 30)
		globals.set_int(1973525 + 823 + 56 + 2, 35)
		globals.set_int(1973525 + 823 + 56 + 3, 35)
	end)
end
-- WEEKLY FOUR PLAYERS
do
	local WKLY_FOUR_PANTHER =
					{ { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
					{ 'H4CNF_TARGET', 5 }, { 'H4LOOT_CASH_I', 6490148 }, { 'H4LOOT_CASH_I_SCOPED', 6490148 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 },
       { 'H4LOOT_COKE_I', 8421904 }, { 'H4LOOT_COKE_I_SCOPED', 8421904 }, { 'H4LOOT_COKE_C', 0 }, { 'H4LOOT_COKE_C_SCOPED', 0 },
       { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C', 255 }, { 'H4LOOT_GOLD_C_SCOPED', 255 }, { 'H4LOOT_WEED_I', 1311112 },
       { 'H4LOOT_WEED_I_SCOPED', 1311112 }, { 'H4LOOT_WEED_C', 0 }, { 'H4LOOT_WEED_C_SCOPED', 0 }, { 'H4LOOT_PAINT', 127 },
       { 'H4LOOT_PAINT_SCOPED', 127 }, { 'H4LOOT_CASH_V', 1045454 }, { 'H4LOOT_COKE_V', 2090909 }, { 'H4LOOT_GOLD_V', 2787878 },
       { 'H4LOOT_PAINT_V', 2090909 }, { 'H4LOOT_WEED_V', 1672727 }, --
					{ 'H4_PROGRESS', 126823 }, { 'H4CNF_BS_GEN', 262143 }, { 'H4CNF_BS_ENTR', 63 }, { 'H4CNF_BS_ABIL', 63 }, { 'H4CNF_WEP_DISRP', 3 },
       { 'H4CNF_ARM_DISRP', 3 }, { 'H4CNF_HEL_DISRP', 3 }, { 'H4CNF_APPROACH', -1 } }
	local USER_CAN_MDFY_WKLY_FOUR_PANTHER =
					{ { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
					{ 'H4CNF_BOLTCUT', 4424 }, { 'H4CNF_UNIFORM', 5256 }, { 'H4CNF_GRAPPEL', 5156 }, { 'H4_MISSIONS', -1 }, { 'H4CNF_WEAPONS', 4 },
       { 'H4CNF_TROJAN', 5 } }
	WEEKLY_F4:add_action('猎豹雕像 (任意次要目标装满背包,不拿保险箱)', function()
		for i = 1, #USER_CAN_MDFY_WKLY_FOUR_PANTHER do
			stat_set_int(USER_CAN_MDFY_WKLY_FOUR_PANTHER[i][1], true, USER_CAN_MDFY_WKLY_FOUR_PANTHER[i][2])
		end
		for i = 1, #WKLY_FOUR_PANTHER do
			stat_set_int(WKLY_FOUR_PANTHER[i][1], true, WKLY_FOUR_PANTHER[i][2])
		end
		globals.set_float(262145 + 29641, -0.1) -- pavel cut protection
		globals.set_float(262145 + 29642, -0.02) -- fency fee cut protection
		globals.set_int(262145 + 29395, 1800) -- bag protection
		globals.set_int(1973525 + 823 + 56 + 1, 25) -- player 1
		globals.set_int(1973525 + 823 + 56 + 2, 25) -- player 2
		globals.set_int(1973525 + 823 + 56 + 3, 25) -- player 3
		globals.set_int(1973525 + 823 + 56 + 4, 25) -- player 4
	end)
end
------- ADVANCED FEATURES CAYO
-- [unuseable]需要用户输入
-- PERICO_HOST_CUT:add_action("自定义分红", function(perico_host)
--	 local r, s = input.get("It is not recommended to use such high values", "", 1000, 3)
--	 if r == 1 then
--		 return HANDLER_CONTINUE
--	 end
--	 if r == 2 then
--		 return HANDLER_POP
--	 end
--	 globals.set_int(1973525 + 823 + 56 + 1, tonumber(s))
-- end)
PERICO_HOST_CUT:add_action('0 %', function()
	globals.set_int(1973525 + 823 + 56 + 1, 0)
end)
PERICO_HOST_CUT:add_action('50 %', function()
	globals.set_int(1973525 + 823 + 56 + 1, 50)
end)
PERICO_HOST_CUT:add_action('85 %', function()
	globals.set_int(1973525 + 823 + 56 + 1, 85)
end)
PERICO_HOST_CUT:add_action('100 %', function()
	globals.set_int(1973525 + 823 + 56 + 1, 100)
end)
PERICO_HOST_CUT:add_action('125 %', function()
	globals.set_int(1973525 + 823 + 56 + 1, 125)
end)
PERICO_HOST_CUT:add_action('150 %', function()
	globals.set_int(1973525 + 823 + 56 + 1, 150)
end)
-- PLAYER 2 CUT MANAGER
-- [unuseable]需要用户输入
-- PERICO_P2_CUT:add_action("自定义分红", function(perico2)
--	 local r, s = input.get("It is not recommended to use such high values", "", 1000, 3)
--	 if r == 1 then
--		 return HANDLER_CONTINUE
--	 end
--	 if r == 2 then
--		 return HANDLER_POP
--	 end
--	 globals.set_int(1973525 + 823 + 56 + 2, tonumber(s))
-- end)
PERICO_P2_CUT:add_action('0 %', function()
	globals.set_int(1973525 + 823 + 56 + 2, 0)
end)
PERICO_P2_CUT:add_action('50 %', function()
	globals.set_int(1973525 + 823 + 56 + 2, 50)
end)
PERICO_P2_CUT:add_action('85 %', function()
	globals.set_int(1973525 + 823 + 56 + 2, 85)
end)
PERICO_P2_CUT:add_action('100 %', function()
	globals.set_int(1973525 + 823 + 56 + 2, 100)
end)
PERICO_P2_CUT:add_action('125 %', function()
	globals.set_int(1973525 + 823 + 56 + 2, 125)
end)
PERICO_P2_CUT:add_action('150 %', function()
	globals.set_int(1973525 + 823 + 56 + 2, 150)
end)
-- PLAYER 3 CUT MANAGER
-- [unuseable]需要用户输入
-- PERICO_P3_CUT:add_action("自定义分红", function(perico3)
--	 local r, s = input.get("It is not recommended to use such high values", "", 1000, 3)
--	 if r == 1 then
--		 return HANDLER_CONTINUE
--	 end
--	 if r == 2 then
--		 return HANDLER_POP
--	 end
--	 globals.set_int(1973525 + 823 + 56 + 3, tonumber(s))
-- end)
PERICO_P3_CUT:add_action('0 %', function()
	globals.set_int(1973525 + 823 + 56 + 3, 0)
end)
PERICO_P3_CUT:add_action('50 %', function()
	globals.set_int(1973525 + 823 + 56 + 3, 50)
end)
PERICO_P3_CUT:add_action('85 %', function()
	globals.set_int(1973525 + 823 + 56 + 3, 85)
end)
PERICO_P3_CUT:add_action('100 %', function()
	globals.set_int(1973525 + 823 + 56 + 3, 100)
end)
PERICO_P3_CUT:add_action('125 %', function()
	globals.set_int(1973525 + 823 + 56 + 3, 125)
end)
PERICO_P3_CUT:add_action('150 %', function()
	globals.set_int(1973525 + 823 + 56 + 3, 150)
end)
-- PLAYER 4 CUT MANAGER
-- [unuseable]需要用户输入
-- PERICO_P4_CUT:add_action("自定义分红", function(perico4)
--	 local r, s = input.get("It is not recommended to use such high values", "", 1000, 3)
--	 if r == 1 then
--		 return HANDLER_CONTINUE
--	 end
--	 if r == 2 then
--		 return HANDLER_POP
--	 end
--	 globals.set_int(1973525 + 823 + 56 + 4, tonumber(s))
-- end)
PERICO_P4_CUT:add_action('0 %', function()
	globals.set_int(1973525 + 823 + 56 + 4, 0)
end)
PERICO_P4_CUT:add_action('50 %', function()
	globals.set_int(1973525 + 823 + 56 + 4, 50)
end)
PERICO_P4_CUT:add_action('85 %', function()
	globals.set_int(1973525 + 823 + 56 + 4, 85)
end)
PERICO_P4_CUT:add_action('100 %', function()
	globals.set_int(1973525 + 823 + 56 + 4, 100)
end)
PERICO_P4_CUT:add_action('125 %', function()
	globals.set_int(1973525 + 823 + 56 + 4, 125)
end)
PERICO_P4_CUT:add_action('150 %', function()
	globals.set_int(1973525 + 823 + 56 + 4, 150)
end)
CAYO_BAG:add_action('正常背包大小', function()
	globals.set_int(262145 + 29395, 1800)
end)
CAYO_BAG:add_action('2 倍背包大小', function()
	globals.set_int(262145 + 29395, 3600)
end)
CAYO_BAG:add_action('3 倍背包大小', function()
	globals.set_int(262145 + 29395, 5400)
end)
CAYO_BAG:add_action('4 倍背包大小', function()
	globals.set_int(262145 + 29395, 7200)
end)
CAYO_BAG:add_action('无限背包大小', function()
	globals.set_int(262145 + 29395, 9999999)
end)
PERICO_ADV:add_action('VOLTlab (关闭防空系统)', function()
	localplayer:set_position(vector3(4372.792, -4578.357, 4.208))
	localplayer:set_rotation(vector3(2, 0, 0))
	sleep(3)
	ResultScan = script('fm_mission_controller_2020'):get_int(1777)
	script('fm_mission_controller_2020'):set_int(1776, ResultScan)
end)
PERICO_ADV:add_action('快速等离子切割器', function()
	script('fm_mission_controller_2020'):set_float(28269 + 3, 999)
end)
-- [unuseable]该功能需要网络事件和对实体的控制，遂阉割掉
-- PERICO_ADV:add_action("移除排水管道格栅", function()
--	 for k, DOORs in pairs(object.get_all_objects()) do
--		 local ENT_ENTRY = entity.get_entity_model_hash(DOORs)
--		 local prop_chem_grill_bit = 2997331308
--		 if ENT_ENTRY == prop_chem_grill_bit then
--			 network.request_control_of_entity(DOORs)
--			 local timer = utils.time_ms() + 500
--			 while not network.has_control_of_entity(DOORs) and timer > utils.time_ms() do
--				 sleep(3)
--			 end
--			 if network.has_control_of_entity(DOORs) then
--				 -- entity.set_entity_as_mission_entity(DOORs, true, true)
--				 entity.set_entity_as_no_longer_needed(DOORs)
--				 entity.delete_entity(DOORs)
--			 end
--		 end
--	 end
-- end)
-------------------------
do
	local CP_VEH_KA = { { 'H4_MISSIONS', 65283 } }
	CAYO_VEHICLES:add_action('虎鲸', function()
		for i = 1, #CP_VEH_KA do
			stat_set_int(CP_VEH_KA[i][1], true, CP_VEH_KA[i][2])
		end
	end)
end
do
	local CP_VEH_AT = { { 'H4_MISSIONS', 65413 } }
	CAYO_VEHICLES:add_action('阿尔科诺斯特', function()
		for i = 1, #CP_VEH_AT do
			stat_set_int(CP_VEH_AT[i][1], true, CP_VEH_AT[i][2])
		end
	end)
end
do
	local CP_VEH_VM = { { 'H4_MISSIONS', 65289 } }
	CAYO_VEHICLES:add_action('梅杜莎', function()
		for i = 1, #CP_VEH_VM do
			stat_set_int(CP_VEH_VM[i][1], true, CP_VEH_VM[i][2])
		end
	end)
end
do
	local CP_VEH_SA = { { 'H4_MISSIONS', 65425 } }
	CAYO_VEHICLES:add_action('隐形歼灭者', function()
		for i = 1, #CP_VEH_SA do
			stat_set_int(CP_VEH_SA[i][1], true, CP_VEH_SA[i][2])
		end
	end)
end
do
	local CP_VEH_PB = { { 'H4_MISSIONS', 65313 } }
	CAYO_VEHICLES:add_action('巡逻艇', function()
		for i = 1, #CP_VEH_PB do
			stat_set_int(CP_VEH_PB[i][1], true, CP_VEH_PB[i][2])
		end
	end)
end
do
	local CP_VEH_LN = { { 'H4_MISSIONS', 65345 } }
	CAYO_VEHICLES:add_action('长崎', function()
		for i = 1, #CP_VEH_LN do
			stat_set_int(CP_VEH_LN[i][1], true, CP_VEH_LN[i][2])
		end
	end)
end
do
	local CP_VEH_ALL = { { 'H4_MISSIONS', -1 } }
	CAYO_VEHICLES:add_action('解锁全部载具', function()
		for i = 1, #CP_VEH_ALL do
			stat_set_int(CP_VEH_ALL[i][1], true, CP_VEH_ALL[i][2])
		end
	end)
end
do
	local Target_SapphirePanther = { { 'H4CNF_TARGET', 5 } }
	CAYO_PRIMARY:add_action('猎豹雕像', function()
		for i = 1, #Target_SapphirePanther do
			stat_set_int(Target_SapphirePanther[i][1], true, Target_SapphirePanther[i][2])
		end
	end)
end
do
	local Target_MadrazoF = { { 'H4CNF_TARGET', 4 } }
	CAYO_PRIMARY:add_action('玛德拉索文件', function()
		for i = 1, #Target_MadrazoF do
			stat_set_int(Target_MadrazoF[i][1], true, Target_MadrazoF[i][2])
		end
	end)
end
do
	local Target_PinkDiamond = { { 'H4CNF_TARGET', 3 } }
	CAYO_PRIMARY:add_action('粉钻', function()
		for i = 1, #Target_PinkDiamond do
			stat_set_int(Target_PinkDiamond[i][1], true, Target_PinkDiamond[i][2])
		end
	end)
end
do
	local Target_BearerBonds = { { 'H4CNF_TARGET', 2 } }
	CAYO_PRIMARY:add_action('不记名债券', function()
		for i = 1, #Target_BearerBonds do
			stat_set_int(Target_BearerBonds[i][1], true, Target_BearerBonds[i][2])
		end
	end)
end
do
	local Target_Ruby = { { 'H4CNF_TARGET', 1 } }
	CAYO_PRIMARY:add_action('红宝石项链', function()
		for i = 1, #Target_Ruby do
			stat_set_int(Target_Ruby[i][1], true, Target_Ruby[i][2])
		end
	end)
end
do
	local Target_Tequila = { { 'H4CNF_TARGET', 0 } }
	CAYO_PRIMARY:add_action('西西米托龙舌兰酒', function()
		for i = 1, #Target_Tequila do
			stat_set_int(Target_Tequila[i][1], true, Target_Tequila[i][2])
		end
	end)
end
do
	local SecondaryT_RDM = { { 'H4LOOT_CASH_I', 1319624 }, { 'H4LOOT_CASH_C', 18 }, { 'H4LOOT_CASH_V', 89400 }, { 'H4LOOT_WEED_I', 2639108 },
                          { 'H4LOOT_WEED_C', 36 }, { 'H4LOOT_WEED_V', 149000 }, { 'H4LOOT_COKE_I', 4229122 }, { 'H4LOOT_COKE_C', 72 },
                          { 'H4LOOT_COKE_V', 221200 }, { 'H4LOOT_GOLD_I', 8589313 }, { 'H4LOOT_GOLD_C', 129 }, { 'H4LOOT_GOLD_V', 322600 },
                          { 'H4LOOT_PAINT', 127 }, { 'H4LOOT_PAINT_V', 186800 }, { 'H4LOOT_CASH_I_SCOPED', 1319624 }, { 'H4LOOT_CASH_C_SCOPED', 18 },
                          { 'H4LOOT_WEED_I_SCOPED', 2639108 }, { 'H4LOOT_WEED_C_SCOPED', 36 }, { 'H4LOOT_COKE_I_SCOPED', 4229122 },
                          { 'H4LOOT_COKE_C_SCOPED', 72 }, { 'H4LOOT_GOLD_I_SCOPED', 8589313 }, { 'H4LOOT_GOLD_C_SCOPED', 129 },
                          { 'H4LOOT_PAINT_SCOPED', 127 } }
	CAYO_SECONDARY:add_action('随机次要目标', function()
		for i = 1, #SecondaryT_RDM do
			stat_set_int(SecondaryT_RDM[i][1], true, SecondaryT_RDM[i][2])
		end
	end)
end
do
	local SecondaryT_FCash = { { 'H4LOOT_CASH_I', -1 }, { 'H4LOOT_CASH_C', -1 }, { 'H4LOOT_CASH_V', 90000 }, { 'H4LOOT_WEED_I', 0 },
                            { 'H4LOOT_WEED_C', 0 }, { 'H4LOOT_WEED_V', 0 }, { 'H4LOOT_COKE_I', 0 }, { 'H4LOOT_COKE_C', 0 }, { 'H4LOOT_COKE_V', 0 },
                            { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_C', 0 }, { 'H4LOOT_GOLD_V', 0 }, { 'H4LOOT_PAINT', 127 },
                            { 'H4LOOT_PAINT_V', 190000 }, { 'H4LOOT_CASH_I_SCOPED', -1 }, { 'H4LOOT_CASH_C_SCOPED', -1 },
                            { 'H4LOOT_WEED_I_SCOPED', 0 }, { 'H4LOOT_WEED_C_SCOPED', 0 }, { 'H4LOOT_COKE_I_SCOPED', 0 },
                            { 'H4LOOT_COKE_C_SCOPED', 0 }, { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C_SCOPED', 0 },
                            { 'H4LOOT_PAINT_SCOPED', 127 } }
	CAYO_SECONDARY:add_action('现金', function()
		for i = 1, #SecondaryT_FCash do
			stat_set_int(SecondaryT_FCash[i][1], true, SecondaryT_FCash[i][2])
		end
	end)
end
do
	local SecondaryT_FWeed = { { 'H4LOOT_CASH_I', 0 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_V', 0 }, { 'H4LOOT_WEED_I', -1 }, { 'H4LOOT_WEED_C', -1 },
                            { 'H4LOOT_WEED_V', 140000 }, { 'H4LOOT_COKE_I', 0 }, { 'H4LOOT_COKE_C', 0 }, { 'H4LOOT_COKE_V', 0 },
                            { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_C', 0 }, { 'H4LOOT_GOLD_V', 0 }, { 'H4LOOT_PAINT', 127 },
                            { 'H4LOOT_PAINT_V', 190000 }, { 'H4LOOT_CASH_I_SCOPED', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 },
                            { 'H4LOOT_WEED_I_SCOPED', -1 }, { 'H4LOOT_WEED_C_SCOPED', -1 }, { 'H4LOOT_COKE_I_SCOPED', 0 },
                            { 'H4LOOT_COKE_C_SCOPED', 0 }, { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C_SCOPED', 0 },
                            { 'H4LOOT_PAINT_SCOPED', 127 } }
	CAYO_SECONDARY:add_action('大麻', function()
		for i = 1, #SecondaryT_FWeed do
			stat_set_int(SecondaryT_FWeed[i][1], true, SecondaryT_FWeed[i][2])
		end
	end)
end
do
	local SecondaryT_FCoke = { { 'H4LOOT_CASH_I', 0 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_V', 0 }, { 'H4LOOT_WEED_I', 0 }, { 'H4LOOT_WEED_C', 0 },
                            { 'H4LOOT_WEED_V', 0 }, { 'H4LOOT_COKE_I', -1 }, { 'H4LOOT_COKE_C', -1 }, { 'H4LOOT_COKE_V', 210000 },
                            { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_C', 0 }, { 'H4LOOT_GOLD_V', 0 }, { 'H4LOOT_PAINT', 127 },
                            { 'H4LOOT_PAINT_V', 190000 }, { 'H4LOOT_CASH_I_SCOPED', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_WEED_I_SCOPED', 0 },
                            { 'H4LOOT_WEED_C_SCOPED', 0 }, { 'H4LOOT_COKE_I_SCOPED', -1 }, { 'H4LOOT_COKE_C_SCOPED', -1 },
                            { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C_SCOPED', 0 }, { 'H4LOOT_PAINT_SCOPED', 127 } }
	CAYO_SECONDARY:add_action('可卡因', function()
		for i = 1, #SecondaryT_FCoke do
			stat_set_int(SecondaryT_FCoke[i][1], true, SecondaryT_FCoke[i][2])
		end
	end)
end
do
	local SecondaryT_FGold = { { 'H4LOOT_CASH_I', 0 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_V', 0 }, { 'H4LOOT_WEED_I', 0 }, { 'H4LOOT_WEED_C', 0 },
                            { 'H4LOOT_WEED_V', 0 }, { 'H4LOOT_COKE_I', 0 }, { 'H4LOOT_COKE_C', 0 }, { 'H4LOOT_COKE_V', 0 }, { 'H4LOOT_GOLD_I', -1 },
                            { 'H4LOOT_GOLD_C', -1 }, { 'H4LOOT_GOLD_V', 320000 }, { 'H4LOOT_PAINT', -1 }, { 'H4LOOT_PAINT_V', 190000 },
                            { 'H4LOOT_CASH_I_SCOPED', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_WEED_I_SCOPED', 0 },
                            { 'H4LOOT_WEED_C_SCOPED', 0 }, { 'H4LOOT_COKE_I_SCOPED', 0 }, { 'H4LOOT_COKE_C_SCOPED', 0 },
                            { 'H4LOOT_GOLD_I_SCOPED', -1 }, { 'H4LOOT_GOLD_C_SCOPED', -1 }, { 'H4LOOT_PAINT_SCOPED', -1 } }
	CAYO_SECONDARY:add_action('黄金', function()
		for i = 1, #SecondaryT_FGold do
			stat_set_int(SecondaryT_FGold[i][1], true, SecondaryT_FGold[i][2])
		end
	end)
end
do
	local SecondaryT_Remove = { { 'H4LOOT_CASH_I', 0 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_V', 0 }, { 'H4LOOT_WEED_I', 0 }, { 'H4LOOT_WEED_C', 0 },
                             { 'H4LOOT_WEED_V', 0 }, { 'H4LOOT_COKE_I', 0 }, { 'H4LOOT_COKE_C', 0 }, { 'H4LOOT_COKE_V', 0 }, { 'H4LOOT_GOLD_I', 0 },
                             { 'H4LOOT_GOLD_C', 0 }, { 'H4LOOT_GOLD_V', 0 }, { 'H4LOOT_PAINT', 0 }, { 'H4LOOT_PAINT_V', 0 },
                             { 'H4LOOT_CASH_I_SCOPED', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_WEED_I_SCOPED', 0 },
                             { 'H4LOOT_WEED_C_SCOPED', 0 }, { 'H4LOOT_COKE_I_SCOPED', 0 }, { 'H4LOOT_COKE_C_SCOPED', 0 },
                             { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C_SCOPED', 0 }, { 'H4LOOT_PAINT_SCOPED', 0 } }
	CAYO_SECONDARY:add_action('移除全部次要目标', function()
		for i = 1, #SecondaryT_Remove do
			stat_set_int(SecondaryT_Remove[i][1], true, SecondaryT_Remove[i][2])
		end
	end)
end
-- [unuseable]需要用户输入
-- local CAH_2ND_TARGET_MDY = CAYO_SECONDARY:add_submenu("修改次要目标价值")
-- local valueToSet = CAH_2ND_TARGET_MDY:add_action("修改现金价值", function()
--	 local Choose, ME = input.get("输入数字", "", 1000, 3)
--	 if Choose == 1 then
--		 return HANDLER_CONTINUE
--	 end
--	 if Choose == 2 then
--		 return HANDLER_POP
--	 end
--	 stats.set_int(PlayerMP .. "_H4LOOT_CASH_V", tonumber(ME), true)
-- end)
-- local valueToSet = CAH_2ND_TARGET_MDY:add_action("修改大麻价值", function()
--	 local Choose, ME = input.get("输入数字", "", 1000, 3)
--	 if Choose == 1 then
--		 return HANDLER_CONTINUE
--	 end
--	 if Choose == 2 then
--		 return HANDLER_POP
--	 end
--	 stats.set_int(PlayerMP .. "_H4LOOT_WEED_V", tonumber(ME), true)
-- end)
-- local valueToSet = CAH_2ND_TARGET_MDY:add_action("修改可卡因价值", function()
--	 local Choose, ME = input.get("输入数字", "", 1000, 3)
--	 if Choose == 1 then
--		 return HANDLER_CONTINUE
--	 end
--	 if Choose == 2 then
--		 return HANDLER_POP
--	 end
--	 stats.set_int(PlayerMP .. "_H4LOOT_COKE_V", tonumber(ME), true)
-- end)
-- local valueToSet = CAH_2ND_TARGET_MDY:add_action("修改黄金价值", function()
--	 local Choose, ME = input.get("输入数字", "", 1000, 3)
--	 if Choose == 1 then
--		 return HANDLER_CONTINUE
--	 end
--	 if Choose == 2 then
--		 return HANDLER_POP
--	 end
--	 stats.set_int(PlayerMP .. "_H4LOOT_GOLD_V", tonumber(ME), true)
-- end)
-- local valueToSet = CAH_2ND_TARGET_MDY:add_action("修改画价值", function()
--	 local Choose, ME = input.get("输入数字", "", 1000, 3)
--	 if Choose == 1 then
--		 return HANDLER_CONTINUE
--	 end
--	 if Choose == 2 then
--		 return HANDLER_POP
--	 end
--	 stats.set_int(PlayerMP .. "_H4LOOT_PAINT_V", tonumber(ME), true)
-- end)
local CAYO_COMPOUND = CAYO_SECONDARY:add_submenu('豪宅内次要目标')
do
	local Compound_LT_MIX = { { 'H4LOOT_CASH_C', 2 }, { 'H4LOOT_CASH_V', 474431 }, { 'H4LOOT_WEED_C', 17 }, { 'H4LOOT_WEED_V', 759090 },
                           { 'H4LOOT_COKE_C', 132 }, { 'H4LOOT_COKE_V', 948863 }, { 'H4LOOT_GOLD_C', 104 }, { 'H4LOOT_GOLD_V', 1265151 },
                           { 'H4LOOT_PAINT', 127 }, { 'H4LOOT_PAINT_V', 948863 }, { 'H4LOOT_CASH_C_SCOPED', 2 }, { 'H4LOOT_WEED_C_SCOPED', 17 },
                           { 'H4LOOT_COKE_C_SCOPED', 132 }, { 'H4LOOT_GOLD_C_SCOPED', 104 }, { 'H4LOOT_PAINT_SCOPED', 127 } }
	CAYO_COMPOUND:add_action('随机次要目标', function()
		for i = 1, #Compound_LT_MIX do
			stat_set_int(Compound_LT_MIX[i][1], true, Compound_LT_MIX[i][2])
		end
	end)
end
do
	local Compound_LT_CASH = { { 'H4LOOT_CASH_C', -1 }, { 'H4LOOT_CASH_V', 90000 }, { 'H4LOOT_WEED_C', 0 }, { 'H4LOOT_WEED_V', 0 },
                            { 'H4LOOT_COKE_C', 0 }, { 'H4LOOT_COKE_V', 0 }, { 'H4LOOT_GOLD_C', 0 }, { 'H4LOOT_GOLD_V', 0 }, { 'H4LOOT_PAINT', 127 },
                            { 'H4LOOT_PAINT_V', 190000 }, { 'H4LOOT_CASH_C_SCOPED', -1 }, { 'H4LOOT_WEED_C_SCOPED', 0 },
                            { 'H4LOOT_COKE_C_SCOPED', 0 }, { 'H4LOOT_GOLD_C_SCOPED', 0 }, { 'H4LOOT_PAINT_SCOPED', 127 } }
	CAYO_COMPOUND:add_action('现金', function()
		for i = 1, #Compound_LT_CASH do
			stat_set_int(Compound_LT_CASH[i][1], true, Compound_LT_CASH[i][2])
		end
	end)
end
do
	local Compound_LT_WEED = { { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_V', 0 }, { 'H4LOOT_WEED_C', -1 }, { 'H4LOOT_WEED_V', 140000 },
                            { 'H4LOOT_COKE_C', 0 }, { 'H4LOOT_COKE_V', 0 }, { 'H4LOOT_GOLD_C', 0 }, { 'H4LOOT_PAINT', 127 },
                            { 'H4LOOT_PAINT_V', 190000 }, { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_WEED_C_SCOPED', -1 },
                            { 'H4LOOT_COKE_C_SCOPED', 0 }, { 'H4LOOT_GOLD_C_SCOPED', 0 }, { 'H4LOOT_PAINT_SCOPED', 127 } }
	CAYO_COMPOUND:add_action('大麻', function()
		for i = 1, #Compound_LT_WEED do
			stat_set_int(Compound_LT_WEED[i][1], true, Compound_LT_WEED[i][2])
		end
	end)
end
do
	local Compound_LT_COKE = { { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_V', 0 }, { 'H4LOOT_WEED_C', 0 }, { 'H4LOOT_WEED_V', 0 }, { 'H4LOOT_COKE_C', -1 },
                            { 'H4LOOT_COKE_V', 210000 }, { 'H4LOOT_GOLD_C', 0 }, { 'H4LOOT_PAINT', 127 }, { 'H4LOOT_PAINT_V', 190000 },
                            { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_WEED_C_SCOPED', 0 }, { 'H4LOOT_COKE_C_SCOPED', -1 },
                            { 'H4LOOT_GOLD_C_SCOPED', 0 }, { 'H4LOOT_PAINT_SCOPED', 127 } }
	CAYO_COMPOUND:add_action('可卡因', function()
		for i = 1, #Compound_LT_COKE do
			stat_set_int(Compound_LT_COKE[i][1], true, Compound_LT_COKE[i][2])
		end
	end)
end
do
	local Compound_LT_GOLD = { { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_V', 0 }, { 'H4LOOT_WEED_C', 0 }, { 'H4LOOT_WEED_V', 0 }, { 'H4LOOT_COKE_C', 0 },
                            { 'H4LOOT_COKE_V', 0 }, { 'H4LOOT_GOLD_C', -1 }, { 'H4LOOT_GOLD_V', 320000 }, { 'H4LOOT_PAINT', 127 },
                            { 'H4LOOT_PAINT_V', 190000 }, { 'H4LOOT_GOLD_C_SCOPED', -1 }, { 'H4LOOT_CASH_C_SCOPED', 0 },
                            { 'H4LOOT_WEED_C_SCOPED', 0 }, { 'H4LOOT_COKE_C_SCOPED', 0 }, { 'H4LOOT_PAINT_SCOPED', 127 } }
	CAYO_COMPOUND:add_action('黄金', function()
		for i = 1, #Compound_LT_GOLD do
			stat_set_int(Compound_LT_GOLD[i][1], true, Compound_LT_GOLD[i][2])
		end
	end)
end
do
	local Compound_LT_PAINT = { { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_V', 0 }, { 'H4LOOT_WEED_C', 0 }, { 'H4LOOT_WEED_V', 0 }, { 'H4LOOT_COKE_C', 0 },
                             { 'H4LOOT_COKE_V', 0 }, { 'H4LOOT_GOLD_C', 0 }, { 'H4LOOT_GOLD_V', 0 }, { 'H4LOOT_GOLD_C_SCOPED', 0 },
                             { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_WEED_C_SCOPED', 0 }, { 'H4LOOT_COKE_C_SCOPED', 0 }, { 'H4LOOT_PAINT', 127 },
                             { 'H4LOOT_PAINT_V', 190000 }, { 'H4LOOT_PAINT_SCOPED', 127 } }
	CAYO_COMPOUND:add_action('画', function()
		for i = 1, #Compound_LT_PAINT do
			stat_set_int(Compound_LT_PAINT[i][1], true, Compound_LT_PAINT[i][2])
		end
	end)
end
do
	local Remove_Compound_Paint = { { 'H4LOOT_PAINT', 0 }, { 'H4LOOT_PAINT_V', 0 }, { 'H4LOOT_PAINT_SCOPED', 0 } }
	CAYO_COMPOUND:add_action('移除全部画', function()
		for i = 1, #Remove_Compound_Paint do
			stat_set_int(Remove_Compound_Paint[i][1], true, Remove_Compound_Paint[i][2])
		end
	end)
end
do
	local Remove_ALL_Compound_LT = { { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_WEED_C', 0 }, { 'H4LOOT_COKE_C', 0 }, { 'H4LOOT_GOLD_C', 0 },
                                  { 'H4LOOT_GOLD_C_SCOPED', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_WEED_C_SCOPED', 0 },
                                  { 'H4LOOT_COKE_C_SCOPED', 0 }, { 'H4LOOT_PAINT', 0 }, { 'H4LOOT_PAINT_SCOPED', 0 } }
	CAYO_COMPOUND:add_action('移除全部次要目标', function()
		for i = 1, #Remove_ALL_Compound_LT do
			stat_set_int(Remove_ALL_Compound_LT[i][1], true, Remove_ALL_Compound_LT[i][2])
		end
	end)
end
do
	local Weapon_Aggressor = { { 'H4CNF_WEAPONS', 1 } }
	CAYO_WEAPONS:add_action('侵略者', function()
		for i = 1, #Weapon_Aggressor do
			stat_set_int(Weapon_Aggressor[i][1], true, Weapon_Aggressor[i][2])
		end
	end)
end
do
	local Weapon_Conspirator = { { 'H4CNF_WEAPONS', 2 } }
	CAYO_WEAPONS:add_action('阴谋者', function()
		for i = 1, #Weapon_Conspirator do
			stat_set_int(Weapon_Conspirator[i][1], true, Weapon_Conspirator[i][2])
		end
	end)
end
do
	local Weapon_Crackshot = { { 'H4CNF_WEAPONS', 3 } }
	CAYO_WEAPONS:add_action('神枪手', function()
		for i = 1, #Weapon_Crackshot do
			stat_set_int(Weapon_Crackshot[i][1], true, Weapon_Crackshot[i][2])
		end
	end)
end
do
	local Weapon_Saboteur = { { 'H4CNF_WEAPONS', 4 } }
	CAYO_WEAPONS:add_action('破坏者', function()
		for i = 1, #Weapon_Saboteur do
			stat_set_int(Weapon_Saboteur[i][1], true, Weapon_Saboteur[i][2])
		end
	end)
end
do
	local Weapon_Marksman = { { 'H4CNF_WEAPONS', 5 } }
	CAYO_WEAPONS:add_action('神射手', function()
		for i = 1, #Weapon_Marksman do
			stat_set_int(Weapon_Marksman[i][1], true, Weapon_Marksman[i][2])
		end
	end)
end
do
	local Supress_Removal = { { 'H4CNF_BS_GEN', 126975 } }
	local FUCK_Supressor = CAYO_WEAPONS:add_submenu('消音器')
	FUCK_Supressor:add_action('买不起消音器上你妈的岛', function()
	end)
	CAYO_WEAPONS:add_action('移除消音器', function()
		for i = 1, #Supress_Removal do
			stat_set_int(Supress_Removal[i][1], true, Supress_Removal[i][2])
		end
	end)
end
do
	local CP_Item_SpawnPlace_AIR = { { 'H4CNF_GRAPPEL', 2022 }, { 'H4CNF_UNIFORM', 12 }, { 'H4CNF_BOLTCUT', 4161 }, { 'H4CNF_TROJAN', 1 } }
	CAYO_EQUIPM:add_action('机场周边', function()
		for i = 1, #CP_Item_SpawnPlace_AIR do
			stat_set_int(CP_Item_SpawnPlace_AIR[i][1], true, CP_Item_SpawnPlace_AIR[i][2])
		end
	end)
end
do
	local CP_Item_SpawnPlace_DKS = { { 'H4CNF_GRAPPEL', 3671 }, { 'H4CNF_UNIFORM', 5256 }, { 'H4CNF_BOLTCUT', 4424 }, { 'H4CNF_TROJAN', 2 } }
	CAYO_EQUIPM:add_action('码头周边', function()
		for i = 1, #CP_Item_SpawnPlace_DKS do
			stat_set_int(CP_Item_SpawnPlace_DKS[i][1], true, CP_Item_SpawnPlace_DKS[i][2])
		end
	end)
end
do
	local CP_Item_SpawnPlace_CP = { { 'H4CNF_GRAPPEL', 85324 }, { 'H4CNF_UNIFORM', 61034 }, { 'H4CNF_BOLTCUT', 4612 }, { 'H4CNF_TROJAN', 5 } }
	CAYO_EQUIPM:add_action('豪宅周边', function()
		for i = 1, #CP_Item_SpawnPlace_CP do
			stat_set_int(CP_Item_SpawnPlace_CP[i][1], true, CP_Item_SpawnPlace_CP[i][2])
		end
	end)
end
do
	local CP_TRUCK_SPAWN_mov1 = { { 'H4CNF_TROJAN', 1 } }
	CAYO_TRUCK:add_action('机场', function()
		for i = 1, #CP_TRUCK_SPAWN_mov1 do
			stat_set_int(CP_TRUCK_SPAWN_mov1[i][1], true, CP_TRUCK_SPAWN_mov1[i][2])
		end
	end)
end
do
	local CP_TRUCK_SPAWN_mov2 = { { 'H4CNF_TROJAN', 2 } }
	CAYO_TRUCK:add_action('北码头', function()
		for i = 1, #CP_TRUCK_SPAWN_mov2 do
			stat_set_int(CP_TRUCK_SPAWN_mov2[i][1], true, CP_TRUCK_SPAWN_mov2[i][2])
		end
	end)
end
do
	local CP_TRUCK_SPAWN_mov3 = { { 'H4CNF_TROJAN', 3 } }
	CAYO_TRUCK:add_action('主码头 (东)', function()
		for i = 1, #CP_TRUCK_SPAWN_mov3 do
			stat_set_int(CP_TRUCK_SPAWN_mov3[i][1], true, CP_TRUCK_SPAWN_mov3[i][2])
		end
	end)
end
do
	local CP_TRUCK_SPAWN_mov4 = { { 'H4CNF_TROJAN', 4 } }
	CAYO_TRUCK:add_action('主码头 (西)', function()
		for i = 1, #CP_TRUCK_SPAWN_mov4 do
			stat_set_int(CP_TRUCK_SPAWN_mov4[i][1], true, CP_TRUCK_SPAWN_mov4[i][2])
		end
	end)
end
do
	local CP_TRUCK_SPAWN_mov5 = { { 'H4CNF_TROJAN', 5 } }
	CAYO_TRUCK:add_action('豪宅', function()
		for i = 1, #CP_TRUCK_SPAWN_mov5 do
			stat_set_int(CP_TRUCK_SPAWN_mov5[i][1], true, CP_TRUCK_SPAWN_mov5[i][2])
		end
	end)
end
do
	local CAYO_NORMAL = { { 'H4_PROGRESS', 126823 } }
	CAYO_DFFCTY:add_action('正常模式', function()
		for i = 1, #CAYO_NORMAL do
			stat_set_int(CAYO_NORMAL[i][1], true, CAYO_NORMAL[i][2])
		end
	end)
end
do
	local CAYO_Hard = { { 'H4_PROGRESS', 131055 } }
	CAYO_DFFCTY:add_action('困难模式', function()
		for i = 1, #CAYO_Hard do
			stat_set_int(CAYO_Hard[i][1], true, CAYO_Hard[i][2])
		end
	end)
end
do
	MORE_OPTIONS:add_action('解锁佩里科岛奖励', function()
		local CP_AWRD_BL = { { 'AWD_INTELGATHER', true }, { 'AWD_COMPOUNDINFILT', true }, { 'AWD_LOOT_FINDER', true }, { 'AWD_MAX_DISRUPT', true },
                       { 'AWD_THE_ISLAND_HEIST', true }, { 'AWD_GOING_ALONE', true }, { 'AWD_TEAM_WORK', true }, { 'AWD_MIXING_UP', true },
                       { 'AWD_PRO_THIEF', true }, { 'AWD_CAT_BURGLAR', true }, { 'AWD_ONE_OF_THEM', true }, { 'AWD_GOLDEN_GUN', true },
                       { 'AWD_ELITE_THIEF', true }, { 'AWD_PROFESSIONAL', true }, { 'AWD_HELPING_OUT', true }, { 'AWD_COURIER', true },
                       { 'AWD_PARTY_VIBES', true }, { 'AWD_HELPING_HAND', true }, { 'AWD_ELEVENELEVEN', true }, { 'COMPLETE_H4_F_USING_VETIR', true },
                       { 'COMPLETE_H4_F_USING_LONGFIN', true }, { 'COMPLETE_H4_F_USING_ANNIH', true }, { 'COMPLETE_H4_F_USING_ALKONOS', true },
                       { 'COMPLETE_H4_F_USING_PATROLB', true } }
		local CP_AWRD_IT = { { 'AWD_LOSTANDFOUND', 500000 }, { 'AWD_SUNSET', 1800000 }, { 'AWD_TREASURE_HUNTER', 1000000 }, { 'AWD_WRECK_DIVING', 1000000 },
                       { 'AWD_KEINEMUSIK', 1800000 }, { 'AWD_PALMS_TRAX', 1800000 }, { 'AWD_MOODYMANN', 1800000 },
                       { 'AWD_FILL_YOUR_BAGS', 1000000000 }, { 'AWD_WELL_PREPARED', 80 }, { 'H4_H4_DJ_MISSIONS', -1 } }
		for i = 1, #CP_AWRD_IT do
			stat_set_int(CP_AWRD_IT[i][1], true, CP_AWRD_IT[i][2])
		end
		for i = 1, #CP_AWRD_BL do
			stat_set_bool(CP_AWRD_BL[i][1], true, CP_AWRD_BL[i][2])
		end
		for i = 0, 192, 1 do
			hash = CharID .. '_HISLANDPSTAT_BOOL'
			stats.set_bool_masked(hash, true, i)
		end
	end)
end
do
	local COMPLETE_CP_MISSIONS =
					{ { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
					{ 'H4_MISSIONS', -1 }, { 'H4CNF_APPROACH', -1 }, { 'H4CNF_BS_ENTR', 63 }, { 'H4CNF_BS_GEN', 63 }, { 'H4CNF_WEP_DISRP', 3 },
       { 'H4CNF_ARM_DISRP', 3 }, { 'H4CNF_HEL_DISRP', 3 } }
	MORE_OPTIONS:add_action('完成全部任务', function()
		for i = 1, #COMPLETE_CP_MISSIONS do
			stat_set_int(COMPLETE_CP_MISSIONS[i][1], true, COMPLETE_CP_MISSIONS[i][2])
		end
	end)
end
do
	local CP_RST = { { 'H4_MISSIONS', 0 }, { 'H4_PROGRESS', 0 }, { 'H4CNF_APPROACH', 0 }, { 'H4CNF_BS_ENTR', 0 }, { 'H4CNF_BS_GEN', 0 },
                  { 'H4_PLAYTHROUGH_STATUS', 2 } }
	MORE_OPTIONS:add_action('重置抢劫', function()
		for i = 1, #CP_RST do
			stat_set_int(CP_RST[i][1], true, CP_RST[i][2])
		end
	end)
end
-- 名钻赌场抢劫
do
	local RunOnce = { { 'H3_COMPLETEDPOSIX', -1 }, { 'H3OPT_MASKS', 4 }, { 'H3OPT_WEAPS', 1 }, { 'H3OPT_VEHS', 3 } }
	local CAH_SILENT_SNEAKY_PRESET_ID_DMND = { { 'CAS_HEIST_FLOW', -1 }, { 'H3_LAST_APPROACH', 0 }, { 'H3OPT_APPROACH', 1 }, { 'H3_HARD_APPROACH', 0 },
                                            { 'H3OPT_TARGET', 3 }, { 'H3OPT_POI', 1023 }, { 'H3OPT_ACCESSPOINTS', 2047 }, { 'H3OPT_CREWWEAP', 4 },
                                            { 'H3OPT_CREWDRIVER', 3 }, { 'H3OPT_CREWHACKER', 4 }, { 'H3OPT_DISRUPTSHIP', 3 },
                                            { 'H3OPT_BODYARMORLVL', -1 }, { 'H3OPT_KEYLEVELS', 2 }, { 'H3OPT_BITSET1', 127 },
                                            { 'H3OPT_BITSET0', 262270 } }
	CAH_DIA_TARGET:add_action('隐迹潜踪 (钻石,请选择低级买家)', function()
		for i = 1, #RunOnce do
			stat_set_int(RunOnce[i][1], true, RunOnce[i][2])
		end
		for i = 1, #CAH_SILENT_SNEAKY_PRESET_ID_DMND do
			stat_set_int(CAH_SILENT_SNEAKY_PRESET_ID_DMND[i][1], true, CAH_SILENT_SNEAKY_PRESET_ID_DMND[i][2])
		end
		globals.set_int(1966739 + 2326, 60) -- [Diamond] 60% Low | 57 Medium | High 54
		globals.set_int(1966739 + 2326 + 1, 147) -- Low Buyer: 147 | Medium: 140 | High Buyer: 133
		globals.set_int(1966739 + 2326 + 2, 147)
		globals.set_int(1966739 + 2326 + 3, 147)
		globals.set_int(262145 + 28472, 1410065408) -- Diamond
	end)
end
do
	local RunOnce = { { 'H3_COMPLETEDPOSIX', -1 }, { 'H3OPT_MASKS', 2 }, { 'H3OPT_WEAPS', 1 }, { 'H3OPT_VEHS', 3 } }
	local CAH_BIGCON_PRESET_ID_DMND = { { 'CAS_HEIST_FLOW', -1 }, { 'H3_LAST_APPROACH', 0 }, { 'H3OPT_APPROACH', 2 }, { 'H3_HARD_APPROACH', 0 },
                                     { 'H3OPT_TARGET', 3 }, { 'H3OPT_POI', 1023 }, { 'H3OPT_ACCESSPOINTS', 2047 }, { 'H3OPT_CREWWEAP', 4 },
                                     { 'H3OPT_CREWDRIVER', 3 }, { 'H3OPT_CREWHACKER', 4 }, { 'H3OPT_DISRUPTSHIP', 3 }, { 'H3OPT_BODYARMORLVL', -1 },
                                     { 'H3OPT_KEYLEVELS', 2 }, { 'H3OPT_BITSET1', 159 }, { 'H3OPT_BITSET0', 524118 } }
	CAH_DIA_TARGET:add_action('兵不厌诈 (钻石,请选择低级买家)', function()
		for i = 1, #RunOnce do
			stat_set_int(RunOnce[i][1], true, RunOnce[i][2])
		end
		for i = 1, #CAH_BIGCON_PRESET_ID_DMND do
			stat_set_int(CAH_BIGCON_PRESET_ID_DMND[i][1], true, CAH_BIGCON_PRESET_ID_DMND[i][2])
		end
		globals.set_int(1966739 + 2326, 60) -- [Diamond] 60% Low | 57 Medium | High 54
		globals.set_int(1966739 + 2326 + 1, 147) -- Low Buyer: 147 | Medium: 140 | High Buyer: 133
		globals.set_int(1966739 + 2326 + 2, 147)
		globals.set_int(1966739 + 2326 + 3, 147)
		globals.set_int(262145 + 28472, 1410065408) -- Diamond
	end)
end
do
	local RunOnce = { { 'H3_COMPLETEDPOSIX', -1 }, { 'H3OPT_MASKS', 4 }, { 'H3OPT_WEAPS', 1 }, { 'H3OPT_VEHS', 3 } }
	local CAH_AGGRESS_PRESET_ID_DMND = { { 'CAS_HEIST_FLOW', -1 }, { 'H3_LAST_APPROACH', 0 }, { 'H3OPT_APPROACH', 3 }, { 'H3_HARD_APPROACH', 0 },
                                      { 'H3OPT_TARGET', 3 }, { 'H3OPT_POI', 1023 }, { 'H3OPT_ACCESSPOINTS', 2047 }, { 'H3OPT_CREWWEAP', 4 },
                                      { 'H3OPT_CREWDRIVER', 3 }, { 'H3OPT_CREWHACKER', 4 }, { 'H3OPT_DISRUPTSHIP', 3 }, { 'H3OPT_BODYARMORLVL', -1 },
                                      { 'H3OPT_KEYLEVELS', 2 }, { 'H3OPT_BITSET1', 799 }, { 'H3OPT_BITSET0', 3670102 } }
	CAH_DIA_TARGET:add_action('气势汹汹 (钻石,请选择低级买家)', function()
		for i = 1, #RunOnce do
			stat_set_int(RunOnce[i][1], true, RunOnce[i][2])
		end
		for i = 1, #CAH_AGGRESS_PRESET_ID_DMND do
			stat_set_int(CAH_AGGRESS_PRESET_ID_DMND[i][1], true, CAH_AGGRESS_PRESET_ID_DMND[i][2])
		end
		globals.set_int(1966739 + 2326, 60) -- [Diamond] 60% Low | 57 Medium | High 54
		globals.set_int(1966739 + 2326 + 1, 147) -- Low Buyer: 147 | Medium: 140 | High Buyer: 133
		globals.set_int(1966739 + 2326 + 2, 147)
		globals.set_int(1966739 + 2326 + 3, 147)
		globals.set_int(262145 + 28472, 1410065408) -- Diamond
	end)
end
do
	local RunOnce = { { 'H3_COMPLETEDPOSIX', -1 }, { 'H3OPT_MASKS', 4 }, { 'H3OPT_WEAPS', 1 }, { 'H3OPT_VEHS', 3 } }
	local CAH_SILENT_GOLD_PRESET = { { 'CAS_HEIST_FLOW', -1 }, { 'H3_LAST_APPROACH', 0 }, { 'H3OPT_APPROACH', 1 }, { 'H3_HARD_APPROACH', 0 },
                                  { 'H3OPT_TARGET', 1 }, { 'H3OPT_POI', 1023 }, { 'H3OPT_ACCESSPOINTS', 2047 }, { 'H3OPT_CREWWEAP', 4 },
                                  { 'H3OPT_CREWDRIVER', 3 }, { 'H3OPT_CREWHACKER', 4 }, { 'H3OPT_DISRUPTSHIP', 3 }, { 'H3OPT_BODYARMORLVL', -1 },
                                  { 'H3OPT_KEYLEVELS', 2 }, { 'H3OPT_BITSET1', 127 }, { 'H3OPT_BITSET0', 262270 } }
	CAH_GOLD_TARGET:add_action('隐迹潜踪 (黄金,请选择低级买家)', function()
		for i = 1, #RunOnce do
			stat_set_int(RunOnce[i][1], true, RunOnce[i][2])
		end
		for i = 1, #CAH_SILENT_GOLD_PRESET do
			stat_set_int(CAH_SILENT_GOLD_PRESET[i][1], true, CAH_SILENT_GOLD_PRESET[i][2])
		end
		globals.set_int(1966739 + 2326, 60) -- [Gold] 60% Low | 57 Medium | High 54
		globals.set_int(1966739 + 2326 + 1, 178) -- -- [Gold] 178% Low | 169 Medium | 161 High
		globals.set_int(1966739 + 2326 + 2, 178)
		globals.set_int(1966739 + 2326 + 3, 178)
		globals.set_int(262145 + 28471, 1410065408) -- Gold
	end)
end
do
	local RunOnce = { { 'H3_COMPLETEDPOSIX', -1 }, { 'H3OPT_MASKS', 4 }, { 'H3OPT_WEAPS', 1 }, { 'H3OPT_VEHS', 3 } }
	local CAH_BIGCON_GOLD_PRESET = { { 'CAS_HEIST_FLOW', -1 }, { 'H3_LAST_APPROACH', 0 }, { 'H3OPT_APPROACH', 2 }, { 'H3_HARD_APPROACH', 0 },
                                  { 'H3OPT_TARGET', 1 }, { 'H3OPT_POI', 1023 }, { 'H3OPT_ACCESSPOINTS', 2047 }, { 'H3OPT_CREWWEAP', 4 },
                                  { 'H3OPT_CREWDRIVER', 3 }, { 'H3OPT_CREWHACKER', 4 }, { 'H3OPT_DISRUPTSHIP', 3 }, { 'H3OPT_BODYARMORLVL', -1 },
                                  { 'H3OPT_KEYLEVELS', 2 }, { 'H3OPT_BITSET1', 159 }, { 'H3OPT_BITSET0', 524118 } }
	CAH_GOLD_TARGET:add_action('兵不厌诈 (黄金,请选择低级买家)', function()
		for i = 1, #RunOnce do
			stat_set_int(RunOnce[i][1], true, RunOnce[i][2])
		end
		for i = 1, #CAH_BIGCON_GOLD_PRESET do
			stat_set_int(CAH_BIGCON_GOLD_PRESET[i][1], true, CAH_BIGCON_GOLD_PRESET[i][2])
		end
		globals.set_int(1966739 + 2326, 60) -- [Gold] 60% Low | 57 Medium | High 54
		globals.set_int(1966739 + 2326 + 1, 178) -- [Gold] 178% Low | 169 Medium | 161 High
		globals.set_int(1966739 + 2326 + 2, 178)
		globals.set_int(1966739 + 2326 + 3, 178)
		globals.set_int(262145 + 28471, 1410065408) -- Gold
	end)
end
do
	local RunOnce = { { 'H3_COMPLETEDPOSIX', -1 }, { 'H3OPT_MASKS', 4 }, { 'H3OPT_WEAPS', 1 }, { 'H3OPT_VEHS', 3 } }
	local CAH_AGGRESSIV_GOLD_PRESET = { { 'CAS_HEIST_FLOW', -1 }, { 'H3OPT_APPROACH', 3 }, { 'H3OPT_TARGET', 1 }, { 'H3OPT_POI', 1023 },
                                     { 'H3OPT_ACCESSPOINTS', 2047 }, { 'H3OPT_DISRUPTSHIP', 3 }, { 'H3OPT_BODYARMORLVL', -1 },
                                     { 'H3OPT_KEYLEVELS', 2 }, { 'H3OPT_CREWWEAP', 4 }, { 'H3OPT_CREWDRIVER', 3 }, { 'H3OPT_CREWHACKER', 4 },
                                     { 'H3OPT_BITSET1', 799 }, { 'H3OPT_BITSET0', 3670102 }, { 'H3_LAST_APPROACH', 0 }, { 'H3_HARD_APPROACH', 0 } }
	CAH_GOLD_TARGET:add_action('气势汹汹 (黄金,请选择低级买家)', function()
		for i = 1, #RunOnce do
			stat_set_int(RunOnce[i][1], true, RunOnce[i][2])
		end
		for i = 1, #CAH_AGGRESSIV_GOLD_PRESET do
			stat_set_int(CAH_AGGRESSIV_GOLD_PRESET[i][1], true, CAH_AGGRESSIV_GOLD_PRESET[i][2])
		end
		globals.set_int(1966739 + 2326, 60) -- [Gold] 60% Low | 57 Medium | High 54
		globals.set_int(1966739 + 2326 + 1, 178) -- [Gold] 178% Low | 169 Medium | 161 High
		globals.set_int(1966739 + 2326 + 2, 178)
		globals.set_int(1966739 + 2326 + 3, 178)
		globals.set_int(262145 + 28471, 1410065408) -- Gold
	end)
end
do
	local CH_UNLCK_PT = { { 'H3OPT_POI', -1 }, { 'H3OPT_ACCESSPOINTS', -1 } }
	CASINO_BOARD1:add_action('解锁全部出入口和兴趣点', function()
		for i = 1, #CH_UNLCK_PT do
			stat_set_int(CH_UNLCK_PT[i][1], true, CH_UNLCK_PT[i][2])
		end
	end)
end
do
	local CH_Target_Diamond = { { 'H3OPT_TARGET', 3 } }
	CASINO_TARGET:add_action('钻石', function()
		for i = 1, #CH_Target_Diamond do
			stat_set_int(CH_Target_Diamond[i][1], true, CH_Target_Diamond[i][2])
		end
	end)
end
do
	local CH_Target_Gold = { { 'H3OPT_TARGET', 1 } }
	CASINO_TARGET:add_action('黄金', function()
		for i = 1, #CH_Target_Gold do
			stat_set_int(CH_Target_Gold[i][1], true, CH_Target_Gold[i][2])
		end
	end)
end
do
	local CH_Target_Artwork = { { 'H3OPT_TARGET', 2 } }
	CASINO_TARGET:add_action('艺术品', function()
		for i = 1, #CH_Target_Artwork do
			stat_set_int(CH_Target_Artwork[i][1], true, CH_Target_Artwork[i][2])
		end
	end)
end
do
	local CH_Target_Cash = { { 'H3OPT_TARGET', 0 } }
	CASINO_TARGET:add_action('现金', function()
		for i = 1, #CH_Target_Cash do
			stat_set_int(CH_Target_Cash[i][1], true, CH_Target_Cash[i][2])
		end
	end)
end
---- CASINO ADVANCED
local CAH_PLAYER_CUT = CAH_ADVCED:add_submenu('玩家分红')
do
	local CAH_NON_HOSTCUT = CAH_PLAYER_CUT:add_submenu('你的分红 (不是房主是使用)')
	-- [unuseable]需要用户输入
	-- CAH_NON_HOSTCUT:add_action("自定义分红", function(cahnon)
	--	 local r, s = input.get("It is not recommended to use such high values", "", 1000, 3)
	--	 if r == 1 then
	--		 return HANDLER_CONTINUE
	--	 end
	--	 if r == 2 then
	--		 return HANDLER_POP
	--	 end
	--	 globals.set_int(2715551 + 6546, tonumber(s))
	-- end)
	CAH_NON_HOSTCUT:add_action('0 %', function()
		globals.set_int(2715551 + 6546, 0)
	end)
	CAH_NON_HOSTCUT:add_action('50 %', function()
		globals.set_int(2715551 + 6546, 50)
	end)
	CAH_NON_HOSTCUT:add_action('85 %', function()
		globals.set_int(2715551 + 6546, 85)
	end)
	CAH_NON_HOSTCUT:add_action('100 %', function()
		globals.set_int(2715551 + 6546, 100)
	end)
	CAH_NON_HOSTCUT:add_action('125 %', function()
		globals.set_int(2715551 + 6546, 125)
	end)
	CAH_NON_HOSTCUT:add_action('150 %', function()
		globals.set_int(2715551 + 6546, 150)
	end)
	CAH_NON_HOSTCUT:add_action('200 %', function()
		globals.set_int(2715551 + 6546, 200)
	end)
end
do
	local CAH_PLAYER_HOST = CAH_PLAYER_CUT:add_submenu('你的分红 (作为房主时使用)')
	-- [unuseable]需要用户输入
	-- CAH_PLAYER_HOST:add_action("自定义分红", function(cahhost)
	--	 local r, s = input.get("It is not recommended to use such high values", "", 1000, 3)
	--	 if r == 1 then
	--		 return HANDLER_CONTINUE
	--	 end
	--	 if r == 2 then
	--		 return HANDLER_POP
	--	 end
	--	 globals.set_int(1966739 + 2326, tonumber(s))
	-- end)
	CAH_PLAYER_HOST:add_action('0 %', function()
		globals.set_int(1966739 + 2326, 0)
	end)
	CAH_PLAYER_HOST:add_action('35 %', function()
		globals.set_int(1966739 + 2326, 35)
	end)
	CAH_PLAYER_HOST:add_action('50 %', function()
		globals.set_int(1966739 + 2326, 50)
	end)
	CAH_PLAYER_HOST:add_action('85 %', function()
		globals.set_int(1966739 + 2326, 85)
	end)
	CAH_PLAYER_HOST:add_action('100 %', function()
		globals.set_int(1966739 + 2326, 100)
	end)
	CAH_PLAYER_HOST:add_action('125 %', function()
		globals.set_int(1966739 + 2326, 125)
	end)
	CAH_PLAYER_HOST:add_action('150 %', function()
		globals.set_int(1966739 + 2326, 150)
	end)
	local CAH_PLAYER_TWO = CAH_PLAYER_CUT:add_submenu('玩家 2 分红')
	-- [unuseable]需要用户输入
	-- CAH_PLAYER_TWO:add_action("自定义分红", function(cah2)
	--	 local r, s = input.get("It is not recommended to use such high values", "", 1000, 3)
	--	 if r == 1 then
	--		 return HANDLER_CONTINUE
	--	 end
	--	 if r == 2 then
	--		 return HANDLER_POP
	--	 end
	--	 globals.set_int(1966739 + 2326 + 1, tonumber(s))
	-- end)
	CAH_PLAYER_TWO:add_action('0 %', function()
		globals.set_int(1966739 + 2326 + 1, 0)
	end)
	CAH_PLAYER_TWO:add_action('50 %', function()
		globals.set_int(1966739 + 2326 + 1, 50)
	end)
	CAH_PLAYER_TWO:add_action('85 %', function()
		globals.set_int(1966739 + 2326 + 1, 85)
	end)
	CAH_PLAYER_TWO:add_action('100 %', function()
		globals.set_int(1966739 + 2326 + 1, 100)
	end)
	CAH_PLAYER_TWO:add_action('125 %', function()
		globals.set_int(1966739 + 2326 + 1, 125)
	end)
	CAH_PLAYER_TWO:add_action('150 %', function()
		globals.set_int(1966739 + 2326 + 1, 150)
	end)
	local CAH_PLAYER_THREE = CAH_PLAYER_CUT:add_submenu('玩家 3 分红')
	-- [unuseable]需要用户输入
	-- CAH_PLAYER_THREE:add_action("自定义分红", function(cah3)
	--	 local r, s = input.get("It is not recommended to use such high values", "", 1000, 3)
	--	 if r == 1 then
	--		 return HANDLER_CONTINUE
	--	 end
	--	 if r == 2 then
	--		 return HANDLER_POP
	--	 end
	--	 globals.set_int(1966739 + 2326 + 2, tonumber(s))
	-- end)
	CAH_PLAYER_THREE:add_action('0 %', function()
		globals.set_int(1966739 + 2326 + 2, 0)
	end)
	CAH_PLAYER_THREE:add_action('50 %', function()
		globals.set_int(1966739 + 2326 + 2, 50)
	end)
	CAH_PLAYER_THREE:add_action('85 %', function()
		globals.set_int(1966739 + 2326 + 2, 85)
	end)
	CAH_PLAYER_THREE:add_action('100 %', function()
		globals.set_int(1966739 + 2326 + 2, 100)
	end)
	CAH_PLAYER_THREE:add_action('125 %', function()
		globals.set_int(1966739 + 2326 + 2, 125)
	end)
	CAH_PLAYER_THREE:add_action('150 %', function()
		globals.set_int(1966739 + 2326 + 2, 150)
	end)
	local CAH_PLAYER_FOUR = CAH_PLAYER_CUT:add_submenu('玩家 4 分红')
	-- [unuseable]需要用户输入
	-- CAH_PLAYER_FOUR:add_action("自定义分红", function(cah4)
	--	 local r, s = input.get("It is not recommended to use such high values", "", 1000, 3)
	--	 if r == 1 then
	--		 return HANDLER_CONTINUE
	--	 end
	--	 if r == 2 then
	--		 return HANDLER_POP
	--	 end
	--	 globals.set_int(1966739 + 2326 + 3, tonumber(s))
	-- end)
	CAH_PLAYER_FOUR:add_action('0 %', function()
		globals.set_int(1966739 + 2326 + 3, 0)
	end)
	CAH_PLAYER_FOUR:add_action('50 %', function()
		globals.set_int(1966739 + 2326 + 3, 50)
	end)
	CAH_PLAYER_FOUR:add_action('85 %', function()
		globals.set_int(1966739 + 2326 + 3, 85)
	end)
	CAH_PLAYER_FOUR:add_action('100 %', function()
		globals.set_int(1966739 + 2326 + 3, 100)
	end)
	CAH_PLAYER_FOUR:add_action('125 %', function()
		globals.set_int(1966739 + 2326 + 3, 125)
	end)
	CAH_PLAYER_FOUR:add_action('150 %', function()
		globals.set_int(1966739 + 2326 + 3, 150)
	end)
end
--- CASINO DIFFICULTY
do
	local CH_Diff_Hard1 = { { 'H3_LAST_APPROACH', 0 }, { 'H3OPT_APPROACH', 1 }, { 'H3_HARD_APPROACH', 1 } }
	BOARD1_APPROACH:add_action('隐迹潜踪 : 困难模式', function()
		for i = 1, #CH_Diff_Hard1 do
			stat_set_int(CH_Diff_Hard1[i][1], true, CH_Diff_Hard1[i][2])
		end
	end)
end
do
	local CH_Diff_Normal1 = { { 'H3_LAST_APPROACH', 0 }, { 'H3OPT_APPROACH', 1 }, { 'H3_HARD_APPROACH', 0 } }
	BOARD1_APPROACH:add_action('隐迹潜踪 : 正常模式', function()
		for i = 1, #CH_Diff_Normal1 do
			stat_set_int(CH_Diff_Normal1[i][1], true, CH_Diff_Normal1[i][2])
		end
	end)
end
do
	local CH_Diff_Hard2 = { { 'H3_LAST_APPROACH', 0 }, { 'H3OPT_APPROACH', 2 }, { 'H3_HARD_APPROACH', 2 } }
	BOARD1_APPROACH:add_action('兵不厌诈 : 困难模式', function()
		for i = 1, #CH_Diff_Hard2 do
			stat_set_int(CH_Diff_Hard2[i][1], true, CH_Diff_Hard2[i][2])
		end
	end)
end
do
	local CH_Diff_Normal2 = { { 'H3_LAST_APPROACH', 0 }, { 'H3OPT_APPROACH', 2 }, { 'H3_HARD_APPROACH', 0 } }
	BOARD1_APPROACH:add_action('兵不厌诈 : 正常模式', function()
		for i = 1, #CH_Diff_Normal2 do
			stat_set_int(CH_Diff_Normal2[i][1], true, CH_Diff_Normal2[i][2])
		end
	end)
end
do
	local CH_Diff_Hard3 = { { 'H3_LAST_APPROACH', 0 }, { 'H3OPT_APPROACH', 3 }, { 'H3_HARD_APPROACH', 0 } }
	BOARD1_APPROACH:add_action('气势汹汹 : 困难模式', function()
		for i = 1, #CH_Diff_Hard3 do
			stat_set_int(CH_Diff_Hard3[i][1], true, CH_Diff_Hard3[i][2])
		end
	end)
end
do
	local CH_Diff_Normal3 = { { 'H3_LAST_APPROACH', 0 }, { 'H3OPT_APPROACH', 3 }, { 'H3_HARD_APPROACH', 0 } }
	BOARD1_APPROACH:add_action('气势汹汹 : 正常模式', function()
		for i = 1, #CH_Diff_Normal3 do
			stat_set_int(CH_Diff_Normal3[i][1], true, CH_Diff_Normal3[i][2])
		end
	end)
end
local CASINO_GUNMAN = CASINO_BOARD2:add_submenu('选择枪手')
do
	local CH_GUNMAN_05 = { { 'H3OPT_CREWWEAP', 4 } }
	CASINO_GUNMAN:add_action('切斯特·麦考伊 (10%)', function()
		for i = 1, #CH_GUNMAN_05 do
			stat_set_int(CH_GUNMAN_05[i][1], true, CH_GUNMAN_05[i][2])
		end
	end)
end
do
	local CH_GUNMAN_04 = { { 'H3OPT_CREWWEAP', 2 } }
	CASINO_GUNMAN:add_action('古斯塔沃·莫塔 (9%)', function()
		for i = 1, #CH_GUNMAN_04 do
			stat_set_int(CH_GUNMAN_04[i][1], true, CH_GUNMAN_04[i][2])
		end
	end)
end
do
	local CH_GUNMAN_03 = { { 'H3OPT_CREWWEAP', 5 } }
	CASINO_GUNMAN:add_action('派奇·麦克瑞利 (8%)', function()
		for i = 1, #CH_GUNMAN_03 do
			stat_set_int(CH_GUNMAN_03[i][1], true, CH_GUNMAN_03[i][2])
		end
	end)
end
do
	local CH_GUNMAN_02 = { { 'H3OPT_CREWWEAP', 3 } }
	CASINO_GUNMAN:add_action('查理·里德 (7%)', function()
		for i = 1, #CH_GUNMAN_02 do
			stat_set_int(CH_GUNMAN_02[i][1], true, CH_GUNMAN_02[i][2])
		end
	end)
end
do
	local CH_GUNMAN_01 = { { 'H3OPT_CREWWEAP', 1 } }
	CASINO_GUNMAN:add_action('卡尔·阿卜拉季 (5%)', function()
		for i = 1, #CH_GUNMAN_01 do
			stat_set_int(CH_GUNMAN_01[i][1], true, CH_GUNMAN_01[i][2])
		end
	end)
end
do
	local CH_GUNMAN_RND = { { 'H3OPT_CREWWEAP', 1, 5, 1, 5 } }
	CASINO_GUNMAN:add_action('随机枪手 (??%)', function()
		for i = 1, #CH_GUNMAN_RND do
			stat_set_int(CH_GUNMAN_RND[i][1], true, math.random(CH_GUNMAN_RND[i][4], CH_GUNMAN_RND[i][5]))
		end
	end)
end
do
	local CH_GUNMAN_00 = { { 'H3OPT_CREWWEAP', 6 } }
	CASINO_GUNMAN:add_action('移除枪手 (0%)', function()
		for i = 1, #CH_GUNMAN_00 do
			stat_set_int(CH_GUNMAN_00[i][1], true, CH_GUNMAN_00[i][2])
		end
	end)
end
local CASINO_GUNMAN_var = CASINO_GUNMAN:add_submenu('武器选择')
do
	local CH_Gunman_var_01 = { { 'H3OPT_WEAPS', 1 } }
	CASINO_GUNMAN_var:add_action('最佳武器选择', function()
		for i = 1, #CH_Gunman_var_01 do
			stat_set_int(CH_Gunman_var_01[i][1], true, CH_Gunman_var_01[i][2])
		end
	end)
end
do
	local CH_Gunman_var_00 = { { 'H3OPT_WEAPS', 0 } }
	CASINO_GUNMAN_var:add_action('最差武器选择', function()
		for i = 1, #CH_Gunman_var_00 do
			stat_set_int(CH_Gunman_var_00[i][1], true, CH_Gunman_var_00[i][2])
		end
	end)
end
local CASINO_DRIVER_TEAM = CASINO_BOARD2:add_submenu('选择车手')
do
	local CH_DRV_MAN_05 = { { 'H3OPT_CREWDRIVER', 5 } }
	CASINO_DRIVER_TEAM:add_action('切斯特·麦考伊 (10%)', function()
		for i = 1, #CH_DRV_MAN_05 do
			stat_set_int(CH_DRV_MAN_05[i][1], true, CH_DRV_MAN_05[i][2])
		end
	end)
end
do
	local CH_DRV_MAN_04 = { { 'H3OPT_CREWDRIVER', 3 } }
	CASINO_DRIVER_TEAM:add_action('陶艾迪 (9%)', function()
		for i = 1, #CH_DRV_MAN_04 do
			stat_set_int(CH_DRV_MAN_04[i][1], true, CH_DRV_MAN_04[i][2])
		end
	end)
end
do
	local CH_DRV_MAN_03 = { { 'H3OPT_CREWDRIVER', 2 } }
	CASINO_DRIVER_TEAM:add_action('塔丽娜.马丁内斯 (7%)', function()
		for i = 1, #CH_DRV_MAN_03 do
			stat_set_int(CH_DRV_MAN_03[i][1], true, CH_DRV_MAN_03[i][2])
		end
	end)
end
do
	local CH_DRV_MAN_02 = { { 'H3OPT_CREWDRIVER', 4 } }
	CASINO_DRIVER_TEAM:add_action('扎克·尼尔森 (6%)', function()
		for i = 1, #CH_DRV_MAN_02 do
			stat_set_int(CH_DRV_MAN_02[i][1], true, CH_DRV_MAN_02[i][2])
		end
	end)
end
do
	local CH_DRV_MAN_01 = { { 'H3OPT_CREWDRIVER', 1 } }
	CASINO_DRIVER_TEAM:add_action('卡里姆·登茨 (5%)', function()
		for i = 1, #CH_DRV_MAN_01 do
			stat_set_int(CH_DRV_MAN_01[i][1], true, CH_DRV_MAN_01[i][2])
		end
	end)
end
do
	local CH_DRV_MAN_RND = { { 'H3OPT_CREWDRIVER', 1, 5, 1, 5 } }
	CASINO_DRIVER_TEAM:add_action('随机车手 (??%)', function()
		for i = 1, #CH_DRV_MAN_RND do
			stat_set_int(CH_DRV_MAN_RND[i][1], true, math.random(CH_DRV_MAN_RND[i][4], CH_DRV_MAN_RND[i][5]))
		end
	end)
end
do
	local CH_DRV_MAN_00 = { { 'H3OPT_CREWDRIVER', 6 } }
	CASINO_DRIVER_TEAM:add_action('移除车手 (0%)', function()
		for i = 1, #CH_DRV_MAN_00 do
			stat_set_int(CH_DRV_MAN_00[i][1], true, CH_DRV_MAN_00[i][2])
		end
	end)
end
local CAH_DRIVER_TEAM_var = CASINO_DRIVER_TEAM:add_submenu('载具选择')
do
	local CH_DRV_MAN_var_03 = { { 'H3OPT_VEHS', 3 } }
	CAH_DRIVER_TEAM_var:add_action('最佳载具选择', function()
		for i = 1, #CH_DRV_MAN_var_03 do
			stat_set_int(CH_DRV_MAN_var_03[i][1], true, CH_DRV_MAN_var_03[i][2])
		end
	end)
end
do
	local CH_DRV_MAN_var_02 = { { 'H3OPT_VEHS', 2 } }
	CAH_DRIVER_TEAM_var:add_action('较好载具选择', function()
		for i = 1, #CH_DRV_MAN_var_02 do
			stat_set_int(CH_DRV_MAN_var_02[i][1], true, CH_DRV_MAN_var_02[i][2])
		end
	end)
end
do
	local CH_DRV_MAN_var_01 = { { 'H3OPT_VEHS', 1 } }
	CAH_DRIVER_TEAM_var:add_action('较差载具选择', function()
		for i = 1, #CH_DRV_MAN_var_01 do
			stat_set_int(CH_DRV_MAN_var_01[i][1], true, CH_DRV_MAN_var_01[i][2])
		end
	end)
end
do
	local CH_DRV_MAN_var_00 = { { 'H3OPT_VEHS', 0 } }
	CAH_DRIVER_TEAM_var:add_action('最差载具选择', function()
		for i = 1, #CH_DRV_MAN_var_00 do
			stat_set_int(CH_DRV_MAN_var_00[i][1], true, CH_DRV_MAN_var_00[i][2])
		end
	end)
end
do
	local CH_DRV_MAN_var_RND = { { 'H3OPT_VEHS', 0, 3, 0, 3 } }
	CAH_DRIVER_TEAM_var:add_action('随机载具选择', function()
		for i = 1, #CH_DRV_MAN_var_RND do
			stat_set_int(CH_DRV_MAN_var_RND[i][1], true, math.random(CH_DRV_MAN_var_RND[i][4], CH_DRV_MAN_var_RND[i][5]))
		end
	end)
end
local CASINO_HACKERs = CASINO_BOARD2:add_submenu('选择黑客')
do
	local CH_HCK_MAN_04 = { { 'H3OPT_CREWHACKER', 4 } }
	CASINO_HACKERs:add_action('阿维·施瓦茨曼 (10%,210/146秒)', function()
		for i = 1, #CH_HCK_MAN_04 do
			stat_set_int(CH_HCK_MAN_04[i][1], true, CH_HCK_MAN_04[i][2])
		end
	end)
end
do
	local CH_HCK_MAN_05 = { { 'H3OPT_CREWHACKER', 5 } }
	CASINO_HACKERs:add_action('佩奇·哈里斯 (9%,205/143秒)', function()
		for i = 1, #CH_HCK_MAN_05 do
			stat_set_int(CH_HCK_MAN_05[i][1], true, CH_HCK_MAN_05[i][2])
		end
	end)
end
do
	local CH_HCK_MAN_03 = { { 'H3OPT_CREWHACKER', 2 } }
	CASINO_HACKERs:add_action('克里斯汀·费尔兹 (7%,179/125秒)', function()
		for i = 1, #CH_HCK_MAN_03 do
			stat_set_int(CH_HCK_MAN_03[i][1], true, CH_HCK_MAN_03[i][2])
		end
	end)
end
do
	local CH_HCK_MAN_02 = { { 'H3OPT_CREWHACKER', 3 } }
	CASINO_HACKERs:add_action('尤汗·布莱尔 (5%,172/121秒)', function()
		for i = 1, #CH_HCK_MAN_02 do
			stat_set_int(CH_HCK_MAN_02[i][1], true, CH_HCK_MAN_02[i][2])
		end
	end)
end
do
	local CH_HCK_MAN_01 = { { 'H3OPT_CREWHACKER', 1 } }
	CASINO_HACKERs:add_action('里奇·卢肯斯 (3%,146/102秒)', function()
		for i = 1, #CH_HCK_MAN_01 do
			stat_set_int(CH_HCK_MAN_01[i][1], true, CH_HCK_MAN_01[i][2])
		end
	end)
end
do
	local CH_HCK_MAN_RND = { { 'H3OPT_CREWHACKER', 0, 5, 1, 5 } }
	CASINO_HACKERs:add_action('随机黑客 (??%)', function()
		for i = 1, #CH_HCK_MAN_RND do
			stat_set_int(CH_HCK_MAN_RND[i][1], true, math.random(CH_HCK_MAN_RND[i][4], CH_HCK_MAN_RND[i][5]))
		end
	end)
end
do
	local CH_HCK_MAN_00 = { { 'H3OPT_CREWHACKER', 6 } }
	CASINO_HACKERs:add_action('移除黑客 (0%)', function()
		for i = 1, #CH_HCK_MAN_00 do
			stat_set_int(CH_HCK_MAN_00[i][1], true, CH_HCK_MAN_00[i][2])
		end
	end)
end
local CASINO_MASK = CASINO_BOARD2:add_submenu('选择面具')
do
	local CH_MASK_00 = { { 'H3OPT_MASKS', -1 } }
	CASINO_MASK:add_action('移除面具', function()
		for i = 1, #CH_MASK_00 do
			stat_set_int(CH_MASK_00[i][1], true, CH_MASK_00[i][2])
		end
	end)
end
do
	local CH_MASK_01 = { { 'H3OPT_MASKS', 1 } }
	CASINO_MASK:add_action('几何系列', function()
		for i = 1, #CH_MASK_01 do
			stat_set_int(CH_MASK_01[i][1], true, CH_MASK_01[i][2])
		end
	end)
end
do
	local CH_MASK_02 = { { 'H3OPT_MASKS', 2 } }
	CASINO_MASK:add_action('猎人系列', function()
		for i = 1, #CH_MASK_02 do
			stat_set_int(CH_MASK_02[i][1], true, CH_MASK_02[i][2])
		end
	end)
end
do
	local CH_MASK_03 = { { 'H3OPT_MASKS', 3 } }
	CASINO_MASK:add_action('半罩系列', function()
		for i = 1, #CH_MASK_03 do
			stat_set_int(CH_MASK_03[i][1], true, CH_MASK_03[i][2])
		end
	end)
end
do
	local CH_MASK_04 = { { 'H3OPT_MASKS', 4 } }
	CASINO_MASK:add_action('表情系列', function()
		for i = 1, #CH_MASK_04 do
			stat_set_int(CH_MASK_04[i][1], true, CH_MASK_04[i][2])
		end
	end)
end
do
	local CH_MASK_05 = { { 'H3OPT_MASKS', 5 } }
	CASINO_MASK:add_action('骷髅头系列', function()
		for i = 1, #CH_MASK_05 do
			stat_set_int(CH_MASK_05[i][1], true, CH_MASK_05[i][2])
		end
	end)
end
do
	local CH_MASK_06 = { { 'H3OPT_MASKS', 6 } }
	CASINO_MASK:add_action('幸运水果系列', function()
		for i = 1, #CH_MASK_06 do
			stat_set_int(CH_MASK_06[i][1], true, CH_MASK_06[i][2])
		end
	end)
end
do
	local CH_MASK_07 = { { 'H3OPT_MASKS', 7 } }
	CASINO_MASK:add_action('游击队系列', function()
		for i = 1, #CH_MASK_07 do
			stat_set_int(CH_MASK_07[i][1], true, CH_MASK_07[i][2])
		end
	end)
end
do
	local CH_MASK_08 = { { 'H3OPT_MASKS', 8 } }
	CASINO_MASK:add_action('小丑系列', function()
		for i = 1, #CH_MASK_08 do
			stat_set_int(CH_MASK_08[i][1], true, CH_MASK_08[i][2])
		end
	end)
end
do
	local CH_MASK_09 = { { 'H3OPT_MASKS', 9 } }
	CASINO_MASK:add_action('动物系列', function()
		for i = 1, #CH_MASK_09 do
			stat_set_int(CH_MASK_09[i][1], true, CH_MASK_09[i][2])
		end
	end)
end
do
	local CH_MASK_10 = { { 'H3OPT_MASKS', 10 } }
	CASINO_MASK:add_action('暴乱系列', function()
		for i = 1, #CH_MASK_10 do
			stat_set_int(CH_MASK_10[i][1], true, CH_MASK_10[i][2])
		end
	end)
end
do
	local CH_MASK_11 = { { 'H3OPT_MASKS', 11 } }
	CASINO_MASK:add_action('妖怪系列', function()
		for i = 1, #CH_MASK_11 do
			stat_set_int(CH_MASK_11[i][1], true, CH_MASK_11[i][2])
		end
	end)
end
do
	local CH_MASK_12 = { { 'H3OPT_MASKS', 12 } }
	CASINO_MASK:add_action('曲棍球系列', function()
		for i = 1, #CH_MASK_12 do
			stat_set_int(CH_MASK_12[i][1], true, CH_MASK_12[i][2])
		end
	end)
end
do
	local CH_DUGGAN = { { 'H3OPT_DISRUPTSHIP', 3 } }
	local CH_SCANC_LVL = { { 'H3OPT_KEYLEVELS', 2 } }
	CASINO_BOARD2:add_action('解锁二级门禁卡', function()
		for i = 1, #CH_SCANC_LVL do
			stat_set_int(CH_SCANC_LVL[i][1], true, CH_SCANC_LVL[i][2])
		end
	end)
	CASINO_BOARD2:add_action('杜根货物 (削弱杜根警卫)', function()
		for i = 1, #CH_DUGGAN do
			stat_set_int(CH_DUGGAN[i][1], true, CH_DUGGAN[i][2])
		end
	end)
end
do
	local CH_UNLCK_3stboard_var1 = { { 'H3OPT_BITSET0', -8849 } }
	local CH_UNLCK_3stboard_var3bc = { { 'H3OPT_BITSET0', -186 } }
	CASINO_BOARD3:add_action('移除电钻 (隐迹潜踪/气势汹汹)', function()
		for i = 1, #CH_UNLCK_3stboard_var1 do
			stat_set_int(CH_UNLCK_3stboard_var1[i][1], true, CH_UNLCK_3stboard_var1[i][2])
		end
	end)
	CASINO_BOARD3:add_action('移除电钻 (兵不厌诈)', function()
		for i = 1, #CH_UNLCK_3stboard_var3bc do
			stat_set_int(CH_UNLCK_3stboard_var3bc[i][1], true, CH_UNLCK_3stboard_var3bc[i][2])
		end
	end)
end
do
	local CH_LOAD_BOARD_var0 = { { 'H3OPT_BITSET1', -1 }, { 'H3OPT_BITSET0', -1 } }
	local CH_UNLOAD_BOARD_var1 = { { 'H3OPT_BITSET1', 0 }, { 'H3OPT_BITSET0', 0 } }
	CASINO_LBOARDS:add_action('加载全部计划版', function()
		for i = 1, #CH_LOAD_BOARD_var0 do
			stat_set_int(CH_LOAD_BOARD_var0[i][1], true, CH_LOAD_BOARD_var0[i][2])
		end
	end)
	CASINO_LBOARDS:add_action('卸载全部计划版', function()
		for i = 1, #CH_UNLOAD_BOARD_var1 do
			stat_set_int(CH_UNLOAD_BOARD_var1[i][1], true, CH_UNLOAD_BOARD_var1[i][2])
		end
	end)
end
do
	local CLD_CH_RMV = { { 'MPPLY_H3_COOLDOWN', 0xFFFFFFF }, { 'H3_COMPLETEDPOSIX', 0xFFFFFFF } }
	CASINO_MORE:add_action('移除抢劫准备冷却', function()
		for i = 1, #CLD_CH_RMV do
			stat_set_int(CLD_CH_RMV[i][1], true, CLD_CH_RMV[i][2])
			stat_set_int(CLD_CH_RMV[i][1], false, CLD_CH_RMV[i][2])
		end
	end)
end
do
	local CH_AWRD_BL = { { 'AWD_FIRST_TIME1', true }, { 'AWD_FIRST_TIME2', true }, { 'AWD_FIRST_TIME3', true }, { 'AWD_FIRST_TIME4', true },
                      { 'AWD_FIRST_TIME5', true }, { 'AWD_FIRST_TIME6', true }, { 'AWD_ALL_IN_ORDER', true }, { 'AWD_SUPPORTING_ROLE', true },
                      { 'AWD_LEADER', true }, { 'AWD_ODD_JOBS', true }, { 'AWD_SURVIVALIST', true }, { 'AWD_SCOPEOUT', true },
                      { 'AWD_CREWEDUP', true }, { 'AWD_MOVINGON', true }, { 'AWD_PROMOCAMP', true }, { 'AWD_GUNMAN', true },
                      { 'AWD_SMASHNGRAB', true }, { 'AWD_INPLAINSI', true }, { 'AWD_UNDETECTED', true }, { 'AWD_ALLROUND', true },
                      { 'AWD_ELITETHEIF', true }, { 'AWD_PRO', true }, { 'AWD_SUPPORTACT', true }, { 'AWD_SHAFTED', true }, { 'AWD_COLLECTOR', true },
                      { 'AWD_DEADEYE', true }, { 'AWD_PISTOLSATDAWN', true }, { 'AWD_TRAFFICAVOI', true }, { 'AWD_CANTCATCHBRA', true },
                      { 'AWD_WIZHARD', true }, { 'AWD_APEESCAPE', true }, { 'AWD_MONKEYKIND', true }, { 'AWD_AQUAAPE', true },
                      { 'AWD_KEEPFAITH', true }, { 'AWD_TRUELOVE', true }, { 'AWD_NEMESIS', true }, { 'AWD_FRIENDZONED', true },
                      { 'VCM_FLOW_CS_RSC_SEEN', true }, { 'VCM_FLOW_CS_BWL_SEEN', true }, { 'VCM_FLOW_CS_MTG_SEEN', true },
                      { 'VCM_FLOW_CS_OIL_SEEN', true }, { 'VCM_FLOW_CS_DEF_SEEN', true }, { 'VCM_FLOW_CS_FIN_SEEN', true },
                      { 'CAS_VEHICLE_REWARD', false }, { 'HELP_FURIA', true }, { 'HELP_MINITAN', true }, { 'HELP_YOSEMITE2', true },
                      { 'HELP_ZHABA', true }, { 'HELP_IMORGEN', true }, { 'HELP_SULTAN2', true }, { 'HELP_VAGRANT', true }, { 'HELP_VSTR', true },
                      { 'HELP_STRYDER', true }, { 'HELP_SUGOI', true }, { 'HELP_KANJO', true }, { 'HELP_FORMULA', true }, { 'HELP_FORMULA2', true },
                      { 'HELP_JB7002', true } }
	local CH_AWRD_IT = { { 'ARCADE_MAC_0', -1 }, { 'ARCADE_MAC_1', -1 }, { 'ARCADE_MAC_2', -1 }, { 'ARCADE_MAC_3', -1 }, { 'ARCADE_MAC_4', -1 },
                      { 'ARCADE_MAC_5', -1 }, { 'ARCADE_MAC_6', -1 }, { 'ARCADE_MAC_7', -1 }, { 'ARCADE_MAC_8', -1 }, { 'ARCADE_MAC_9', -1 },
                      { 'ARCADE_MAC_10', -1 }, { 'ARCADE_MAC_11', -1 }, { 'ARCADE_MAC_12', -1 }, { 'ARCADE_MAC_13', -1 }, { 'ARCADE_MAC_14', -1 },
                      { 'ARCADE_MAC_15', -1 }, { 'CAS_HEIST_NOTS', -1 }, { 'CAS_HEIST_FLOW', -1 }, { 'CH_ARC_CAB_CLAW_TROPHY', -1 },
                      { 'CH_ARC_CAB_LOVE_TROPHY', -1 }, { 'SIGNAL_JAMMERS_COLLECTED', 50 }, { 'AWD_ODD_JOBS', 52 }, { 'AWD_PREPARATION', 40 },
                      { 'AWD_ASLEEPONJOB', 20 }, { 'AWD_DAICASHCRAB', 100000 }, { 'AWD_BIGBRO', 40 }, { 'AWD_SHARPSHOOTER', 40 },
                      { 'AWD_RACECHAMP', 40 }, { 'AWD_BATSWORD', 1000000 }, { 'AWD_COINPURSE', 950000 }, { 'AWD_ASTROCHIMP', 3000000 },
                      { 'AWD_MASTERFUL', 40000 }, { 'H3_BOARD_DIALOGUE0', -1 }, { 'H3_BOARD_DIALOGUE1', -1 }, { 'H3_BOARD_DIALOGUE2', -1 },
                      { 'H3_VEHICLESUSED', -1 }, { 'H3_CR_STEALTH_1A', 100 }, { 'H3_CR_STEALTH_2B_RAPP', 100 }, { 'H3_CR_STEALTH_2C_SIDE', 100 },
                      { 'H3_CR_STEALTH_3A', 100 }, { 'H3_CR_STEALTH_4A', 100 }, { 'H3_CR_STEALTH_5A', 100 }, { 'H3_CR_SUBTERFUGE_1A', 100 },
                      { 'H3_CR_SUBTERFUGE_2A', 100 }, { 'H3_CR_SUBTERFUGE_2B', 100 }, { 'H3_CR_SUBTERFUGE_3A', 100 }, { 'H3_CR_SUBTERFUGE_3B', 100 },
                      { 'H3_CR_SUBTERFUGE_4A', 100 }, { 'H3_CR_SUBTERFUGE_5A', 100 }, { 'H3_CR_DIRECT_1A', 100 }, { 'H3_CR_DIRECT_2A1', 100 },
                      { 'H3_CR_DIRECT_2A2', 100 }, { 'H3_CR_DIRECT_2BP', 100 }, { 'H3_CR_DIRECT_2C', 100 }, { 'H3_CR_DIRECT_3A', 100 },
                      { 'H3_CR_DIRECT_4A', 100 }, { 'H3_CR_DIRECT_5A', 100 }, { 'CR_ORDER', 100 } }
	CASINO_MORE:add_action('解锁游戏厅奖章和赌场抢劫奖励', function()
		for i = 1, #CH_AWRD_IT do
			stat_set_int(CH_AWRD_IT[i][1], true, CH_AWRD_IT[i][2])
		end
		for i = 1, #CH_AWRD_BL do
			stat_set_bool(CH_AWRD_BL[i][1], true, CH_AWRD_BL[i][2])
		end
		for i = 0, 128, 1 do -- 28483 - 28355 = 128
			hash = CharID .. '_HEIST3TATTOOSTAT_BOOL'
			stats.set_bool_masked(hash, true, i)
		end
		for i = 0, 256, 1 do -- 28354 - 28098 = 256
			hash = CharID .. '_CASINOHSTPSTAT_BOOL'
			stats.set_bool_masked(hash, true, i)
		end
		for i = 0, 448, 1 do -- 27258 - 26810 = 448
			hash = CharID .. '_CASINOPSTAT_BOOL'
			stats.set_bool_masked(hash, true, i)
		end
	end)
end
do
	local AGATHA_MS_INT = { { 'VCM_FLOW_PROGRESS', -1 }, { 'VCM_STORY_PROGRESS', 5 } }
	local AGATHA_MS_BOL = { { 'AWD_LEADER', true }, { 'VCM_FLOW_CS_FIN_SEEN', true } }
	CASINO_MORE:add_action('跳过贝克女士任务至最后一个', function()
		for i = 1, #AGATHA_MS_INT do
			stat_set_int(AGATHA_MS_INT[i][1], true, AGATHA_MS_INT[i][2])
		end
		for i = 2, #AGATHA_MS_BOL do
			stat_set_bool(AGATHA_MS_BOL[i][1], true, AGATHA_MS_BOL[i][2])
		end
	end)
end
do
	local CH_RST = { { 'H3_LAST_APPROACH', 0 }, { 'H3OPT_APPROACH', 0 }, { 'H3_HARD_APPROACH', 0 }, { 'H3OPT_TARGET', 0 }, { 'H3OPT_POI', 0 },
                  { 'H3OPT_ACCESSPOINTS', 0 }, { 'H3OPT_BITSET1', 0 }, { 'H3OPT_CREWWEAP', 0 }, { 'H3OPT_CREWDRIVER', 0 }, { 'H3OPT_CREWHACKER', 0 },
                  { 'H3OPT_WEAPS', 0 }, { 'H3OPT_VEHS', 0 }, { 'H3OPT_DISRUPTSHIP', 0 }, { 'H3OPT_BODYARMORLVL', 0 }, { 'H3OPT_KEYLEVELS', 0 },
                  { 'H3OPT_MASKS', 0 }, { 'H3OPT_BITSET0', 0 } }
	CASINO_MORE:add_action('重置抢劫', function()
		for i = 1, #CH_RST do
			stat_set_int(CH_RST[i][1], true, CH_RST[i][2])
		end
	end)
end
-------- DOOMSDAY HEIST
do
	local DD_H_ACT1 = { { 'GANGOPS_FLOW_MISSION_PROG', 503 }, { 'GANGOPS_HEIST_STATUS', -229383 }, { 'GANGOPS_FLOW_NOTIFICATIONS', 1557 } }
	DOOMS_PRESETS:add_action('末日一 : 数据泄露 $250w 1-4 人', function()
		for i = 1, #DD_H_ACT1 do
			stat_set_int(DD_H_ACT1[i][1], true, DD_H_ACT1[i][2])
		end
		globals.set_int(1962763 + 812 + 50 + 1, 313)
		globals.set_int(1962763 + 812 + 50 + 2, 313)
		globals.set_int(1962763 + 812 + 50 + 3, 313)
		globals.set_int(1962763 + 812 + 50 + 4, 313)
	end)
end
do
	local DD_H_ACT2 = { { 'GANGOPS_FLOW_MISSION_PROG', 240 }, { 'GANGOPS_HEIST_STATUS', -229378 }, { 'GANGOPS_FLOW_NOTIFICATIONS', 1557 } }
	DOOMS_PRESETS:add_action('末日二 : 波格丹危机 $250w 1-4 人', function()
		for i = 1, #DD_H_ACT2 do
			stat_set_int(DD_H_ACT2[i][1], true, DD_H_ACT2[i][2])
		end
		globals.set_int(1962763 + 812 + 50 + 1, 214)
		globals.set_int(1962763 + 812 + 50 + 2, 214)
		globals.set_int(1962763 + 812 + 50 + 3, 214)
		globals.set_int(1962763 + 812 + 50 + 4, 214)
	end)
end
do
	local DD_H_ACT3 = { { 'GANGOPS_FLOW_MISSION_PROG', 16368 }, { 'GANGOPS_HEIST_STATUS', -229380 }, { 'GANGOPS_FLOW_NOTIFICATIONS', 1557 } }
	DOOMS_PRESETS:add_action('末日三 : 末日将至 $250w 1-4 人', function()
		for i = 1, #DD_H_ACT3 do
			stat_set_int(DD_H_ACT3[i][1], true, DD_H_ACT3[i][2])
		end
		globals.set_int(1962763 + 812 + 50 + 1, 170)
		globals.set_int(1962763 + 812 + 50 + 2, 170)
		globals.set_int(1962763 + 812 + 50 + 3, 170)
		globals.set_int(1962763 + 812 + 50 + 4, 170)
	end)
end
do
	local DDHEIST_HOST_MANAGER = DDHEIST_PLYR_MANAGER:add_submenu('玩家 1 分红')
	-- [unuseable]需要用户输入
	-- DDHEIST_HOST_MANAGER:add_action("自定义分红", function(domhost)
	-- 	local r, s = input.get("It is not recommended to use such high values", "", 1000, 3)
	-- 	if r == 1 then
	-- 		return HANDLER_CONTINUE
	-- 	end
	-- 	if r == 2 then
	-- 		return HANDLER_POP
	-- 	end
	-- 	globals.set_int(1962763 + 812 + 50 + 1, tonumber(s))
	-- end)
	DDHEIST_HOST_MANAGER:add_action('0%', function()
		globals.set_int(1962763 + 812 + 50 + 1, 0)
	end)
	DDHEIST_HOST_MANAGER:add_action('50%', function()
		globals.set_int(1962763 + 812 + 50 + 1, 50)
	end)
	DDHEIST_HOST_MANAGER:add_action('85%', function()
		globals.set_int(1962763 + 812 + 50 + 1, 85)
	end)
	DDHEIST_HOST_MANAGER:add_action('100%', function()
		globals.set_int(1962763 + 812 + 50 + 1, 100)
	end)
	DDHEIST_HOST_MANAGER:add_action('150%', function()
		globals.set_int(1962763 + 812 + 50 + 1, 150)
	end)
	DDHEIST_HOST_MANAGER:add_action('175%', function()
		globals.set_int(1962763 + 812 + 50 + 1, 175)
	end)
	DDHEIST_HOST_MANAGER:add_action('205%', function()
		globals.set_int(1962763 + 812 + 50 + 1, 205)
	end)
end
do
	local DDHEIST_PLAYER2_MANAGER = DDHEIST_PLYR_MANAGER:add_submenu('玩家 2 分红')
	-- [unuseable]需要用户输入
	-- DDHEIST_PLAYER2_MANAGER:add_action("自定义分红", function(dom2)
	-- 	local r, s = input.get("It is not recommended to use such high values", "", 1000, 3)
	-- 	if r == 1 then
	-- 		return HANDLER_CONTINUE
	-- 	end
	-- 	if r == 2 then
	-- 		return HANDLER_POP
	-- 	end
	-- 	globals.set_int(1962763 + 812 + 50 + 2, tonumber(s))
	-- end)
	DDHEIST_PLAYER2_MANAGER:add_action('0%', function()
		globals.set_int(1962763 + 812 + 50 + 2, 0)
	end)
	DDHEIST_PLAYER2_MANAGER:add_action('50%', function()
		globals.set_int(1962763 + 812 + 50 + 2, 50)
	end)
	DDHEIST_PLAYER2_MANAGER:add_action('85%', function()
		globals.set_int(1962763 + 812 + 50 + 2, 85)
	end)
	DDHEIST_PLAYER2_MANAGER:add_action('100%', function()
		globals.set_int(1962763 + 812 + 50 + 2, 100)
	end)
	DDHEIST_PLAYER2_MANAGER:add_action('150%', function()
		globals.set_int(1962763 + 812 + 50 + 2, 150)
	end)
	DDHEIST_PLAYER2_MANAGER:add_action('175%', function()
		globals.set_int(1962763 + 812 + 50 + 2, 175)
	end)
	DDHEIST_PLAYER2_MANAGER:add_action('200%', function()
		globals.set_int(1962763 + 812 + 50 + 2, 200)
	end)
	DDHEIST_PLAYER2_MANAGER:add_action('205%', function()
		globals.set_int(1962763 + 812 + 50 + 2, 205)
	end)
end
do
	local DDHEIST_PLAYER3_MANAGER = DDHEIST_PLYR_MANAGER:add_submenu('玩家 3 分红')
	-- [unuseable]需要用户输入
	-- DDHEIST_PLAYER3_MANAGER:add_action("自定义分红", function(dom3)
	-- 	local r, s = input.get("It is not recommended to use such high values", "", 1000, 3)
	-- 	if r == 1 then
	-- 		return HANDLER_CONTINUE
	-- 	end
	-- 	if r == 2 then
	-- 		return HANDLER_POP
	-- 	end
	-- 	globals.set_int(1962763 + 812 + 50 + 3, tonumber(s))
	-- end)
	DDHEIST_PLAYER3_MANAGER:add_action('0%', function()
		globals.set_int(1962763 + 812 + 50 + 3, 0)
	end)
	DDHEIST_PLAYER3_MANAGER:add_action('50%', function()
		globals.set_int(1962763 + 812 + 50 + 3, 50)
	end)
	DDHEIST_PLAYER3_MANAGER:add_action('85%', function()
		globals.set_int(1962763 + 812 + 50 + 3, 85)
	end)
	DDHEIST_PLAYER3_MANAGER:add_action('100%', function()
		globals.set_int(1962763 + 812 + 50 + 3, 100)
	end)
	DDHEIST_PLAYER3_MANAGER:add_action('150%', function()
		globals.set_int(1962763 + 812 + 50 + 3, 150)
	end)
	DDHEIST_PLAYER3_MANAGER:add_action('175%', function()
		globals.set_int(1962763 + 812 + 50 + 3, 175)
	end)
	DDHEIST_PLAYER3_MANAGER:add_action('200%', function()
		globals.set_int(1962763 + 812 + 50 + 3, 200)
	end)
	DDHEIST_PLAYER3_MANAGER:add_action('205%', function()
		globals.set_int(1962763 + 812 + 50 + 3, 205)
	end)
end
do
	local DDHEIST_PLAYER4_MANAGER = DDHEIST_PLYR_MANAGER:add_submenu('玩家 4 分红')
	-- [unuseable]需要用户输入
	-- DDHEIST_PLAYER4_MANAGER:add_action("自定义分红", function(dom4)
	-- 	local r, s = input.get("It is not recommended to use such high values", "", 1000, 3)
	-- 	if r == 1 then
	-- 		return HANDLER_CONTINUE
	-- 	end
	-- 	if r == 2 then
	-- 		return HANDLER_POP
	-- 	end
	-- 	globals.set_int(1962763 + 812 + 50 + 4, tonumber(s))
	-- end)
	DDHEIST_PLAYER4_MANAGER:add_action('0%', function()
		globals.set_int(1962763 + 812 + 50 + 4, 0)
	end)
	DDHEIST_PLAYER4_MANAGER:add_action('50%', function()
		globals.set_int(1962763 + 812 + 50 + 4, 50)
	end)
	DDHEIST_PLAYER4_MANAGER:add_action('85%', function()
		globals.set_int(1962763 + 812 + 50 + 4, 85)
	end)
	DDHEIST_PLAYER4_MANAGER:add_action('100%', function()
		globals.set_int(1962763 + 812 + 50 + 4, 100)
	end)
	DDHEIST_PLAYER4_MANAGER:add_action('150%', function()
		globals.set_int(1962763 + 812 + 50 + 4, 150)
	end)
	DDHEIST_PLAYER4_MANAGER:add_action('175%', function()
		globals.set_int(1962763 + 812 + 50 + 4, 175)
	end)
	DDHEIST_PLAYER4_MANAGER:add_action('200%', function()
		globals.set_int(1962763 + 812 + 50 + 4, 200)
	end)
	DDHEIST_PLAYER4_MANAGER:add_action('205%', function()
		globals.set_int(1962763 + 812 + 50 + 4, 205)
	end)
end
do
	local DD_H_ULCK = { { 'GANGOPS_HEIST_STATUS', -1 }, { 'GANGOPS_HEIST_STATUS', -229384 } }
	DOOMS_HEIST:add_action('解锁全部末日抢劫 (给莱斯特打电话取消末日抢劫三次)', function()
		for i = 1, #DD_H_ULCK do
			stat_set_int(DD_H_ULCK[i][1], true, DD_H_ULCK[i][2])
		end
	end)
end
do
	local DD_PREPS_DONE = { { 'GANGOPS_FM_MISSION_PROG', -1 } }
	DOOMS_HEIST:add_action('完成全部前置', function()
		for i = 1, #DD_PREPS_DONE do
			stat_set_int(DD_PREPS_DONE[i][1], true, DD_PREPS_DONE[i][2])
		end
	end)
end
do
	local DD_H_RST = { { 'GANGOPS_FLOW_MISSION_PROG', 240 }, { 'GANGOPS_HEIST_STATUS', 0 }, { 'GANGOPS_FLOW_NOTIFICATIONS', 1557 } }
	DOOMS_HEIST:add_action('重置抢劫', function()
		for i = 1, #DD_H_RST do
			stat_set_int(DD_H_RST[i][1], true, DD_H_RST[i][2])
		end
	end)
end
do
	local DD_AWARDS_I = { { 'GANGOPS_FM_MISSION_PROG', -1 }, { 'GANGOPS_FLOW_MISSION_PROG', -1 }, { 'MPPLY_GANGOPS_ALLINORDER', 536870911 },
                       { 'MPPLY_GANGOPS_LOYALTY', 536870911 }, { 'MPPLY_GANGOPS_CRIMMASMD', 536870911 }, { 'MPPLY_GANGOPS_LOYALTY2', 536870911 },
                       { 'MPPLY_GANGOPS_LOYALTY3', 536870911 }, { 'MPPLY_GANGOPS_CRIMMASMD2', 536870911 }, { 'MPPLY_GANGOPS_CRIMMASMD3', 536870911 },
                       { 'MPPLY_GANGOPS_SUPPORT', 536870911 }, { 'CR_GANGOP_MORGUE', 10 }, { 'CR_GANGOP_DELUXO', 10 }, { 'CR_GANGOP_SERVERFARM', 10 },
                       { 'CR_GANGOP_IAABASE_FIN', 10 }, { 'CR_GANGOP_STEALOSPREY', 10 }, { 'CR_GANGOP_FOUNDRY', 10 }, { 'CR_GANGOP_RIOTVAN', 10 },
                       { 'CR_GANGOP_SUBMARINECAR', 10 }, { 'CR_GANGOP_SUBMARINE_FIN', 10 }, { 'CR_GANGOP_PREDATOR', 10 },
                       { 'CR_GANGOP_BMLAUNCHER', 10 }, { 'CR_GANGOP_BCCUSTOM', 10 }, { 'CR_GANGOP_STEALTHTANKS', 10 }, { 'CR_GANGOP_SPYPLANE', 10 },
                       { 'CR_GANGOP_FINALE', 10 }, { 'CR_GANGOP_FINALE_P2', 10 }, { 'CR_GANGOP_FINALE_P3', 10 }, { 'WAM_FLOW_VEHICLE_BS', -1 },
                       { 'GANGOPS_FLOW_IMPEXP_NUM', -1 } }
	local DD_AWARDS_B = { { 'MPPLY_AWD_GANGOPS_IAA', true }, { 'MPPLY_AWD_GANGOPS_SUBMARINE', true }, { 'MPPLY_AWD_GANGOPS_MISSILE', true },
                       { 'MPPLY_AWD_GANGOPS_ALLINORDER', true }, { 'MPPLY_AWD_GANGOPS_LOYALTY', true }, { 'MPPLY_AWD_GANGOPS_LOYALTY2', true },
                       { 'MPPLY_AWD_GANGOPS_LOYALTY3', true }, { 'MPPLY_AWD_GANGOPS_CRIMMASMD', true }, { 'MPPLY_AWD_GANGOPS_CRIMMASMD2', true },
                       { 'MPPLY_AWD_GANGOPS_CRIMMASMD3', true } }
	DOOMS_HEIST:add_action('解锁全部末日抢劫奖励', function()
		for i = 1, #DD_AWARDS_I do
			stat_set_int(DD_AWARDS_I[i][1], true, DD_AWARDS_I[i][2])
			stat_set_int(DD_AWARDS_I[i][1], false, DD_AWARDS_I[i][2])
		end
		for i = 1, #DD_AWARDS_B do
			stat_set_bool(DD_AWARDS_B[i][1], true, DD_AWARDS_B[i][2])
			stat_set_bool(DD_AWARDS_B[i][1], false, DD_AWARDS_B[i][2])
		end
		for i = 0, 64, 1 do
			hash = CharID .. '_GANGOPSPSTAT_BOOL'
			stats.set_bool_masked(hash, true, i)
		end
	end)
end
-------- CLASSIC HEIST
do
	-- [unuseable]需要用户输入
	-- CLASSIC_CUT:add_action('自定义分红', function(classic)
	-- 	local r, s = input.get('It is not recommended to use such high values', '', 1000, 3)
	-- 	if r == 1 then
	-- 		return HANDLER_CONTINUE
	-- 	end
	-- 	if r == 2 then
	-- 		return HANDLER_POP
	-- 	end
	-- 	globals.set_int(1934636 + 3008 + 1, tonumber(s))
	-- end)
	CLASSIC_CUT:add_action('0 %', function()
		globals.set_int(1934636 + 3008 + 1, 0)
	end)
	CLASSIC_CUT:add_action('25 %', function()
		globals.set_int(1934636 + 3008 + 1, 25)
	end)
	CLASSIC_CUT:add_action('50 %', function()
		globals.set_int(1934636 + 3008 + 1, 50)
	end)
	CLASSIC_CUT:add_action('75 %', function()
		globals.set_int(1934636 + 3008 + 1, 75)
	end)
	CLASSIC_CUT:add_action('85 %', function()
		globals.set_int(1934636 + 3008 + 1, 85)
	end)
	CLASSIC_CUT:add_action('100 %', function()
		globals.set_int(1934636 + 3008 + 1, 100)
	end)
	CLASSIC_CUT:add_action('125 %', function()
		globals.set_int(1934636 + 3008 + 1, 125)
	end)
	CLASSIC_CUT:add_action('150 %', function()
		globals.set_int(1934636 + 3008 + 1, 150)
	end)
	CLASSIC_CUT:add_action('175 %', function()
		globals.set_int(1934636 + 3008 + 1, 175)
	end)
	CLASSIC_CUT:add_action('200 %', function(a)
		globals.set_int(1934636 + 3008 + 1, 200)
	end)
end
do
	local Apartment_AWD_B = { { 'MPPLY_AWD_COMPLET_HEIST_MEM', true }, { 'MPPLY_AWD_COMPLET_HEIST_1STPER', true }, { 'MPPLY_AWD_FLEECA_FIN', true },
                           { 'MPPLY_AWD_HST_ORDER', true }, { 'MPPLY_AWD_HST_SAME_TEAM', true }, { 'MPPLY_AWD_HST_ULT_CHAL', true },
                           { 'MPPLY_AWD_HUMANE_FIN', true }, { 'MPPLY_AWD_PACIFIC_FIN', true }, { 'MPPLY_AWD_PRISON_FIN', true },
                           { 'MPPLY_AWD_SERIESA_FIN', true }, { 'AWD_FINISH_HEIST_NO_DAMAGE', true }, { 'AWD_SPLIT_HEIST_TAKE_EVENLY', true },
                           { 'AWD_ALL_ROLES_HEIST', true }, { 'AWD_MATCHING_OUTFIT_HEIST', true }, { 'HEIST_PLANNING_DONE_PRINT', true },
                           { 'HEIST_PLANNING_DONE_HELP_0', true }, { 'HEIST_PLANNING_DONE_HELP_1', true }, { 'HEIST_PRE_PLAN_DONE_HELP_0', true },
                           { 'HEIST_CUTS_DONE_FINALE', true }, { 'HEIST_IS_TUTORIAL', false }, { 'HEIST_STRAND_INTRO_DONE', true },
                           { 'HEIST_CUTS_DONE_ORNATE', true }, { 'HEIST_CUTS_DONE_PRISON', true }, { 'HEIST_CUTS_DONE_BIOLAB', true },
                           { 'HEIST_CUTS_DONE_NARCOTIC', true }, { 'HEIST_CUTS_DONE_TUTORIAL', true }, { 'HEIST_AWARD_DONE_PREP', true },
                           { 'HEIST_AWARD_BOUGHT_IN', true } }
	local Apartment_AWD_I = { { 'AWD_FINISH_HEISTS', 900 }, { 'MPPLY_WIN_GOLD_MEDAL_HEISTS', 900 }, { 'AWD_DO_HEIST_AS_MEMBER', 900 },
                           { 'AWD_DO_HEIST_AS_THE_LEADER', 900 }, { 'AWD_FINISH_HEIST_SETUP_JOB', 900 }, { 'AWD_FINISH_HEIST', 900 },
                           { 'HEIST_COMPLETION', 900 }, { 'HEISTS_ORGANISED', 900 }, { 'AWD_CONTROL_CROWDS', 900 },
                           { 'AWD_WIN_GOLD_MEDAL_HEISTS', 900 }, { 'AWD_COMPLETE_HEIST_NOT_DIE', 900 }, { 'HEIST_START', 900 }, { 'HEIST_END', 900 },
                           { 'CUTSCENE_MID_PRISON', 900 }, { 'CUTSCENE_MID_HUMANE', 900 }, { 'CUTSCENE_MID_NARC', 900 },
                           { 'CUTSCENE_MID_ORNATE', 900 }, { 'CR_FLEECA_PREP_1', 5000 }, { 'CR_FLEECA_PREP_2', 5000 }, { 'CR_FLEECA_FINALE', 5000 },
                           { 'CR_PRISON_PLANE', 5000 }, { 'CR_PRISON_BUS', 5000 }, { 'CR_PRISON_STATION', 5000 },
                           { 'CR_PRISON_UNFINISHED_BIZ', 5000 }, { 'CR_PRISON_FINALE', 5000 }, { 'CR_HUMANE_KEY_CODES', 5000 },
                           { 'CR_HUMANE_ARMORDILLOS', 5000 }, { 'CR_HUMANE_EMP', 5000 }, { 'CR_HUMANE_VALKYRIE', 5000 }, { 'CR_HUMANE_FINALE', 5000 },
                           { 'CR_NARC_COKE', 5000 }, { 'CR_NARC_TRASH_TRUCK', 5000 }, { 'CR_NARC_BIKERS', 5000 }, { 'CR_NARC_WEED', 5000 },
                           { 'CR_NARC_STEAL_METH', 5000 }, { 'CR_NARC_FINALE', 5000 }, { 'CR_PACIFIC_TRUCKS ', 5000 }, { 'CR_PACIFIC_WITSEC', 5000 },
                           { 'CR_PACIFIC_HACK', 5000 }, { 'CR_PACIFIC_BIKES', 5000 }, { 'CR_PACIFIC_CONVOY', 5000 }, { 'CR_PACIFIC_FINALE', 5000 },
                           { 'MPPLY_HEIST_ACH_TRACKER', -1 } }
	CLASSIC_HEISTS:add_action('解锁全部公寓抢劫和奖励', function()
		for i = 1, #Apartment_AWD_I do
			stat_set_int(Apartment_AWD_I[i][1], true, Apartment_AWD_I[i][2])
			stat_set_int(Apartment_AWD_I[i][1], false, Apartment_AWD_I[i][2])
			for i = 1, #Apartment_AWD_B do
				stat_set_bool(Apartment_AWD_B[i][1], true, Apartment_AWD_B[i][2])
				stat_set_bool(Apartment_AWD_B[i][1], false, Apartment_AWD_B[i][2])
			end
		end
	end)
end
do
	local Apartment_SetDone = { { 'HEIST_PLANNING_STAGE', -1 } }
	CLASSIC_HEISTS:add_action('跳过全部前置', function()
		for i = 1, #Apartment_SetDone do
			stat_set_int(Apartment_SetDone[i][1], true, Apartment_SetDone[i][2])
		end
	end)
end
CLASSIC_HEISTS:add_action('全福银行 1500w (作为房主时使用)', function()
	globals.set_int(1934636 + 3008 + 1, 10434)
end)
CLASSIC_HEISTS:add_action('全福银行 1000w (作为房主时使用)', function()
	globals.set_int(1934636 + 3008 + 1, 7000)
end)
CLASSIC_HEISTS:add_action('全福银行 500w (作为房主时使用)', function()
	globals.set_int(1934636 + 3008 + 1, 3500)
end)
-- CLASSIC CUT WEEKLY EVENT
CLASSIC_HEISTS:add_action('[2x] 全福银行 1500w (作为房主时使用)', function()
	globals.set_int(1934636 + 3008 + 1, 5217)
end)
CLASSIC_HEISTS:add_action('[2x] 全福银行 1000w (作为房主时使用)', function()
	globals.set_int(1934636 + 3008 + 1, 3500)
end)
CLASSIC_HEISTS:add_action('[2x] 全福银行 500w (作为房主时使用)', function()
	globals.set_int(1934636 + 3008 + 1, 1750)
end)
------------- LS CONTRACTS
LS_ROBBERY:add_action('修改收入为 100w', function()
	globals.set_int(262145 + 30691 + 0, 1000000)
	globals.set_int(262145 + 30691 + 1, 1000000)
	globals.set_int(262145 + 30691 + 2, 1000000)
	globals.set_int(262145 + 30691 + 3, 1000000)
	globals.set_int(262145 + 30691 + 4, 1000000)
	globals.set_int(262145 + 30691 + 5, 1000000)
	globals.set_int(262145 + 30691 + 6, 1000000)
	globals.set_int(262145 + 30691 + 7, 1000000)
	-- globals.set_int(292668,1000000)
	globals.set_int(262145 + 30690, 1000000) -- reward when joining a contract
	globals.set_float(262145 + 30687, 0) -- IA cut removal
end)
LS_ROBBERY:add_action('[2x] 修改收入为 100w', function()
	globals.set_int(262145 + 30691 + 0, 500000)
	globals.set_int(262145 + 30691 + 1, 500000)
	globals.set_int(262145 + 30691 + 2, 500000)
	globals.set_int(262145 + 30691 + 3, 500000)
	globals.set_int(262145 + 30691 + 4, 500000)
	globals.set_int(262145 + 30691 + 5, 500000)
	globals.set_int(262145 + 30691 + 6, 500000)
	globals.set_int(262145 + 30691 + 7, 500000)
	-- globals.set_int(292668,500000)
	globals.set_int(262145 + 30690, 500000) -- reward when joining a contract
	globals.set_float(262145 + 30687, 0) -- IA cut removal
end)
do
	local LS_CONTRACT_0_UD = { { 'TUNER_GEN_BS', 12543 }, { 'TUNER_CURRENT', 0 } }
	LS_ROBBERY:add_action('联合储蓄合约', function()
		for i = 1, #LS_CONTRACT_0_UD do
			stat_set_int(LS_CONTRACT_0_UD[i][1], true, LS_CONTRACT_0_UD[i][2])
		end
	end)
end
do
	local LS_CONTRACT_1_SD = { { 'TUNER_GEN_BS', 4351 }, { 'TUNER_CURRENT', 1 } }
	LS_ROBBERY:add_action('大钞交易', function()
		for i = 1, #LS_CONTRACT_1_SD do
			stat_set_int(LS_CONTRACT_1_SD[i][1], true, LS_CONTRACT_1_SD[i][2])
		end
	end)
end
do
	local LS_CONTRACT_2_BC = { { 'TUNER_GEN_BS', 12543 }, { 'TUNER_CURRENT', 2 } }
	LS_ROBBERY:add_action('银行合约', function()
		for i = 1, #LS_CONTRACT_2_BC do
			stat_set_int(LS_CONTRACT_2_BC[i][1], true, LS_CONTRACT_2_BC[i][2])
		end
	end)
end
do
	local LS_CONTRACT_3_ECU = { { 'TUNER_GEN_BS', 12543 }, { 'TUNER_CURRENT', 3 } }
	LS_ROBBERY:add_action('电控单元差事', function()
		for i = 1, #LS_CONTRACT_3_ECU do
			stat_set_int(LS_CONTRACT_3_ECU[i][1], true, LS_CONTRACT_3_ECU[i][2])
		end
	end)
end
do
	local LS_CONTRACT_4_PRSN = { { 'TUNER_GEN_BS', 12543 }, { 'TUNER_CURRENT', 4 } }
	LS_ROBBERY:add_action('监狱合约', function()
		for i = 1, #LS_CONTRACT_4_PRSN do
			stat_set_int(LS_CONTRACT_4_PRSN[i][1], true, LS_CONTRACT_4_PRSN[i][2])
		end
	end)
end
do
	local LS_CONTRACT_5_AGC = { { 'TUNER_GEN_BS', 12543 }, { 'TUNER_CURRENT', 5 } }
	LS_ROBBERY:add_action('IAA 交易', function()
		for i = 1, #LS_CONTRACT_5_AGC do
			stat_set_int(LS_CONTRACT_5_AGC[i][1], true, LS_CONTRACT_5_AGC[i][2])
		end
	end)
end
do
	local LS_CONTRACT_6_LOST = { { 'TUNER_GEN_BS', 12543 }, { 'TUNER_CURRENT', 6 } }
	LS_ROBBERY:add_action('失落摩托帮合约', function()
		for i = 1, #LS_CONTRACT_6_LOST do
			stat_set_int(LS_CONTRACT_6_LOST[i][1], true, LS_CONTRACT_6_LOST[i][2])
		end
	end)
end
do
	local LS_CONTRACT_7_DATA = { { 'TUNER_GEN_BS', 12543 }, { 'TUNER_CURRENT', 7 } }
	LS_ROBBERY:add_action('数据合约', function()
		for i = 1, #LS_CONTRACT_7_DATA do
			stat_set_int(LS_CONTRACT_7_DATA[i][1], true, LS_CONTRACT_7_DATA[i][2])
		end
	end)
end
do
	local LS_CONTRACT_MSS_ONLY = { { 'TUNER_GEN_BS', -1 } }
	LS_ROBBERY:add_action('完成全部任务', function()
		for i = 1, #LS_CONTRACT_MSS_ONLY do
			stat_set_int(LS_CONTRACT_MSS_ONLY[i][1], true, LS_CONTRACT_MSS_ONLY[i][2])
		end
	end)
end
do
	local LS_TUNERS_DLC_BL = { { 'AWD_CAR_CLUB', true }, { 'AWD_PRO_CAR_EXPORT', true }, { 'AWD_UNION_DEPOSITORY', true },
                            { 'AWD_MILITARY_CONVOY', true }, { 'AWD_FLEECA_BANK', true }, { 'AWD_FREIGHT_TRAIN', true },
                            { 'AWD_BOLINGBROKE_ASS', true }, { 'AWD_IAA_RAID', true }, { 'AWD_METH_JOB', true }, { 'AWD_BUNKER_RAID', true },
                            { 'AWD_STRAIGHT_TO_VIDEO', true }, { 'AWD_MONKEY_C_MONKEY_DO', true }, { 'AWD_TRAINED_TO_KILL', true },
                            { 'AWD_DIRECTOR', true } }
	local LS_TUNERS_DLC_IT = { { 'AWD_CAR_CLUB_MEM', 100 }, { 'AWD_SPRINTRACER', 50 }, { 'AWD_STREETRACER', 50 }, { 'AWD_PURSUITRACER', 50 },
                            { 'AWD_TEST_CAR', 240 }, { 'AWD_AUTO_SHOP', 50 }, { 'AWD_CAR_EXPORT', 100 }, { 'AWD_GROUNDWORK', 40 },
                            { 'AWD_ROBBERY_CONTRACT', 100 }, { 'AWD_FACES_OF_DEATH', 100 } }
	LS_ROBBERY:add_action('解锁全部改装铺合约奖励', function()
		for i = 1, #LS_TUNERS_DLC_IT do
			stat_set_int(LS_TUNERS_DLC_IT[i][1], true, LS_TUNERS_DLC_IT[i][2])
		end
		for i = 2, #LS_TUNERS_DLC_BL do
			stat_set_bool(LS_TUNERS_DLC_BL[i][1], true, LS_TUNERS_DLC_BL[i][2])
		end
		for i = 0, 576, 1 do
			hash = CharID .. '_TUNERPSTAT_BOOL'
			stats.set_bool_masked(hash, true, i)
		end
		globals.set_int(262145 + 30833, 1)
	end)
end
local ROBBERY_RESETER = LS_ROBBERY:add_submenu('::: 更多选项')
do
	local LS_CONTRACT_MISSION_RST = { { 'TUNER_GEN_BS', 12467 } }
	ROBBERY_RESETER:add_action('重置任务', function()
		for i = 1, #LS_CONTRACT_MISSION_RST do
			stat_set_int(LS_CONTRACT_MISSION_RST[i][1], true, LS_CONTRACT_MISSION_RST[i][2])
		end
	end)
end
do
	local LS_CONTRACT_RST = { { 'TUNER_GEN_BS', 8371 }, { 'TUNER_CURRENT', -1 } }
	ROBBERY_RESETER:add_action('重置合约', function()
		for i = 1, #LS_CONTRACT_RST do
			stat_set_int(LS_CONTRACT_RST[i][1], true, LS_CONTRACT_RST[i][2])
		end
	end)
end
do
	local RST_COUNT_TNR = { { 'TUNER_COUNT', 0 }, { 'TUNER_EARNINGS', 0 } }
	ROBBERY_RESETER:add_action('重置合约任务收入和完成次数', function()
		for i = 1, #RST_COUNT_TNR do
			stat_set_int(RST_COUNT_TNR[i][1], true, RST_COUNT_TNR[i][2])
		end
	end)
end
-- THE CONTRACT DLC
local CONTRACT_MANAGER = TH_CONTRACT:add_submenu('VIP 合约')
local CONTRACT_MANAGER_ = CONTRACT_MANAGER:add_submenu('夜生活泄密')
local CONTRACT_MANAGER__ = CONTRACT_MANAGER:add_submenu('上流社会泄密')
local CONTRACT_MANAGER___ = CONTRACT_MANAGER:add_submenu('南中心区泄密')
do
	local LEAK_NIGHTCLUB = { { 'FIXER_GENERAL_BS', -1 }, { 'FIXER_COMPLETED_BS', -1 }, { 'FIXER_STORY_BS', 3 }, { 'FIXER_STORY_COOLDOWN', -1 } }
	CONTRACT_MANAGER_:add_action('夜总会 (前置)', function()
		for i = 1, #LEAK_NIGHTCLUB do
			stat_set_int(LEAK_NIGHTCLUB[i][1], true, LEAK_NIGHTCLUB[i][2])
		end
	end)
end
do
	local LEAK_MARINA = { { 'FIXER_GENERAL_BS', -1 }, { 'FIXER_COMPLETED_BS', -1 }, { 'FIXER_STORY_BS', 4 }, { 'FIXER_STORY_COOLDOWN', -1 } }
	CONTRACT_MANAGER_:add_action('船坞 (前置)', function()
		for i = 1, #LEAK_MARINA do
			stat_set_int(LEAK_MARINA[i][1], true, LEAK_MARINA[i][2])
		end
	end)
end
do
	local LEAK_NIGHTLIFE = { { 'FIXER_GENERAL_BS', -1 }, { 'FIXER_COMPLETED_BS', -1 }, { 'FIXER_STORY_BS', 12 }, { 'FIXER_STORY_COOLDOWN', -1 } }
	CONTRACT_MANAGER_:add_action('夜生活泄密 (任务)', function()
		for i = 1, #LEAK_NIGHTLIFE do
			stat_set_int(LEAK_NIGHTLIFE[i][1], true, LEAK_NIGHTLIFE[i][2])
		end
	end)
end
do
	local LEAK_COUNTRYCLUB = { { 'FIXER_GENERAL_BS', -1 }, { 'FIXER_COMPLETED_BS', -1 }, { 'FIXER_STORY_STRAND', -1 }, { 'FIXER_STORY_BS', 28 },
                            { 'FIXER_STORY_COOLDOWN', -1 } }
	CONTRACT_MANAGER__:add_action('乡村俱乐部 (前置)', function()
		for i = 1, #LEAK_COUNTRYCLUB do
			stat_set_int(LEAK_COUNTRYCLUB[i][1], true, LEAK_COUNTRYCLUB[i][2])
		end
	end)
end
do
	local LEAK_GUESTLIST = { { 'FIXER_GENERAL_BS', -1 }, { 'FIXER_COMPLETED_BS', -1 }, { 'FIXER_STORY_STRAND', -1 }, { 'FIXER_STORY_BS', 60 },
                          { 'FIXER_STORY_COOLDOWN', -1 } }
	CONTRACT_MANAGER__:add_action('宾客名单 (前置)', function()
		for i = 1, #LEAK_GUESTLIST do
			stat_set_int(LEAK_GUESTLIST[i][1], true, LEAK_GUESTLIST[i][2])
		end
	end)
end
do
	local LEAK_HIGHSOCIETY = { { 'FIXER_GENERAL_BS', -1 }, { 'FIXER_COMPLETED_BS', -1 }, { 'FIXER_STORY_STRAND', -1 }, { 'FIXER_STORY_BS', 124 },
                            { 'FIXER_STORY_COOLDOWN', -1 } }
	CONTRACT_MANAGER__:add_action('上流社会泄密 (任务)', function()
		for i = 1, #LEAK_HIGHSOCIETY do
			stat_set_int(LEAK_HIGHSOCIETY[i][1], true, LEAK_HIGHSOCIETY[i][2])
		end
	end)
end
do
	local LEAK_DAVIS = { { 'FIXER_GENERAL_BS', -1 }, { 'FIXER_COMPLETED_BS', -1 }, { 'FIXER_STORY_STRAND', -1 }, { 'FIXER_STORY_BS', 252 },
                      { 'FIXER_STORY_COOLDOWN', -1 } }
	CONTRACT_MANAGER___:add_action('戴维斯 (前置)', function()
		for i = 1, #LEAK_DAVIS do
			stat_set_int(LEAK_DAVIS[i][1], true, LEAK_DAVIS[i][2])
		end
	end)
end
do
	local LEAK_BALLAS = { { 'FIXER_GENERAL_BS', -1 }, { 'FIXER_COMPLETED_BS', -1 }, { 'FIXER_STORY_STRAND', -1 }, { 'FIXER_STORY_BS', 508 },
                       { 'FIXER_STORY_COOLDOWN', -1 } }
	CONTRACT_MANAGER___:add_action('巴勒帮 (前置)', function()
		for i = 1, #LEAK_BALLAS do
			stat_set_int(LEAK_BALLAS[i][1], true, LEAK_BALLAS[i][2])
		end
	end)
end
do
	local LEAK_STUDIO = { { 'FIXER_GENERAL_BS', -1 }, { 'FIXER_COMPLETED_BS', -1 }, { 'FIXER_STORY_STRAND', -1 }, { 'FIXER_STORY_BS', 2044 },
                       { 'FIXER_STORY_COOLDOWN', -1 } }
	CONTRACT_MANAGER___:add_action('工作室时间 (任务)', function()
		for i = 1, #LEAK_STUDIO do
			stat_set_int(LEAK_STUDIO[i][1], true, LEAK_STUDIO[i][2])
		end
	end)
end
do
	local LEAK_FINAL = { { 'FIXER_GENERAL_BS', -1 }, { 'FIXER_COMPLETED_BS', -1 }, { 'FIXER_STORY_STRAND', -1 }, { 'FIXER_STORY_BS', 4092 },
                      { 'FIXER_STORY_COOLDOWN', -1 } }
	CONTRACT_MANAGER___:add_action('终章 : 别惹德瑞', function()
		for i = 1, #LEAK_FINAL do
			stat_set_int(LEAK_FINAL[i][1], true, LEAK_FINAL[i][2])
		end
	end)
end
--
TH_CONTRACT:add_action('修改终章收入 240w', function()
	globals.set_int(262145 + 31389, 2400000)
end)
TH_CONTRACT:add_action('[活动] 修改终章收入 240w', function()
	globals.set_int(262145 + 31389, 1600000)
end)
TH_CONTRACT:add_action('移除安保合约冷却', function(CONT_REM_CD)
	globals.set_int(262145 + 31345, 0)
	globals.set_int(262145 + 31423, 0)
	globals.set_int(2720311, 0) --- NEED update
end)
do
	local CONTRACT_COMPLETE = { { 'FIXER_GENERAL_BS', -1 }, { 'FIXER_COMPLETED_BS', -1 }, { 'FIXER_STORY_BS', -1 }, { 'FIXER_STORY_COOLDOWN', -1 } }
	TH_CONTRACT:add_action('完成全部任务', function()
		for i = 1, #CONTRACT_COMPLETE do
			stat_set_int(CONTRACT_COMPLETE[i][1], true, CONTRACT_COMPLETE[i][2])
		end
	end)
end
do
	local TH_AWARDS_I = { { 'AWD_CONTRACTOR', 50 }, { 'AWD_COLD_CALLER', 50 }, { 'AWD_PRODUCER', 60 }, { 'FIXERTELEPHONEHITSCOMPL', 10 },
                       { 'PAYPHONE_BONUS_KILL_METHOD', 10 }, { 'FIXER_COUNT', 501 }, { 'FIXER_SC_VEH_RECOVERED', 501 },
                       { 'FIXER_SC_VAL_RECOVERED', 501 }, { 'FIXER_SC_GANG_TERMINATED', 501 }, { 'FIXER_SC_VIP_RESCUED', 501 },
                       { 'FIXER_SC_ASSETS_PROTECTED', 501 }, { 'FIXER_SC_EQ_DESTROYED', 501 }, { 'FIXER_EARNINGS', 300000 } }
	local TH_AWARDS_B = { { 'AWD_TEEING_OFF', true }, { 'AWD_PARTY_NIGHT', true }, { 'AWD_BILLIONAIRE_GAMES', true }, { 'AWD_HOOD_PASS', true },
                       { 'AWD_STUDIO_TOUR', true }, { 'AWD_DONT_MESS_DRE', true }, { 'AWD_BACKUP', true }, { 'AWD_SHORTFRANK_1', true },
                       { 'AWD_SHORTFRANK_2', true }, { 'AWD_SHORTFRANK_3', true }, { 'AWD_CONTR_KILLER', true }, { 'AWD_DOGS_BEST_FRIEND', true },
                       { 'AWD_MUSIC_STUDIO', true }, { 'AWD_SHORTLAMAR_1', true }, { 'AWD_SHORTLAMAR_2', true }, { 'AWD_SHORTLAMAR_3', true } }
	TH_CONTRACT:add_action('解锁全部合约奖励和服装', function()
		local BL0 = PlayerMP .. '_FIXERPSTAT_BOOL0'
		local BL1 = PlayerMP .. '_FIXERPSTAT_BOOL1'
		for i = 0, 128, 1 do
			stats.set_bool_masked(BL0, true, i) -- True
			stats.set_bool_masked(BL1, true, i) -- True
		end
		for i = 1, #TH_AWARDS_I do
			stat_set_int(TH_AWARDS_I[i][1], true, TH_AWARDS_I[i][2])
		end
		for i = 1, #TH_AWARDS_B do
			stat_set_bool(TH_AWARDS_B[i][1], true, TH_AWARDS_B[i][2])
		end
	end)
end
-- TOOLS
TOOLS:add_action('允许非公开战局任务', function()
	globals.set_int(2714635 + 744, 0) -- NETWORK::NETWORK_SESSION_GET_PRIVATE_SLOTS
end)
-- Heist Cooldown Reminder
-- [unuseable]需要lua多线程运行
-- do
-- 	local COOLDOWN_REMIND = menu.add_feature('Heist Cooldown Reminder', 'parent', TOOLS.id)
-- 	menu.add_feature('Reminder for Cayo Perico Heist', 'action', COOLDOWN_REMIND.id, function(HCR_Cayo)
-- 		menu.notify('Counting down the next 16 minutes\n\nYou can play a different Heist in the meantime\n\nThe cooldown for each Heist is individual',
-- 		            ':: Cayo Perico Heist', 15, 0x64FF78B4)
-- 		system.wait(60000)
-- 		system.wait(300000)
-- 		menu.notify('5 minutes have passed\n\nThere are still 10 minutes left to finish the cooldown.\n\nYou will receive another notification soon',
-- 		            ':: Cayo Perico Heist', 10, 0x64FF78B4)
-- 		system.wait(300000)
-- 		menu.notify('10 minutes have passed\n\nThere are still 6 minutes left to finish the cooldown.\n\nYou will receive another notification soon',
-- 		            ':: Cayo Perico Heist', 10, 0x64FF78B4)
-- 		system.wait(360000)
-- 		menu.notify('16 minutes have passed\n\nThe cooldown is over!!!\n\nNow you can play and get paid again\nEnjoy!', ':: Cayo Perico Heist', 20,
-- 		            0x6400FF14)
-- 		return menu.notify('Heist Cooldown Reminder has been disabled...', '', 5, 0x64781EF0)
-- 	end)
-- 	menu.add_feature('Reminder for Diamond Casino Heist', 'action', COOLDOWN_REMIND.id, function(HCR_Casino)
-- 		menu.notify('Counting down the next 16 minutes\n\nYou can play a different Heist in the meantime\n\nThe cooldown for each Heist is individual',
-- 		            ':: Diamond Casino Heist', 15, 0x64FF78B4)
-- 		system.wait(60000)
-- 		system.wait(300000)
-- 		menu.notify('5 minutes have passed\n\nThere are still 10 minutes left to finish the cooldown.\n\nYou will receive another notification soon',
-- 		            ':: Diamond Casino Heist', 10, 0x64FF78B4)
-- 		system.wait(300000)
-- 		menu.notify('10 minutes have passed\n\nThere are still 6 minutes left to finish the cooldown.\n\nYou will receive another notification soon',
-- 		            ':: Diamond Casino Heist', 10, 0x64FF78B4)
-- 		system.wait(360000)
-- 		menu.notify('16 minutes have passed\n\nThe cooldown is over!!!\n\nNow you can play and get paid again\nEnjoy!', ':: Diamond Casino Heist', 20,
-- 		            0x6400FF14)
-- 		return menu.notify('Heist Cooldown Reminder has been disabled...', '', 5, 0x64781EF0)
-- 	end)
-- 	menu.add_feature('Reminder for Doomsday Heist', 'action', COOLDOWN_REMIND.id, function(HCR_Dooms)
-- 		menu.notify('Counting down the next 16 minutes\n\nYou can play a different Heist in the meantime\n\nThe cooldown for each Heist is individual',
-- 		            ':: Doomsday Heist', 15, 0x64FF78B4)
-- 		system.wait(60000)
-- 		system.wait(300000)
-- 		menu.notify('5 minutes have passed\n\nThere are still 10 minutes left to finish the cooldown.\n\nYou will receive another notification soon',
-- 		            ':: Doomsday Heist', 10, 0x64FF78B4)
-- 		system.wait(300000)
-- 		menu.notify('10 minutes have passed\n\nThere are still 6 minutes left to finish the cooldown.\n\nYou will receive another notification soon',
-- 		            ':: Doomsday Heist', 10, 0x64FF78B4)
-- 		system.wait(360000)
-- 		menu.notify('16 minutes have passed\n\nThe cooldown is over!!!\n\nNow you can play and get paid again\nEnjoy!', ':: Doomsday Heist', 20, 0x6400FF14)
-- 		return menu.notify('Heist Cooldown Reminder has been disabled...', '', 5, 0x64781EF0)
-- 	end)
-- 	menu.add_feature('Reminder for Classic Heists', 'action', COOLDOWN_REMIND.id, function(HCR_Classic)
-- 		menu.notify('Counting down the next 16 minutes\n\nYou can play a different Heist in the meantime\n\nThe cooldown for each Heist is individual',
-- 		            ':: Classic Heists', 15, 0x64FF78B4)
-- 		system.wait(60000)
-- 		system.wait(300000)
-- 		menu.notify('5 minutes have passed\n\nThere are still 10 minutes left to finish the cooldown.\n\nYou will receive another notification soon',
-- 		            ':: Classic Heists', 10, 0x64FF78B4)
-- 		system.wait(300000)
-- 		menu.notify('10 minutes have passed\n\nThere are still 6 minutes left to finish the cooldown.\n\nYou will receive another notification soon',
-- 		            ':: Classic Heists', 10, 0x64FF78B4)
-- 		system.wait(360000)
-- 		menu.notify('16 minutes have passed\n\nThe cooldown is over!!!\n\nNow you can play and get paid again\nEnjoy!', ':: Classic Heists', 20, 0x6400FF14)
-- 		return menu.notify('Heist Cooldown Reminder has been disabled...', '', 5, 0x64781EF0)
-- 	end)
-- 	menu.add_feature('Reminder for LS Robbery (Contracts)', 'action', COOLDOWN_REMIND.id, function(HCR_LS)
-- 		menu.notify('Counting down the next 17 minutes\n\nYou can play a different Heist in the meantime\n\nThe cooldown for each Heist is individual',
-- 		            ':: LS Robbery - Contracts', 15, 0x64FF78B4)
-- 		system.wait(60000)
-- 		system.wait(300000)
-- 		menu.notify('5 minutes have passed\n\nThere are still 10 minutes left to finish the cooldown.\n\nYou will receive another notification soon',
-- 		            ':: LS Robbery - Contracts', 10, 0x64FF78B4)
-- 		system.wait(300000)
-- 		menu.notify('10 minutes have passed\n\nThere are still 7 minutes left to finish the cooldown.\n\nYou will receive another notification soon',
-- 		            ':: LS Robbery - Contracts', 10, 0x64FF78B4)
-- 		system.wait(420000)
-- 		menu.notify('17 minutes have passed\n\nThe cooldown is over!!!\n\nNow you can play and get paid again\nEnjoy!', ':: LS Robbery - Contracts', 20,
-- 		            0x6400FF14)
-- 		return menu.notify('Heist Cooldown Reminder has been disabled...', '', 5, 0x64781EF0)
-- 	end)
-- end
