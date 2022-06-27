-- ██████╗ ██╗     ██╗   ██╗███████╗      ███████╗██╗      █████╗  ██████╗      ██╗     ██╗   ██╗ █████╗
-- ██╔══██╗██║     ██║   ██║██╔════╝      ██╔════╝██║     ██╔══██╗██╔════╝      ██║     ██║   ██║██╔══██╗
-- ██████╔╝██║     ██║   ██║█████╗  █████╗█████╗  ██║     ███████║██║  ███╗     ██║     ██║   ██║███████║
-- ██╔══██╗██║     ██║   ██║██╔══╝  ╚════╝██╔══╝  ██║     ██╔══██║██║   ██║     ██║     ██║   ██║██╔══██║
-- ██████╔╝███████╗╚██████╔╝███████╗      ██║     ███████╗██║  ██║╚██████╔╝     ███████╗╚██████╔╝██║  ██║
-- ╚═════╝ ╚══════╝ ╚═════╝ ╚══════╝      ╚═╝     ╚══════╝╚═╝  ╚═╝ ╚═════╝      ╚══════╝ ╚═════╝ ╚═╝  ╚═╝
-- Github: https://github.com/Galaxy-Studio-Code/Blue-Flag-Lua
-- init
-- 自定义设置区域
-- 生成载具
-- 使用自定义车牌
local Vehicle_Spawn_Custom_Plate_text = true;
-- 自定义车牌
local PLATE_TEXT = 'Blue-Flag'
-- 使用高级自定义设置
local Vehicle_Spawn_Adv_Custom_Setting = false;
-- 高级自定义设置参数请自行 goto Vehicle_Spawn_Adv_Setting 修改
require_game_build(2628)
local LUA_VER = '1.1.5'
local bfmenu = menu.add_submenu('Blue-Flag\'s Lua')
local Player_Function = bfmenu:add_submenu('玩家功能')
local Weapon_Function = bfmenu:add_submenu('武器功能')
local Vehicle_Function = bfmenu:add_submenu('载具功能')
local World_Function = bfmenu:add_submenu('世界功能')
local Teleport_Function = bfmenu:add_submenu('传送功能')
local Recovery_Function = bfmenu:add_submenu('恢复功能')
local Heist_Control = bfmenu:add_submenu('任务功能')
local Misc_Function = bfmenu:add_submenu('杂项功能')
local HE_about_info = bfmenu:add_submenu('关于')
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
function GTAO_USER_MP()
	MP_ = stats.get_int('MPPLY_LAST_MP_CHAR')
	if not MP_ then
		MP_ = 0
	end
	return tostring(MP_)
end
local CharID = '' .. GTAO_USER_MP()
local PlayerMP = 'MP' .. GTAO_USER_MP()
-- Player Function
-- Kiddion's example
Player_Function:add_toggle('冻结玩家', function()
	if not localplayer then
		return nil
	end
	return localplayer:get_config_flag(292)
end, function(value)
	if not localplayer then
		return nil
	end
	localplayer:set_config_flag(292, value)
end)
local PlayerChangedCallbackEnabled = false
Player_Function:add_toggle('切换角色时自动补满血量、护甲和弹药', function()
	return PlayerChangedCallbackEnabled
end, function(e)
	PlayerChangedCallbackEnabled = not PlayerChangedCallbackEnabled
	if e then
		PlayerChangedCallback = menu.register_callback('OnPlayerChanged', function(oldPlayer, newPlayer)
			-- When switching player, instantly refill health and armor
			if not newPlayer then
				newPlayer:set_armour(100)
				newPlayer:set_health(newPlayer:get_max_health())
				menu.max_all_ammo()
			end
		end)
	end
	if not e then
		menu.remove_callback(PlayerChangedCallback)
	end
end)
Player_Function:add_action('自杀', function()
	menu.suicide_player()
end)
local function m_health()
	if not localplayer then
		return 1000
	end
	if localplayer:get_max_health() < 1000 then
		return 1000
	end
	return localplayer:get_max_health()
end
Player_Function:add_int_range('玩家血量', 10, 0, m_health(), function()
	if not localplayer then
		return nil
	end
	return localplayer:get_health()
end, function(value)
	if not localplayer then
		return nil
	end
	localplayer:set_health(value)
end)
Player_Function:add_action('补满零食', function()
	local items = { { 'NO_BOUGHT_YUM_SNACKS', 30 }, { 'NO_BOUGHT_HEALTH_SNACKS', 15 }, { 'NO_BOUGHT_EPIC_SNACKS', 5 }, { 'NUMBER_OF_ORANGE_BOUGHT', 10 }, { 'NUMBER_OF_BOURGE_BOUGHT', 10 }, { 'NUMBER_OF_CHAMP_BOUGHT', 5 }, { 'CIGARETTES_BOUGHT', 20 } }
	for i = 1, #items do
		stat_set_int(items[i][1], true, items[i][2])
	end
end)
-- Kiddion's example
Player_Function:add_toggle('缩小玩家', function()
	if not localplayer then
		return nil
	end
	return localplayer:get_config_flag(223)
end, function(value)
	if not localplayer then
		return nil
	end
	localplayer:set_config_flag(223, value)
end)
-- Weapon Function
Weapon_Function:add_action('补满防弹衣', function()
	local items = { { 'MP_CHAR_ARMOUR_1_COUNT', 10 }, { 'MP_CHAR_ARMOUR_2_COUNT', 10 }, { 'MP_CHAR_ARMOUR_3_COUNT', 10 }, { 'MP_CHAR_ARMOUR_4_COUNT', 10 }, { 'MP_CHAR_ARMOUR_5_COUNT', 10 } }
	for i = 1, #items do
		stat_set_int(items[i][1], true, items[i][2])
	end
end)
-- Vehicle Function
-- Kiddion's example
Vehicle_Function:add_toggle('保持载具引擎开启', function()
	if not localplayer then
		return nil
	end
	return localplayer:get_config_flag(241)
end, function(value)
	if not localplayer then
		return nil
	end
	localplayer:set_config_flag(241, value)
end)
VehicelChangedCallbackEnabled = false
Vehicle_Function:add_toggle('进入载具时自动补满血量', function()
	return VehicelChangedCallbackeEnabled
end, function(e)
	VehicelChangedCallbackeEnabled = not VehicelChangedCallbackeEnabled
	if e then
		VehicelChangedCallback = menu.register_callback('OnVehicleChanged', function(oldVehicle, newVehicle)
			if newVehicle then
				if newVehicle:get_health() < newVehicle:get_max_health() then
					newVehicle:set_health(newVehicle:get_max_health())
				end
			end
		end)
	end
	if not e then
		menu.remove_callback(VehicelChangedCallback)
	end
end)
local function m_v_health()
	if not localplayer then
		return 1000
	end
	local current_vehicle = localplayer:get_current_vehicle()
	if not current_vehicle then
		return 1000
	end
	if current_vehicle:get_max_health() < 1000 then
		return 1000
	end
	return current_vehicle:get_max_health()
