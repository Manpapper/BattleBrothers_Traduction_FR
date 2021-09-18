this.nordic_helmet_with_closed_mail <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.nordic_helmet_with_closed_mail";
		this.m.Name = "Nordic Helmet with Closed Mail";
		this.m.Description = "A metal nordic helmet with an attached closed mail neck guard.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		local variants = [
			202,
			202,
			202,
			202,
			202,
			202,
			202,
			222,
			223,
			224,
			225,
			226
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 2600;
		this.m.Condition = 265;
		this.m.ConditionMax = 265;
		this.m.StaminaModifier = -18;
		this.m.Vision = -2;
	}

	function onPaint( _color )
	{
		switch(_color)
		{
		case this.Const.Items.Paint.None:
			this.m.Variant = 202;
			break;

		case this.Const.Items.Paint.Black:
			this.m.Variant = 222;
			break;

		case this.Const.Items.Paint.WhiteBlue:
			this.m.Variant = 225;
			break;

		case this.Const.Items.Paint.WhiteGreenYellow:
			this.m.Variant = 226;
			break;

		case this.Const.Items.Paint.OrangeRed:
			this.m.Variant = 224;
			break;

		case this.Const.Items.Paint.Red:
			this.m.Variant = 223;
			break;
		}

		this.updateVariant();
		this.updateAppearance();
	}

});

