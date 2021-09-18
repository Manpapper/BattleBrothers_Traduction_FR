this.kettle_hat <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.kettle_hat";
		this.m.Name = "Kettle hat";
		this.m.Description = "A full-metal helmet with a broad rim.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		local variants = [
			8,
			8,
			8,
			8,
			8,
			8,
			8,
			104,
			105,
			106,
			107,
			172
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 450;
		this.m.Condition = 115;
		this.m.ConditionMax = 115;
		this.m.StaminaModifier = -6;
		this.m.Vision = -1;
	}

	function setPlainVariant()
	{
		this.setVariant(8);
	}

	function onPaint( _color )
	{
		switch(_color)
		{
		case this.Const.Items.Paint.None:
			this.m.Variant = 8;
			break;

		case this.Const.Items.Paint.Black:
			this.m.Variant = 107;
			break;

		case this.Const.Items.Paint.WhiteBlue:
			this.m.Variant = 104;
			break;

		case this.Const.Items.Paint.WhiteGreenYellow:
			this.m.Variant = 105;
			break;

		case this.Const.Items.Paint.OrangeRed:
			this.m.Variant = 106;
			break;

		case this.Const.Items.Paint.Red:
			this.m.Variant = 172;
			break;
		}

		this.updateVariant();
		this.updateAppearance();
	}

});