end
Vehicle_Function:add_int_range('载具血量', 10, 0, m_v_health(), function()
	if not localplayer then
		return nil
	end
	local current_vehicle = localplayer:get_current_vehicle()
	if not current_vehicle then
		return nil
	end
	return current_vehicle:get_health()
end, function(value)
	if not localplayer then
		return nil
	end
	local current_vehicle = localplayer:get_current_vehicle()
	if not current_vehicle then
		return nil
	end
	current_vehicle:set_health(value)
end)
Vehicle_Function:add_int_range('修改载具极速', 10, 0, 1000, function()
	if not localplayer then
		return nil
	end
	local current_vehicle = localplayer:get_current_vehicle()
	if not current_vehicle then
		return nil
	end
	return current_vehicle:get_max_speed()
end, function(value)
	if not localplayer then
		return nil
	end
	local current_vehicle = localplayer:get_current_vehicle()
	if not current_vehicle then
		return nil
	end
	current_vehicle:set_max_speed(value)
end)
vehicleHashes_Boats = { { '丁卡 水上侯爵', 0XC1CE1183 }, { '佩嘉西 飙速', 0XDC60D2B }, { '佩嘉西 飙速', 0X1A144F2A }, { '兰帕达缇 公牛', 0X3FD5AA2F }, { '兰帕达缇 公牛', 0X362CAC6D }, { '卢恩 虎鲸', 0X4FAF0D70 }, { '库尔兹31巡逻艇', 0XEF813606 }, { '拖船', 0X82CAC433 }, { '水上枭雄 海鲨摩托艇', 0XC2974024 }, { '水上枭雄 海鲨摩托艇', 0XDB4388E4 }, { '水上枭雄 海鲨摩托艇', 0XED762D49 }, { '海怪 阿维萨', 0X9A474B5E }, { '海怪', 0XC07107EE }, { '潜水艇', 0X2DFF622F }, { '警用追猎快艇', 0XE2E7D4AB }, { '诗津 向阳号', 0XEF2295C9 }, { '诗津 思快乐快艇', 0X17DF5EC2 }, { '诗津 极限快艇', 0X33581161 }, { '诗津 烈阳号', 0X56590FE9 }, { '诗津 烈阳号', 0X1149422F }, { '诗津 长鳍', 0X6EF89CCC }, { '长崎 小艇', 0X3D961290 }, { '长崎 小艇', 0X107F392C }, { '长崎 小艇', 0X1E5E54EA }, { '长崎 小艇', 0X33B47F96 }, { '长崎 武装小艇', 0XC58DA34A } }
vehicleHashes_Commercials = { { 'HVY 倾卸车', 0X32B91AE8 }, { 'MTL 末日地狱犬', 0XD039510B }, { 'MTL 梦魇地狱犬', 0X71D3B6F0 }, { 'MTL 科幻地狱犬', 0X287FA449 }, { 'MTL 跑德', 0X7DE35E7D }, { 'MTL 跑德改装版', 0X6290F15B }, { 'MTL 车辆运送车', 0X21EEE87D }, { '乔氏 尖锥魅影', 0X9DAE1398 }, { '乔氏 搬运者', 0X5A82F9AE }, { '乔氏 搬运者改装版', 0X171C92C4 }, { '乔氏 魅影', 0X809AA4CB }, { '乔氏 魅影改装版', 0XA90ED5C }, { '威皮 班森', 0X7A61B330 }, { '威霸 拦截者', 0X6827CF72 }, { '威霸 拦截者', 0XF337AB36 }, { '贝飞特 恐霸', 0X897AFC65 }, { '麦霸子 猛骡', 0X501AC93C }, { '麦霸子 猛骡', 0X85A5B471 }, { '麦霸子 猛骡', 0XC1632BEB }, { '麦霸子 猛骡', 0X35ED670B }, { '麦霸子 猛骡改装版', 0X73F4110E } }
vehicleHashes_Compacts = { { '丁卡 旅行家', 0XEB70965F }, { '丁卡 旅行家羽黑', 0X18619B7E }, { '包洛坎 原野行者', 0XA988D3A2 }, { '卡林 半吊子', 0X64430650 }, { '卡林 半吊子', 0XBC993509 }, { '古罗帝 精力霸300', 0X55365079 }, { '古罗帝 精力霸R/A', 0X5C55CB39 }, { '威尼 天威', 0XB9CB3B69 }, { '威尼 天威经典版', 0X378236E1 }, { '威尼 末日天威', 0X256E92BA }, { '威尼 梦魇天威', 0X49E25BA1 }, { '威尼 科幻天威', 0X5BA0FF1E }, { '毕福 俱乐部', 0X82E47E85 }, { '毕福 象鼻虫', 0X61FE4D6A }, { '绝致 狂想曲', 0X322CF98F }, { '贝飞特 哑剧', 0XE644E480 }, { '麦克斯韦 反社会', 0X42ACA95F } }
vehicleHashes_Coupes = { { '兰帕达缇 恶龙', 0XE8A8BDA8 }, { '兰帕达缇 恶龙GT', 0XFAAD85EE }, { '卡林 普莱温', 0X546DA331 }, { '埃努斯 温莎', 0X5E4327C8 }, { '埃努斯 温莎敞篷版', 0X8CF5CAE1 }, { '埃努斯 至尊慧眼敞篷版', 0X13B57D8A }, { '欧斯洛 F620', 0XDCBCBE48 }, { '欧斯洛 胡狼', 0XDAC67112 }, { '浪子 典范', 0XFFB15B5E }, { '绝品 先知', 0XE18195B2 }, { '绝品 先知XS', 0X506434F6 }, { '绝品 卫士', 0X3412AE2D }, { '绝品 卫士XS', 0X50732C82 }, { '绝品 绝品天堂', 0XBD1B39C3 }, { '绝品 绝品天堂敞篷版', 0XB8E2AE18 } }
vehicleHashes_Cycles = { { 'BMX', 0X43779C54 }, { '先驱者', 0XF4E1AA15 }, { '巡航者', 0X1ABA13B5 }, { '惠比特竞速自行车', 0X4339CD69 }, { '极限耐力竞速自行车', 0XB67597EC }, { '特莱赛可竞速自行车', 0XE823FB48 }, { '费斯特', 0XCE23D3BF } }
vehicleHashes_Emergency = { { 'FIB', 0X432EA949 }, { 'FIB', 0X9DC66994 }, { 'MTL 消防车', 0X73920F8E }, { '国家公园警用车', 0X2C33B46E }, { '救护车', 0X45D56ADA }, { '无标识巡航者', 0X8A63C7B9 }, { '移监巴士', 0X885F3671 }, { '绝致 沙滩急救车', 0X1BF8D381 }, { '警用公路巡逻车', 0X95F4C618 }, { '警用巡逻车', 0X71FA16EA }, { '警用巡逻车', 0X79FBB0C5 }, { '警用巡逻车', 0X9F05F101 }, { '警用摩托车', 0XFDEFAEC3 }, { '警用蓝彻', 0XA46462F7 }, { '警用运输车', 0X1B38E955 }, { '警用防暴车', 0XB822A1AA }, { '警长SUV', 0X72935408 }, { '警长座车', 0X9BAA707C }, { '防暴车', 0X9B16A3B4 } }
vehicleHashes_Helicopters = { { 'FH-1猎杀者', 0XFD707EDE }, { '吊挂直升机', 0X3E48BF23 }, { '女武神', 0XA09E15FD }, { '女武神MOD.0', 0X5BFA5C4B }, { '小蛮牛', 0X9D0450CA }, { '歼灭者', 0X31F0B376 }, { '歼灭者隐形版', 0X11962E49 }, { '海雀', 0XD4AE63D9 }, { '白金汉 弗拉图斯', 0X920016F1 }, { '白金汉 斯威夫特', 0XEBC24DF2 }, { '白金汉 斯威夫特豪华版', 0X4019CB4C }, { '白金汉 超级沃利托', 0X2A54C47D }, { '白金汉 超级沃利托碳纤版', 0X9C5E5644 }, { '秃鹰攻击直升机', 0X2F03547B }, { '秃鹰直升机', 0X2C75F0DD }, { '穿梭者', 0X742E9AC0 }, { '穿梭者', 0X2C634FBD }, { '警用小蛮牛', 0X1517D4D9 }, { '运兵直升机', 0X53174EEF }, { '运兵直升机', 0X60A7EA10 }, { '运兵直升机', 0X78BC1A3C }, { '运兵直升机', 0XFCFCB68B }, { '野蛮人', 0XFB133A17 }, { '长崎 浩劫者', 0X89BA59F5 }, { '阿库拉', 0X46699F47 }, { '麻雀', 0X494752F7 }, { '麻雀', 0X5F017E6B } }
vehicleHashes_Industrial = { { 'HVY 推土机', 0X7074F39D }, { 'HVY 混凝土搅拌车', 0XD138A6BB }, { 'HVY 混凝土搅拌车', 0X1C534995 }, { 'HVY 矿石搬运车', 0X810369E2 }, { 'HVY 钻洞机', 0XC3FBA120 }, { 'MTL 平板拖车', 0X50B0215A }, { '乔氏 砂通天', 0X9A5B1DCC }, { '威皮 守护者', 0X825A9F4C }, { '威霸 工地倾卸车', 0X2E19879 }, { '工地倾卸车', 0XC7824E5E }, { '码头装卸车', 0X1A7FCEFA } }
vehicleHashes_Military = { { 'HVY APC', 0X2189D250 }, { 'HVY 拖车型地霸王', 0X4008EABB }, { 'HVY 末日圣甲虫', 0XBBA2A2F7 }, { 'HVY 梦魇圣甲虫', 0XDD71BFEB }, { 'HVY 科幻圣甲虫', 0X5BEB3CE0 }, { 'TM-02可汗贾利', 0XAA6F980A }, { '入侵与说服 坦克', 0XB53C6C52 }, { '冒险家 半履战车', 0XFE141DA6 }, { '冯·伏厄 防空拖车', 0X8FD54EBB }, { '切尔诺伯格', 0XD6BC7523 }, { '卡尼斯 傲世铁骑', 0X132D5A1A }, { '地霸王', 0XCEEA3F4B }, { '地霸王', 0X2592B5CF }, { '巨象 推进者', 0X58CDAF30 }, { '巴拉杰', 0XF34DFB25 }, { '犀牛坦克', 0X2EA68690 }, { '维泰尔', 0X780FFBD2 } }
vehicleHashes_Motorcycles = { { 'LCC 创新', 0XF683EACA }, { 'LCC 圣驹', 0X58E316C7 }, { 'LCC 迷魅光轮', 0X11F76C14 }, { 'LCC 阿瓦鲁斯', 0X81E38F7F }, { '丁卡 双T', 0X9C669788 }, { '丁卡 审判者', 0XAF599F01 }, { '丁卡 恩斗罗', 0X6882FA73 }, { '丁卡 猛冲', 0X6D6F8F43 }, { '丁卡 街头恶魔', 0X63ABADE7 }, { '佩嘉西 801RR巴提', 0XCADD5D2D }, { '佩嘉西 801巴提', 0XF9300CC5 }, { '佩嘉西 FCR1000', 0X25676EAF }, { '佩嘉西 FCR1000改装版', 0XD2D5E00E }, { '佩嘉西 恶霸', 0XCABD11E8 }, { '佩嘉西 暴君', 0X34B82784 }, { '佩嘉西 暴君Mk2', 0X7B54A9D3 }, { '佩嘉西 漩涡', 0XDBA9DBFC }, { '佩嘉西 爱时吉', 0X794CB30C }, { '佩嘉西 费甲欧', 0X350D1AB }, { '佩嘉西 费甲欧摩登版', 0XB328B188 }, { '佩嘉西 费甲欧现代版', 0X9229E4EB }, { '普林西比 复仇女神', 0XDA288376 }, { '普林西比 蒂雅布萝', 0XF1B44F44 }, { '普林西比 蒂雅布萝改装版', 0X6ABDF65E }, { '普林西比 雷克卓', 0X26321E67 }, { '西部 君主', 0X2C509634 }, { '西部 夜刃', 0XA0438767 }, { '西部 恶狼克星', 0XDB20A373 }, { '西部 恶魔', 0X77934CEE }, { '西部 恶魔', 0XAC4E93C9 }, { '西部 末日丧尸', 0XFE5F0722 }, { '西部 梦魇丧尸', 0XAE12C99C }, { '西部 狂暴火箭', 0X36A167E0 }, { '西部 石像鬼', 0X2C2C2324 }, { '西部 破烂摩托车', 0X6FACDF31 }, { '西部 碎尸者', 0XDE05FB87 }, { '西部 科幻丧尸', 0X93F09558 }, { '西部 里弗', 0X76D7C404 }, { '西部 鞭尸者', 0XC3D7C72B }, { '西部 驮兽', 0X806B9CC3 }, { '西部 高潮', 0X17420102 }, { '诗津 PCJ600', 0XC9CEAF06 }, { '诗津 亵渎者', 0X30FF0190 }, { '诗津 威德', 0XF79A00F7 }, { '诗津 白鸟', 0X4B6C568A }, { '诗津 白鸟竞速版', 0XF0C2A91F }, { '长崎 BF400', 0X5283265 }, { '长崎 信奴比', 0X50A6FB9C }, { '长崎 圣太郎', 0XE7D2A16E }, { '长崎 奇美拉', 0X675ED7 }, { '长崎 斯特德', 0X11F58A5A }, { '长崎 碳纤RS型', 0XABB0C0 }, { '麦霸子 曼切兹', 0XA5325278 }, { '麦霸子 曼切兹侦查', 0X40C332A3 }, { '麦霸子 桑切斯 (涂装版)', 0X2EF89E46 }, { '麦霸子 桑切斯', 0XA960B13E } }
vehicleHashes_Muscle = { { '亚班尼 室女座', 0XE2504942 }, { '亚班尼 明日之星改装版', 0X665F785D }, { '亚班尼 赫耳墨斯', 0XE83C17 }, { '亚班尼 闹鬼灵车', 0X7B47A6A7 }, { '亚班尼 风流海盗', 0XD756460C }, { '亚班尼 风流海盗改装版', 0XC397F748 }, { '冒险家 猛牛STX', 0XDB0C9B04 }, { '冒险家 红木烟业铁腕', 0X14D22159 }, { '冒险家 老爷货车', 0XDCE1D9F7 }, { '冒险家 铁腕', 0X94B395C5 }, { '冒险家 铁腕地狱火', 0X734C5E50 }, { '冒险家 铁腕经典改装版', 0X817AFAAD }, { '冒险家 铁腕经典版', 0X2B0C4DCD }, { '威拉德 宗派', 0X81A9CDDF }, { '威拉德 宗派改装巨轮版', 0X866BCE26 }, { '威拉德 宗派改装版', 0X95466BDB }, { '威皮 佩优特古董赛车', 0X9472CD24 }, { '威皮 克里克', 0XA29F78B0 }, { '威皮 公路霸者', 0X4CE68AC }, { '威皮 公路霸者ASP', 0X196F9418 }, { '威皮 公路霸者GTT', 0X2BE8B90A }, { '威皮 公路霸者GTX', 0XC52C6B93 }, { '威皮 刀锋', 0XB820ED5E }, { '威皮 大满贯皮卡', 0X2B7F9DE3 }, { '威皮 大满贯皮卡改装版', 0X42BC5E19 }, { '威皮 失落摩托帮大满贯皮卡', 0X31ADBBFC }, { '威皮 奇诺', 0X14D69010 }, { '威皮 奇诺改装版', 0XAED64A63 }, { '威皮 尿汤啤公路霸者', 0XC96B73D9 }, { '威皮 末日公路霸者', 0XD6FB0F30 }, { '威皮 末日凯撒大帝', 0X1A861243 }, { '威皮 末日大满贯皮卡', 0X8526E2F5 }, { '威皮 梦魇公路霸者', 0XB2E046FB }, { '威皮 梦魇凯撒大帝', 0XD2F77E37 }, { '威皮 梦魇大满贯皮卡', 0X67D52852 }, { '威皮 热情使徒', 0X239E390 }, { '威皮 爱利', 0XB472D2B5 }, { '威皮 科幻公路霸者', 0XAE0A3D4F }, { '威皮 科幻凯撒大帝', 0X619C1B82 }, { '威皮 科幻大满贯皮卡', 0X163F8520 }, { '威皮 赫斯勒', 0X23CA25F2 }, { '敦追里 经典室女座', 0XFDFFB0 }, { '敦追里 经典室女座改装版', 0XCA62927A }, { '绝致 军刀涡轮', 0X9B909C94 }, { '绝致 军刀涡轮改装版', 0XD4EA603 }, { '绝致 刺刑官', 0X83070B62 }, { '绝致 吃得饱汉堡种马', 0XE80F67EE }, { '绝致 坦帕', 0X39F9C898 }, { '绝致 巫毒', 0X1F3766E3 }, { '绝致 巫毒改装版', 0X779B4F2D }, { '绝致 月光', 0X1F52A43F }, { '绝致 月光改装版', 0X710A2B9B }, { '绝致 末日刺刑官', 0X3C26BD0C }, { '绝致 梦魇刺刑官', 0X9804F4C7 }, { '绝致 武装坦帕', 0XB7D9F7F1 }, { '绝致 活力够', 0XCEC6B9B7 }, { '绝致 漂移约塞米蒂', 0X64F49967 }, { '绝致 瓦魔狮', 0XFD128DFD }, { '绝致 种马', 0X72A4C31E }, { '绝致 科幻刺刑官', 0X8D45DF49 }, { '绝致 约塞米蒂', 0X6F946279 }, { '绝致 郁金', 0X56D42971 }, { '老爷卡车', 0XD83C13CE }, { '英庞提 不死鸟', 0X831A21D5 }, { '英庞提 公爵', 0X2B26F456 }, { '英庞提 暗夜魅影', 0X8C2BD0DC }, { '英庞提 死亡公爵', 0XEC8F7094 }, { '英庞提 比特公爵', 0X7F3415E3 }, { '英庞提 灭世暴徒', 0XF26CEFF9 }, { '英庞提 灭世暴徒', 0X2E5AFD37 }, { '英庞提 灭世暴徒2000', 0X381E10BD }, { '赛乐斯特 异类', 0X4C3FFF49 }, { '雪佛 斗牛士', 0X59E0FBF3 }, { '非凡 艳妇黑鳍', 0X2EC385FE } }
vehicleHashes_Off_Road = { { 'HVY 叛乱分子', 0X7B7E56F0 }, { 'HVY 叛乱分子皮卡', 0X9114EADA }, { 'HVY 叛乱分子皮卡改装版', 0X8D4B7A8A }, { 'HVY 夜鲨', 0X19DD9ED1 }, { 'HVY 威胁者', 0X79DD18AE }, { 'RC匪徒', 0XEEF345EC }, { '丁卡 维鲁斯', 0X11CBC051 }, { '冒险家 末日大脚怪', 0X669EB40A }, { '冒险家 梦魇大脚怪', 0XD556917C }, { '冒险家 科幻大脚怪', 0X32174AFC }, { '冒险家 越野游侠', 0X698521E3 }, { '卡尼斯 万用行者', 0XAA699BB6 }, { '卡尼斯 卡拉哈里', 0X5852838 }, { '卡尼斯 卡马乔', 0XF8C2E0E7 }, { '卡尼斯 炎魔', 0X84F42E51 }, { '卡尼斯 自由攀登者', 0XFCC2F483 }, { '卡林 叛逆男女', 0X8612B64B }, { '卡林 叛逆男女生锈版', 0XB802DD46 }, { '卡林 埃弗伦', 0X97553C28 }, { '卡林 水陆铁尼高', 0X4662BCBB }, { '卡林 铁尼高', 0X83051506 }, { '卡林 铁尼高改装版', 0X50D4D19F }, { '卢恩 炸吧', 0X4C8DBA51 }, { '太空码头工', 0X1FD824AF }, { '威皮 利雅塔', 0XA4A4E453 }, { '威皮 卡拉卡拉', 0X4ABEBF23 }, { '威皮 卡拉卡拉四驱车', 0XAF966F3C }, { '威皮 大脚霸王SWB', 0X3AF8C345 }, { '威皮 大脚霸王XL', 0XB9210FD0 }, { '威皮 威起', 0XF376F1E6 }, { '威皮 沙漠突击', 0XD876DBE2 }, { '威皮 解放者', 0XCD93A7DB }, { '威皮 越野卡车', 0X612F4B6 }, { '巨象 爱国者军用版', 0XD80F4A44 }, { '斜面魔宝', 0XCEB28249 }, { '斜面魔宝', 0XED62BFA9 }, { '旋风 斗殴者', 0XA7CE1BC5 }, { '毕福 必浮塔', 0XEB298297 }, { '毕福 沙丘FAV', 0X711D4738 }, { '毕福 沙丘征服者', 0X432AA566 }, { '毕福 沙丘魔宝', 0X9CF21E0F }, { '爱尼仕 恶人', 0XEA6A047F }, { '绝致 末日布鲁图斯', 0X7F81A829 }, { '绝致 梦魇布鲁图斯', 0X798682A2 }, { '绝致 科幻布鲁图斯', 0X8F49AE28 }, { '绝致 约塞米蒂蓝彻', 0X409D787 }, { '绝致 蓝彻XL', 0X6210CBB0 }, { '绝致 蓝彻XL', 0X7341576B }, { '贝飞特 末日捍士', 0X27D79225 }, { '贝飞特 梦魇捍士', 0X8644331A }, { '贝飞特 科幻捍士', 0X9B065C9E }, { '贝飞特 迪布达6x6', 0XB6410173 }, { '长崎 不法之徒', 0X185E2FF3 }, { '长崎 水陆烈焰骑士', 0XA1355F67 }, { '长崎 火辣烈焰', 0XB44F0582 }, { '长崎 烈焰', 0X8125BCF9 }, { '长崎 烈焰救生型', 0XFD231729 }, { '长崎 街头烈焰', 0XE5BA6858 }, { '雪佛 马绍尔', 0X49863E9C }, { '麦克斯韦 流浪者', 0X2C1FEA99 } }
vehicleHashes_Open_Wheel = { { '培罗 PR4', 0X1446590A }, { '欧斯洛 R88', 0X8B213907 }, { '绝致 DR1', 0X4669D038 }, { '贝飞特 BR8', 0X58F77553 } }
vehicleHashes_Planes = { { 'B-11突击部队', 0X64DE07A1 }, { 'LF-22星椋', 0X9A9EB7DE }, { 'P-45诺克塔', 0X3DC92356 }, { 'P-996天煞', 0XB39B0AE6 }, { 'RM-10邦布什卡', 0XFE0A508C }, { 'RO-86阿尔科诺斯特', 0XEA313705 }, { 'V-65莫洛托克', 0X5D56F01B }, { '原子飞艇', 0XF7004C86 }, { '古邦800', 0XD9927FE3 }, { '喷气机', 0X3F119114 }, { '天行巨兽', 0X97E55D11 }, { '巨象 九头蛇', 0X39D6E83F }, { '巨象 嘟嘟鸟', 0XCA495705 }, { '巨象 图拉', 0X3E2E4F8A }, { '巨象 复仇者', 0X81BD2ED0 }, { '巨象 复仇者', 0X18606535 }, { '巨象 莫古尔', 0XD35698EF }, { '希罗飞艇', 0XDB6B4924 }, { '梅杜莎', 0X9C429B6A }, { '梅杜莎5座', 0X403820E8 }, { '沃拉托', 0X1AAD0DED }, { '泰坦号', 0X761E2AD3 }, { '洒药机', 0X39D6779E }, { '白金汉 乐梭', 0X250B0C5E }, { '白金汉 乐梭豪华版', 0XB79F589E }, { '白金汉 军用喷气机', 0X9D80F93 }, { '白金汉 夏玛尔客机', 0XB79C1BF5 }, { '白金汉 威斯特拉', 0X4FF77E37 }, { '白金汉 灵气号', 0XB2CF7250 }, { '白金汉 狂焰', 0XAD6065C0 }, { '白金汉 阿尔法-Z1', 0XA52F6866 }, { '白金汉 霍华德NX-25', 0XC3F25753 }, { '西部 恶徒', 0XC5DD6967 }, { '西部 海风', 0XE8983F9F }, { '西部 雀鹰', 0X6CBD1D6D }, { '货机', 0X15F27762 }, { '野鸭', 0X81794C70 }, { '长崎 鸿毛', 0X96E24857 }, { '飞艇', 0XEDA4ED97 } }
vehicleHashes_Sedans = { { '亚班尼 初代', 0XBB6B404F }, { '亚班尼 初代改装版', 0X86618EDA }, { '亚班尼 华盛顿', 0X69F06B57 }, { '亚班尼 皇霸天', 0X8FC3AADC }, { '亚班尼 皇霸天', 0XB5FCF74E }, { '亚班尼 皇霸天', 0XD7278283 }, { '兰帕达缇 五千', 0XA4F52C13 }, { '卡林 入侵者', 0X34DD8AA1 }, { '卡林 爱硕普', 0X8E9254FB }, { '埃努斯 斯塔福德', 0X1324E960 }, { '埃努斯 神灵', 0X5B531351 }, { '埃努斯 至尊慧眼 (装甲版)', 0XDBF2D57A }, { '埃努斯 至尊慧眼', 0X86FE0B60 }, { '埃努斯 至尊慧眼55 (装甲版)', 0X29FCD3E4 }, { '埃努斯 至尊慧眼55', 0X360A438E }, { '埃努斯 金钻耀星', 0X42F2ED16 }, { '奥北 密探', 0XC3DDFDCE }, { '奥北 密探S', 0XB5D306A4 }, { '威皮 史塔尼亚', 0XA7EDE74D }, { '敦追里 加长型礼车', 0X8B13F083 }, { '敦追里 女皇', 0XFF22D208 }, { '烈火马 钢骨灵车', 0X2560B2FC }, { '福狮 守护星', 0X51D83328 }, { '福狮 守护星HKR', 0X2290C50A }, { '福狮 英卡特', 0XB3206692 }, { '绝致 海致', 0X94204D89 }, { '绝致 海致', 0X9441D8D5 }, { '绝致 统领', 0X8FB66F9B }, { '贝飞特 格伦戴尔', 0X47A6BC1 }, { '贝飞特 格伦戴尔改装版', 0XC98BBAD6 }, { '贝飞特 武装礼车', 0XF92AEC4D }, { '贝飞特 莎夫特', 0XB52B5113 }, { '贝飞特 莎夫特V12 (装甲版)', 0XCB0E7CD9 }, { '贝飞特 长轴莎夫特 (装甲版)', 0X72934BE4 }, { '赛柯尼 地层先锋', 0X66B4FC45 }, { '雪佛 奔腾', 0X8F0E3594 }, { '雪佛 流星', 0X71CB2FFB } }
vehicleHashes_Service = { { 'MTL 布里凯德', 0XEDC6F847 }, { 'MTL 拓荒者', 0X8E08EC82 }, { 'MTL 沙丘', 0X829A3C44 }, { '出租车', 0XC703DB5F }, { '垃圾大王', 0X72435A19 }, { '垃圾大王', 0XB527915C }, { '巴士', 0XD577C962 }, { '机场巴士', 0X4C80EB0E }, { '白狗巴士', 0X84718D34 }, { '租用穿梭巴士', 0XBE819C63 }, { '观光巴士', 0X73B1C3CB }, { '音乐节巴士', 0X149BD32A } }
vehicleHashes_Sports = { { '丁卡 RT3000', 0XE505CF99 }, { '丁卡 冲冲猴旅行家', 0XDCBC1C3B }, { '丁卡 小型旅行家', 0X3DEE5EDA }, { '丁卡 弄臣 (赛车)', 0XBE0E6126 }, { '丁卡 弄臣', 0XB2A716A3 }, { '丁卡 弄臣RR', 0XA1B3A871 }, { '丁卡 弄臣经典版', 0XF330CB6A }, { '丁卡 微托现代版', 0XA703E4A9 }, { '丁卡 微托经典版', 0XCCE5C8FA }, { '丁卡 斯国一', 0X3ADB9758 }, { '亚班尼 V-STR', 0X56CDEE7D }, { '亚班尼 阿尔法', 0X2DB8D1AA }, { '傲弗拉 明日', 0XBC7C0A00 }, { '兰帕达缇 沸洛雷GT', 0XBF1691E0 }, { '兰帕达缇 科莫达', 0XCE44C4B9 }, { '兰帕达缇 逐波雷厉', 0X707E63A4 }, { '冒险家 女妖', 0XC1E908D2 }, { '冒险家 猛牛', 0XEDD516C6 }, { '冒险家 猛牛S', 0X2BEC3CBE }, { '冒险家 迷失者', 0X41B77FA4 }, { '冒险家 霜碧猛牛', 0XE2C013E }, { '卡林 卡利科GTF', 0XB8D657AD }, { '卡林 王者', 0X39DA2754 }, { '卡林 王者RS经典版', 0XEEA75E63 }, { '卡林 王者经典版', 0X3404691C }, { '卡林 福多', 0X7836CE2F }, { '卡林 福多GTX', 0XA6297CC8 }, { '卡林 骷髅马 (装甲版)', 0X187D938D }, { '卡林 骷髅马', 0XAE2BFE94 }, { '古罗帝 义塔力GTO', 0XEC3E3404 }, { '古罗帝 义塔力RSX', 0XBB78956A }, { '古罗帝 汗血宝马', 0X7B8AB45F }, { '古罗帝 野兽GTS', 0X4BFCF28B }, { '埃努斯 帕拉贡R (装甲版)', 0X546D8EEE }, { '埃努斯 帕拉贡R', 0XE550775B }, { '奥北 8F尾随者', 0X28EAB80F }, { '奥北 9F', 0X3D8FA25C }, { '奥北 9F敞篷版', 0XA8E38B01 }, { '奥北 奥姆尼斯', 0XD1AD4937 }, { '威尼 天威跑车版', 0X6E8DA4F7 }, { '威皮 GB200', 0X71CBEA98 }, { '威皮 闪电GT', 0XB4F32118 }, { '旋风 雷电', 0XA4D99B7D }, { '欧斯洛 山猫', 0X1CBDC10B }, { '欧斯洛 扼喉', 0XF38C4245 }, { '欧斯洛 放逐者', 0X33B98FE2 }, { '欧斯洛 蝗虫', 0XC7E55211 }, { '毕福 迅猛龙', 0XD7C56D39 }, { '浪子 幽鬼', 0X706E2B40 }, { '浪子 幽鬼改装版', 0X400F5147 }, { '浪子 柒-70', 0X97398A4B }, { '浪子 疾速GT', 0X679450AF }, { '浪子 疾速GT', 0X8CB29A14 }, { '浪子 马萨克罗 (赛车)', 0XDA5819A3 }, { '浪子 马萨克罗', 0XF77ADE32 }, { '海岬 变色龙', 0X206D1B68 }, { '海岬 拉斯顿', 0X2AE524A8 }, { '爱尼仕 ZR350', 0X91373058 }, { '爱尼仕 挽歌RH8', 0XDE3D9D22 }, { '爱尼仕 挽歌怀旧改装版', 0XBBA2261 }, { '爱尼仕 末日ZR380', 0X20314B42 }, { '爱尼仕 梦魇ZR380', 0XA7DCC35C }, { '爱尼仕 欧洲', 0X7980BDD5 }, { '爱尼仕 科幻ZR380', 0XBE11EFC6 }, { '爱尼仕 雷姆斯', 0X5216AD5E }, { '皇霸天 韦柯特', 0XA42FC3A5 }, { '绝品 卫士经典版', 0X41D149AA }, { '绝品 反叛者', 0XE78CC3D9 }, { '绝品 塞弗', 0X68A5D1EF }, { '绝致 漂移坦帕', 0XC0240885 }, { '绝致 燃轨军刀', 0X42836BE5 }, { '维沙 尼欧', 0X9F6ED5A2 }, { '菲斯特 嚎叫者', 0X4DC079D7 }, { '菲斯特 彗星狩猎者', 0X5D1903F9 }, { '菲斯特 陆上彗星', 0XC1AE4D16 }, { '菲斯特 陆上彗星S2', 0X991EFC04 }, { '菲斯特 陆上彗星S2敞篷版', 0X440851D8 }, { '菲斯特 陆上彗星SR', 0X276D98A3 }, { '菲斯特 陆上彗星怀旧改装版', 0X877358AD }, { '菲斯特 霓虹', 0X91CA96EE }, { '贝飞特 撞击GT', 0XE1C03AB0 }, { '贝飞特 斯垂特', 0X67D2B389 }, { '贝飞特 施瓦兹', 0XD37B7976 }, { '贝飞特 莎夫特V12', 0XA774B5A6 }, { '贝飞特 速雷', 0X16E478C1 }, { '贝飞特 长轴莎夫特', 0X58CF185C }, { '贝飞特 飞特者', 0X8911B9F5 }, { '赛乐斯特 眩光', 0X1DC0BA53 }, { '非凡 艳妇', 0X67BC037 }, { '非凡 艳妇D10', 0X98F65A5E }, { '麦霸子 半影使者', 0XE9805550 }, { '麦霸子 半影使者FF', 0XDA5EC7DA } }
vehicleHashes_Sports_Classic = { { '亚班尼 明日之星', 0X81634188 }, { '亚班尼 科学怪人', 0XCE6B35A4 }, { '亚班尼 罗斯福', 0X6FF6914 }, { '亚班尼 罗斯福勇气', 0XDC19D101 }, { '佩嘉西 图拉尔多', 0X56C8A5EF }, { '佩嘉西 斗牛', 0X59A9E570 }, { '佩嘉西 炼狱魔经典版', 0XAC33179C }, { '佩嘉西 门罗', 0XE62B361B }, { '兰帕达缇 卡斯科', 0X3822BDFE }, { '兰帕达缇 皮卡乐', 0X404B6381 }, { '兰帕达缇 米其利GT', 0X3E5BD8D9 }, { '兰帕达缇 维瑟瑞斯', 0XE8A8BA94 }, { '卡林 190z', 0X3201DD49 }, { '卢恩 切布列克', 0XC514AAE0 }, { '古罗帝 GT500', 0X8408F33A }, { '古罗帝 史汀格', 0X5C23AF9B }, { '古罗帝 史汀格GT', 0X82E499FA }, { '古罗帝 猎豹经典版', 0XD4E5F4D }, { '古罗帝 远途经典版', 0XC575DF11 }, { '威尼 王朝', 0X127E90D5 }, { '威皮 佩优特', 0X6D19CCBC }, { '威皮 佩优特改装版', 0X4201A843 }, { '威皮 随行者 Mk 2', 0X79178F0A }, { '威皮 随行者', 0X6DBD6C0A }, { '欧斯洛 放荡者', 0X1DD4C0FF }, { '欧斯洛 斯特龙伯格', 0X34DBA661 }, { '欧斯洛 炽焰', 0X97E5533 }, { '浪子 JB700', 0X3EAB5555 }, { '浪子 JB700W', 0X177DA45C }, { '浪子 疾速GT经典版', 0X7A2EF5E4 }, { '爱尼仕 萨维斯特拉', 0X35DED0DD }, { '特卢菲 Z型', 0X2D3BD401 }, { '福狮 星云涡轮', 0XCB642637 }, { '福狮 法加洛亚', 0X6068AD86 }, { '绝品 天堂经典版', 0X6F039A67 }, { '绝致 曼巴', 0X9CFFFC56 }, { '绝致 龙卷风', 0X5B42A5C4 }, { '绝致 龙卷风', 0X690A4153 }, { '绝致 龙卷风', 0X86CF7CDD }, { '绝致 龙卷风', 0X1BB290BC }, { '绝致 龙卷风改装版', 0X94DA98EF }, { '绝致 龙卷风破烂老爷车', 0XA31CB573 }, { '英庞提 德罗索', 0X586765FB }, { '贝飞特 斯特林GT', 0XA29D6D10 }, { '非凡 艳妇经典版', 0X3C4E2113 } }
vehicleHashes_Super = { { '义警', 0XB5EF4C33 }, { '佩嘉西 伊格纳斯', 0XA9EC907B }, { '佩嘉西 佐路索', 0XD757D97D }, { '佩嘉西 奥西里斯', 0X767164D6 }, { '佩嘉西 桑托劳', 0XAC5DF515 }, { '佩嘉西 死神', 0XDF381E5 }, { '佩嘉西 泰泽拉克', 0X3D7C6410 }, { '佩嘉西 炼狱魔', 0X18F25AC7 }, { '佩嘉西 狂牛', 0X142E0DC3 }, { '佩嘉西 风暴', 0X1044926F }, { '傲弗拉 捷诺', 0X2714AA93 }, { '傲弗拉 本质XF', 0XB2FE5CF9 }, { '傲弗拉 本质XXR', 0X8198AEDC }, { '傲弗拉 独裁者', 0XED552C74 }, { '傲弗拉 统治者', 0XE99011C2 }, { '兰帕达缇 虎狮兽', 0XAF0B8D48 }, { '冒险家 女妖900R', 0X25C5AF13 }, { '卡林 王者RS', 0XEE6024BC }, { '古罗帝 X80原型', 0X7E8F677F }, { '古罗帝 幻象', 0XC4810400 }, { '古罗帝 狂热', 0X3944D5A0 }, { '古罗帝 猎豹', 0XB1D95DA0 }, { '古罗帝 远途R', 0X185484E1 }, { '培罗 GP1', 0X4992196C }, { '培罗 T20', 0X6322B39A }, { '培罗 义塔力GTB', 0X85E8E76B }, { '培罗 义塔力GTB改装版', 0XE33A477B }, { '培罗 泰勒斯', 0X7B406EFB }, { '培罗 艾梅鲁斯', 0X4EE74355 }, { '威皮 FMJ', 0X5502626C }, { '威皮 子弹', 0X9AE6DDA1 }, { '旋风 火箭狂雷', 0X3AF76F4A }, { '旋风 狂雷', 0X9F4B77BE }, { '旋风 飓风', 0X52FF9437 }, { '普林西比 蹂躏者8', 0X5EE005DA }, { '欧斯洛 XA-21', 0X36B4A8A9 }, { '欧斯洛 穿刺者', 0X9734F3EA }, { '浪子 冠军', 0XC972A155 }, { '浪子 瓦格纳', 0X7397224C }, { '爱尼仕 RE-7B', 0XB6846A55 }, { '爱尼仕 S80RR', 0XECA6B6A3 }, { '特卢菲 尼罗', 0X3DA47243 }, { '特卢菲 尼罗改装版', 0X4131F378 }, { '特卢菲 灵蛇', 0XB779A091 }, { '特卢菲 特拉克斯', 0X3E3D1F59 }, { '皇霸天 ETR1', 0X30D3F6D8 }, { '绝品 SC1', 0X5097F589 }, { '绝致 超燃', 0XD9F0503D }, { '菲斯特 811', 0X92EF6E04 }, { '贝飞特 武夫', 0XD86A0247 }, { '雪佛 泰斑', 0XBC5DC07E } }
vehicleHashes_SUVs = { { '亚班尼 骑兵', 0X779F23AA }, { '亚班尼 骑兵', 0XD0EB2BE5 }, { '佩嘉西 奔牛', 0XBA5334AC }, { '兰帕达缇 诺瓦克', 0X92F5024E }, { '冒险家 情欲猎手', 0XA3FC0F4D }, { '卡尼斯 炎魔', 0XD36A4B44 }, { '卡尼斯 炎魔', 0X36848602 }, { '卡尼斯 陆上专家', 0X48CECED3 }, { '卡尼斯 陆上专家边境', 0X94114926 }, { '卡林 碧杰XL', 0X32B29A4B }, { '埃努斯 亨特利S', 0X1D06D681 }, { '埃努斯 吉伯力', 0X1B8165D3 }, { '奥北 小辣椒', 0X7F5C91F1 }, { '奥北 爱瓦根', 0X27816B7E }, { '威皮 争夺者', 0X28B67ACA }, { '威皮 辐光', 0X9D96B45B }, { '巨象 列兵', 0XF9E67C05 }, { '巨象 爱国者', 0XCFCFEB3B }, { '巨象 爱国者加长型', 0XE6E967F8 }, { '悠游行者 行者', 0X8852855 }, { '悠游行者 行者', 0XCFCA3668 }, { '悠游行者 行者LE (装甲版)', 0X1C09CF5E }, { '悠游行者 行者LE', 0X6FF0F727 }, { '悠游行者 行者ST', 0X1573422D }, { '悠游行者 长轴行者LE (装甲版)', 0X27B4E6B0 }, { '悠游行者 长轴行者LE', 0X25CBE2E2 }, { '敦追里 追捕者', 0X4BA4E8DC }, { '敦追里 追捕者XL', 0XCE0B9F22 }, { '深水 FQ2', 0XBC32A33B }, { '皇霸天 哈拔尼禄', 0X34B7390F }, { '绝品 瑞巴 GTS', 0X4F48FC4 }, { '绝致 屌王', 0X9628879C }, { '绝致 屌王3600LX', 0XF06C29C7 }, { '菲斯特 宇航', 0X258C9364 }, { '贝飞特 XLS (装甲版)', 0XE6401328 }, { '贝飞特 XLS', 0X47BBCF2E }, { '贝飞特 瑟雷诺', 0X4FB1A214 }, { '贝飞特 迪布达', 0X462FE277 }, { '贝飞特 迪布达', 0XE882E5F6 } }
vehicleHashes_Trains = { { '缆车', 0XC6C3242D }, { '货运列车', 0X3D6AAA9B }, { '货运列车', 0XAFD22A6 }, { '货运列车', 0XE512E79 }, { '货运列车', 0XBDEC3D99 }, { '货运列车', 0X22EDDC30 }, { '货运列车', 0X264D9262 }, { '货运列车', 0X33C9E158 }, { '货运列车', 0X36DCFF98 } }
vehicleHashes_Utility = { { 'HVY 叉车', 0X58E49664 }, { '公共事业卡车', 0X7F2153DF }, { '公共事业卡车', 0X1ED0A534 }, { '公共事业卡车', 0X34E6BF6B }, { '军用拖车', 0X9E6B14D6 }, { '军用拖车', 0XA7FF33F5 }, { '军用拖车', 0XB8081009 }, { '割草车', 0X6A4BD8F6 }, { '威皮 大满贯卡车', 0XC1A8A914 }, { '威皮 沙德勒', 0XDC434E51 }, { '威皮 沙德勒', 0X2BC345D1 }, { '拖吊车', 0XB12314E0 }, { '拖吊车', 0XE5A2D6C6 }, { '拖船', 0X1F3D44B5 }, { '拖车', 0X3CC7F596 }, { '拖车', 0X6A59902D }, { '拖车', 0X74998082 }, { '拖车', 0X782A236D }, { '拖车', 0X7BE032C6 }, { '拖车', 0X7CAB34D0 }, { '拖车', 0X806EFBEE }, { '拖车', 0X8548036D }, { '拖车', 0X967620BE }, { '拖车', 0XA1DA3C91 }, { '拖车', 0XAF62F6B2 }, { '拖车', 0XBE66F5AA }, { '拖车', 0XCBB2BE0E }, { '拖车', 0XD1ABB666 }, { '拖车', 0X153E1B0A }, { '拖车', 0XD46F4737 }, { '拖车', 0X174CB172 }, { '拖车', 0X2A72BEAB }, { '斯坦利 农耕机', 0X562A97BD }, { '斯坦利 农耕机', 0X843B73DE }, { '机动作战中心', 0X5993F939 }, { '机场牵引车', 0XCD935EF9 }, { '码头拖车', 0XCB44B1CA }, { '老式拖拉机', 0X61D6BA8C }, { '草捆拖车', 0XE82AE656 }, { '行李拖车', 0X5D0AAC8F }, { '高尔夫球车', 0X44623884 }, { '高尔夫球车', 0XD227BDBB }, { '高尔夫球车', 0XDFF0594C } }
vehicleHashes_Vans = { { '冒险家 天堂', 0X58B3979C }, { '冒险家 游侠', 0X3E5F6B8 }, { '冒险家 游侠经典四驱车', 0X6B73A9BE }, { '冒险家 游侠经典版', 0X3D29CD2B }, { '冒险家 澜波', 0X4543B74D }, { '冒险家 澜波', 0X961AFEF7 }, { '冒险家 澜波改装版', 0X57F682AF }, { '冒险家 野牛', 0X67B3F020 }, { '冒险家 野牛', 0X7B8297C5 }, { '冒险家 野牛', 0XFEFD644F }, { '厢村', 0XF21B33BE }, { '威皮 劲速', 0XCFB3870C }, { '威皮 劲速改装版', 0XD17099D }, { '威皮 小丑花车', 0X2B6DC64A }, { '威皮 游侠改装版', 0X589A840C }, { '威皮 迷你厢型车', 0XED7EADA4 }, { '威皮 迷你厢型车改装版', 0XBCDE91F0 }, { '威皮 雄猫XL', 0X3FC5D440 }, { '威霸 厢村', 0X7405E08 }, { '威霸 厢村', 0X898ECCEA }, { '威霸 厢村', 0X1A79847A }, { '威霸 小马', 0XF8DE29A8 }, { '威霸 小马', 0X38408341 }, { '威霸 露营车', 0X6FD95F68 }, { '废五金回收车', 0X9A9FD3DF }, { '毕福 乘风', 0XB1D80E06 }, { '毕福 乘风', 0X29B0DA97 }, { '玉米饼餐车', 0X744CA80D }, { '绝致 屌客', 0X437CF2A0 }, { '绝致 屌客', 0X98171BD3 }, { '绝致 屌客', 0XAFBB2CA4 }, { '绝致 屌客', 0X353B561D }, { '绝致 屌客帮派版', 0X97FA4F36 }, { '绝致 屌客帮派版', 0X11AA0E14 }, { '绝致 除虫大师屌客', 0XC9E8FF76 }, { '装甲版厢村', 0X28AD20E1 }, { '赛柯尼 安旅者', 0XF8D48E7A } }
local Vehicle_Spawn = Vehicle_Function:add_submenu('生成载具')
Vehicle_Spawn:add_toggle('使用高级自定义设定', function()
	return Vehicle_Spawn_Adv_Custom_Setting
end, function(customSetting)
	Vehicle_Spawn_Adv_Custom_Setting = not Vehicle_Spawn_Adv_Custom_Setting
end)
function Spawn_Vehicle(model)
	local position = localplayer:get_position()
	globals.set_int(2725269 + 2, 1)
	globals.set_uint(2725269 + 5, 1)
	globals.set_uint(2725269 + 27, 1)
	if Vehicle_Spawn_Custom_Plate_text then
		globals.set_string(2725269 + 27 + 1, PLATE_TEXT, 100) -- EHICLE_NUMBER_PLATE_TEXT 车牌号
	end
	if Vehicle_Spawn_Adv_Custom_Setting then
		::Vehicle_Spawn_Adv_Setting::
		globals.set_uint(2725269 + 27 + 5, 255) -- VEHICLE_PRIMARY_COLOR 主色调
		globals.set_uint(2725269 + 27 + 6, 255) -- VEHICLE_SECONDARY_COLOR 副色调
		globals.set_uint(2725269 + 27 + 7, 255) -- VEHICLE_EXTRA_COLOURS 额外色调
		globals.set_int(2725269 + 27 + 8, 255)
		globals.set_int(2725269 + 27 + 10, 5)
		globals.set_int(2725269 + 27 + 12, 4)
		globals.set_int(2725269 + 27 + 13, 8)
		globals.set_int(2725269 + 27 + 14, 6)
		globals.set_int(2725269 + 27 + 15, 3)
		globals.set_int(2725269 + 27 + 16, 4)
		globals.set_int(2725269 + 27 + 17, 13)
		globals.set_int(2725269 + 27 + 18, 8)
		globals.set_int(2725269 + 27 + 19, 5)
		globals.set_int(2725269 + 27 + 20, 255)
		globals.set_int(2725269 + 27 + 21, 3)
		globals.set_int(2725269 + 27 + 22, 6)
		globals.set_int(2725269 + 27 + 23, 10)
		globals.set_int(2725269 + 27 + 24, -1)
		globals.set_uint(2725269 + 27 + 59, 2)
		globals.set_int(2725269 + 27 + 62, 255)
		globals.set_int(2725269 + 27 + 63, 0)
		globals.set_int(2725269 + 27 + 64, 0)
		globals.set_int(2725269 + 27 + 65, 2)
		globals.set_uint(2725269 + 27 + 67, 1)
		globals.set_uint(2725269 + 27 + 69, 0)
		globals.set_uint(2725269 + 27 + 27, 1)
		globals.set_uint(2725269 + 27 + 74, 255) -- VEHICLE_NEON_LIGHTS_COLOUR 氙气车灯颜色
		globals.set_uint(2725269 + 27 + 75, 255)
		globals.set_uint(2725269 + 27 + 76, 255)
		globals.set_uint(2725269 + 27 + 68, 1) -- GET_CONVERTIBLE_ROOF_STATE 车顶状态
		globals.set_int(2725269 + 27 + 77, 0xF0400000) -- CAR OPTIONS
		globals.set_uint(2725269 + 27 + 96, 1)
		globals.set_uint(2725269 + 27 + 97, 1)
		globals.set_uint(2725269 + 27 + 98, 0)
		globals.set_uint(2725269 + 27 + 99, 255)
	end
	globals.set_uint(2725269 + 27 + 70, 0) -- VEHICLE_DOOR_LOCK_STATUS (If it is not 0, you cant enter the vehicle). 车门
	globals.set_int(2725269 + 27 + 66, model)
	globals.set_float(2725269 + 7, position.x + 5) -- Position X
	globals.set_float(2725269 + 7 + 1, position.y + 5) -- Position Y
	globals.set_float(2725269 + 7 + 2, -255)
