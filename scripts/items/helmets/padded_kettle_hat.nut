this.padded_kettle_hat <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.padded_kettle_hat";
		this.m.Name = "Padded Kettle hat";
		this.m.Description = "A full-metal helmet with a broad rim and a padded coif underneath.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		local variants = [
			9,
			9,
			9,
			9,
			9,
			9,
			9,
			108,
			109,
			110,
			111,
			173
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 650;
		this.m.Condition = 140;
		this.m.ConditionMax = 140;
		this.m.StaminaModifier = -8;
		this.m.Vision = -1;
	}

	function onPaint( _color )
	{
		switch(_color)
		{
		case this.Const.Items.Paint.None:
			this.m.Variant = 9;
			break;

		case this.Const.Items.Paint.Black:
			this.m.Variant = 111;
			break;

		case this.Const.Items.Paint.WhiteBlue:
			this.m.Variant = 108;
			break;

		case this.Const.Items.Paint.WhiteGreenYellow:
			this.m.Variant = 109;
			break;

		case this.Const.Items.Paint.OrangeRed:
			this.m.Variant = 110;
			break;

		case this.Const.Items.Paint.Red:
			this.m.Variant = 173;
			break;
		}

		this.updateVariant();
		this.updateAppearance();
	}

});

