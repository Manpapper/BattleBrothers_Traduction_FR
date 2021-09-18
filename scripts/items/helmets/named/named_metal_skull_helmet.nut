this.named_metal_skull_helmet <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.named_metal_skull_helmet";
		this.m.Description = "A heavy helmet typical of the northern barbarians with a skull-like facemask. This piece is as massive as it is impressive.";
		this.m.NameList = [
			"Face of the North",
			"Metal Skull",
			"Facemask",
			"Aspect of the Clans",
			"Mask",
			"Steel Veil",
			"Tribal Visage",
			"Pillager Gaze"
		];
		this.m.PrefixList = this.Const.Strings.BarbarianPrefix;
		this.m.UseRandomName = false;
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.HideCharacterHead = true;
		this.m.Variant = 232;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 5000;
		this.m.Condition = 210;
		this.m.ConditionMax = 210;
		this.m.StaminaModifier = -13;
		this.m.Vision = -2;
		this.randomizeValues();
	}

});