end
do
	Vehicle_Spawn_Boats = Vehicle_Spawn:add_submenu('船')
	for i = 1, #vehicleHashes_Boats do
		local model = vehicleHashes_Boats[i][1]
		local hash = vehicleHashes_Boats[i][2]
		Vehicle_Spawn_Boats:add_action(model, function()
			Spawn_Vehicle(hash)
		end)
	end
	Vehicle_Spawn_Commercials = Vehicle_Spawn:add_submenu('商用车')
	for i = 1, #vehicleHashes_Commercials do
		local model = vehicleHashes_Commercials[i][1]
		local hash = vehicleHashes_Commercials[i][2]
		Vehicle_Spawn_Commercials:add_action(model, function()
			Spawn_Vehicle(hash)
		end)
	end
	Vehicle_Spawn_Compacts = Vehicle_Spawn:add_submenu('小型汽车')
	for i = 1, #vehicleHashes_Compacts do
		local model = vehicleHashes_Compacts[i][1]
		local hash = vehicleHashes_Compacts[i][2]
		Vehicle_Spawn_Compacts:add_action(model, function()
			Spawn_Vehicle(hash)
		end)
	end
	Vehicle_Spawn_Coupes = Vehicle_Spawn:add_submenu('轿跑车')
	for i = 1, #vehicleHashes_Coupes do
		local model = vehicleHashes_Coupes[i][1]
		local hash = vehicleHashes_Coupes[i][2]
		Vehicle_Spawn_Coupes:add_action(model, function()
			Spawn_Vehicle(hash)
		end)
	end
	Vehicle_Spawn_Cycles = Vehicle_Spawn:add_submenu('自行车')
	for i = 1, #vehicleHashes_Cycles do
		local model = vehicleHashes_Cycles[i][1]
		local hash = vehicleHashes_Cycles[i][2]
		Vehicle_Spawn_Cycles:add_action(model, function()
			Spawn_Vehicle(hash)
		end)
	end
	Vehicle_Spawn_Emergency = Vehicle_Spawn:add_submenu('特种车')
	for i = 1, #vehicleHashes_Emergency do
		local model = vehicleHashes_Emergency[i][1]
		local hash = vehicleHashes_Emergency[i][2]
		Vehicle_Spawn_Emergency:add_action(model, function()
			Spawn_Vehicle(hash)
		end)
	end
	Vehicle_Spawn_Helicopters = Vehicle_Spawn:add_submenu('直升机')
	for i = 1, #vehicleHashes_Helicopters do
		local model = vehicleHashes_Helicopters[i][1]
		local hash = vehicleHashes_Helicopters[i][2]
		Vehicle_Spawn_Helicopters:add_action(model, function()
			Spawn_Vehicle(hash)
		end)
	end
	Vehicle_Spawn_Industrial = Vehicle_Spawn:add_submenu('工业用车')
	for i = 1, #vehicleHashes_Industrial do
		local model = vehicleHashes_Industrial[i][1]
		local hash = vehicleHashes_Industrial[i][2]
		Vehicle_Spawn_Industrial:add_action(model, function()
			Spawn_Vehicle(hash)
		end)
	end
	Vehicle_Spawn_Military = Vehicle_Spawn:add_submenu('军用车')
	for i = 1, #vehicleHashes_Military do
		local model = vehicleHashes_Military[i][1]
		local hash = vehicleHashes_Military[i][2]
		Vehicle_Spawn_Military:add_action(model, function()
			Spawn_Vehicle(hash)
		end)
	end
	Vehicle_Spawn_Motorcycles = Vehicle_Spawn:add_submenu('摩托车')
	for i = 1, #vehicleHashes_Motorcycles do
		local model = vehicleHashes_Motorcycles[i][1]
		local hash = vehicleHashes_Motorcycles[i][2]
		Vehicle_Spawn_Motorcycles:add_action(model, function()
			Spawn_Vehicle(hash)
		end)
	end
	Vehicle_Spawn_Muscle = Vehicle_Spawn:add_submenu('肌肉车')
	for i = 1, #vehicleHashes_Muscle do
		local model = vehicleHashes_Muscle[i][1]
		local hash = vehicleHashes_Muscle[i][2]
		Vehicle_Spawn_Muscle:add_action(model, function()
			Spawn_Vehicle(hash)
		end)
	end
	Vehicle_Spawn_Off_Road = Vehicle_Spawn:add_submenu('越野车')
	for i = 1, #vehicleHashes_Off_Road do
		local model = vehicleHashes_Off_Road[i][1]
		local hash = vehicleHashes_Off_Road[i][2]
		Vehicle_Spawn_Off_Road:add_action(model, function()
			Spawn_Vehicle(hash)
		end)
	end
	Vehicle_Spawn_Open_Wheel = Vehicle_Spawn:add_submenu('开轮式')
	for i = 1, #vehicleHashes_Open_Wheel do
		local model = vehicleHashes_Open_Wheel[i][1]
		local hash = vehicleHashes_Open_Wheel[i][2]
		Vehicle_Spawn_Open_Wheel:add_action(model, function()
			Spawn_Vehicle(hash)
		end)
	end
	Vehicle_Spawn_Planes = Vehicle_Spawn:add_submenu('飞机')
	for i = 1, #vehicleHashes_Planes do
		local model = vehicleHashes_Planes[i][1]
		local hash = vehicleHashes_Planes[i][2]
		Vehicle_Spawn_Planes:add_action(model, function()
			Spawn_Vehicle(hash)
		end)
	end
	Vehicle_Spawn_Sedans = Vehicle_Spawn:add_submenu('轿车')
	for i = 1, #vehicleHashes_Sedans do
		local model = vehicleHashes_Sedans[i][1]
		local hash = vehicleHashes_Sedans[i][2]
		Vehicle_Spawn_Sedans:add_action(model, function()
			Spawn_Vehicle(hash)
		end)
	end
	Vehicle_Spawn_Service = Vehicle_Spawn:add_submenu('服务用车')
	for i = 1, #vehicleHashes_Service do
		local model = vehicleHashes_Service[i][1]
		local hash = vehicleHashes_Service[i][2]
		Vehicle_Spawn_Service:add_action(model, function()
			Spawn_Vehicle(hash)
		end)
	end
	Vehicle_Spawn_SUVs = Vehicle_Spawn:add_submenu('SUV')
	for i = 1, #vehicleHashes_SUVs do
		local model = vehicleHashes_SUVs[i][1]
		local hash = vehicleHashes_SUVs[i][2]
		Vehicle_Spawn_SUVs:add_action(model, function()
			Spawn_Vehicle(hash)
		end)
	end
	Vehicle_Spawn_Sports = Vehicle_Spawn:add_submenu('跑车')
	for i = 1, #vehicleHashes_Sports do
		local model = vehicleHashes_Sports[i][1]
		local hash = vehicleHashes_Sports[i][2]
		Vehicle_Spawn_Sports:add_action(model, function()
			Spawn_Vehicle(hash)
		end)
	end
	Vehicle_Spawn_Sports_Classic = Vehicle_Spawn:add_submenu('经典跑车')
	for i = 1, #vehicleHashes_Sports_Classic do
		local model = vehicleHashes_Sports_Classic[i][1]
		local hash = vehicleHashes_Sports_Classic[i][2]
		Vehicle_Spawn_Sports_Classic:add_action(model, function()
			Spawn_Vehicle(hash)
		end)
	end
	Vehicle_Spawn_Super = Vehicle_Spawn:add_submenu('超级跑车')
	for i = 1, #vehicleHashes_Super do
		local model = vehicleHashes_Super[i][1]
		local hash = vehicleHashes_Super[i][2]
		Vehicle_Spawn_Super:add_action(model, function()
			Spawn_Vehicle(hash)
		end)
	end
	Vehicle_Spawn_Utility = Vehicle_Spawn:add_submenu('公众事业用车')
	for i = 1, #vehicleHashes_Utility do
		local model = vehicleHashes_Utility[i][1]
		local hash = vehicleHashes_Utility[i][2]
		Vehicle_Spawn_Utility:add_action(model, function()
			Spawn_Vehicle(hash)
		end)
	end
	Vehicle_Spawn_Vans = Vehicle_Spawn:add_submenu('厢型车')
	for i = 1, #vehicleHashes_Vans do
		local model = vehicleHashes_Vans[i][1]
		local hash = vehicleHashes_Vans[i][2]
		Vehicle_Spawn_Vans:add_action(model, function()
			Spawn_Vehicle(hash)
		end)
	end
