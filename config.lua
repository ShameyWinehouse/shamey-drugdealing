
Config = {}

Config.Debug = false
Config.DebugVisual = false

Config.DistanceToSell = 1.6
Config.PromptSellKey = `INPUT_CONTEXT_X` -- R key
Config.PromptSellText = "Sell Drugs"

Config.DrugItems = {
    ["cocaine"] = {
        ItemName = "cocaine",
        Label = "Cocaine",
        BasePrice = 10.00,
    },
    ["ganja_cigarette"] = {
        ItemName = "ganja_cigarette",
        Label = "Ganja Cigarette",
        BasePrice = 14.00,
    },
    ["opium"] = {
        ItemName = "opium",
        Label = "Opium",
        BasePrice = 8.00,
    },
    ["MedicalGanja"] = {
        ItemName = "MedicalGanja",
        Label = "Medical Ganja",
        BasePrice = 16.00,
    },
}

Config.BaseChanceCustomerWillBuy = 60 -- percent
Config.MaximumSoldPerExchange = 3

Config.TimeoutAfterExchange = 5 * 1000

Config.LeoRequired = true
Config.LeoRequiredAmount = 1
Config.LeoJobs = {
    "leo",
    "sheriff",
	"marshal",
	"deputy",
}
Config.LeoPresenceMultiplier = 0.2
Config.LeoPresenceMultiplierCap = 2

Config.Animations = {
    GiveItem = {
        Dict = "script_re@animal_mauling",
        Anim = "give_whiskey_r_plr",
    },
    GiveMoney = {
        Dict = "cnv_camp@handover@dark_alley_stab@handover",
        Anim = "take_offer_victim",
    },
    RejectOffer = {
        Dict = "script_re@hostage_rescue@male@plead",
        Anim = "player_reject_player",
    },
    Sup = {
        Dict = "ai_gestures@gen_female@standing@listener",
        Anim = "neutral_nod_f_001",
    },
}

Config.NotificationTexts = {
    NoDrugs = "You don't have any drugs.",
    PlayerIsLeo = "You cannot do this because you are an LEO.",
    NoOfficers = "There are not enough LEOs awake for this.",
    DealerReported = "Locals report suspicious activity at %s.\nQuickly check your map!",
    SellAtTownOnly = "You can only sell drugs in towns.",
}

Config.LeoAlert = {
    BlipMod = 0xEE89BCA4, -- BLIP_MODIFIER_FLASH_LONG
    BlipName = "Suspicious Activity",
    BlipIcon = `blip_outlaw`,
    BlipRemoveTimer = 2 * 60 * 1000, -- 2 minutes
    AlertActivity = true,
    AlertChance = 50,
    MinimumSalesBeforeAlert = 2,
    TimeOnScreen = 20 * 1000,
    Title = "Suspicious Activity",
    TextureGroup = "generic_textures_tu",
    TextureName = "mp_rank_shield",
}

Config.ModelBonus = {
    ["Rich"] = 1.40,
    ["Nightlady"] = 1.35,
    ["Poor"] = 1.00,
    ["None"] = 1.10,
    ["Foreigner"] = 1.25,
    ["Middle"] = 1.20,
    ["Worker"] = 1.15,
}

Config.Webhook = "https://discord.com/api/webhooks/..."


-------- TOWNS
Config.Towns = {
    {
        Name = "Annesburg",
        Hash = `Annesburg`,
        DbName = "ANNESBURG",
    },
    {
        Name = "Armadillo",
        Hash = `Armadillo`,
        DbName = "ARMADILLO",
    },
    {
        Name = "Blackwater",
        Hash = `Blackwater`,
        DbName = "BLACKWATER",
    },
    {
        Name = "Butcher Creek",
        Hash = `Butcher`,
        DbName = "BUTCHERC",
    },
    {
        Name = "Blackwater",
        Hash = `Blackwater`,
        DbName = "BLACKWATER",
    },
    {
        Name = "Lagras",
        Hash = `lagras`,
        DbName = "LAGRAS",
    },
    {
        Name = "Rhodes",
        Hash = `Rhodes`,
        DbName = "RHODES",
    },
    {
        Name = "Saint Denis",
        Hash = `StDenis`,
        DbName = "STDENIS",
    },
    {
        Name = "Strawberry",
        Hash = `Strawberry`,
        DbName = "STRAWBERRY",
    },
    {
        Name = "Tumbleweed",
        Hash = `Tumbleweed`,
        DbName = "TUMBLEWEED",
    },
    {
        Name = "Valentine",
        Hash = `valentine`,
        DbName = "VALENTINE",
    },
    {
        Name = "Van Horn",
        Hash = `VANHORN`,
        DbName = "VANHORN",
    },
}

