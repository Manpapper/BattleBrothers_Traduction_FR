this.flat_top_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.flat_top_helmet";
		this.m.Name = "Flat Top Helmet";
		this.m.Description = "A flat full-metal helmet with noseguard.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		local variants = [
			12,
			12,
			12,
			12,
			12,
			12,
			12,
			120,
			121,
			123,
			176
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 500;
		this.m.Condition = 125;
		this.m.ConditionMax = 125;
		this.m.StaminaModifier = -7;
		this.m.Vision = -1;
	}

	function setPlainVariant()
	{
		this.setVariant(12);
	}

	function onPaint( _color )
	{
		switch(_color)
		{
		case this.Const.Items.Paint.None:
			this.m.Variant = 12;
			break;

		case this.Const.Items.Paint.Black:
			this.m.Variant = 123;
			break;

		case this.Const.Items.Paint.WhiteBlue:
			this.m.Variant = 120;
			break;

		case this.Const.Items.Paint.WhiteGreenYellow:
			this.m.Variant = 121;
			break;

		case this.Const.Items.Paint.OrangeRed:
			this.m.Variant = 122;
			break;

		case this.Const.Items.Paint.Red:
			this.m.Variant = 176;
			break;
		}

		this.updateVariant();
		this.updateAppearance();
	}

});