end
-- World Function
World_Function:add_action('允许非公开战局任务', function()
	globals.set_int(2714635 + 744, 0) -- NETWORK::NETWORK_SESSION_GET_PRIVATE_SLOTS
end)
local toggled1 = false
World_Function:add_toggle('移除CEO板条箱冷却', function()
	return toggled1
end, function(e)
	toggled1 = not toggled1
	if e then
		globals.set_int(262145 + 15361, 0)
		globals.set_int(262145 + 15362, 0)
	end
	if not e then
		globals.set_int(262145 + 15361, 300000) -- Buy
		globals.set_int(262145 + 15362, 1800000) -- Sell
	end
end)
local toggled2 = false
World_Function:add_toggle('移除CEO载具货物冷却', function()
	return toggled2
end, function(e)
	toggled2 = not toggled2
	if e then
		globals.set_int(262145 + 19477, 0)
		globals.set_int(262145 + 19478, 0)
		globals.set_int(262145 + 19479, 0)
		globals.set_int(262145 + 19480, 0)
	end
	if not e then
		globals.set_int(262145 + 19477, 1200000) -- 1 Vehicle
		globals.set_int(262145 + 19478, 1680000) -- 2 Vehicles
		globals.set_int(262145 + 19479, 2340000) -- 3 Vehicles
		globals.set_int(262145 + 19480, 2880000) -- 4 Vehicles
	end
end)
local toggled3 = false
World_Function:add_toggle('移除空运货物冷却', function()
	return toggled3
end, function(e)
	toggled3 = not toggled3
	if e then
		globals.set_int(262145 + 22522, 0)
		globals.set_int(262145 + 22523, 0)
		globals.set_int(262145 + 22524, 0)
		globals.set_int(262145 + 22525, 0)
		globals.set_int(262145 + 22561, 0)
	end
	if not e then
		globals.set_int(262145 + 22522, 120000) -- Tobacco, Counterfeit Goods
		globals.set_int(262145 + 22523, 180000) -- Animal Materials, Art, Jewelry
		globals.set_int(262145 + 22524, 240000) -- Narcotics, Chemicals, Medical Supplies
		globals.set_int(262145 + 22525, 60000) -- Additional Time per Player
		globals.set_int(262145 + 22561, 180000) -- Sale
	end
end)
local toggled4 = false
World_Function:add_toggle('移除恐霸任务冷却', function()
	return toggled4
end, function(e)
	toggle4 = not toggled4
	if e then
		globals.set_int(262145 + 24304, 0)
		globals.set_int(262145 + 24305, 0)
		globals.set_int(262145 + 24306, 0)
		globals.set_int(262145 + 24307, 0)
		globals.set_int(262145 + 24308, 0)
	end
	if not e then
		globals.set_int(262145 + 24304, 300000) -- Between Jobs
		globals.set_int(262145 + 24305, 1800000) -- Robbery in Progress
		globals.set_int(262145 + 24306, 1800000) -- Data Sweep
		globals.set_int(262145 + 24307, 1800000) -- Targeted Data
		globals.set_int(262145 + 24308, 1800000) -- Diamond Shopping
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
local toggled5 = false
World_Function:add_toggle('冻结 NPC', function()
	return toggled5
end, function(e)
	toggled5 = not toggled5
	if not localplayer then
		return nil
	end
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
	if not localplayer then
		return nil
	end
	for p in replayinterface.get_peds() do
		if p == localplayer then
			goto continue
		end
		p:set_max_health(150)
		p:set_health(150)
		::continue::
	end
end)
World_Function:add_action('削弱全部 NPC', function()
	for p in replayinterface.get_peds() do
		if p == nil or p:get_pedtype() < 4 then
			goto continue
		end
		p:set_infinite_ammo(false)
		p:set_wallet(2000)
		p:set_run_speed(0.3)
		for w in p:get_all_weapon_hashes() do
			p:set_weapon_enabled(w, false)
		end
		::continue::
	end
end)
-- Teleport Function
local NIGHTCLUB_TELE = Teleport_Function:add_submenu('夜总会')
NIGHTCLUB_TELE:add_action('夜总会保险柜', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(-1615.6827392578, -3015.6813964844, -75.205070495605))
end)
local HU_JING_TELE = Teleport_Function:add_submenu('虎鲸')
HU_JING_TELE:add_action('驾驶座位', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(1560.303, 381.718, -49.685))
end)
HU_JING_TELE:add_action('导弹控制座位', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(1559.726, 388.009, -49.685))
end)
HU_JING_TELE:add_action('麻雀停机坪 (主甲板)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(1563.830, 409.712, -49.667))
end)
HU_JING_TELE:add_action('个人空间', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(1558.518, 383.137, -53.284))
end)
HU_JING_TELE:add_action('武器工作室', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(1561.609, 381.089, -56.088))
end)
HU_JING_TELE:add_action('出口 1', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(1563.479, 371.470, -49.685))
end)
HU_JING_TELE:add_action('出口 2', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(1561.433, 391.197, -49.685))
end)
HU_JING_TELE:add_action('出口 3', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(1564.593, 447.083, -53.129))
end)
local LSC_DLC_TELE = Teleport_Function:add_submenu('洛圣都车友会')
LSC_DLC_TELE:add_action('车友会入口', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(782.597, -1867.812, 29.253))
end)
LSC_DLC_TELE:add_action('车友会内部', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(-2148.729, 1137.968, -24.371))
end)
LSC_DLC_TELE:add_action('测试赛道', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(-2025.252, 1115.701, -27.761))
end)
LSC_BANG = Teleport_Function:add_submenu('媒体记忆棒')
LSC_BANG:add_action('赌场楼顶露台', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(955.550, 50.059, 112.553))
end)
LSC_BANG:add_action('车友会角落', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(-2172.616, 1159.674, -24.372))
end)
LSC_BANG:add_action('夜总会办公室', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(-1619.068, -3010.602, -75.205))
end)
LSC_BANG:add_action('游戏厅吧台', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(2727.082, -387.540, -48.993))
end)
local UKN_HELPSRKL = Teleport_Function:add_submenu('连环杀手')
UKN_HELPSRKL:add_action('线索 1 - 血手印', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(-678.9984, 5797.6851, 17.3309))
end)
UKN_HELPSRKL:add_action('线索 2 - 砍刀', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(1901.4042, 4911.5479, 48.6951))
end)
UKN_HELPSRKL:add_action('线索 3 - 断手', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(1111.7750, 3142.0457, 38.4241))
end)
UKN_HELPSRKL:add_action('线索 4 -信件', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(-136.5509, 1912.8038, 197.2982))
end)
local UKN_HELPSRKLC = UKN_HELPSRKL:add_submenu('线索 5 - 黑色面包车')
UKN_HELPSRKLC:add_action('线索5 - 地点 1', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(2576.0391, 1251.7494, 43.6099))
end)
UKN_HELPSRKLC:add_action('线索5 - 地点 2', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(2903.4150, 3644.0413, 43.8774))
end)
UKN_HELPSRKLC:add_action('线索5 - 地点 3', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(2432.3904, 5846.0757, 58.8891))
end)
UKN_HELPSRKLC:add_action('线索5 - 地点 4', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(-1567.880, 4424.6104, 7.2154))
end)
UKN_HELPSRKLC:add_action('线索5 - 地点 5', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(-1715.793, 2618.7686, 2.9409))
end)
local UKN_KBBL_TELE = Teleport_Function:add_submenu('Kenny\'s Backyard Boogie 专辑')
UKN_KBBL_TELE:add_action('Kenny\'s Backyard Boogie - 地点 1', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(-2163.025, 1083.473, -24.362))
end)
UKN_KBBL_TELE:add_action('Kenny\'s Backyard Boogie - 地点 2', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(-2180.532, 1082.276, -24.367))
end)
UKN_KBBL_TELE:add_action('Kenny\'s Backyard Boogie - 地点 3', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(-2162.992, 1089.790, -24.363))
end)
UKN_KBBL_TELE:add_action('Kenny\'s Backyard Boogie - 地点 4', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(-2162.770, 1115.913, -24.371))
end)
-- Recovery Function
Recovery_Function:add_action('附近 Ped 掉落 ($2000)', function()
	local position = localplayer:get_position()
	position.z = position.z + 10
	for p in replayinterface.get_peds() do
		if not p or p == localplayer then
			goto continue
		end
		if p:get_pedtype() < 4 then
			goto continue
		end
		if p:is_in_vehicle() then
			goto continue
		end
		p:set_position(position)
		p:set_freeze_momentum(true)
		p:set_wallet(2000)
		p:set_health(0)
		sleep(0.5)
		::continue::
	end
end)
Recovery_Function:add_action('生成 Ped 掉落 ($2000)', function()
	if not localplayer then
		return nil
	end
	local position = localplayer:get_position()
	globals.set_uint(2783351, 1)
	globals.set_int(2783345 + 1, 2000)
	globals.set_float(2783345 + 3, position.x)
	globals.set_float(2783345 + 4, position.y)
	globals.set_float(2783345 + 5, position.z + 5)
	globals.set_uint(4528329 + 1 + (globals.get_int(2783345) * 85) + 66 + 2, 2)
	sleep(1)
end)
Recovery_Function:add_action('移除交易进行中错误', function()
	if globals.get_int(4529836) == 20 or globals.get_int(4529836) == 4 then
		globals.set_int(4529830, 0)
	end
end)
Recovery_Function:add_action('填满夜总会保险箱', function()
	globals.set_int(262145 + 22853, 133377)
	globals.set_int(262145 + 23814, 300000) -- KEEP AT 300000 OR YOU WILL NEED TO DELETE & RE-MAKE YOUR CHARACTER, IT WILL BUG THE NIGHTCLUB SAFE!
	globals.set_int(262145 + 23810, 300000) -- KEEP AT 300000 OR YOU WILL NEED TO DELETE & RE-MAKE YOUR CHARACTER, IT WILL BUG THE NIGHTCLUB SAFE!
	stat_set_int('CLUB_POPULARITY', true, 10000)
	stat_set_int('CLUB_PAY_TIME_LEFT', true, -1)
	stat_set_int('CLUB_POPULARITY', true, 100000)
	sleep(5)
end)
Recovery_Function:add_action('天基炮退款 $50w', function()
	globals.set_int(1964179, 1)
	sleep(5)
	globals.set_int(1964179, 0)
end)
Recovery_Function:add_action('天基炮退款 $75w', function()
	globals.set_int(1964179, 2)
	sleep(5)
	globals.set_int(1964179, 0)
end)
Recovery_Function:add_action('清除被杀记录', function()
	stat_set_int('ARCHENEMY_KILLS', true, 0)
	stat_set_int('ARCHENEMY_KILLS', true, 0)
	stat_set_int('DEATHS', true, 0)
	stat_set_int('DEATHS', true, 0)
	stat_set_int('DIED_IN_EXPLOSION', true, 0)
	stat_set_int('DIED_IN_EXPLOSION', true, 0)
	stat_set_int('DIED_IN_FALL', true, 0)
	stat_set_int('DIED_IN_FALL', true, 0)
	stat_set_int('DIED_IN_FIRE', true, 0)
	stat_set_int('DIED_IN_FIRE', true, 0)
	stat_set_int('DIED_IN_ROAD', true, 0)
	stat_set_int('DIED_IN_ROAD', true, 0)
	stat_set_int('DIED_IN_DROWNING', true, 0)
	stat_set_int('DIED_IN_DROWNING', true, 0)
end)
Recovery_Function:add_action('移除赌场筹码冷却', function()
	if stats.get_int('MPPLY_CASINO_CHIPS_PUR_GD') ~= 0 then
		stat_set_int('MPPLY_CASINO_CHIPS_PUR_GD', true, 0)
	end
end)
Recovery_Function:add_action('移除收支差', function()
	local a = stats.get_int(PlayerMP .. '_MONEY_SPENT_WEAPON_ARMOR')
	a = a + stats.get_int(PlayerMP .. '_MONEY_SPENT_VEH_MAINTENANCE')
	a = a + stats.get_int(PlayerMP .. '_MONEY_SPENT_STYLE_ENT')
	a = a + stats.get_int(PlayerMP .. '_MONEY_SPENT_PROPERTY_UTIL')
	a = a + stats.get_int(PlayerMP .. '_MONEY_SPENT_JOB_ACTIVITY')
	a = a + stats.get_int(PlayerMP .. '_MONEY_SPENT_CONTACT_SERVICE')
	a = a + stats.get_int(PlayerMP .. '_MONEY_SPENT_HEALTHCARE')
	a = a + stats.get_int(PlayerMP .. '_MONEY_SPENT_DROPPED_STOLEN')
	a = a + stats.get_int(PlayerMP .. '_MONEY_SPENT_SHARED')
	a = a + stats.get_int(PlayerMP .. '_MONEY_SPENT_JOBSHARED')
	local b = stats.get_int(PlayerMP .. '_MONEY_EARN_JOBS')
	b = b + stats.get_int(PlayerMP .. '_MONEY_EARN_SELLING_VEH')
	b = b + stats.get_int(PlayerMP .. '_MONEY_EARN_BETTING')
	b = b + stats.get_int(PlayerMP .. '_MONEY_EARN_GOOD_SPORT')
	b = b + stats.get_int(PlayerMP .. '_MONEY_EARN_PICKED_UP')
	b = b + stats.get_int(PlayerMP .. '_MONEY_EARN_SHARED')
	b = b + stats.get_int(PlayerMP .. '_MONEY_EARN_JOBSHARED')
	if a > b then
		local m = a - b
		stat_set_int('MONEY_EARN_JOBSHARED', true, stats.get_int(PlayerMP .. '_MONEY_EARN_JOBSHARED') + m)
	end
end)
-- Misc Function
local SCENE_CUT = Misc_Function:add_submenu('过场动画')
SCENE_CUT:add_action('跳过过场动画', function()
	menu.end_cutscene()
end)
-- Heist Control
-- Edit from 2Take1 Heist-Control-v2 lua by jhowkNx
local PERICO_HEIST = Heist_Control:add_submenu('佩里科岛')
local CAYO_AUTO_PRST = PERICO_HEIST:add_submenu('预设 (进入分红界面后也须点击一次)')
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
local CASINO_PRESETS = CASINO_HEIST:add_submenu('预设 (进入分红界面后也须点击一次)')
local CAH_DIA_TARGET = CASINO_PRESETS:add_submenu('钻石 $350w 1-4 人')
local CAH_GOLD_TARGET = CASINO_PRESETS:add_submenu('黄金 $350w 1-4 人')
local CAH_ADVCED = CASINO_HEIST:add_submenu('高级功能')
local CASINO_BOARD1 = CASINO_HEIST:add_submenu('抢劫计划板 (第一块)')
local BOARD1_APPROACH = CASINO_BOARD1:add_submenu('选择抢劫方式和难度')
local CASINO_TARGET = CASINO_BOARD1:add_submenu('选择主要目标')
local CASINO_BOARD2 = CASINO_HEIST:add_submenu('抢劫计划板 (第二块)')
local CASINO_BOARD3 = CASINO_HEIST:add_submenu('抢劫计划板 (第三块)')
local CAH_MISSION_MANAGER = CASINO_HEIST:add_submenu('贝克女士任务')
--
local DOOMS_HEIST = Heist_Control:add_submenu('末日抢劫')
local DOOMS_PRESETS = DOOMS_HEIST:add_submenu('预设 (进入分红界面后也须点击一次)')
local DDHEIST_PLYR_MANAGER = DOOMS_HEIST:add_submenu('玩家分红')
local TELEPORT_DOOMS = DOOMS_HEIST:add_submenu('传送地点')
--
local CLASSIC_HEISTS = Heist_Control:add_submenu('公寓老抢劫 (进入分红界面后也须点击一次)')
local CLASSIC_CUT = CLASSIC_HEISTS:add_submenu('你的分红 (作为房主时使用)')
local CLASSIC_M_GAME = CLASSIC_HEISTS:add_submenu('小游戏破解')
--
local TH_CONTRACT = Heist_Control:add_submenu('事务所合约 (进入分红界面后也须点击一次)')
local LS_ROBBERY = Heist_Control:add_submenu('改装铺合约 (进入分红界面后也须点击一次)')
local Heist_Inspector = Heist_Control:add_submenu('抢劫检测')
local TOOLS = Heist_Control:add_submenu('工具')
local MINI_GAME_TOOL = TOOLS:add_submenu('小游戏破解')
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
	local stat = PlayerMP .. '_' .. KOS
	local stat_result = stats.get_int(stat)
	if not stat_result then
		stat_result = 0
	end
	--
	local stat = PlayerMP .. '_' .. STB
	local stat_result_0 = stats.get_int(stat)
	if not stat_result_0 then
		stat_result_0 = 0
	end
	--
	local stat = PlayerMP .. '_' .. SMG
	local stat_result_1 = stats.get_int(stat)
	if not stat_result_1 then
		stat_result_1 = 0
	end
	--
	local stat = PlayerMP .. '_' .. STE
	local stat_result_2 = stats.get_int(stat)
	if not stat_result_2 then
		stat_result_2 = 0
	end
	--
	local stat = PlayerMP .. '_' .. KTT
	local stat_result_3 = stats.get_int(stat)
	if not stat_result_3 then
		stat_result_3 = 0
	end
	--
	local stat = PlayerMP .. '_' .. LNG
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
	local stat = PlayerMP .. '_' .. PAN_
	local Answer_0 = stats.get_int(stat)
	if not Answer_0 then
		Answer_0 = 0
	end
	--
	local stat = PlayerMP .. '_' .. MAZ_
	local Answer_1 = stats.get_int(stat)
	if not Answer_1 then
		Answer_1 = 0
	end
	--
	local stat = PlayerMP .. '_' .. PDD_
	local Answer_2 = stats.get_int(stat)
	if not Answer_2 then
		Answer_2 = 0
	end
	--
	local stat = PlayerMP .. '_' .. BON_
	local Answer_3 = stats.get_int(stat)
	if not Answer_3 then
		Answer_3 = 0
	end
	--
	local stat = PlayerMP .. '_' .. NCK_
	local Answer_4 = stats.get_int(stat)
	if not Answer_4 then
		Answer_4 = 0
	end
	--
	local stat = PlayerMP .. '_' .. TQL_
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
	local stat = PlayerMP .. '_' .. CPL
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
EDIT_HI:add_action('该功能暂时不可用', function()
end)
EDIT_HI:add_int_range('修改佩里克岛抢劫次数', 1, 0, 9999999, function()
	return stats.get_int(PlayerMP .. '_H4_PLAYTHROUGH_STATUS')
end, function(ME)
	stats.set_int(PlayerMP .. '_H4_PLAYTHROUGH_STATUS', ME)
end)
EDIT_HI:add_int_range('修改虎鲸次数', 1, 0, 9999999, function()
	return stats.get_int(PlayerMP .. '_CR_SUBMARINE')
end, function(ME)
	stats.set_int(PlayerMP .. '_CR_SUBMARINE', ME)
end)
EDIT_HI:add_int_range('修改阿尔科诺斯特次数', 1, 0, 9999999, function()
	return stats.get_int(PlayerMP .. '_CR_STRATEGIC_BOMBER')
end, function(ME)
	stats.set_int(PlayerMP .. '_CR_STRATEGIC_BOMBER', ME)
end)
EDIT_HI:add_int_range('修改梅杜莎次数', 1, 0, 9999999, function()
	return stats.get_int(PlayerMP .. '_CR_SMUGGLER_PLANE')
end, function(ME)
	stats.set_int(PlayerMP .. '_CR_SMUGGLER_PLANE', ME)
end)
EDIT_HI:add_int_range('修改隐型直升机次数', 1, 0, 9999999, function()
	return stats.get_int(PlayerMP .. '_CR_STEALTH_HELI')
end, function(ME)
	stats.set_int(PlayerMP .. '_CR_STEALTH_HELI', ME)
end)
EDIT_HI:add_int_range('修改巡逻艇次数', 1, 0, 9999999, function()
	return stats.get_int(PlayerMP .. '_CR_PATROL_BOAT')
end, function(ME)
	stats.set_int(PlayerMP .. '_CR_PATROL_BOAT', ME)
end)
EDIT_HI:add_int_range('修改长崎次数', 1, 0, 9999999, function()
	return stats.get_int(PlayerMP .. '_CR_SMUGGLER_BOAT')
end, function(ME)
	stats.set_int(PlayerMP .. '_CR_SMUGGLER_BOAT', ME)
end)
EDIT_HI:add_int_range('修改猎豹雕像次数', 1, 0, 9999999, function()
	return stats.get_int(PlayerMP .. '_CR_SAPHIREPANSTAT')
end, function(ME)
	stats.set_int(PlayerMP .. '_CR_SAPHIREPANSTAT', ME)
end)
EDIT_HI:add_int_range('修改玛德拉索文件次数', 1, 0, 9999999, function()
	return stats.get_int(PlayerMP .. '_CR_MADRAZO_FILES')
end, function(ME)
	stats.set_int(PlayerMP .. '_CR_MADRAZO_FILES', ME)
end)
EDIT_HI:add_int_range('修改粉钻次数', 1, 0, 9999999, function()
	return stats.get_int(PlayerMP .. '_CR_PINK_DIAMOND')
end, function(ME)
	stats.set_int(PlayerMP .. '_CR_PINK_DIAMOND', ME)
end)
EDIT_HI:add_int_range('修改不记名债券次数', 1, 0, 9999999, function()
	return stats.get_int(PlayerMP .. '_CR_BEARER_BONDS')
end, function(ME)
	stats.set_int(PlayerMP .. '_CR_BEARER_BONDS', ME)
end)
EDIT_HI:add_int_range('修改红宝石项链次数', 1, 0, 9999999, function()
	return stats.get_int(PlayerMP .. '_CR_PEARL_NECKLACE')
end, function(ME)
	stats.set_int(PlayerMP .. '_CR_PEARL_NECKLACE', ME)
end)
EDIT_HI:add_int_range('修改西西米托龙舌兰酒次数', 1, 0, 9999999, function()
	return stats.get_int(PlayerMP .. '_CR_TEQUILA')
end, function(ME)
	stats.set_int(PlayerMP .. '_CR_TEQUILA', ME)
end)
-- CAYO CUSTOM TELEPORT
TELEPORT_QL:add_action('虎鲸 :: 内部面板 [请先呼叫虎鲸]', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(1561.224, 386.659, -49.685))
end)
TELEPORT_QL:add_action('虎鲸 :: 主甲板 [请先呼叫虎鲸]', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(1563.218, 406.030, -49.667))
end)
TELEPORT_QL:add_action('排水管道 :: 入口 (切割格栅处)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5044.726, -5816.164, -11.213))
end)
TELEPORT_QL:add_action('排水管道 :: 入口 (二次检查点)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5054.630, -5771.519, -4.807))
end)
TELEPORT_QL:add_action('主要目标 :: 房间', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5007.895, -5755.581, 15.484))
end)
TELEPORT_QL:add_action('次要目标 :: 房间', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5003.467, -5749.352, 14.840))
end)
TELEPORT_QL:add_action('办公室 :: 金库/保险柜', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5010.753, -5757.639, 28.845))
	localplayer:set_rotation(vector3(2, 0, 0))
