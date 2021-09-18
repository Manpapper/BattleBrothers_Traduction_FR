this.nordic_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.nordic_helmet";
		this.m.Name = "Nordic Helmet";
		this.m.Description = "A nordic helmet guarding face and neck with additional metal plates.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		local variants = [
			52,
			52,
			52,
			52,
			52,
			52,
			52,
			227,
			228,
			229,
			230,
			231
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
		this.setVariant(52);
	}

	function onPaint( _color )
	{
		switch(_color)
		{
		case this.Const.Items.Paint.None:
			this.m.Variant = 52;
			break;

		case this.Const.Items.Paint.Black:
			this.m.Variant = 227;
			break;

		case this.Const.Items.Paint.WhiteBlue:
			this.m.Variant = 230;
			break;

		case this.Const.Items.Paint.WhiteGreenYellow:
			this.m.Variant = 231;
			break;

		case this.Const.Items.Paint.OrangeRed:
			this.m.Variant = 229;
			break;

		case this.Const.Items.Paint.Red:
			this.m.Variant = 228;
			break;
		}

		this.updateVariant();
		this.updateAppearance();
	}

});

