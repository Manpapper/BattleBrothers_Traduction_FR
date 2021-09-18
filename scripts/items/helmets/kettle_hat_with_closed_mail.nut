this.kettle_hat_with_closed_mail <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.kettle_hat_with_closed_mail";
		this.m.Name = "Kettle Hat with Closed Mail";
		this.m.Description = "A full-metal helmet with a broad rim and a mail coif covering the neck and face.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		local variants = [
			11,
			11,
			11,
			11,
			11,
			11,
			11,
			116,
			117,
			118,
			119,
			175
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 2200;
		this.m.Condition = 250;
		this.m.ConditionMax = 250;
		this.m.StaminaModifier = -17;
		this.m.Vision = -2;
	}

	function setPlainVariant()
	{
		this.setVariant(11);
	}

	function onPaint( _color )
	{
		switch(_color)
		{
		case this.Const.Items.Paint.None:
			this.m.Variant = 11;
			break;

		case this.Const.Items.Paint.Black:
			this.m.Variant = 119;
			break;

		case this.Const.Items.Paint.WhiteBlue:
			this.m.Variant = 116;
			break;

		case this.Const.Items.Paint.WhiteGreenYellow:
			this.m.Variant = 117;
			break;

		case this.Const.Items.Paint.OrangeRed:
			this.m.Variant = 118;
			break;

		case this.Const.Items.Paint.Red:
			this.m.Variant = 175;
			break;
		}

		this.updateVariant();
		this.updateAppearance();
	}

});