end)
TELEPORT_QL:add_action('豪宅 :: 大门出口', function()
	if not localplayer then
		return nil
	end
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
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5047.394, -5820.962, -12.447))
end)
TELEPORTMANSIONO:add_action('豪宅外部大门入口', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(4972.337, -5701.617, 19.887))
end)
TELEPORTMANSIONO:add_action('豪宅外部北墙', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5041.111, -5675.523, 19.292))
end)
TELEPORTMANSIONO:add_action('豪宅外部北大门入口', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5086.59, -5730.8, 15.773))
end)
TELEPORTMANSIONO:add_action('豪宅外部南墙', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(4987.32, -5819.869, 19.548))
end)
TELEPORTMANSIONO:add_action('豪宅外部南大门入口', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(4958.965, -5785.213, 20.839))
end)
--
TELEPORTLOOT:add_action('机场控制塔', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(4374.47, -4577.694, 4.208))
end)
TELEPORTLOOT:add_action('机场发电站', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(4478.387, -4591.498, 5.568))
end)
TELEPORTLOOT:add_action('机场逃离点', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(4493.552, -4472.608, 4.212))
end)
TELEPORTLOOT:add_action('机场次要目标 (下层)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(4437.678, -4449.029, 4.328))
end)
TELEPORTLOOT:add_action('机场次要目标 (上层)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(4445.451, -4444.368, 7.237))
end)
TELEPORTLOOT:add_action('机场其他次要目标', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(4503.399, -4552.043, 4.161))
end)
TELEPORTLOOT:add_action('北码头安全位置', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5064.167, -4587.988, 2.988))
end)
TELEPORTLOOT:add_action('北码头次要目标 (1)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5065.108, -4592.708, 2.855))
end)
TELEPORTLOOT:add_action('北码头次要目标 (2)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5134.84, -4609.992, 2.529))
end)
TELEPORTLOOT:add_action('北码头次要目标 (3)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5090.356, -4682.487, 2.407))
end)
TELEPORTLOOT:add_action('大麻地次要目标', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5331.424, -5269.504, 33.186))
end)
TELEPORTLOOT:add_action('加工区次要目标', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5193.133, -5134.256, 3.345))
end)
TELEPORTLOOT:add_action('主码头安全位置', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(4847.7, -5325.062, 15.017))
end)
TELEPORTLOOT:add_action('主码头次要目标 (1)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(4923.587, -5242.541, 2.523))
end)
TELEPORTLOOT:add_action('主码头次要目标 (2)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(4998.355, -5165.41, 2.764))
end)
TELEPORTLOOT:add_action('主码头次要目标 (3)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(4961.247, -5109.312, 2.982))
end)
TELEPORTLOOT:add_action('通信塔第一层 (底层)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5270.362, -5422.213, 65.579))
end)
TELEPORTLOOT:add_action('通信塔第二层', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5262.419, -5428.451, 90.724))
end)
TELEPORTLOOT:add_action('通信塔第三层', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5263.550, -5428.477, 109.148))
end)
TELEPORTLOOT:add_action('通信塔第四层 (顶层)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5266.207, -5427.754, 141.047))
end)
--
TELEPORTMANSIONI:add_action('豪宅办公室', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5008.106, -5752.442, 28.845))
end)
TELEPORTMANSIONI:add_action('豪宅地下室主要目标', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5007.573, -5754.908, 15.484))
end)
TELEPORTMANSIONI:add_action('豪宅地下室次要目标', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5001.469, -5747.327, 14.84))
end)
TELEPORTMANSIONI:add_action('豪宅次要目标房间 (1)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5084.015, -5758.132, 15.83))
end)
TELEPORTMANSIONI:add_action('豪宅次要目标房间 (2)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5009.42, -5790.591, 17.832))
end)
TELEPORTMANSIONI:add_action('豪宅次要目标房间 (3)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5031.386, -5737.249, 17.866))
end)
TELEPORTMANSIONI:add_action('豪宅出口大门', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(4986.727, -5723.624, 19.88))
end)
TELEPORTMANSIONI:add_action('豪宅出口北墙', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5024.82, -5682.374, 19.877))
end)
TELEPORTMANSIONI:add_action('豪宅出口南墙', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(4998.833, -5801.947, 20.877))
end)
TELEPORTMANSIONI:add_action('豪宅出口北门', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5084.957, -5739.043, 15.677))
end)
TELEPORTMANSIONI:add_action('豪宅出口南门', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(4967.008, -5783.731, 20.878))
end)
--
TELEPORTCHESTS:add_action('陆地藏宝箱 (1)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5176.394, -4678.343, 2.427))
end)
TELEPORTCHESTS:add_action('陆地藏宝箱 (2)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(4855.533, -5561.123, 27.534))
end)
TELEPORTCHESTS:add_action('陆地藏宝箱 (3)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(4877.224, -4781.618, 2.068))
end)
TELEPORTCHESTS:add_action('陆地藏宝箱 (4)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5591.956, -5215.923, 14.351))
end)
TELEPORTCHESTS:add_action('陆地藏宝箱 (5)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5458.669, -5860.041, 19.973))
end)
TELEPORTCHESTS:add_action('陆地藏宝箱 (6)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(4855.781, -5163.507, 2.439))
end)
TELEPORTCHESTS:add_action('陆地藏宝箱 (7)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(3898.093, -4710.935, 4.771))
end)
TELEPORTCHESTS:add_action('陆地藏宝箱 (8)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(4822.828, -4322.015, 5.617))
end)
TELEPORTCHESTS:add_action('陆地藏宝箱 (9)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(4535.064, -4702.882, 2.431))
end)
TELEPORTCHESTS:add_action('陆地藏宝箱 (10)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(4179.426, -4358.279, 2.686))
end)
TELEPORTCHESTS:add_action('海洋藏宝箱 (1)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(4415.093, -4653.384, -4.172))
end)
TELEPORTCHESTS:add_action('海洋藏宝箱 (2)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(4560.742, -4355.47, -7.187))
end)
TELEPORTCHESTS:add_action('海洋藏宝箱 (3)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5262.87, -4919.246, -1.878))
end)
TELEPORTCHESTS:add_action('海洋藏宝箱 (4)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(4561.338, -4768.874, -2.167))
end)
TELEPORTCHESTS:add_action('海洋藏宝箱 (5)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(4943.188, -4294.895, -5.481))
end)
TELEPORTCHESTS:add_action('海洋藏宝箱 (6)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(5599.706, -5604.149, -5.064))
end)
TELEPORTCHESTS:add_action('海洋藏宝箱 (7)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(3982.371, -4542.297, -5.194))
end)
TELEPORTCHESTS:add_action('海洋藏宝箱 (8)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(4775.263, -5394.031, -4.116))
end)
TELEPORTCHESTS:add_action('海洋藏宝箱 (9)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(4940.111, -5167.373, -2.564))
end)
-- DOOMSDAY CUSTOM TELEPORT
TELEPORT_DOOMS:add_action('设施 :: 抢劫计划室', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(343.97885131836, 4864.76953125, -60.004898071289))
end)
TELEPORT_DOOMS:add_action('末日一 :: IAA基地', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(2051.454102, 2937.856201, 46.412567))
end)
TELEPORT_DOOMS:add_action('末日一 :: 作战室', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(2066.660645, 2991.692383, -67.501999))
end)
TELEPORT_DOOMS:add_action('末日二 :: 拍照屏幕', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(515.528, 4835.353, -62.587))
end)
TELEPORT_DOOMS:add_action('末日二 :: 囚犯牢房', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(512.888, 4833.033, -68.989))
end)
TELEPORT_DOOMS:add_action('末日二 :: 复仇者', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(-970.208191, 6216.608398, 2.252363))
end)

