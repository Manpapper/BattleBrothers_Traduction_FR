this.nasal_helmet_with_closed_mail <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.nasal_helmet_with_closed_mail";
		this.m.Name = "Nasal Helmet with Closed Mail";
		this.m.Description = "A metal helmet with a noseguard and a closed mail coif underneath.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		local variants = [
			32,
			32,
			32,
			32,
			32,
			32,
			32,
			100,
			101,
			102,
			103,
			171
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 2000;
		this.m.Condition = 240;
		this.m.ConditionMax = 240;
		this.m.StaminaModifier = -16;
		this.m.Vision = -2;
	}

	function setPlainVariant()
	{
		this.setVariant(32);
	}

	function onPaint( _color )
	{
		switch(_color)
		{
		case this.Const.Items.Paint.None:
			this.m.Variant = 32;
			break;

		case this.Const.Items.Paint.Black:
			this.m.Variant = 103;
			break;

		case this.Const.Items.Paint.WhiteBlue:
			this.m.Variant = 100;
			break;

		case this.Const.Items.Paint.WhiteGreenYellow:
			this.m.Variant = 101;
			break;

		case this.Const.Items.Paint.OrangeRed:
			this.m.Variant = 102;
			break;

		case this.Const.Items.Paint.Red:
			this.m.Variant = 171;
			break;
		}

		this.updateVariant();
		this.updateAppearance();
	}

});

