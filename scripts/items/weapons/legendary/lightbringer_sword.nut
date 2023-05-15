this.lightbringer_sword <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.lightbringer_sword";
		this.m.Name = "Reproche des Dieux anciens";
		this.m.Description = "L\'épée crépusculaire plie les violets et les oranges jusqu\'à ce qu\'elle porte apparemment elle-même le crépuscule dans son intégralité. Au toucher, on ne peut pas dire s\'ils sont brûlés ou refroidis. Magique ou bien conçue, quelle que soit cette arme, elle vibre comme si elle combattait une puissance immense et il vous suffit de la manier pour trouver le véritable pouvoir de l\'acier.";
		this.m.Categories = "Epée, Une Main";
		this.m.IconLarge = "weapons/melee/sword_legendary_01.png";
		this.m.Icon = "weapons/melee/sword_legendary_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded | this.Const.Items.ItemType.Legendary;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_sword_legendary_01";
		this.m.Condition = 90.0;
		this.m.ConditionMax = 90.0;
		this.m.StaminaModifier = -8;
		this.m.Value = 20000;
		this.m.RegularDamage = 50;
		this.m.RegularDamageMax = 55;
		this.m.ArmorDamageMult = 0.9;
		this.m.DirectDamageMult = 0.2;
	}

	function getTooltip()
	{
		local result = this.weapon.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Inflige [color=" + this.Const.UI.Color.DamageValue + "]10[/color] - [color=" + this.Const.UI.Color.DamageValue + "]20[/color] dégâts supplémentaires qui ignorent l\'armure jusqu\'à trois cibles"
		});
		return result;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/slash_lightning"));
		this.addSkill(this.new("scripts/skills/actives/riposte"));
	}

	function onAddedToStash( _stashID )
	{
		if (_stashID == "player")
		{
			this.updateAchievement("ReproachOfTheOldGods", 1, 1);
		}
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});