do
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
	local QUICK_SET_ANY = { { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
	{ 'H4CNF_BS_GEN', 262143 }, { 'H4CNF_BS_ENTR', 63 }, { 'H4CNF_BS_ABIL', 63 }, { 'H4CNF_WEP_DISRP', 3 }, { 'H4CNF_ARM_DISRP', 3 }, { 'H4CNF_HEL_DISRP', 3 }, { 'H4CNF_BOLTCUT', 4424 }, { 'H4CNF_UNIFORM', 5256 }, { 'H4CNF_GRAPPEL', 5156 }, { 'H4CNF_APPROACH', -1 }, { 'H4LOOT_CASH_I', 0 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_WEED_I', 0 }, { 'H4LOOT_WEED_C', 0 }, { 'H4LOOT_COKE_I', 0 }, { 'H4LOOT_COKE_C', 0 }, { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_C', 0 }, { 'H4LOOT_PAINT', 0 }, { 'H4LOOT_CASH_V', 0 }, { 'H4LOOT_COKE_V', 0 }, { 'H4LOOT_GOLD_V', 0 }, { 'H4LOOT_PAINT_V', 0 }, { 'H4LOOT_WEED_V', 0 }, { 'H4LOOT_CASH_I_SCOPED', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_WEED_I_SCOPED', 0 }, { 'H4LOOT_WEED_C_SCOPED', 0 }, { 'H4LOOT_COKE_I_SCOPED', 0 }, { 'H4LOOT_COKE_C_SCOPED', 0 }, { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C_SCOPED', 0 }, { 'H4LOOT_PAINT_SCOPED', 0 }, { 'H4CNF_TARGET', 5 }, { 'H4CNF_WEAPONS', 5 }, { 'H4_MISSIONS', -1 }, { 'H4_PROGRESS', 126823 } }
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
	local WEAKLY_QUICK = { { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
	{ 'H4CNF_BS_GEN', 262143 }, { 'H4CNF_BS_ENTR', 63 }, { 'H4CNF_BS_ABIL', 63 }, { 'H4CNF_WEP_DISRP', 3 }, { 'H4CNF_ARM_DISRP', 3 }, { 'H4CNF_HEL_DISRP', 3 }, { 'H4CNF_BOLTCUT', 4424 }, { 'H4CNF_UNIFORM', 5256 }, { 'H4CNF_GRAPPEL', 5156 }, { 'H4CNF_APPROACH', -1 }, { 'H4LOOT_CASH_I', 0 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_WEED_I', 0 }, { 'H4LOOT_WEED_C', 0 }, { 'H4LOOT_COKE_I', 0 }, { 'H4LOOT_COKE_C', 0 }, { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_C', 0 }, { 'H4LOOT_PAINT', 0 }, { 'H4LOOT_CASH_V', 0 }, { 'H4LOOT_COKE_V', 0 }, { 'H4LOOT_GOLD_V', 0 }, { 'H4LOOT_PAINT_V', 0 }, { 'H4LOOT_WEED_V', 0 }, { 'H4LOOT_CASH_I_SCOPED', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_WEED_I_SCOPED', 0 }, { 'H4LOOT_WEED_C_SCOPED', 0 }, { 'H4LOOT_COKE_I_SCOPED', 0 }, { 'H4LOOT_COKE_C_SCOPED', 0 }, { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C_SCOPED', 0 }, { 'H4LOOT_PAINT_SCOPED', 0 }, { 'H4CNF_TARGET', 5 }, { 'H4CNF_WEAPONS', 4 }, { 'H4_MISSIONS', -1 }, { 'H4_PROGRESS', 126823 } }
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
	local AUTOMATED_1P_TARGET_5 = { { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
	{ 'H4CNF_TARGET', 5 }, { 'H4LOOT_CASH_I', 8128 }, { 'H4LOOT_CASH_I_SCOPED', 8128 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_COKE_I', 63 }, { 'H4LOOT_COKE_I_SCOPED', 63 }, { 'H4LOOT_COKE_C', 22 }, { 'H4LOOT_COKE_C_SCOPED', 22 }, { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C', 168 }, { 'H4LOOT_GOLD_C_SCOPED', 168 }, { 'H4LOOT_WEED_I', 16769024 }, { 'H4LOOT_WEED_I_SCOPED', 16769024 }, { 'H4LOOT_WEED_C', 65 }, { 'H4LOOT_WEED_C_SCOPED', 65 }, { 'H4LOOT_PAINT', 127 }, { 'H4LOOT_PAINT_SCOPED', 127 }, { 'H4LOOT_CASH_V', 207386 }, { 'H4LOOT_COKE_V', 414772 }, { 'H4LOOT_GOLD_V', 553029 }, { 'H4LOOT_PAINT_V', 414772 }, { 'H4LOOT_WEED_V', 331818 }, --
	{ 'H4_PROGRESS', 126823 }, { 'H4CNF_BS_GEN', -1 }, { 'H4CNF_BS_ENTR', -1 }, { 'H4CNF_BS_ABIL', -1 }, { 'H4CNF_WEP_DISRP', 3 }, { 'H4CNF_ARM_DISRP', 3 }, { 'H4CNF_HEL_DISRP', 3 }, { 'H4CNF_APPROACH', -1 } }
	local AUTOMATED_1P_TARGET_5_A = { { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
	{ 'H4CNF_BOLTCUT', 4424 }, { 'H4CNF_UNIFORM', 5256 }, { 'H4CNF_GRAPPEL', 5156 }, { 'H4_MISSIONS', -1 }, { 'H4CNF_WEAPONS', 4 }, { 'H4CNF_TROJAN', 5 } }
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
	local CAYO_SOLO_AUTO_TARGET_3 = { { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
	{ 'H4CNF_TARGET', 3 }, { 'H4LOOT_CASH_I', 63 }, { 'H4LOOT_CASH_I_SCOPED', 63 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_COKE_I', 16769024 }, { 'H4LOOT_COKE_I_SCOPED', 16769024 }, { 'H4LOOT_COKE_C', 22 }, { 'H4LOOT_COKE_C_SCOPED', 22 }, { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C', 168 }, { 'H4LOOT_GOLD_C_SCOPED', 168 }, { 'H4LOOT_WEED_I', 8128 }, { 'H4LOOT_WEED_I_SCOPED', 8128 }, { 'H4LOOT_WEED_C', 65 }, { 'H4LOOT_WEED_C_SCOPED', 65 }, { 'H4LOOT_PAINT', 127 }, { 'H4LOOT_PAINT_SCOPED', 127 }, { 'H4LOOT_CASH_V', 357386 }, { 'H4LOOT_COKE_V', 714772 }, { 'H4LOOT_GOLD_V', 953029 }, { 'H4LOOT_PAINT_V', 714772 }, { 'H4LOOT_WEED_V', 571818 }, --
	{ 'H4_PROGRESS', 126823 }, { 'H4CNF_BS_GEN', 262143 }, { 'H4CNF_BS_ENTR', 63 }, { 'H4CNF_BS_ABIL', 63 }, { 'H4CNF_WEP_DISRP', 3 }, { 'H4CNF_ARM_DISRP', 3 }, { 'H4CNF_HEL_DISRP', 3 }, { 'H4CNF_APPROACH', -1 } }
	local USER_CAN_MDFY_PRESET_AUTO_SOLO_T3 = { { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
	{ 'H4CNF_BOLTCUT', 4424 }, { 'H4CNF_UNIFORM', 5256 }, { 'H4CNF_GRAPPEL', 5156 }, { 'H4_MISSIONS', -1 }, { 'H4CNF_WEAPONS', 4 }, { 'H4CNF_TROJAN', 5 } }
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
	local AUTOMATED_2P_TARGET_5 = { { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
	{ 'H4CNF_TARGET', 5 }, { 'H4LOOT_CASH_I', 8128 }, { 'H4LOOT_CASH_I_SCOPED', 8128 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_COKE_I', 63 }, { 'H4LOOT_COKE_I_SCOPED', 63 }, { 'H4LOOT_COKE_C', 22 }, { 'H4LOOT_COKE_C_SCOPED', 22 }, { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C', 168 }, { 'H4LOOT_GOLD_C_SCOPED', 168 }, { 'H4LOOT_WEED_I', 16769024 }, { 'H4LOOT_WEED_I_SCOPED', 16769024 }, { 'H4LOOT_WEED_C', 65 }, { 'H4LOOT_WEED_C_SCOPED', 65 }, { 'H4LOOT_PAINT', 127 }, { 'H4LOOT_PAINT_SCOPED', 127 }, { 'H4LOOT_CASH_V', 457386 }, { 'H4LOOT_COKE_V', 914772 }, { 'H4LOOT_GOLD_V', 1219696 }, { 'H4LOOT_PAINT_V', 914772 }, { 'H4LOOT_WEED_V', 731818 }, --
	{ 'H4_PROGRESS', 126823 }, { 'H4CNF_BS_GEN', 262143 }, { 'H4CNF_BS_ENTR', 63 }, { 'H4CNF_BS_ABIL', 63 }, { 'H4CNF_WEP_DISRP', 3 }, { 'H4CNF_ARM_DISRP', 3 }, { 'H4CNF_HEL_DISRP', 3 }, { 'H4CNF_APPROACH', -1 } }
	local AUTOMATED_2P_TARGET_5_A = { { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
	{ 'H4CNF_BOLTCUT', 4424 }, { 'H4CNF_UNIFORM', 5256 }, { 'H4CNF_GRAPPEL', 5156 }, { 'H4_MISSIONS', -1 }, { 'H4CNF_WEAPONS', 4 }, { 'H4CNF_TROJAN', 5 } }
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
	local AUTOMATED_2_TARGET_3 = { { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
	{ 'H4CNF_TARGET', 3 }, { 'H4LOOT_CASH_I', 63 }, { 'H4LOOT_CASH_I_SCOPED', 63 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_COKE_I', 16769024 }, { 'H4LOOT_COKE_I_SCOPED', 16769024 }, { 'H4LOOT_COKE_C', 22 }, { 'H4LOOT_COKE_C_SCOPED', 22 }, { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C', 168 }, { 'H4LOOT_GOLD_C_SCOPED', 168 }, { 'H4LOOT_WEED_I', 8128 }, { 'H4LOOT_WEED_I_SCOPED', 8128 }, { 'H4LOOT_WEED_C', 65 }, { 'H4LOOT_WEED_C_SCOPED', 65 }, { 'H4LOOT_PAINT', 127 }, { 'H4LOOT_PAINT_SCOPED', 127 }, { 'H4LOOT_CASH_V', 532386 }, { 'H4LOOT_COKE_V', 1064772 }, { 'H4LOOT_GOLD_V', 1419696 }, { 'H4LOOT_PAINT_V', 1064772 }, { 'H4LOOT_WEED_V', 851818 }, { 'H4_PROGRESS', 126823 }, { 'H4CNF_BS_GEN', 262143 }, { 'H4CNF_BS_ENTR', 63 }, { 'H4CNF_BS_ABIL', 63 }, { 'H4CNF_WEP_DISRP', 3 }, { 'H4CNF_ARM_DISRP', 3 }, { 'H4CNF_HEL_DISRP', 3 }, { 'H4CNF_APPROACH', -1 } }
	local AUTOMATED_2_TARGET_3_A = { { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
	{ 'H4CNF_BOLTCUT', 4424 }, { 'H4CNF_UNIFORM', 5256 }, { 'H4CNF_GRAPPEL', 5156 }, { 'H4_MISSIONS', -1 }, { 'H4CNF_WEAPONS', 4 }, { 'H4CNF_TROJAN', 5 } }
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
	local AUTOMATED_3P_TARGET_5 = { { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
	{ 'H4CNF_TARGET', 5 }, { 'H4LOOT_CASH_I', 8128 }, { 'H4LOOT_CASH_I_SCOPED', 8128 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_COKE_I', 63 }, { 'H4LOOT_COKE_I_SCOPED', 63 }, { 'H4LOOT_COKE_C', 22 }, { 'H4LOOT_COKE_C_SCOPED', 22 }, { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C', 168 }, { 'H4LOOT_GOLD_C_SCOPED', 168 }, { 'H4LOOT_WEED_I', 16769024 }, { 'H4LOOT_WEED_I_SCOPED', 16769024 }, { 'H4LOOT_WEED_C', 65 }, { 'H4LOOT_WEED_C_SCOPED', 65 }, { 'H4LOOT_PAINT', 127 }, { 'H4LOOT_PAINT_SCOPED', 127 }, { 'H4LOOT_CASH_V', 507034 }, { 'H4LOOT_COKE_V', 1014069 }, { 'H4LOOT_GOLD_V', 1352091 }, { 'H4LOOT_PAINT_V', 1014069 }, { 'H4LOOT_WEED_V', 811255 }, --
	{ 'H4_PROGRESS', 126823 }, { 'H4CNF_BS_GEN', 262143 }, { 'H4CNF_BS_ENTR', 63 }, { 'H4CNF_BS_ABIL', 63 }, { 'H4CNF_WEP_DISRP', 3 }, { 'H4CNF_ARM_DISRP', 3 }, { 'H4CNF_HEL_DISRP', 3 }, { 'H4CNF_APPROACH', -1 } }
	local AUTOMATED_3P_TARGET_5_A = { { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
	{ 'H4CNF_BOLTCUT', 4424 }, { 'H4CNF_UNIFORM', 5256 }, { 'H4CNF_GRAPPEL', 5156 }, { 'H4_MISSIONS', -1 }, { 'H4CNF_WEAPONS', 4 }, { 'H4CNF_TROJAN', 5 } }
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
	local AUTOMATED_3P_TARGET_3 = { { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
	{ 'H4CNF_TARGET', 3 }, { 'H4LOOT_CASH_I', 63 }, { 'H4LOOT_CASH_I_SCOPED', 63 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_COKE_I', 16769024 }, { 'H4LOOT_COKE_I_SCOPED', 16769024 }, { 'H4LOOT_COKE_C', 22 }, { 'H4LOOT_COKE_C_SCOPED', 22 }, { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C', 168 }, { 'H4LOOT_GOLD_C_SCOPED', 168 }, { 'H4LOOT_WEED_I', 8128 }, { 'H4LOOT_WEED_I_SCOPED', 8128 }, { 'H4LOOT_WEED_C', 65 }, { 'H4LOOT_WEED_C_SCOPED', 65 }, { 'H4LOOT_PAINT', 127 }, { 'H4LOOT_PAINT_SCOPED', 127 }, { 'H4LOOT_CASH_V', 557034 }, { 'H4LOOT_COKE_V', 1114069 }, { 'H4LOOT_GOLD_V', 1485425 }, { 'H4LOOT_PAINT_V', 1114069 }, { 'H4LOOT_WEED_V', 891255 }, --
	{ 'H4_PROGRESS', 126823 }, { 'H4CNF_BS_GEN', 262143 }, { 'H4CNF_BS_ENTR', 63 }, { 'H4CNF_BS_ABIL', 63 }, { 'H4CNF_WEP_DISRP', 3 }, { 'H4CNF_ARM_DISRP', 3 }, { 'H4CNF_HEL_DISRP', 3 }, { 'H4CNF_APPROACH', -1 } }
	local AUTOMATED_3P_TARGET_3_A = { { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
	{ 'H4CNF_BOLTCUT', 4424 }, { 'H4CNF_UNIFORM', 5256 }, { 'H4CNF_GRAPPEL', 5156 }, { 'H4_MISSIONS', -1 }, { 'H4CNF_WEAPONS', 4 }, { 'H4CNF_TROJAN', 5 } }
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
	local AUTOMATED_4P_TARGET_5 = { { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
	{ 'H4CNF_TARGET', 5 }, { 'H4LOOT_CASH_I', 8128 }, { 'H4LOOT_CASH_I_SCOPED', 8128 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_COKE_I', 63 }, { 'H4LOOT_COKE_I_SCOPED', 63 }, { 'H4LOOT_COKE_C', 22 }, { 'H4LOOT_COKE_C_SCOPED', 22 }, { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C', 168 }, { 'H4LOOT_GOLD_C_SCOPED', 168 }, { 'H4LOOT_WEED_I', 16769024 }, { 'H4LOOT_WEED_I_SCOPED', 16769024 }, { 'H4LOOT_WEED_C', 65 }, { 'H4LOOT_WEED_C_SCOPED', 65 }, { 'H4LOOT_PAINT', 127 }, { 'H4LOOT_PAINT_SCOPED', 127 }, { 'H4LOOT_CASH_V', 582386 }, { 'H4LOOT_COKE_V', 1164772 }, { 'H4LOOT_GOLD_V', 1553030 }, { 'H4LOOT_PAINT_V', 1164772 }, { 'H4LOOT_WEED_V', 931818 }, --
	{ 'H4_PROGRESS', 126823 }, { 'H4CNF_BS_GEN', 262143 }, { 'H4CNF_BS_ENTR', 63 }, { 'H4CNF_BS_ABIL', 63 }, { 'H4CNF_WEP_DISRP', 3 }, { 'H4CNF_ARM_DISRP', 3 }, { 'H4CNF_HEL_DISRP', 3 }, { 'H4CNF_APPROACH', -1 } }
	local AUTOMATED_4P_TARGET_5_A = { { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
	{ 'H4CNF_BOLTCUT', 4424 }, { 'H4CNF_UNIFORM', 5256 }, { 'H4CNF_GRAPPEL', 5156 }, { 'H4_MISSIONS', -1 }, { 'H4CNF_WEAPONS', 4 }, { 'H4CNF_TROJAN', 5 } }
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
	local AUTOMATED_4P_TARGET_3 = { { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
	{ 'H4CNF_TARGET', 3 }, { 'H4LOOT_CASH_I', 63 }, { 'H4LOOT_CASH_I_SCOPED', 63 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_COKE_I', 16769024 }, { 'H4LOOT_COKE_I_SCOPED', 16769024 }, { 'H4LOOT_COKE_C', 22 }, { 'H4LOOT_COKE_C_SCOPED', 22 }, { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C', 168 }, { 'H4LOOT_GOLD_C_SCOPED', 168 }, { 'H4LOOT_WEED_I', 8128 }, { 'H4LOOT_WEED_I_SCOPED', 8128 }, { 'H4LOOT_WEED_C', 65 }, { 'H4LOOT_WEED_C_SCOPED', 65 }, { 'H4LOOT_PAINT', 127 }, { 'H4LOOT_PAINT_SCOPED', 127 }, { 'H4LOOT_CASH_V', 619886 }, { 'H4LOOT_COKE_V', 1239772 }, { 'H4LOOT_GOLD_V', 1653030 }, { 'H4LOOT_PAINT_V', 1239772 }, { 'H4LOOT_WEED_V', 991818 }, --
	{ 'H4_PROGRESS', 126823 }, { 'H4CNF_BS_GEN', 262143 }, { 'H4CNF_BS_ENTR', 63 }, { 'H4CNF_BS_ABIL', 63 }, { 'H4CNF_WEP_DISRP', 3 }, { 'H4CNF_ARM_DISRP', 3 }, { 'H4CNF_HEL_DISRP', 3 }, { 'H4CNF_APPROACH', -1 } }
	local AUTOMATED_4P_TARGET_3_A = { { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
	{ 'H4CNF_BOLTCUT', 4424 }, { 'H4CNF_UNIFORM', 5256 }, { 'H4CNF_GRAPPEL', 5156 }, { 'H4_MISSIONS', -1 }, { 'H4CNF_WEAPONS', 4 }, { 'H4CNF_TROJAN', 5 } }
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
	local WKLY_SOLO_PANTHER = { { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
	{ 'H4CNF_TARGET', 5 }, { 'H4LOOT_CASH_I', 6490148 }, { 'H4LOOT_CASH_I_SCOPED', 6490148 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_COKE_I', 8421904 }, { 'H4LOOT_COKE_I_SCOPED', 8421904 }, { 'H4LOOT_COKE_C', 0 }, { 'H4LOOT_COKE_C_SCOPED', 0 }, { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C', 255 }, { 'H4LOOT_GOLD_C_SCOPED', 255 }, { 'H4LOOT_WEED_I', 1311112 }, { 'H4LOOT_WEED_I_SCOPED', 1311112 }, { 'H4LOOT_WEED_C', 0 }, { 'H4LOOT_WEED_C_SCOPED', 0 }, { 'H4LOOT_PAINT', 127 }, { 'H4LOOT_PAINT_SCOPED', 127 }, { 'H4LOOT_CASH_V', 670454 }, { 'H4LOOT_COKE_V', 1340909 }, { 'H4LOOT_GOLD_V', 1787878 }, { 'H4LOOT_PAINT_V', 1340909 }, { 'H4LOOT_WEED_V', 1072727 }, --
	{ 'H4_PROGRESS', 126823 }, { 'H4CNF_BS_GEN', 262143 }, { 'H4CNF_BS_ENTR', 63 }, { 'H4CNF_BS_ABIL', 63 }, { 'H4CNF_WEP_DISRP', 3 }, { 'H4CNF_ARM_DISRP', 3 }, { 'H4CNF_HEL_DISRP', 3 }, { 'H4CNF_APPROACH', -1 } }
	local USER_CAN_MDFY_WKLY_SOLO_PANTHER = { { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
	{ 'H4CNF_BOLTCUT', 4424 }, { 'H4CNF_UNIFORM', 5256 }, { 'H4CNF_GRAPPEL', 5156 }, { 'H4_MISSIONS', -1 }, { 'H4CNF_WEAPONS', 4 }, { 'H4CNF_TROJAN', 5 } }
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
	local WKLY_DUO_PANTHER = { { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
	{ 'H4CNF_TARGET', 5 }, { 'H4LOOT_CASH_I', 6490148 }, { 'H4LOOT_CASH_I_SCOPED', 6490148 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_COKE_I', 8421904 }, { 'H4LOOT_COKE_I_SCOPED', 8421904 }, { 'H4LOOT_COKE_C', 0 }, { 'H4LOOT_COKE_C_SCOPED', 0 }, { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C', 255 }, { 'H4LOOT_GOLD_C_SCOPED', 255 }, { 'H4LOOT_WEED_I', 1311112 }, { 'H4LOOT_WEED_I_SCOPED', 1311112 }, { 'H4LOOT_WEED_C', 0 }, { 'H4LOOT_WEED_C_SCOPED', 0 }, { 'H4LOOT_PAINT', 127 }, { 'H4LOOT_PAINT_SCOPED', 127 }, { 'H4LOOT_CASH_V', 920454 }, { 'H4LOOT_COKE_V', 1840909 }, { 'H4LOOT_GOLD_V', 2454545 }, { 'H4LOOT_PAINT_V', 1840909 }, { 'H4LOOT_WEED_V', 1472727 }, --
	{ 'H4_PROGRESS', 126823 }, { 'H4CNF_BS_GEN', 262143 }, { 'H4CNF_BS_ENTR', 63 }, { 'H4CNF_BS_ABIL', 63 }, { 'H4CNF_WEP_DISRP', 3 }, { 'H4CNF_ARM_DISRP', 3 }, { 'H4CNF_HEL_DISRP', 3 }, { 'H4CNF_APPROACH', -1 } }
	local USER_CAN_MDFY_WKLY_DUO_PANTHER = { { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
	{ 'H4CNF_BOLTCUT', 4424 }, { 'H4CNF_UNIFORM', 5256 }, { 'H4CNF_GRAPPEL', 5156 }, { 'H4_MISSIONS', -1 }, { 'H4CNF_WEAPONS', 4 }, { 'H4CNF_TROJAN', 5 } }
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
	local WKLY_TRIO_PANTHER = { { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
	{ 'H4CNF_TARGET', 5 }, { 'H4LOOT_CASH_I', 6490148 }, { 'H4LOOT_CASH_I_SCOPED', 6490148 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_COKE_I', 8421904 }, { 'H4LOOT_COKE_I_SCOPED', 8421904 }, { 'H4LOOT_COKE_C', 0 }, { 'H4LOOT_COKE_C_SCOPED', 0 }, { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C', 255 }, { 'H4LOOT_GOLD_C_SCOPED', 255 }, { 'H4LOOT_WEED_I', 1311112 }, { 'H4LOOT_WEED_I_SCOPED', 1311112 }, { 'H4LOOT_WEED_C', 0 }, { 'H4LOOT_WEED_C_SCOPED', 0 }, { 'H4LOOT_PAINT', 127 }, { 'H4LOOT_PAINT_SCOPED', 127 }, { 'H4LOOT_CASH_V', 948051 }, { 'H4LOOT_COKE_V', 1896103 }, { 'H4LOOT_GOLD_V', 2528137 }, { 'H4LOOT_PAINT_V', 1896103 }, { 'H4LOOT_WEED_V', 1516882 }, --
	{ 'H4_PROGRESS', 126823 }, { 'H4CNF_BS_GEN', 262143 }, { 'H4CNF_BS_ENTR', 63 }, { 'H4CNF_BS_ABIL', 63 }, { 'H4CNF_WEP_DISRP', 3 }, { 'H4CNF_ARM_DISRP', 3 }, { 'H4CNF_HEL_DISRP', 3 }, { 'H4CNF_APPROACH', -1 } }
	local USER_CAN_MDFY_WKLY_TRIO_PANTHER = { { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
	{ 'H4CNF_BOLTCUT', 4424 }, { 'H4CNF_UNIFORM', 5256 }, { 'H4CNF_GRAPPEL', 5156 }, { 'H4_MISSIONS', -1 }, { 'H4CNF_WEAPONS', 4 }, { 'H4CNF_TROJAN', 5 } }
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
	local WKLY_FOUR_PANTHER = { { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
	{ 'H4CNF_TARGET', 5 }, { 'H4LOOT_CASH_I', 6490148 }, { 'H4LOOT_CASH_I_SCOPED', 6490148 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_COKE_I', 8421904 }, { 'H4LOOT_COKE_I_SCOPED', 8421904 }, { 'H4LOOT_COKE_C', 0 }, { 'H4LOOT_COKE_C_SCOPED', 0 }, { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C', 255 }, { 'H4LOOT_GOLD_C_SCOPED', 255 }, { 'H4LOOT_WEED_I', 1311112 }, { 'H4LOOT_WEED_I_SCOPED', 1311112 }, { 'H4LOOT_WEED_C', 0 }, { 'H4LOOT_WEED_C_SCOPED', 0 }, { 'H4LOOT_PAINT', 127 }, { 'H4LOOT_PAINT_SCOPED', 127 }, { 'H4LOOT_CASH_V', 1045454 }, { 'H4LOOT_COKE_V', 2090909 }, { 'H4LOOT_GOLD_V', 2787878 }, { 'H4LOOT_PAINT_V', 2090909 }, { 'H4LOOT_WEED_V', 1672727 }, --
	{ 'H4_PROGRESS', 126823 }, { 'H4CNF_BS_GEN', 262143 }, { 'H4CNF_BS_ENTR', 63 }, { 'H4CNF_BS_ABIL', 63 }, { 'H4CNF_WEP_DISRP', 3 }, { 'H4CNF_ARM_DISRP', 3 }, { 'H4CNF_HEL_DISRP', 3 }, { 'H4CNF_APPROACH', -1 } }
	local USER_CAN_MDFY_WKLY_FOUR_PANTHER = { { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
	{ 'H4CNF_BOLTCUT', 4424 }, { 'H4CNF_UNIFORM', 5256 }, { 'H4CNF_GRAPPEL', 5156 }, { 'H4_MISSIONS', -1 }, { 'H4CNF_WEAPONS', 4 }, { 'H4CNF_TROJAN', 5 } }
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
PERICO_HOST_CUT:add_int_range('自定义分红', 1, 0, 200, function()
	return globals.get_int(1973525 + 823 + 56 + 1)
end, function(s)
	globals.set_int(1973525 + 823 + 56 + 1, s)
end)
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
PERICO_P2_CUT:add_int_range('自定义分红', 1, 0, 200, function()
	return globals.get_int(1973525 + 823 + 56 + 2)
end, function(s)
	globals.set_int(1973525 + 823 + 56 + 2, s)
end)
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
PERICO_P3_CUT:add_int_range('自定义分红', 1, 0, 200, function()
	return globals.get_int(1973525 + 823 + 56 + 3)
end, function(s)
	globals.set_int(1973525 + 823 + 56 + 3, s)
end)
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
PERICO_P4_CUT:add_int_range('自定义分红', 1, 0, 200, function()
	return globals.get_int(1973525 + 823 + 56 + 4)
end, function(s)
	globals.set_int(1973525 + 823 + 56 + 4, s)
end)
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
	local SecondaryT_RDM = { { 'H4LOOT_CASH_I', 1319624 }, { 'H4LOOT_CASH_C', 18 }, { 'H4LOOT_CASH_V', 89400 }, { 'H4LOOT_WEED_I', 2639108 }, { 'H4LOOT_WEED_C', 36 }, { 'H4LOOT_WEED_V', 149000 }, { 'H4LOOT_COKE_I', 4229122 }, { 'H4LOOT_COKE_C', 72 }, { 'H4LOOT_COKE_V', 221200 }, { 'H4LOOT_GOLD_I', 8589313 }, { 'H4LOOT_GOLD_C', 129 }, { 'H4LOOT_GOLD_V', 322600 }, { 'H4LOOT_PAINT', 127 }, { 'H4LOOT_PAINT_V', 186800 }, { 'H4LOOT_CASH_I_SCOPED', 1319624 }, { 'H4LOOT_CASH_C_SCOPED', 18 }, { 'H4LOOT_WEED_I_SCOPED', 2639108 }, { 'H4LOOT_WEED_C_SCOPED', 36 }, { 'H4LOOT_COKE_I_SCOPED', 4229122 }, { 'H4LOOT_COKE_C_SCOPED', 72 }, { 'H4LOOT_GOLD_I_SCOPED', 8589313 }, { 'H4LOOT_GOLD_C_SCOPED', 129 }, { 'H4LOOT_PAINT_SCOPED', 127 } }
	CAYO_SECONDARY:add_action('随机次要目标', function()
		for i = 1, #SecondaryT_RDM do
			stat_set_int(SecondaryT_RDM[i][1], true, SecondaryT_RDM[i][2])
		end
	end)
end
do
	local SecondaryT_FCash = { { 'H4LOOT_CASH_I', -1 }, { 'H4LOOT_CASH_C', -1 }, { 'H4LOOT_CASH_V', 90000 }, { 'H4LOOT_WEED_I', 0 }, { 'H4LOOT_WEED_C', 0 }, { 'H4LOOT_WEED_V', 0 }, { 'H4LOOT_COKE_I', 0 }, { 'H4LOOT_COKE_C', 0 }, { 'H4LOOT_COKE_V', 0 }, { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_C', 0 }, { 'H4LOOT_GOLD_V', 0 }, { 'H4LOOT_PAINT', 127 }, { 'H4LOOT_PAINT_V', 190000 }, { 'H4LOOT_CASH_I_SCOPED', -1 }, { 'H4LOOT_CASH_C_SCOPED', -1 }, { 'H4LOOT_WEED_I_SCOPED', 0 }, { 'H4LOOT_WEED_C_SCOPED', 0 }, { 'H4LOOT_COKE_I_SCOPED', 0 }, { 'H4LOOT_COKE_C_SCOPED', 0 }, { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C_SCOPED', 0 }, { 'H4LOOT_PAINT_SCOPED', 127 } }
	CAYO_SECONDARY:add_action('现金', function()
		for i = 1, #SecondaryT_FCash do
			stat_set_int(SecondaryT_FCash[i][1], true, SecondaryT_FCash[i][2])
		end
	end)
end
do
	local SecondaryT_FWeed = { { 'H4LOOT_CASH_I', 0 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_V', 0 }, { 'H4LOOT_WEED_I', -1 }, { 'H4LOOT_WEED_C', -1 }, { 'H4LOOT_WEED_V', 140000 }, { 'H4LOOT_COKE_I', 0 }, { 'H4LOOT_COKE_C', 0 }, { 'H4LOOT_COKE_V', 0 }, { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_C', 0 }, { 'H4LOOT_GOLD_V', 0 }, { 'H4LOOT_PAINT', 127 }, { 'H4LOOT_PAINT_V', 190000 }, { 'H4LOOT_CASH_I_SCOPED', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_WEED_I_SCOPED', -1 }, { 'H4LOOT_WEED_C_SCOPED', -1 }, { 'H4LOOT_COKE_I_SCOPED', 0 }, { 'H4LOOT_COKE_C_SCOPED', 0 }, { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C_SCOPED', 0 }, { 'H4LOOT_PAINT_SCOPED', 127 } }
	CAYO_SECONDARY:add_action('大麻', function()
		for i = 1, #SecondaryT_FWeed do
			stat_set_int(SecondaryT_FWeed[i][1], true, SecondaryT_FWeed[i][2])
		end
	end)
end
do
	local SecondaryT_FCoke = { { 'H4LOOT_CASH_I', 0 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_V', 0 }, { 'H4LOOT_WEED_I', 0 }, { 'H4LOOT_WEED_C', 0 }, { 'H4LOOT_WEED_V', 0 }, { 'H4LOOT_COKE_I', -1 }, { 'H4LOOT_COKE_C', -1 }, { 'H4LOOT_COKE_V', 210000 }, { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_C', 0 }, { 'H4LOOT_GOLD_V', 0 }, { 'H4LOOT_PAINT', 127 }, { 'H4LOOT_PAINT_V', 190000 }, { 'H4LOOT_CASH_I_SCOPED', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_WEED_I_SCOPED', 0 }, { 'H4LOOT_WEED_C_SCOPED', 0 }, { 'H4LOOT_COKE_I_SCOPED', -1 }, { 'H4LOOT_COKE_C_SCOPED', -1 }, { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C_SCOPED', 0 }, { 'H4LOOT_PAINT_SCOPED', 127 } }
	CAYO_SECONDARY:add_action('可卡因', function()
		for i = 1, #SecondaryT_FCoke do
			stat_set_int(SecondaryT_FCoke[i][1], true, SecondaryT_FCoke[i][2])
		end
	end)
end
do
	local SecondaryT_FGold = { { 'H4LOOT_CASH_I', 0 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_V', 0 }, { 'H4LOOT_WEED_I', 0 }, { 'H4LOOT_WEED_C', 0 }, { 'H4LOOT_WEED_V', 0 }, { 'H4LOOT_COKE_I', 0 }, { 'H4LOOT_COKE_C', 0 }, { 'H4LOOT_COKE_V', 0 }, { 'H4LOOT_GOLD_I', -1 }, { 'H4LOOT_GOLD_C', -1 }, { 'H4LOOT_GOLD_V', 320000 }, { 'H4LOOT_PAINT', -1 }, { 'H4LOOT_PAINT_V', 190000 }, { 'H4LOOT_CASH_I_SCOPED', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_WEED_I_SCOPED', 0 }, { 'H4LOOT_WEED_C_SCOPED', 0 }, { 'H4LOOT_COKE_I_SCOPED', 0 }, { 'H4LOOT_COKE_C_SCOPED', 0 }, { 'H4LOOT_GOLD_I_SCOPED', -1 }, { 'H4LOOT_GOLD_C_SCOPED', -1 }, { 'H4LOOT_PAINT_SCOPED', -1 } }
	CAYO_SECONDARY:add_action('黄金', function()
		for i = 1, #SecondaryT_FGold do
			stat_set_int(SecondaryT_FGold[i][1], true, SecondaryT_FGold[i][2])
		end
	end)
end
do
	local SecondaryT_Remove = { { 'H4LOOT_CASH_I', 0 }, { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_V', 0 }, { 'H4LOOT_WEED_I', 0 }, { 'H4LOOT_WEED_C', 0 }, { 'H4LOOT_WEED_V', 0 }, { 'H4LOOT_COKE_I', 0 }, { 'H4LOOT_COKE_C', 0 }, { 'H4LOOT_COKE_V', 0 }, { 'H4LOOT_GOLD_I', 0 }, { 'H4LOOT_GOLD_C', 0 }, { 'H4LOOT_GOLD_V', 0 }, { 'H4LOOT_PAINT', 0 }, { 'H4LOOT_PAINT_V', 0 }, { 'H4LOOT_CASH_I_SCOPED', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_WEED_I_SCOPED', 0 }, { 'H4LOOT_WEED_C_SCOPED', 0 }, { 'H4LOOT_COKE_I_SCOPED', 0 }, { 'H4LOOT_COKE_C_SCOPED', 0 }, { 'H4LOOT_GOLD_I_SCOPED', 0 }, { 'H4LOOT_GOLD_C_SCOPED', 0 }, { 'H4LOOT_PAINT_SCOPED', 0 } }
	CAYO_SECONDARY:add_action('移除全部次要目标', function()
		for i = 1, #SecondaryT_Remove do
			stat_set_int(SecondaryT_Remove[i][1], true, SecondaryT_Remove[i][2])
		end
	end)
end
local CAH_2ND_TARGET_MDY = CAYO_SECONDARY:add_submenu('修改次要目标价值')
CAH_2ND_TARGET_MDY:add_int_range('修改现金价值', 1, 0, 1000, function()
	return globals.get_int(PlayerMP .. '_H4LOOT_CASH_V')
end, function(s)
	globals.set_int(PlayerMP .. '_H4LOOT_CASH_V', s)
end)
CAH_2ND_TARGET_MDY:add_int_range('修改大麻价值', 1, 0, 1000, function()
	return globals.get_int(PlayerMP .. '_H4LOOT_WEED_V')
end, function(s)
	globals.set_int(PlayerMP .. '_H4LOOT_WEED_V', s)
end)
CAH_2ND_TARGET_MDY:add_int_range('修改可卡因价值', 1, 0, 1000, function()
	return globals.get_int(PlayerMP .. '_H4LOOT_COKE_V')
end, function(s)
	globals.set_int(PlayerMP .. '_H4LOOT_COKE_V', s)
end)
CAH_2ND_TARGET_MDY:add_int_range('修改黄金价值', 1, 0, 1000, function()
	return globals.get_int(PlayerMP .. '_H4LOOT_GOLD_V')
end, function(s)
	globals.set_int(PlayerMP .. '_H4LOOT_GOLD_V', s)
end)
CAH_2ND_TARGET_MDY:add_int_range('修改画价值', 1, 0, 1000, function()
	return globals.get_int(PlayerMP .. '_H4LOOT_PAINT_V')
end, function(s)
	globals.set_int(PlayerMP .. '_H4LOOT_PAINT_V', s)
end)
local CAYO_COMPOUND = CAYO_SECONDARY:add_submenu('豪宅内次要目标')
do
	local Compound_LT_MIX = { { 'H4LOOT_CASH_C', 2 }, { 'H4LOOT_CASH_V', 474431 }, { 'H4LOOT_WEED_C', 17 }, { 'H4LOOT_WEED_V', 759090 }, { 'H4LOOT_COKE_C', 132 }, { 'H4LOOT_COKE_V', 948863 }, { 'H4LOOT_GOLD_C', 104 }, { 'H4LOOT_GOLD_V', 1265151 }, { 'H4LOOT_PAINT', 127 }, { 'H4LOOT_PAINT_V', 948863 }, { 'H4LOOT_CASH_C_SCOPED', 2 }, { 'H4LOOT_WEED_C_SCOPED', 17 }, { 'H4LOOT_COKE_C_SCOPED', 132 }, { 'H4LOOT_GOLD_C_SCOPED', 104 }, { 'H4LOOT_PAINT_SCOPED', 127 } }
	CAYO_COMPOUND:add_action('随机次要目标', function()
		for i = 1, #Compound_LT_MIX do
			stat_set_int(Compound_LT_MIX[i][1], true, Compound_LT_MIX[i][2])
		end
	end)
end
do
	local Compound_LT_CASH = { { 'H4LOOT_CASH_C', -1 }, { 'H4LOOT_CASH_V', 90000 }, { 'H4LOOT_WEED_C', 0 }, { 'H4LOOT_WEED_V', 0 }, { 'H4LOOT_COKE_C', 0 }, { 'H4LOOT_COKE_V', 0 }, { 'H4LOOT_GOLD_C', 0 }, { 'H4LOOT_GOLD_V', 0 }, { 'H4LOOT_PAINT', 127 }, { 'H4LOOT_PAINT_V', 190000 }, { 'H4LOOT_CASH_C_SCOPED', -1 }, { 'H4LOOT_WEED_C_SCOPED', 0 }, { 'H4LOOT_COKE_C_SCOPED', 0 }, { 'H4LOOT_GOLD_C_SCOPED', 0 }, { 'H4LOOT_PAINT_SCOPED', 127 } }
	CAYO_COMPOUND:add_action('现金', function()
		for i = 1, #Compound_LT_CASH do
			stat_set_int(Compound_LT_CASH[i][1], true, Compound_LT_CASH[i][2])
		end
	end)
end
do
	local Compound_LT_WEED = { { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_V', 0 }, { 'H4LOOT_WEED_C', -1 }, { 'H4LOOT_WEED_V', 140000 }, { 'H4LOOT_COKE_C', 0 }, { 'H4LOOT_COKE_V', 0 }, { 'H4LOOT_GOLD_C', 0 }, { 'H4LOOT_PAINT', 127 }, { 'H4LOOT_PAINT_V', 190000 }, { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_WEED_C_SCOPED', -1 }, { 'H4LOOT_COKE_C_SCOPED', 0 }, { 'H4LOOT_GOLD_C_SCOPED', 0 }, { 'H4LOOT_PAINT_SCOPED', 127 } }
	CAYO_COMPOUND:add_action('大麻', function()
		for i = 1, #Compound_LT_WEED do
			stat_set_int(Compound_LT_WEED[i][1], true, Compound_LT_WEED[i][2])
		end
	end)
end
do
	local Compound_LT_COKE = { { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_V', 0 }, { 'H4LOOT_WEED_C', 0 }, { 'H4LOOT_WEED_V', 0 }, { 'H4LOOT_COKE_C', -1 }, { 'H4LOOT_COKE_V', 210000 }, { 'H4LOOT_GOLD_C', 0 }, { 'H4LOOT_PAINT', 127 }, { 'H4LOOT_PAINT_V', 190000 }, { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_WEED_C_SCOPED', 0 }, { 'H4LOOT_COKE_C_SCOPED', -1 }, { 'H4LOOT_GOLD_C_SCOPED', 0 }, { 'H4LOOT_PAINT_SCOPED', 127 } }
	CAYO_COMPOUND:add_action('可卡因', function()
		for i = 1, #Compound_LT_COKE do
			stat_set_int(Compound_LT_COKE[i][1], true, Compound_LT_COKE[i][2])
		end
	end)
end
do
	local Compound_LT_GOLD = { { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_V', 0 }, { 'H4LOOT_WEED_C', 0 }, { 'H4LOOT_WEED_V', 0 }, { 'H4LOOT_COKE_C', 0 }, { 'H4LOOT_COKE_V', 0 }, { 'H4LOOT_GOLD_C', -1 }, { 'H4LOOT_GOLD_V', 320000 }, { 'H4LOOT_PAINT', 127 }, { 'H4LOOT_PAINT_V', 190000 }, { 'H4LOOT_GOLD_C_SCOPED', -1 }, { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_WEED_C_SCOPED', 0 }, { 'H4LOOT_COKE_C_SCOPED', 0 }, { 'H4LOOT_PAINT_SCOPED', 127 } }
	CAYO_COMPOUND:add_action('黄金', function()
		for i = 1, #Compound_LT_GOLD do
			stat_set_int(Compound_LT_GOLD[i][1], true, Compound_LT_GOLD[i][2])
		end
	end)
end
do
	local Compound_LT_PAINT = { { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_CASH_V', 0 }, { 'H4LOOT_WEED_C', 0 }, { 'H4LOOT_WEED_V', 0 }, { 'H4LOOT_COKE_C', 0 }, { 'H4LOOT_COKE_V', 0 }, { 'H4LOOT_GOLD_C', 0 }, { 'H4LOOT_GOLD_V', 0 }, { 'H4LOOT_GOLD_C_SCOPED', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_WEED_C_SCOPED', 0 }, { 'H4LOOT_COKE_C_SCOPED', 0 }, { 'H4LOOT_PAINT', 127 }, { 'H4LOOT_PAINT_V', 190000 }, { 'H4LOOT_PAINT_SCOPED', 127 } }
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
	local Remove_ALL_Compound_LT = { { 'H4LOOT_CASH_C', 0 }, { 'H4LOOT_WEED_C', 0 }, { 'H4LOOT_COKE_C', 0 }, { 'H4LOOT_GOLD_C', 0 }, { 'H4LOOT_GOLD_C_SCOPED', 0 }, { 'H4LOOT_CASH_C_SCOPED', 0 }, { 'H4LOOT_WEED_C_SCOPED', 0 }, { 'H4LOOT_COKE_C_SCOPED', 0 }, { 'H4LOOT_PAINT', 0 }, { 'H4LOOT_PAINT_SCOPED', 0 } }
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
		local CP_AWRD_BL = { { 'AWD_INTELGATHER', true }, { 'AWD_COMPOUNDINFILT', true }, { 'AWD_LOOT_FINDER', true }, { 'AWD_MAX_DISRUPT', true }, { 'AWD_THE_ISLAND_HEIST', true }, { 'AWD_GOING_ALONE', true }, { 'AWD_TEAM_WORK', true }, { 'AWD_MIXING_UP', true }, { 'AWD_PRO_THIEF', true }, { 'AWD_CAT_BURGLAR', true }, { 'AWD_ONE_OF_THEM', true }, { 'AWD_GOLDEN_GUN', true }, { 'AWD_ELITE_THIEF', true }, { 'AWD_PROFESSIONAL', true }, { 'AWD_HELPING_OUT', true }, { 'AWD_COURIER', true }, { 'AWD_PARTY_VIBES', true }, { 'AWD_HELPING_HAND', true }, { 'AWD_ELEVENELEVEN', true }, { 'COMPLETE_H4_F_USING_VETIR', true }, { 'COMPLETE_H4_F_USING_LONGFIN', true }, { 'COMPLETE_H4_F_USING_ANNIH', true }, { 'COMPLETE_H4_F_USING_ALKONOS', true }, { 'COMPLETE_H4_F_USING_PATROLB', true } }
		local CP_AWRD_IT = { { 'AWD_LOSTANDFOUND', 500000 }, { 'AWD_SUNSET', 1800000 }, { 'AWD_TREASURE_HUNTER', 1000000 }, { 'AWD_WRECK_DIVING', 1000000 }, { 'AWD_KEINEMUSIK', 1800000 }, { 'AWD_PALMS_TRAX', 1800000 }, { 'AWD_MOODYMANN', 1800000 }, { 'AWD_FILL_YOUR_BAGS', 1000000000 }, { 'AWD_WELL_PREPARED', 80 }, { 'H4_H4_DJ_MISSIONS', -1 } }
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
	local COMPLETE_CP_MISSIONS = { { 'PROSTITUTES_FREQUENTE', 100 }, -- I know horny boy, this has nothing to do with Cayo, but it is just a protection to avoid bugs
	{ 'H4_MISSIONS', -1 }, { 'H4CNF_APPROACH', -1 }, { 'H4CNF_BS_ENTR', 63 }, { 'H4CNF_BS_GEN', 63 }, { 'H4CNF_WEP_DISRP', 3 }, { 'H4CNF_ARM_DISRP', 3 }, { 'H4CNF_HEL_DISRP', 3 } }
	MORE_OPTIONS:add_action('完成全部任务', function()
		for i = 1, #COMPLETE_CP_MISSIONS do
			stat_set_int(COMPLETE_CP_MISSIONS[i][1], true, COMPLETE_CP_MISSIONS[i][2])
		end
	end)
end
do
	local CP_RST = { { 'H4_MISSIONS', 0 }, { 'H4_PROGRESS', 0 }, { 'H4CNF_APPROACH', 0 }, { 'H4CNF_BS_ENTR', 0 }, { 'H4CNF_BS_GEN', 0 }, { 'H4_PLAYTHROUGH_STATUS', 2 } }
	MORE_OPTIONS:add_action('重置抢劫', function()
		for i = 1, #CP_RST do
			stat_set_int(CP_RST[i][1], true, CP_RST[i][2])
		end
	end)
end
-- 名钻赌场抢劫
do
	local RunOnce = { { 'H3_COMPLETEDPOSIX', -1 }, { 'H3OPT_MASKS', 9 }, { 'H3OPT_WEAPS', 1 }, { 'H3OPT_VEHS', 3 } }
	local CAH_SILENT_SNEAKY_PRESET_ID_DMND = { { 'CAS_HEIST_FLOW', -1 }, { 'H3_LAST_APPROACH', 0 }, { 'H3OPT_APPROACH', 1 }, { 'H3_HARD_APPROACH', 0 }, { 'H3OPT_TARGET', 3 }, { 'H3OPT_POI', 1023 }, { 'H3OPT_ACCESSPOINTS', 2047 }, { 'H3OPT_CREWWEAP', 4 }, { 'H3OPT_CREWDRIVER', 3 }, { 'H3OPT_CREWHACKER', 4 }, { 'H3OPT_DISRUPTSHIP', 3 }, { 'H3OPT_BODYARMORLVL', -1 }, { 'H3OPT_KEYLEVELS', 2 }, { 'H3OPT_BITSET1', 127 }, { 'H3OPT_BITSET0', 262270 } }
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
	local RunOnce = { { 'H3_COMPLETEDPOSIX', -1 }, { 'H3OPT_MASKS', 9 }, { 'H3OPT_WEAPS', 1 }, { 'H3OPT_VEHS', 3 } }
	local CAH_BIGCON_PRESET_ID_DMND = { { 'CAS_HEIST_FLOW', -1 }, { 'H3_LAST_APPROACH', 0 }, { 'H3OPT_APPROACH', 2 }, { 'H3_HARD_APPROACH', 0 }, { 'H3OPT_TARGET', 3 }, { 'H3OPT_POI', 1023 }, { 'H3OPT_ACCESSPOINTS', 2047 }, { 'H3OPT_CREWWEAP', 4 }, { 'H3OPT_CREWDRIVER', 3 }, { 'H3OPT_CREWHACKER', 4 }, { 'H3OPT_DISRUPTSHIP', 3 }, { 'H3OPT_BODYARMORLVL', -1 }, { 'H3OPT_KEYLEVELS', 2 }, { 'H3OPT_BITSET1', 159 }, { 'H3OPT_BITSET0', 524118 } }
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
	local RunOnce = { { 'H3_COMPLETEDPOSIX', -1 }, { 'H3OPT_MASKS', 9 }, { 'H3OPT_WEAPS', 1 }, { 'H3OPT_VEHS', 3 } }
	local CAH_AGGRESS_PRESET_ID_DMND = { { 'CAS_HEIST_FLOW', -1 }, { 'H3_LAST_APPROACH', 0 }, { 'H3OPT_APPROACH', 3 }, { 'H3_HARD_APPROACH', 0 }, { 'H3OPT_TARGET', 3 }, { 'H3OPT_POI', 1023 }, { 'H3OPT_ACCESSPOINTS', 2047 }, { 'H3OPT_CREWWEAP', 4 }, { 'H3OPT_CREWDRIVER', 3 }, { 'H3OPT_CREWHACKER', 4 }, { 'H3OPT_DISRUPTSHIP', 3 }, { 'H3OPT_BODYARMORLVL', -1 }, { 'H3OPT_KEYLEVELS', 2 }, { 'H3OPT_BITSET1', 799 }, { 'H3OPT_BITSET0', 3670102 } }
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
	local RunOnce = { { 'H3_COMPLETEDPOSIX', -1 }, { 'H3OPT_MASKS', 9 }, { 'H3OPT_WEAPS', 1 }, { 'H3OPT_VEHS', 3 } }
	local CAH_SILENT_GOLD_PRESET = { { 'CAS_HEIST_FLOW', -1 }, { 'H3_LAST_APPROACH', 0 }, { 'H3OPT_APPROACH', 1 }, { 'H3_HARD_APPROACH', 0 }, { 'H3OPT_TARGET', 1 }, { 'H3OPT_POI', 1023 }, { 'H3OPT_ACCESSPOINTS', 2047 }, { 'H3OPT_CREWWEAP', 4 }, { 'H3OPT_CREWDRIVER', 3 }, { 'H3OPT_CREWHACKER', 4 }, { 'H3OPT_DISRUPTSHIP', 3 }, { 'H3OPT_BODYARMORLVL', -1 }, { 'H3OPT_KEYLEVELS', 2 }, { 'H3OPT_BITSET1', 127 }, { 'H3OPT_BITSET0', 262270 } }
	CAH_GOLD_TARGET:add_action('隐迹潜踪 (黄金,请选择低级买家)', function()
		for i = 1, #RunOnce do
			stat_set_int(RunOnce[i][1], true, RunOnce[i][2])
		end
		for i = 1, #CAH_SILENT_GOLD_PRESET do
			stat_set_int(CAH_SILENT_GOLD_PRESET[i][1], true, CAH_SILENT_GOLD_PRESET[i][2])
		end
		globals.set_int(1966739 + 2326, 60) -- [Gold] 60% Low | 57 Medium | High 54
		globals.set_int(1966739 + 2326 + 1, 177) -- -- [Gold] 178% Low | 169 Medium | 161 High
		globals.set_int(1966739 + 2326 + 2, 177)
		globals.set_int(1966739 + 2326 + 3, 177)
		globals.set_int(262145 + 28471, 1410065408) -- Gold
	end)
end
do
	local RunOnce = { { 'H3_COMPLETEDPOSIX', -1 }, { 'H3OPT_MASKS', 9 }, { 'H3OPT_WEAPS', 1 }, { 'H3OPT_VEHS', 3 } }
	local CAH_BIGCON_GOLD_PRESET = { { 'CAS_HEIST_FLOW', -1 }, { 'H3_LAST_APPROACH', 0 }, { 'H3OPT_APPROACH', 2 }, { 'H3_HARD_APPROACH', 0 }, { 'H3OPT_TARGET', 1 }, { 'H3OPT_POI', 1023 }, { 'H3OPT_ACCESSPOINTS', 2047 }, { 'H3OPT_CREWWEAP', 4 }, { 'H3OPT_CREWDRIVER', 3 }, { 'H3OPT_CREWHACKER', 4 }, { 'H3OPT_DISRUPTSHIP', 3 }, { 'H3OPT_BODYARMORLVL', -1 }, { 'H3OPT_KEYLEVELS', 2 }, { 'H3OPT_BITSET1', 159 }, { 'H3OPT_BITSET0', 524118 } }
	CAH_GOLD_TARGET:add_action('兵不厌诈 (黄金,请选择低级买家)', function()
		for i = 1, #RunOnce do
			stat_set_int(RunOnce[i][1], true, RunOnce[i][2])
		end
		for i = 1, #CAH_BIGCON_GOLD_PRESET do
			stat_set_int(CAH_BIGCON_GOLD_PRESET[i][1], true, CAH_BIGCON_GOLD_PRESET[i][2])
		end
		globals.set_int(1966739 + 2326, 60) -- [Gold] 60% Low | 57 Medium | High 54
		globals.set_int(1966739 + 2326 + 1, 177) -- [Gold] 178% Low | 169 Medium | 161 High
		globals.set_int(1966739 + 2326 + 2, 177)
		globals.set_int(1966739 + 2326 + 3, 177)
		globals.set_int(262145 + 28471, 1410065408) -- Gold
	end)
end
do
	local RunOnce = { { 'H3_COMPLETEDPOSIX', -1 }, { 'H3OPT_MASKS', 9 }, { 'H3OPT_WEAPS', 1 }, { 'H3OPT_VEHS', 3 } }
	local CAH_AGGRESSIV_GOLD_PRESET = { { 'CAS_HEIST_FLOW', -1 }, { 'H3OPT_APPROACH', 3 }, { 'H3OPT_TARGET', 1 }, { 'H3OPT_POI', 1023 }, { 'H3OPT_ACCESSPOINTS', 2047 }, { 'H3OPT_DISRUPTSHIP', 3 }, { 'H3OPT_BODYARMORLVL', -1 }, { 'H3OPT_KEYLEVELS', 2 }, { 'H3OPT_CREWWEAP', 4 }, { 'H3OPT_CREWDRIVER', 3 }, { 'H3OPT_CREWHACKER', 4 }, { 'H3OPT_BITSET1', 799 }, { 'H3OPT_BITSET0', 3670102 }, { 'H3_LAST_APPROACH', 0 }, { 'H3_HARD_APPROACH', 0 } }
	CAH_GOLD_TARGET:add_action('气势汹汹 (黄金,请选择低级买家)', function()
		for i = 1, #RunOnce do
			stat_set_int(RunOnce[i][1], true, RunOnce[i][2])
		end
		for i = 1, #CAH_AGGRESSIV_GOLD_PRESET do
			stat_set_int(CAH_AGGRESSIV_GOLD_PRESET[i][1], true, CAH_AGGRESSIV_GOLD_PRESET[i][2])
		end
		globals.set_int(1966739 + 2326, 60) -- [Gold] 60% Low | 57 Medium | High 54
		globals.set_int(1966739 + 2326 + 1, 177) -- [Gold] 178% Low | 169 Medium | 161 High
		globals.set_int(1966739 + 2326 + 2, 177)
		globals.set_int(1966739 + 2326 + 3, 177)
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
	CAH_NON_HOSTCUT:add_int_range('自定义分红', 1, 0, 200, function()
		return globals.get_int(2715551 + 6546)
	end, function(s)
		globals.set_int(2715551 + 6546, s)
	end)
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
	CAH_PLAYER_HOST:add_int_range('自定义分红', 1, 0, 200, function()
		return globals.get_int(1966739 + 2326)
	end, function(s)
		globals.set_int(1966739 + 2326, s)
	end)
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
	CAH_PLAYER_TWO:add_int_range('自定义分红', 1, 0, 200, function()
		return globals.get_int(1966739 + 2326 + 1)
	end, function(s)
		globals.set_int(1966739 + 2326 + 1, s)
	end)
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
	CAH_PLAYER_THREE:add_int_range('自定义分红', 1, 0, 200, function()
		return globals.get_int(1966739 + 2326 + 2)
	end, function(s)
		globals.set_int(1966739 + 2326 + 2, s)
	end)
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
	CAH_PLAYER_FOUR:add_int_range('自定义分红', 1, 0, 200, function()
		return globals.get_int(1966739 + 2326 + 3)
	end, function(s)
		globals.set_int(1966739 + 2326 + 3, s)
	end)
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
	local CAH_RELOAD_BOARDS = { { 'H3OPT_BITSET1', 0 }, { 'H3OPT_BITSET0', 0 }, { 'H3OPT_BITSET1', -1 }, { 'H3OPT_BITSET0', -1 } }
	CASINO_HEIST:add_action('重新加载计划版', function()
		for i = 1, #CAH_RELOAD_BOARDS do
			stat_set_int(CAH_RELOAD_BOARDS[i][1], true, CAH_RELOAD_BOARDS[i][2])
		end
	end)
end
do
	local CLD_CH_RMV = { { 'MPPLY_H3_COOLDOWN', 0xFFFFFFF }, { 'H3_COMPLETEDPOSIX', 0xFFFFFFF } }
	CASINO_HEIST:add_action('移除抢劫准备冷却', function()
		for i = 1, #CLD_CH_RMV do
			stat_set_int(CLD_CH_RMV[i][1], true, CLD_CH_RMV[i][2])
			stat_set_int(CLD_CH_RMV[i][1], false, CLD_CH_RMV[i][2])
		end
	end)
end
do
	local CH_AWRD_BL = { { 'AWD_FIRST_TIME1', true }, { 'AWD_FIRST_TIME2', true }, { 'AWD_FIRST_TIME3', true }, { 'AWD_FIRST_TIME4', true }, { 'AWD_FIRST_TIME5', true }, { 'AWD_FIRST_TIME6', true }, { 'AWD_ALL_IN_ORDER', true }, { 'AWD_SUPPORTING_ROLE', true }, { 'AWD_LEADER', true }, { 'AWD_ODD_JOBS', true }, { 'AWD_SURVIVALIST', true }, { 'AWD_SCOPEOUT', true }, { 'AWD_CREWEDUP', true }, { 'AWD_MOVINGON', true }, { 'AWD_PROMOCAMP', true }, { 'AWD_GUNMAN', true }, { 'AWD_SMASHNGRAB', true }, { 'AWD_INPLAINSI', true }, { 'AWD_UNDETECTED', true }, { 'AWD_ALLROUND', true }, { 'AWD_ELITETHEIF', true }, { 'AWD_PRO', true }, { 'AWD_SUPPORTACT', true }, { 'AWD_SHAFTED', true }, { 'AWD_COLLECTOR', true }, { 'AWD_DEADEYE', true }, { 'AWD_PISTOLSATDAWN', true }, { 'AWD_TRAFFICAVOI', true }, { 'AWD_CANTCATCHBRA', true }, { 'AWD_WIZHARD', true }, { 'AWD_APEESCAPE', true }, { 'AWD_MONKEYKIND', true }, { 'AWD_AQUAAPE', true }, { 'AWD_KEEPFAITH', true }, { 'AWD_TRUELOVE', true }, { 'AWD_NEMESIS', true }, { 'AWD_FRIENDZONED', true }, { 'VCM_FLOW_CS_RSC_SEEN', true }, { 'VCM_FLOW_CS_BWL_SEEN', true }, { 'VCM_FLOW_CS_MTG_SEEN', true }, { 'VCM_FLOW_CS_OIL_SEEN', true }, { 'VCM_FLOW_CS_DEF_SEEN', true }, { 'VCM_FLOW_CS_FIN_SEEN', true }, { 'CAS_VEHICLE_REWARD', false }, { 'HELP_FURIA', true }, { 'HELP_MINITAN', true }, { 'HELP_YOSEMITE2', true }, { 'HELP_ZHABA', true }, { 'HELP_IMORGEN', true }, { 'HELP_SULTAN2', true }, { 'HELP_VAGRANT', true }, { 'HELP_VSTR', true }, { 'HELP_STRYDER', true }, { 'HELP_SUGOI', true }, { 'HELP_KANJO', true }, { 'HELP_FORMULA', true }, { 'HELP_FORMULA2', true }, { 'HELP_JB7002', true } }
	local CH_AWRD_IT = { { 'ARCADE_MAC_0', -1 }, { 'ARCADE_MAC_1', -1 }, { 'ARCADE_MAC_2', -1 }, { 'ARCADE_MAC_3', -1 }, { 'ARCADE_MAC_4', -1 }, { 'ARCADE_MAC_5', -1 }, { 'ARCADE_MAC_6', -1 }, { 'ARCADE_MAC_7', -1 }, { 'ARCADE_MAC_8', -1 }, { 'ARCADE_MAC_9', -1 }, { 'ARCADE_MAC_10', -1 }, { 'ARCADE_MAC_11', -1 }, { 'ARCADE_MAC_12', -1 }, { 'ARCADE_MAC_13', -1 }, { 'ARCADE_MAC_14', -1 }, { 'ARCADE_MAC_15', -1 }, { 'CAS_HEIST_NOTS', -1 }, { 'CAS_HEIST_FLOW', -1 }, { 'CH_ARC_CAB_CLAW_TROPHY', -1 }, { 'CH_ARC_CAB_LOVE_TROPHY', -1 }, { 'SIGNAL_JAMMERS_COLLECTED', 50 }, { 'AWD_ODD_JOBS', 52 }, { 'AWD_PREPARATION', 40 }, { 'AWD_ASLEEPONJOB', 20 }, { 'AWD_DAICASHCRAB', 100000 }, { 'AWD_BIGBRO', 40 }, { 'AWD_SHARPSHOOTER', 40 }, { 'AWD_RACECHAMP', 40 }, { 'AWD_BATSWORD', 1000000 }, { 'AWD_COINPURSE', 950000 }, { 'AWD_ASTROCHIMP', 3000000 }, { 'AWD_MASTERFUL', 40000 }, { 'H3_BOARD_DIALOGUE0', -1 }, { 'H3_BOARD_DIALOGUE1', -1 }, { 'H3_BOARD_DIALOGUE2', -1 }, { 'H3_VEHICLESUSED', -1 }, { 'H3_CR_STEALTH_1A', 100 }, { 'H3_CR_STEALTH_2B_RAPP', 100 }, { 'H3_CR_STEALTH_2C_SIDE', 100 }, { 'H3_CR_STEALTH_3A', 100 }, { 'H3_CR_STEALTH_4A', 100 }, { 'H3_CR_STEALTH_5A', 100 }, { 'H3_CR_SUBTERFUGE_1A', 100 }, { 'H3_CR_SUBTERFUGE_2A', 100 }, { 'H3_CR_SUBTERFUGE_2B', 100 }, { 'H3_CR_SUBTERFUGE_3A', 100 }, { 'H3_CR_SUBTERFUGE_3B', 100 }, { 'H3_CR_SUBTERFUGE_4A', 100 }, { 'H3_CR_SUBTERFUGE_5A', 100 }, { 'H3_CR_DIRECT_1A', 100 }, { 'H3_CR_DIRECT_2A1', 100 }, { 'H3_CR_DIRECT_2A2', 100 }, { 'H3_CR_DIRECT_2BP', 100 }, { 'H3_CR_DIRECT_2C', 100 }, { 'H3_CR_DIRECT_3A', 100 }, { 'H3_CR_DIRECT_4A', 100 }, { 'H3_CR_DIRECT_5A', 100 }, { 'CR_ORDER', 100 } }
	CASINO_HEIST:add_action('解锁游戏厅奖章和赌场抢劫奖励', function()
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
	local CAH_MISS_1 = { { 'VCM_FLOW_PROGRESS', 1048576 }, { 'VCM_STORY_PROGRESS', 0 } }
	CAH_MISSION_MANAGER:add_action('解救陈陶', function()
		for i = 1, #CAH_MISS_1 do
			stat_set_int(CAH_MISS_1[i][1], true, CAH_MISS_1[i][2])
		end
	end)
	local CAH_MISS_2 = { { 'VCM_FLOW_PROGRESS', 1310785 }, { 'VCM_STORY_PROGRESS', 1 } }
	CAH_MISSION_MANAGER:add_action('日常杂务', function()
		for i = 1, #CAH_MISS_2 do
			stat_set_int(CAH_MISS_2[i][1], true, CAH_MISS_2[i][2])
		end
	end)
	local CAH_MISS_3 = { { 'VCM_FLOW_PROGRESS', 1310915 }, { 'VCM_STORY_PROGRESS', 2 } }
	CAH_MISSION_MANAGER:add_action('铁腕战术', function()
		for i = 1, #CAH_MISS_3 do
			stat_set_int(CAH_MISS_3[i][1], true, CAH_MISS_3[i][2])
		end
	end)
	local CAH_MISS_4 = { { 'VCM_FLOW_PROGRESS', 1311175 }, { 'VCM_STORY_PROGRESS', 3 } }
	CAH_MISSION_MANAGER:add_action('志在得胜', function()
		for i = 1, #CAH_MISS_4 do
			stat_set_int(CAH_MISS_4[i][1], true, CAH_MISS_4[i][2])
		end
	end)
	local CAH_MISS_5 = { { 'VCM_FLOW_PROGRESS', 1311695 }, { 'VCM_STORY_PROGRESS', 4 } }
	CAH_MISSION_MANAGER:add_action('出奇致胜', function()
		for i = 1, #CAH_MISS_5 do
			stat_set_int(CAH_MISS_5[i][1], true, CAH_MISS_5[i][2])
		end
	end)
	local CAH_MISS_6 = { { 'VCM_FLOW_PROGRESS', 1312735 }, { 'VCM_STORY_PROGRESS', 5 } }
	CAH_MISSION_MANAGER:add_action('金盆套现', function()
		for i = 1, #CAH_MISS_6 do
			stat_set_int(CAH_MISS_6[i][1], true, CAH_MISS_6[i][2])
		end
	end)
end
do
	local CH_RST = { { 'H3_LAST_APPROACH', 0 }, { 'H3OPT_APPROACH', 0 }, { 'H3_HARD_APPROACH', 0 }, { 'H3OPT_TARGET', 0 }, { 'H3OPT_POI', 0 }, { 'H3OPT_ACCESSPOINTS', 0 }, { 'H3OPT_BITSET1', 0 }, { 'H3OPT_CREWWEAP', 0 }, { 'H3OPT_CREWDRIVER', 0 }, { 'H3OPT_CREWHACKER', 0 }, { 'H3OPT_WEAPS', 0 }, { 'H3OPT_VEHS', 0 }, { 'H3OPT_DISRUPTSHIP', 0 }, { 'H3OPT_BODYARMORLVL', 0 }, { 'H3OPT_KEYLEVELS', 0 }, { 'H3OPT_MASKS', 0 }, { 'H3OPT_BITSET0', 0 } }
	CASINO_HEIST:add_action('重置抢劫', function()
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
	DDHEIST_HOST_MANAGER:add_int_range('自定义分红', 1, 0, 200, function()
		return globals.get_int(1962763 + 812 + 50 + 1)
	end, function(s)
		globals.set_int(1962763 + 812 + 50 + 1, s)
	end)
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
	DDHEIST_PLAYER2_MANAGER:add_int_range('自定义分红', 1, 0, 200, function()
		return globals.get_int(1962763 + 812 + 50 + 2)
	end, function(s)
		globals.set_int(1962763 + 812 + 50 + 2, s)
	end)
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
	DDHEIST_PLAYER3_MANAGER:add_int_range('自定义分红', 1, 0, 200, function()
		return globals.get_int(1962763 + 812 + 50 + 3)
	end, function(s)
		globals.set_int(1962763 + 812 + 50 + 3, s)
	end)
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
	DDHEIST_PLAYER4_MANAGER:add_int_range('自定义分红', 1, 0, 200, function()
		return globals.get_int(1962763 + 812 + 50 + 4)
	end, function(s)
		globals.set_int(1962763 + 812 + 50 + 4, s)
	end)
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
	local DD_AWARDS_I = { { 'GANGOPS_FM_MISSION_PROG', -1 }, { 'GANGOPS_FLOW_MISSION_PROG', -1 }, { 'MPPLY_GANGOPS_ALLINORDER', 536870911 }, { 'MPPLY_GANGOPS_LOYALTY', 536870911 }, { 'MPPLY_GANGOPS_CRIMMASMD', 536870911 }, { 'MPPLY_GANGOPS_LOYALTY2', 536870911 }, { 'MPPLY_GANGOPS_LOYALTY3', 536870911 }, { 'MPPLY_GANGOPS_CRIMMASMD2', 536870911 }, { 'MPPLY_GANGOPS_CRIMMASMD3', 536870911 }, { 'MPPLY_GANGOPS_SUPPORT', 536870911 }, { 'CR_GANGOP_MORGUE', 10 }, { 'CR_GANGOP_DELUXO', 10 }, { 'CR_GANGOP_SERVERFARM', 10 }, { 'CR_GANGOP_IAABASE_FIN', 10 }, { 'CR_GANGOP_STEALOSPREY', 10 }, { 'CR_GANGOP_FOUNDRY', 10 }, { 'CR_GANGOP_RIOTVAN', 10 }, { 'CR_GANGOP_SUBMARINECAR', 10 }, { 'CR_GANGOP_SUBMARINE_FIN', 10 }, { 'CR_GANGOP_PREDATOR', 10 }, { 'CR_GANGOP_BMLAUNCHER', 10 }, { 'CR_GANGOP_BCCUSTOM', 10 }, { 'CR_GANGOP_STEALTHTANKS', 10 }, { 'CR_GANGOP_SPYPLANE', 10 }, { 'CR_GANGOP_FINALE', 10 }, { 'CR_GANGOP_FINALE_P2', 10 }, { 'CR_GANGOP_FINALE_P3', 10 }, { 'WAM_FLOW_VEHICLE_BS', -1 }, { 'GANGOPS_FLOW_IMPEXP_NUM', -1 } }
	local DD_AWARDS_B = { { 'MPPLY_AWD_GANGOPS_IAA', true }, { 'MPPLY_AWD_GANGOPS_SUBMARINE', true }, { 'MPPLY_AWD_GANGOPS_MISSILE', true }, { 'MPPLY_AWD_GANGOPS_ALLINORDER', true }, { 'MPPLY_AWD_GANGOPS_LOYALTY', true }, { 'MPPLY_AWD_GANGOPS_LOYALTY2', true }, { 'MPPLY_AWD_GANGOPS_LOYALTY3', true }, { 'MPPLY_AWD_GANGOPS_CRIMMASMD', true }, { 'MPPLY_AWD_GANGOPS_CRIMMASMD2', true }, { 'MPPLY_AWD_GANGOPS_CRIMMASMD3', true } }
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
	CLASSIC_CUT:add_int_range('自定义分红', 1, 0, 200, function()
		return globals.get_int(1934636 + 3008 + 1)
	end, function(s)
		globals.set_int(1934636 + 3008 + 1, s)
	end)
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
CLASSIC_M_GAME:add_action('全福银行 : 电路破解', function()
	script('fm_mission_controller'):set_int(11707 + 24, 7)
end)
CLASSIC_M_GAME:add_action('太平洋 : 破解', function()
	script('fm_mission_controller'):set_int(146, 7)
end)
do
	local Apartment_AWD_B = { { 'MPPLY_AWD_COMPLET_HEIST_MEM', true }, { 'MPPLY_AWD_COMPLET_HEIST_1STPER', true }, { 'MPPLY_AWD_FLEECA_FIN', true }, { 'MPPLY_AWD_HST_ORDER', true }, { 'MPPLY_AWD_HST_SAME_TEAM', true }, { 'MPPLY_AWD_HST_ULT_CHAL', true }, { 'MPPLY_AWD_HUMANE_FIN', true }, { 'MPPLY_AWD_PACIFIC_FIN', true }, { 'MPPLY_AWD_PRISON_FIN', true }, { 'MPPLY_AWD_SERIESA_FIN', true }, { 'AWD_FINISH_HEIST_NO_DAMAGE', true }, { 'AWD_SPLIT_HEIST_TAKE_EVENLY', true }, { 'AWD_ALL_ROLES_HEIST', true }, { 'AWD_MATCHING_OUTFIT_HEIST', true }, { 'HEIST_PLANNING_DONE_PRINT', true }, { 'HEIST_PLANNING_DONE_HELP_0', true }, { 'HEIST_PLANNING_DONE_HELP_1', true }, { 'HEIST_PRE_PLAN_DONE_HELP_0', true }, { 'HEIST_CUTS_DONE_FINALE', true }, { 'HEIST_IS_TUTORIAL', false }, { 'HEIST_STRAND_INTRO_DONE', true }, { 'HEIST_CUTS_DONE_ORNATE', true }, { 'HEIST_CUTS_DONE_PRISON', true }, { 'HEIST_CUTS_DONE_BIOLAB', true }, { 'HEIST_CUTS_DONE_NARCOTIC', true }, { 'HEIST_CUTS_DONE_TUTORIAL', true }, { 'HEIST_AWARD_DONE_PREP', true }, { 'HEIST_AWARD_BOUGHT_IN', true } }
	local Apartment_AWD_I = { { 'AWD_FINISH_HEISTS', 900 }, { 'MPPLY_WIN_GOLD_MEDAL_HEISTS', 900 }, { 'AWD_DO_HEIST_AS_MEMBER', 900 }, { 'AWD_DO_HEIST_AS_THE_LEADER', 900 }, { 'AWD_FINISH_HEIST_SETUP_JOB', 900 }, { 'AWD_FINISH_HEIST', 900 }, { 'HEIST_COMPLETION', 900 }, { 'HEISTS_ORGANISED', 900 }, { 'AWD_CONTROL_CROWDS', 900 }, { 'AWD_WIN_GOLD_MEDAL_HEISTS', 900 }, { 'AWD_COMPLETE_HEIST_NOT_DIE', 900 }, { 'HEIST_START', 900 }, { 'HEIST_END', 900 }, { 'CUTSCENE_MID_PRISON', 900 }, { 'CUTSCENE_MID_HUMANE', 900 }, { 'CUTSCENE_MID_NARC', 900 }, { 'CUTSCENE_MID_ORNATE', 900 }, { 'CR_FLEECA_PREP_1', 5000 }, { 'CR_FLEECA_PREP_2', 5000 }, { 'CR_FLEECA_FINALE', 5000 }, { 'CR_PRISON_PLANE', 5000 }, { 'CR_PRISON_BUS', 5000 }, { 'CR_PRISON_STATION', 5000 }, { 'CR_PRISON_UNFINISHED_BIZ', 5000 }, { 'CR_PRISON_FINALE', 5000 }, { 'CR_HUMANE_KEY_CODES', 5000 }, { 'CR_HUMANE_ARMORDILLOS', 5000 }, { 'CR_HUMANE_EMP', 5000 }, { 'CR_HUMANE_VALKYRIE', 5000 }, { 'CR_HUMANE_FINALE', 5000 }, { 'CR_NARC_COKE', 5000 }, { 'CR_NARC_TRASH_TRUCK', 5000 }, { 'CR_NARC_BIKERS', 5000 }, { 'CR_NARC_WEED', 5000 }, { 'CR_NARC_STEAL_METH', 5000 }, { 'CR_NARC_FINALE', 5000 }, { 'CR_PACIFIC_TRUCKS ', 5000 }, { 'CR_PACIFIC_WITSEC', 5000 }, { 'CR_PACIFIC_HACK', 5000 }, { 'CR_PACIFIC_BIKES', 5000 }, { 'CR_PACIFIC_CONVOY', 5000 }, { 'CR_PACIFIC_FINALE', 5000 }, { 'MPPLY_HEIST_ACH_TRACKER', -1 } }
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
	local LS_TUNERS_DLC_BL = { { 'AWD_CAR_CLUB', true }, { 'AWD_PRO_CAR_EXPORT', true }, { 'AWD_UNION_DEPOSITORY', true }, { 'AWD_MILITARY_CONVOY', true }, { 'AWD_FLEECA_BANK', true }, { 'AWD_FREIGHT_TRAIN', true }, { 'AWD_BOLINGBROKE_ASS', true }, { 'AWD_IAA_RAID', true }, { 'AWD_METH_JOB', true }, { 'AWD_BUNKER_RAID', true }, { 'AWD_STRAIGHT_TO_VIDEO', true }, { 'AWD_MONKEY_C_MONKEY_DO', true }, { 'AWD_TRAINED_TO_KILL', true }, { 'AWD_DIRECTOR', true } }
	local LS_TUNERS_DLC_IT = { { 'AWD_CAR_CLUB_MEM', 100 }, { 'AWD_SPRINTRACER', 50 }, { 'AWD_STREETRACER', 50 }, { 'AWD_PURSUITRACER', 50 }, { 'AWD_TEST_CAR', 240 }, { 'AWD_AUTO_SHOP', 50 }, { 'AWD_CAR_EXPORT', 100 }, { 'AWD_GROUNDWORK', 40 }, { 'AWD_ROBBERY_CONTRACT', 100 }, { 'AWD_FACES_OF_DEATH', 100 } }
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
	local LEAK_COUNTRYCLUB = { { 'FIXER_GENERAL_BS', -1 }, { 'FIXER_COMPLETED_BS', -1 }, { 'FIXER_STORY_STRAND', -1 }, { 'FIXER_STORY_BS', 28 }, { 'FIXER_STORY_COOLDOWN', -1 } }
	CONTRACT_MANAGER__:add_action('乡村俱乐部 (前置)', function()
		for i = 1, #LEAK_COUNTRYCLUB do
			stat_set_int(LEAK_COUNTRYCLUB[i][1], true, LEAK_COUNTRYCLUB[i][2])
		end
	end)
end
do
	local LEAK_GUESTLIST = { { 'FIXER_GENERAL_BS', -1 }, { 'FIXER_COMPLETED_BS', -1 }, { 'FIXER_STORY_STRAND', -1 }, { 'FIXER_STORY_BS', 60 }, { 'FIXER_STORY_COOLDOWN', -1 } }
	CONTRACT_MANAGER__:add_action('宾客名单 (前置)', function()
		for i = 1, #LEAK_GUESTLIST do
			stat_set_int(LEAK_GUESTLIST[i][1], true, LEAK_GUESTLIST[i][2])
		end
	end)
end
do
	local LEAK_HIGHSOCIETY = { { 'FIXER_GENERAL_BS', -1 }, { 'FIXER_COMPLETED_BS', -1 }, { 'FIXER_STORY_STRAND', -1 }, { 'FIXER_STORY_BS', 124 }, { 'FIXER_STORY_COOLDOWN', -1 } }
	CONTRACT_MANAGER__:add_action('上流社会泄密 (任务)', function()
		for i = 1, #LEAK_HIGHSOCIETY do
			stat_set_int(LEAK_HIGHSOCIETY[i][1], true, LEAK_HIGHSOCIETY[i][2])
		end
	end)
end
do
	local LEAK_DAVIS = { { 'FIXER_GENERAL_BS', -1 }, { 'FIXER_COMPLETED_BS', -1 }, { 'FIXER_STORY_STRAND', -1 }, { 'FIXER_STORY_BS', 252 }, { 'FIXER_STORY_COOLDOWN', -1 } }
	CONTRACT_MANAGER___:add_action('戴维斯 (前置)', function()
		for i = 1, #LEAK_DAVIS do
			stat_set_int(LEAK_DAVIS[i][1], true, LEAK_DAVIS[i][2])
		end
	end)
end
do
	local LEAK_BALLAS = { { 'FIXER_GENERAL_BS', -1 }, { 'FIXER_COMPLETED_BS', -1 }, { 'FIXER_STORY_STRAND', -1 }, { 'FIXER_STORY_BS', 508 }, { 'FIXER_STORY_COOLDOWN', -1 } }
	CONTRACT_MANAGER___:add_action('巴勒帮 (前置)', function()
		for i = 1, #LEAK_BALLAS do
			stat_set_int(LEAK_BALLAS[i][1], true, LEAK_BALLAS[i][2])
		end
	end)
end
do
	local LEAK_STUDIO = { { 'FIXER_GENERAL_BS', -1 }, { 'FIXER_COMPLETED_BS', -1 }, { 'FIXER_STORY_STRAND', -1 }, { 'FIXER_STORY_BS', 2044 }, { 'FIXER_STORY_COOLDOWN', -1 } }
	CONTRACT_MANAGER___:add_action('工作室时间 (任务)', function()
		for i = 1, #LEAK_STUDIO do
			stat_set_int(LEAK_STUDIO[i][1], true, LEAK_STUDIO[i][2])
		end
	end)
end
do
	local LEAK_FINAL = { { 'FIXER_GENERAL_BS', -1 }, { 'FIXER_COMPLETED_BS', -1 }, { 'FIXER_STORY_STRAND', -1 }, { 'FIXER_STORY_BS', 4092 }, { 'FIXER_STORY_COOLDOWN', -1 } }
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
	local TH_AWARDS_I = { { 'AWD_CONTRACTOR', 50 }, { 'AWD_COLD_CALLER', 50 }, { 'AWD_PRODUCER', 60 }, { 'FIXERTELEPHONEHITSCOMPL', 10 }, { 'PAYPHONE_BONUS_KILL_METHOD', 10 }, { 'FIXER_COUNT', 501 }, { 'FIXER_SC_VEH_RECOVERED', 501 }, { 'FIXER_SC_VAL_RECOVERED', 501 }, { 'FIXER_SC_GANG_TERMINATED', 501 }, { 'FIXER_SC_VIP_RESCUED', 501 }, { 'FIXER_SC_ASSETS_PROTECTED', 501 }, { 'FIXER_SC_EQ_DESTROYED', 501 }, { 'FIXER_EARNINGS', 300000 } }
	local TH_AWARDS_B = { { 'AWD_TEEING_OFF', true }, { 'AWD_PARTY_NIGHT', true }, { 'AWD_BILLIONAIRE_GAMES', true }, { 'AWD_HOOD_PASS', true }, { 'AWD_STUDIO_TOUR', true }, { 'AWD_DONT_MESS_DRE', true }, { 'AWD_BACKUP', true }, { 'AWD_SHORTFRANK_1', true }, { 'AWD_SHORTFRANK_2', true }, { 'AWD_SHORTFRANK_3', true }, { 'AWD_CONTR_KILLER', true }, { 'AWD_DOGS_BEST_FRIEND', true }, { 'AWD_MUSIC_STUDIO', true }, { 'AWD_SHORTLAMAR_1', true }, { 'AWD_SHORTLAMAR_2', true }, { 'AWD_SHORTLAMAR_3', true } }
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
---- Cayo mini-game
cayoPericoMenu:add_action('佩里科岛 : 切割格栅', function()
	script('fm_mission_controller_2020'):set_int(27036, 6)
end)
TOOLS:add_action('佩里科岛 : 指纹复制器', function()
	script('fm_mission_controller_2020'):set_int(23177, 5)
end)
MINI_GAME_TOOL:add_action('佩里科岛 : VOLTlab (关闭防空系统)', function()
	if not localplayer then
		return nil
	end
	localplayer:set_position(vector3(4372.792, -4578.357, 4.208))
	localplayer:set_rotation(vector3(2, 0, 0))
	sleep(3)
	ResultScan = script('fm_mission_controller_2020'):get_int(1777)
	script('fm_mission_controller_2020'):set_int(1776, ResultScan)
end)
MINI_GAME_TOOL:add_action('佩里科岛 : 等离子切割机', function()
	script('fm_mission_controller_2020'):set_float(28269 + 3, 999)
end)
----- Cah mini-game
MINI_GAME_TOOL:add_action('赌场 : 指纹复制器', function()
	script('fm_mission_controller'):set_int(52899, 5) -- ref: struct<756> Local_52899 = { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
end)
MINI_GAME_TOOL:add_action('赌场 : 门禁', function()
	script('fm_mission_controller'):set_int(53961, 5)
end)
MINI_GAME_TOOL:add_action('赌场 : 金库门', function() -- ref: int func_10084(int iParam0)
	script('fm_mission_controller'):set_int(53729, 5) -- ref line 7834 : var uLocal_53729 = 0;
	local Value = script('fm_mission_controller'):get_int(10068 + 37)
	script('fm_mission_controller'):set_int(10068 + 7, Value)
end)
MINI_GAME_TOOL:add_action('赌场 : 指纹 (游戏厅练习)', function() -- am_mp_arc_cab_manager
	script('am_mp_arc_cab_manager'):set_int(2829, 5)
end)
MINI_GAME_TOOL:add_action('赌场 : 门禁 (游戏厅练习)', function() -- am_mp_arc_cab_manager
	script('am_mp_arc_cab_manager'):set_int(3826, 5)
end)
---- Doomsday mini-game
MINI_GAME_TOOL:add_action('末日三 : 激光破解', function() -- fm_mission_controller
	script('fm_mission_controller'):set_int(1326 + 134, 3)
end)
MINI_GAME_TOOL:add_action('末日一前置 : 服务器破解', function()
	script('fm_mission_controller'):set_int(1598, 2)
end)
