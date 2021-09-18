this.flat_top_with_mail <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.flat_top_with_mail";
		this.m.Name = "Flat Top with Mail";
		this.m.Description = "A flat full-metal helmet with noseguard and a mail coif underneath.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		local variants = [
			14,
			14,
			14,
			14,
			14,
			14,
			14,
			128,
			129,
			130,
			131,
			178
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 1800;
		this.m.Condition = 230;
		this.m.ConditionMax = 230;
		this.m.StaminaModifier = -15;
		this.m.Vision = -2;
	}

	function setPlainVariant()
	{
		this.setVariant(14);
	}

	function onPaint( _color )
	{
		switch(_color)
		{
		case this.Const.Items.Paint.None:
			this.m.Variant = 14;
			break;

		case this.Const.Items.Paint.Black:
			this.m.Variant = 131;
			break;

		case this.Const.Items.Paint.WhiteBlue:
			this.m.Variant = 128;
			break;

		case this.Const.Items.Paint.WhiteGreenYellow:
			this.m.Variant = 129;
			break;

		case this.Const.Items.Paint.OrangeRed:
			this.m.Variant = 130;
			break;

		case this.Const.Items.Paint.Red:
			this.m.Variant = 178;
			break;
		}

		this.updateVariant();
		this.updateAppearance();
	}

});

