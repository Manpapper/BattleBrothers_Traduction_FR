this.closed_flat_top_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.closed_flat_top_helmet";
		this.m.Name = "Closed Flat Top Helmet";
		this.m.Description = "A closed helmet with complete faceguard. Hard to breathe in and limiting the field of view.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		local variants = [
			16,
			16,
			16,
			16,
			16,
			16,
			16,
			136,
			137,
			138,
			139,
			180
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 1000;
		this.m.Condition = 170;
		this.m.ConditionMax = 170;
		this.m.StaminaModifier = -10;
		this.m.Vision = -3;
	}

	function setPlainVariant()
	{
		this.setVariant(16);
	}

	function onPaint( _color )
	{
		switch(_color)
		{
		case this.Const.Items.Paint.None:
			this.m.Variant = 16;
			break;

		case this.Const.Items.Paint.Black:
			this.m.Variant = 139;
			break;

		case this.Const.Items.Paint.WhiteBlue:
			this.m.Variant = 136;
			break;

		case this.Const.Items.Paint.WhiteGreenYellow:
			this.m.Variant = 137;
			break;

		case this.Const.Items.Paint.OrangeRed:
			this.m.Variant = 138;
			break;

		case this.Const.Items.Paint.Red:
			this.m.Variant = 180;
			break;
		}

		this.updateVariant();
		this.updateAppearance();
	}

});