-------- MODELS

Config.Models = {
    ["Rich"] = {
        `a_f_m_gamhighsociety_01`,
        `a_m_m_gamhighsociety_01`,
        `a_f_m_blwupperclass_01`,
        `a_f_m_nbxupperclass_01`,
        `a_f_m_rhdupperclass_01`,
        `a_f_m_uppertrainpassengers_01`,
        `a_f_o_blwupperclass_01`,
        `a_f_o_sdupperclass_01`,
        `a_m_m_blwupperclass_01`,
        `a_m_m_nbxupperclass_01`,
        `a_m_m_uppertrainpassengers_01`,
        `a_m_o_blwupperclass_01`,
        `a_m_o_sdupperclass_01`,
        `u_m_m_finale2_aa_upperclass_01`,
        --``,
    },
    ["Nightlady"] = {
        `a_f_m_rhdprostitute_01`,
        `a_f_m_valprostitute_01`,
        `a_f_m_vhtprostitute_01`,
        `cs_odprostitute`,
        `cs_valprostitute_01`,
        `cs_valprostitute_02`,
        --``,
    },
    ["Poor"] = {
        `a_f_m_nbxslums_01`,
        `a_f_m_sdslums_02`,
        `a_m_m_nbxslums_01`,
        `a_m_m_sdslums_02`,
        `a_m_y_nbxstreetkids_slums_01`,
        `a_m_y_sdstreetkids_slums_02`,
        `a_m_m_lowersdtownfolk_02`,
        `a_m_m_lowersdtownfolk_01`,
        `a_f_m_lowersdtownfolk_03`,
        `a_f_m_lowersdtownfolk_02`,
        `a_f_m_lowersdtownfolk_01`,
        --``,
    },
    ["Police"] = {
        `cs_nbxpolicechiefformal`,
        `mp_asn_sdpolicestation_males_01`,
        `mp_u_m_o_blwpolicechief_01`,
        `re_policechase_males_01`,
        `s_m_m_ambientblwpolice_01`,
        `s_m_m_ambientsdpolice_01`,
        `s_m_m_dispatchleaderpolice_01`,
        `s_m_m_dispatchpolice_01`,
        `u_m_m_sdpolicechief_01`,
        `u_m_o_blwpolicechief_01`,
        --``,
    },
    ["Middle"] = {
        --``,
        `a_f_m_middlesdtownfolk_01`,
        `a_f_m_middlesdtownfolk_02`,
        `a_f_m_middlesdtownfolk_03`,
        `a_f_m_middletrainpassengers_01`,
        `a_m_m_middlesdtownfolk_01`,
        `a_m_m_middlesdtownfolk_02`,
        `a_m_m_middlesdtownfolk_03`,
        `a_m_m_middletrainpassengers_01`,
    },
    ["Foreigner"] = {
        `a_f_m_sdchinatown_01`,
        `a_f_o_sdchinatown_01`,
        `a_m_m_sdchinatown_01`,
        `a_m_o_sdchinatown_01`,
    },
    ["Worker"] = {
        `a_m_m_asbtownfolk_01_laborer`,
        `a_m_m_blwlaborer_01`,
        `a_m_m_blwlaborer_02`,
        `a_m_m_nbxlaborers_01`,
        `a_m_m_rhdtownfolk_01_laborer`,
        `a_m_m_sdlaborers_02`,
        `a_m_m_strlaborer_01`,
        `a_m_m_vallaborer_01`,
    },
}