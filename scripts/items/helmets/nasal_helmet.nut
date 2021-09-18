this.nasal_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.nasal_helmet";
		this.m.Name = "Nasal Helmet";
		this.m.Description = "A metal helmet with added noseguard.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		local variants = [
			1,
			1,
			1,
			1,
			1,
			1,
			1,
			88,
			89,
			90,
			91,
			168
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 350;
		this.m.Condition = 105;
		this.m.ConditionMax = 105;
		this.m.StaminaModifier = -5;
		this.m.Vision = -1;
	}

	function setPlainVariant()
	{
		this.setVariant(1);
	}

	function onPaint( _color )
	{
		switch(_color)
		{
		case this.Const.Items.Paint.None:
			this.m.Variant = 1;
			break;

		case this.Const.Items.Paint.Black:
			this.m.Variant = 91;
			break;

		case this.Const.Items.Paint.WhiteBlue:
			this.m.Variant = 88;
			break;

		case this.Const.Items.Paint.WhiteGreenYellow:
			this.m.Variant = 89;
			break;

		case this.Const.Items.Paint.OrangeRed:
			this.m.Variant = 90;
			break;

		case this.Const.Items.Paint.Red:
			this.m.Variant = 168;
			break;
		}

		this.updateVariant();
		this.updateAppearance();
	}

});

