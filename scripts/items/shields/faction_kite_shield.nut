this.faction_kite_shield <- this.inherit("scripts/items/shields/shield", {
	m = {
		Faction = 1
	},
	function create()
	{
		this.shield.create();
		this.m.ID = "shield.faction_kite_shield";
		this.m.Name = "Kite Shield";
		this.m.Description = "An elongated wooden shield covered in leather that offers good protection also to the lower body. Somewhat bulky to handle in close combat engagements.";
		this.m.AddGenericSkill = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = this.Math.rand(1, 2);
		this.updateVariant();
		this.m.Value = 200;
		this.m.MeleeDefense = 15;
		this.m.RangedDefense = 25;
		this.m.StaminaModifier = -16;
		this.m.Condition = 48;
		this.m.ConditionMax = 48;
	}

	function setFaction( _f )
	{
		this.m.Faction = _f;
		this.updateVariant();
	}

	function updateVariant()
	{
		local variant = this.m.Variant < 10 ? "0" + this.m.Variant : this.m.Variant;
		local faction = this.m.Faction < 10 ? "0" + this.m.Faction : this.m.Faction;
		this.m.Sprite = "faction_shield_kite_" + faction + "_" + variant;
		this.m.SpriteDamaged = "faction_shield_kite_" + faction + "_" + variant + "_damaged";
		this.m.ShieldDecal = "faction_shield_kite_" + faction + "_" + variant + "_destroyed";
		this.m.Icon = "shields/icon_faction_shield_kite_" + faction + "_" + variant + ".png";
		this.m.IconLarge = "shields/inventory_faction_shield_kite_" + faction + "_" + variant + ".png";
	}

	function onEquip()
	{
		this.shield.onEquip();
		this.addSkill(this.new("scripts/skills/actives/shieldwall"));
		this.addSkill(this.new("scripts/skills/actives/knock_back"));
	}

	function onSerialize( _out )
	{
		this.shield.onSerialize(_out);
		_out.writeU8(this.m.Faction);
	}

	function onDeserialize( _in )
	{
		this.shield.onDeserialize(_in);
		this.setFaction(_in.readU8());
	}

});

