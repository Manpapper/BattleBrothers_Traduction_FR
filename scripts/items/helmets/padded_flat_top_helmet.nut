this.padded_flat_top_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.padded_flat_top_helmet";
		this.m.Name = "Padded Flat Top Helmet";
		this.m.Description = "A flat full-metal helmet with noseguard and a padded coif underneath.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		local variants = [
			13,
			13,
			13,
			13,
			13,
			13,
			13,
			124,
			125,
			126,
			127,
			177
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 800;
		this.m.Condition = 150;
		this.m.ConditionMax = 150;
		this.m.StaminaModifier = -9;
		this.m.Vision = -1;
	}

	function setPlainVariant()
	{
		this.setVariant(13);
	}

	function onPaint( _color )
	{
		switch(_color)
		{
		case this.Const.Items.Paint.None:
			this.m.Variant = 13;
			break;

		case this.Const.Items.Paint.Black:
			this.m.Variant = 127;
			break;

		case this.Const.Items.Paint.WhiteBlue:
			this.m.Variant = 124;
			break;

		case this.Const.Items.Paint.WhiteGreenYellow:
			this.m.Variant = 125;
			break;

		case this.Const.Items.Paint.OrangeRed:
			this.m.Variant = 126;
			break;

		case this.Const.Items.Paint.Red:
			this.m.Variant = 177;
			break;
		}

		this.updateVariant();
		this.updateAppearance();
	}

});

