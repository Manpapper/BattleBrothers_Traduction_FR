this.craftable_schrat_shield <- this.inherit("scripts/items/shields/shield", {
	m = {},
	function create()
	{
		this.shield.create();
		this.m.ID = "shield.craftable_schrat";
		this.m.Name = "Bouclier d\'arbre vivant";
		this.m.Description = "Ce bouclier taillé dans les restes d\'un arbre vivant repousse lentement s\'il subit des dommages. Au premier coup d\'oeil, on dirait presque que son visage grotesque bouge toujours.";
		this.m.AddGenericSkill = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 8;
		this.updateVariant();
		this.m.Value = 1000;
		this.m.MeleeDefense = 20;
		this.m.RangedDefense = 17;
		this.m.StaminaModifier = -12;
		this.m.Condition = 40;
		this.m.ConditionMax = 40;
	}

	function updateVariant()
	{
		this.m.Sprite = "shield_named_0" + this.m.Variant;
		this.m.SpriteDamaged = "shield_named_0" + this.m.Variant + "_damaged";
		this.m.ShieldDecal = "shield_named_0" + this.m.Variant + "_destroyed";
		this.m.IconLarge = "shields/inventory_named_shield_0" + this.m.Variant + ".png";
		this.m.Icon = "shields/icon_named_shield_0" + this.m.Variant + ".png";
	}

	function getTooltip()
	{
		local result = this.shield.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Se régénère de [color=" + this.Const.UI.Color.PositiveValue + "]20[/color] points de durabilité chaque tour."
		});
		return result;
	}

	function onEquip()
	{
		this.shield.onEquip();
		this.addSkill(this.new("scripts/skills/actives/shieldwall"));
		this.addSkill(this.new("scripts/skills/actives/knock_back"));
	}

	function onTurnStart()
	{
		this.m.Condition = this.Math.min(this.m.ConditionMax, this.m.Condition + 20);
		this.updateAppearance();
	}

	function onCombatFinished()
	{
		this.m.Condition = this.m.ConditionMax;
		this.updateAppearance();
	}

});

